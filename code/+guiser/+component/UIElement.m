% UIElement.m
classdef UIElement < guiser.util.StructSerializable & matlab.mixin.Heterogeneous
    % UIELEMENT A base class for describing a generic UI element.
    %
    % This abstract class serves as the foundation for all GUISER component
    % definitions. It provides common properties like ParentTag and Tag,
    % handles the serialization to/from structs, and defines the core
    % interface for creating and configuring MATLAB UI components from
    % GUISER definitions.
    
    properties (Constant)
        % A list of property names that correspond to callbacks.
        CallbackProperties = {'ButtonPushedFcn', 'ValueChangedFcn', ...
                              'ValueChangingFcn', 'CloseRequestFcn', ...
                              'OpeningFcn', 'DoubleClickFcn', 'SelectionChangedFcn'};
    end

    properties
        ParentTag (1,1) string = missing
        Visible (1,:) char {mustBeMember(Visible,{'on','off'})} = 'on'
        Tag (1,1) string = missing
        UserData
        ParentUuid (1,1) string = missing
    end

    properties (Dependent)
        IsContainer (1,1) logical
        creatorFcn (1,:) char
    end

    methods
        function value = get.IsContainer(obj)
            % get.IsContainer - Determines if the component is a container.
            %
            %   Syntax:
            %       isCont = myUIElement.IsContainer;
            %
            %   Description:
            %       This dependent property returns true if the UIElement object
            %       inherits from the guiser.component.mixin.UIContainer class,
            %       and false otherwise. This is used by the framework to
            %       identify components that can have children.
            %
            %   Outputs:
            %       isCont - A logical scalar (true or false).
            value = logical(isa(obj,'guiser.component.mixin.UIContainer'));
        end

        function value = get.creatorFcn(obj)
            % get.creatorFcn - Gets the MATLAB function name to create the component.
            %
            %   Syntax:
            %       fcnName = myUIElement.creatorFcn;
            %
            %   Description:
            %       This dependent property returns the name of the MATLAB UI
            %       function used to create the graphics object (e.g., 'uibutton',
            %       'uipanel'). It derives the name from the class name by
            %       stripping the 'guiser.component.UI' prefix and converting
            %       to lowercase. It includes a special case for UIFigure to
            %       return 'uifigure'.
            %
            %   Outputs:
            %       fcnName - A character vector holding the function name.
            if isa(obj, 'guiser.component.UIFigure')
                value = 'uifigure';
                return;
            end
            
            fullClassName = class(obj);
            if any(strcmp(fullClassName, {'guiser.component.UIElement'}))
                value = lower(strrep(fullClassName, 'guiser.component.UI', ''));
            else
                parts = strsplit(fullClassName, '.');
                value = lower(parts{end});
            end
        end

        function h = createComponent(obj, app)
            % CREATECOMPONENT Creates and configures a MATLAB graphics object.
            %
            %   Syntax:
            %       h = myUIElement.createComponent(app);
            %
            %   Description:
            %       This is a core method of the framework. It takes a GUISER
            %       app object, determines the correct parent handle using the
            %       ParentTag, creates the corresponding MATLAB UI component
            %       (e.g., uibutton), and then iterates through its own properties
            %       to set the properties of the newly created graphics handle.
            %       It translates GUISER property names (e.g., 'FontColor') to
            %       MATLAB property names (e.g., 'FontColor') using the mapping
            %       defined in matlabPropertyMapping.json. It also handles
            %       special cases like creating unique tags and setting up callbacks.
            %
            %   Inputs:
            %       app - An instance of a class inheriting from guiser.App.class.base.
            %             This provides access to the figure, other UI handles,
            %             and callback methods.
            %
            %   Outputs:
            %       h - A handle to the newly created MATLAB graphics object.
            arguments
                obj
                app (1,1) guiser.App.class.base
            end

            parentHandle = [];
            if ~isempty(obj.ParentTag) && ~ismissing(obj.ParentTag) && ~strcmp(obj.ParentTag,"")
                uniqueParentTag = [char(obj.ParentTag), '_', app.AppUID];
                parentHandle = findall(0, 'Tag', uniqueParentTag);
                
                if isempty(parentHandle)
                    error('guiser:UIElement:ParentNotFound', ...
                        'Could not find parent component. Searched for unique tag: "%s"', uniqueParentTag);
                elseif numel(parentHandle) > 1
                     error('guiser:UIElement:MultipleParentsFound', ...
                        'Found multiple parent components with tag: %s. Tags must be unique within an app.', obj.ParentTag);
                end
            end
            
            creatorFuncHandle = str2func(obj.creatorFcn);
            if isempty(parentHandle)
                h = creatorFuncHandle();
            else
                h = creatorFuncHandle(parentHandle);
            end

            propList = properties(obj);
            for i=1:numel(propList)
                guiserTerm = propList{i};
                
                % Handle Layout property as a special case
                if strcmp(guiserTerm, 'Layout')
                    propValue = obj.(guiserTerm);
                    if ~isempty(propValue.Row) || ~isempty(propValue.Column)
                        h.Layout.Row = propValue.Row;
                        h.Layout.Column = propValue.Column;
                    end
                    continue; % Skip the rest of the loop for the Layout property
                end

                [matlabTerm, isReadOnly, isPostBuild] = guiser.component.UIElement.getMatlabTerm(class(obj), guiserTerm);
                
                if isempty(matlabTerm) || isReadOnly || isPostBuild
                    continue;
                end

                propValue = obj.(guiserTerm);

                if ismissing(propValue)
                    continue;
                end

                if isstring(propValue)
                    propValue = char(propValue);
                end

                if strcmp(guiserTerm, 'Tag')
                    finalValue = [propValue, '_', app.AppUID];
                elseif strcmp(guiserTerm, 'Icon')
                    toolboxPath = guiser.toolboxdir();
                    iconPath = fullfile(toolboxPath, 'code', propValue);
                    if ~isfile(iconPath)
                        warning('guiser:UIElement:IconNotFound', 'Icon file not found at: %s', iconPath);
                        continue;
                    end
                    finalValue = iconPath;
                elseif ismember(guiserTerm, obj.CallbackProperties)
                    if ismethod(app, propValue)
                        finalValue = @(src, evt) app.(propValue)(src, evt);
                    else
                        warning('guiser:UIElement:CallbackNotFound', ...
                            'Callback method "%s" for component tagged "%s" is not defined.', propValue, obj.Tag);
                        continue;
                    end
                else
                    finalValue = propValue;
                end
                
                try
                    matlabTerm,finalValue
                    set(h, matlabTerm, finalValue);
                catch ME
                    fprintf(2, 'GUISER DEBUG: Failed to set property "%s" on component tagged "%s".\n', matlabTerm, obj.Tag);
                    rethrow(ME);
                end
            end
        end

        function doPostBuild(obj, app)
            %DOPOSTBUILD Sets properties that depend on other components.
            %
            %   Syntax:
            %       myUIElement.doPostBuild(app);
            %
            %   Description:
            %       This method is called by the app's buildUI method AFTER all
            %       UI components have been created and have handles. It is used
            %       to set properties that rely on the existence of other
            %       component handles, which would not be available during the
            %       initial createComponent call. For example, setting the
            %       'SelectedObject' of a uibuttongroup requires the handle of
            %       the child radio button.
            %
            %   Inputs:
            %       app - An instance of a class inheriting from guiser.App.class.base.
            %             This provides access to the app's UIHandles structure.
            %
            %   See also: guiser.App.class.base.buildUI

            propList = properties(obj);
            for i = 1:numel(propList)
                guiserTerm = propList{i};

                [matlabTerm, ~, isPostBuild] = guiser.component.UIElement.getMatlabTerm(class(obj), guiserTerm);

                if isempty(matlabTerm) || ~isPostBuild
                    continue;
                end

                % Handle SelectedTag for UIButtonGroup
                if strcmp(guiserTerm, 'SelectedTag') && isa(obj, 'guiser.component.UIButtonGroup')
                    if ~isempty(obj.SelectedTag)
                        parentHandle = app.UIHandles.(obj.Tag);
                        childToSelectHandle = app.UIHandles.(obj.SelectedTag);
                        
                        set(parentHandle, matlabTerm, childToSelectHandle);
                    end
                end

                % Other post-build properties can be handled here...
            end
        end
    end

    methods (Static)
        function [matlabTerm, isReadOnly, isPostBuild] = getMatlabTerm(className, guiserTerm, options)
            % GETMATLABTERM Translates a GUISER property to its MATLAB equivalent.
            %
            %   Syntax:
            %       [mTerm, isRO, isPB] = UIElement.getMatlabTerm(className, guiserTerm);
            %
            %   Description:
            %       This static method acts as a centralized dictionary for the
            %       framework. It reads the 'matlabPropertyMapping.json' file
            %       and caches the results in a persistent map. Given a GUISER
            %       class name and a GUISER property name, it returns the
            %       corresponding MATLAB property name and two flags indicating
            %       if the property is read-only or should be set in the
            %       post-build step.
            %
            %   Inputs:
            %       className - The name of the GUISER component class (e.g.,
            %                   'guiser.component.UIButton').
            %       guiserTerm - The name of the property in the GUISER class
            %                    (e.g., 'FontColor').
            %
            %   Name-Value Pairs:
            %       forceReload (logical, default false) - If true, forces a
            %           reread of the JSON mapping file.
            %
            %   Outputs:
            %       matlabTerm - The corresponding MATLAB property name (e.g.,
            %                    'FontColor'). Returns empty if no mapping exists.
            %       isReadOnly - A logical flag that is true if the property
            %                    should not be set by the framework.
            %       isPostBuild - A logical flag that is true if the property
            %                     should be set in the doPostBuild phase.
            arguments
                className (1,:) char
                guiserTerm (1,:) char
                options.forceReload (1,1) logical = false
            end
            
            persistent propertyMap;

            if options.forceReload
                propertyMap = [];
            end
            
            if isempty(propertyMap)
                propertyMap = containers.Map('KeyType', 'char', 'ValueType', 'any');
                try
                    jsonPath = fullfile(guiser.toolboxdir(), 'resources', 'matlabPropertyMapping.json');
                    jsonText = fileread(jsonPath);
                    mappingsArray = jsondecode(jsonText);

                    for i = 1:numel(mappingsArray)
                        classEntry = mappingsArray(i);
                        cn = classEntry.className;
                        classMappings = classEntry.mappings;
                        
                        innerMap = containers.Map('KeyType', 'char', 'ValueType', 'any');
                        for j = 1:numel(classMappings)
                            mapping = classMappings(j);
                            if ~isfield(mapping, 'isReadOnly')
                                mapping.isReadOnly = false;
                            end
                            if ~isfield(mapping, 'isPostBuild')
                                mapping.isPostBuild = false;
                            end
                            innerMap(mapping.guiserTerm) = mapping;
                        end
                        
                        propertyMap(cn) = innerMap;
                    end
                catch ME
                    error('guiser:UIElement:MappingLoadFailed', 'Failed to load or parse matlabPropertyMapping.json. Error: %s', ME.message);
                end
            end
            
            matlabTerm = [];
            isReadOnly = false;
            isPostBuild = false;
            if isKey(propertyMap, className)
                classSpecificMap = propertyMap(className);
                if isKey(classSpecificMap, guiserTerm)
                    mapping = classSpecificMap(guiserTerm);
                    matlabTerm = mapping.matlabTerm;
                    isReadOnly = logical(mapping.isReadOnly);
                    isPostBuild = logical(mapping.isPostBuild);
                end
            end
        end
    end

    methods (Static, Sealed, Access = protected)
        function default_object = getDefaultScalarElement
            error('UIElement:NoDefaultObject', 'You cannot create a default UIElement object.');
        end
    end
end
