% UIElement.m
classdef UIElement < guiser.util.StructSerializable & matlab.mixin.Heterogeneous
    % UIELEMENT A base class for describing a generic UI element.

    properties (Constant)
        % A list of property names that correspond to callbacks.
        CallbackProperties = {'ButtonPushedFcn', 'ValueChangedFcn', ...
                              'ValueChangingFcn', 'CloseRequestFcn', ...
                              'OpeningFcn', 'DoubleClickFcn'};
    end

    properties
        ParentTag (1,:) char = ''
        Visible (1,:) char {mustBeMember(Visible,{'on','off'})} = 'on'
        Tag (1,:) char = ''
        UserData
        ParentUuid (1,:) char = ''
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
            
            if strcmp(fullClassName, 'guiser.component.UIElement')
                value = 'none';
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
            if ~isempty(obj.ParentTag)
                uniqueParentTag = [obj.ParentTag, '_', app.AppUID];
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
                propValue = obj.(guiserTerm);
                
                % Check for the special case of an empty Layout property
                if strcmp(guiserTerm, 'Layout') && isempty(propValue.Row) && isempty(propValue.Column)
                    continue; % Skip setting the default empty layout
                end

                matlabTerm = guiser.component.UIElement.getMatlabTerm(class(obj), guiserTerm);

                if isempty(matlabTerm), continue; end

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
                elseif strcmp(guiserTerm, 'Layout')
                    % For a non-empty layout, create the layout options object.
                    finalValue = uilayoutoptions('Row', propValue.Row, 'Column', propValue.Column);
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

    end

    methods (Static)
        function matlabTerm = getMatlabTerm(className, guiserTerm)
            % GETMATLABTERM Translates a guiser property name to a MATLAB property name.
            
            arguments
                className (1,:) char
                guiserTerm (1,:) char
            end
            
            persistent propertyMap;
            
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
                        
                        innerMap = containers.Map('KeyType', 'char', 'ValueType', 'char');
                        for j = 1:numel(classMappings)
                            mapping = classMappings(j);
                            innerMap(mapping.guiserTerm) = mapping.matlabTerm;
                        end
                        
                        propertyMap(cn) = innerMap;
                    end
                catch ME
                    error('guiser:UIElement:MappingLoadFailed', 'Failed to load or parse matlabPropertyMapping.json. Error: %s', ME.message);
                end
            end
            
            matlabTerm = [];
            if isKey(propertyMap, className)
                classSpecificMap = propertyMap(className);
                if isKey(classSpecificMap, guiserTerm)
                    matlabTerm = classSpecificMap(guiserTerm);
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
