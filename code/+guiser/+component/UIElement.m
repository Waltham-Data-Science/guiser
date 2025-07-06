% UIElement.m
classdef UIElement < guiser.util.StructSerializable & matlab.mixin.Heterogeneous
    % UIELEMENT A base class for describing a generic UI element.
    properties (Constant)
        CallbackProperties = {'ButtonPushedFcn', 'ValueChangedFcn', ...
                              'ValueChangingFcn', 'CloseRequestFcn', ...
                              'OpeningFcn', 'DoubleClickFcn', 'SelectionChangedFcn', ...
                              'MenuSelectedFcn', 'CellEditCallback', 'CellSelectionCallback'};
    end

    properties
        ParentTag (1,1) string = missing
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
            if isa(obj, 'guiser.component.UIFigure')
                value = 'uifigure';
                return;
            end
            
            if isa(obj, 'guiser.component.UIButton')
                value = 'uibutton';
                return;
            end

            if isa(obj, 'guiser.component.UITable')
                value = 'uitable';
                return;
            end

            if isa(obj, 'guiser.component.UIMenu')
                value = 'uimenu';
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
            % This method gets all name-value properties and creates the component
            % in a single, efficient call.
            arguments
                obj
                app (1,1) guiser.App.class.base
            end

            parentHandle = [];
            if ~ismissing(obj.ParentTag) && ~strcmp(obj.ParentTag,"")
                uniqueParentTag = [char(obj.ParentTag), '_', app.AppUID];
                parentHandle = findall(0, 'Tag', uniqueParentTag);
                if isempty(parentHandle)
                    error('guiser:UIElement:ParentNotFound', 'Could not find parent component with unique tag: "%s"', uniqueParentTag);
                end
            end
            
            nvPairs = obj.getNVProperties(app);
            creatorFuncHandle = str2func(obj.creatorFcn);
            if isempty(parentHandle)
                h = creatorFuncHandle(nvPairs{:});
            else
                h = creatorFuncHandle(parentHandle, nvPairs{:});
            end
            
            if isprop(obj, 'Layout')
                layoutProp = obj.Layout;
                if ~isempty(layoutProp.Row) || ~isempty(layoutProp.Column)
                    h.Layout.Row = layoutProp.Row;
                    h.Layout.Column = layoutProp.Column;
                end
            end
        end

        function updateLiveComponent(obj, app, handle)
            % UPDATELIVECOMPONENT Pushes property values to a live graphics handle.
            % This method gets all name-value properties and uses set() to update
            % an existing component.
            arguments
                obj
                app (1,1) guiser.App.class.base
                handle
            end
            
            nvPairs = obj.getNVProperties(app);
            set(handle, nvPairs{:});

            if isprop(obj, 'Layout')
                layoutProp = obj.Layout;
                if ~isempty(layoutProp.Row) || ~isempty(layoutProp.Column)
                    handle.Layout.Row = layoutProp.Row;
                    handle.Layout.Column = layoutProp.Column;
                end
            end
        end

        function doPostBuild(obj, app)
            %DOPOSTBUILD Sets properties that depend on other components.
            propList = properties(obj);
            for i = 1:numel(propList)
                guiserTerm = propList{i};
                [matlabTerm, ~, isPostBuild] = guiser.component.UIElement.getMatlabTerm(class(obj), guiserTerm);
                if isempty(matlabTerm) || ~isPostBuild
                    continue;
                end
                if strcmp(guiserTerm, 'SelectedTag') && isa(obj, 'guiser.component.UIButtonGroup')
                    if ~ismissing(obj.SelectedTag)
                        parentHandle = app.UIHandles.(obj.Tag);
                        childToSelectHandle = app.UIHandles.(obj.SelectedTag);
                        set(parentHandle, matlabTerm, childToSelectHandle);
                    end
                end
            end

            % Handle context menu attachment
            if isprop(obj, 'ContextMenuTag') && ~ismissing(obj.ContextMenuTag)
                if isfield(app.UIHandles, obj.Tag) && isfield(app.UIHandles, char(obj.ContextMenuTag))
             
                   targetHandle = app.UIHandles.(obj.Tag);
                    contextMenuHandle = app.UIHandles.(char(obj.ContextMenuTag));
                    targetHandle.ContextMenu = contextMenuHandle;
                end
            end
        end
    end

    methods (Access = private)
        function nvPairs = getNVProperties(obj, app)
            % GETNVPROPERTIES Translates GUISER properties to MATLAB name-value pairs.
            % This is the core translation logic, used for both creation and updates.
            nvPairs = {};
            propList = properties(obj);
            for i=1:numel(propList)
                guiserTerm = propList{i};
                if strcmp(guiserTerm, 'Layout')
                    continue;
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

                if isa(obj, 'guiser.component.UITable') && strcmp(guiserTerm, 'Data') && istable(propValue)
                    % Special case for UITable: convert table data to a cell array.
                    cellData = table2cell(propValue);
                    % Also, uitable requires char vectors for text, not strings. Convert any strings.
                    stringCells = cellfun(@isstring, cellData);
                    cellData(stringCells) = cellfun(@char, cellData(stringCells), 'UniformOutput', false);
                    finalValue = cellData;
                elseif isa(obj, 'guiser.component.UITable') && strcmp(guiserTerm, 'RowName')
                    % Special case for RowName: if it's {'numbered'}, convert to the keyword 'numbered'.
                    if iscell(propValue) && isscalar(propValue) && strcmp(propValue{1}, 'numbered')
                        finalValue = 'numbered';
                    else
                        finalValue = propValue;
                    end
                elseif strcmp(guiserTerm, 'Tag')
                    finalValue = [propValue, '_', app.AppUID];
                elseif strcmp(guiserTerm, 'Icon')
                    if ~isempty(propValue)
                        toolboxPath = guiser.toolboxdir();
                        iconPath = fullfile(toolboxPath, propValue);
                        if ~isfile(iconPath)
                            warning('guiser:UIElement:IconNotFound', 'Icon file not found at: %s', iconPath);
                            continue;
                        end
                        finalValue = iconPath;
                    else
                        continue;
                    end
                elseif ismember(guiserTerm, obj.CallbackProperties)
                    if ismethod(app, propValue)
                        finalValue = @(src, evt) app.(propValue)(src, evt);
                    else
                        warning('guiser:UIElement:CallbackNotFound', 'Callback method "%s" for component tagged "%s" is not defined.', propValue, obj.Tag);
                        continue;
                    end
                else
                    finalValue = propValue;
                end
                
                nvPairs{end+1} = matlabTerm;
                nvPairs{end+1} = finalValue;
            end
        end
    end

    methods (Static)
        function [matlabTerm, isReadOnly, isPostBuild] = getMatlabTerm(className, guiserTerm, options)
            arguments
                className (1,:) char
                guiserTerm (1,:) char
                options.forceReload (1,1) logical = false
            end
            persistent propertyMap;
            if options.forceReload || isempty(propertyMap)
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
                            if ~isfield(mapping, 'isReadOnly'), mapping.isReadOnly = false; end
                            if ~isfield(mapping, 'isPostBuild'), mapping.isPostBuild = false;
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