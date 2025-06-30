% UIElement.m
classdef UIElement < guiser.util.StructSerializable & matlab.mixin.Heterogeneous
    % UIELEMENT A base class for describing a generic UI element.
    
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
            value = logical(isa(obj,'guiser.component.mixin.UIContainer'));
        end

        function value = get.creatorFcn(obj)
            % This get method now contains the special case for UIFigure.
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
            % CREATECOMPONENT Creates a MATLAB graphics object from this object's properties.
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
                    set(h, matlabTerm, finalValue);
                catch ME
                    fprintf(2, 'GUISER DEBUG: Failed to set property "%s" on component tagged "%s".\n', matlabTerm, obj.Tag);
                    rethrow(ME);
                end
            end
        end

        function doPostBuild(obj, app)
            %DOPOSTBUILD Sets properties that depend on the existence of other components.
            %   This method is called after all components in the app have been created.
            %   It iterates through its own properties, finds any marked as 'isPostBuild',
            %   and applies them. Subclasses can override this to add specific logic.

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
            % GETMATLABTERM Translates a guiser property name to a MATLAB property name
            % and returns its read-only and post-build status.
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
