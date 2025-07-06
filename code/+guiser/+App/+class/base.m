% base.m
classdef base < matlab.apps.AppBase & guiser.App.class.baseCallbacks
% BASE A base class for GUISER applications.

    properties (SetAccess = {?guiser.App.class.base, ?guiser.App.class.baseCallbacks})
        DefinitionFile (1,:) char
        GUIDefinition (1,:) struct 
        Data (1,1) struct
        UIHandles (1,1) struct
        ComponentObjects (1,1) struct 
    end
    
    properties (SetAccess = public)
        % A flag to indicate if the app is running in an automated test.
        IsTesting (1,1) logical = false
    end

    properties (SetAccess = protected, GetAccess = public)
        AppUID (1,:) char
    end

    properties (Access = private)
        WindowConstraintTimer timer % Timer to enforce window size constraints
    end

    methods
        function app = base(jsonFilePath, options)
            % BASE Construct an instance of this class
            arguments
                jsonFilePath (1,:) char {mustBeFile}
                options.IsTesting (1,1) logical = false
            end
            
            app.IsTesting = options.IsTesting;

            app.generateAppUID();
            app.DefinitionFile = jsonFilePath;
            app.parseDefinition();
            
            app.buildUI();

            % Only start the timer if not in testing mode to avoid timing issues
            if ~app.IsTesting
                app.WindowConstraintTimer = timer(...
                    'ExecutionMode', 'fixedRate', ...
                    'Period', 0.5, ...
                    'TimerFcn', @app.enforceWindowConstraints);
                start(app.WindowConstraintTimer);
            end

            % Register all created figures with the app manager
            componentTags = fieldnames(app.ComponentObjects);
            for i = 1:numel(componentTags)
                tag = componentTags{i};
                componentObj = app.ComponentObjects.(tag);
                if isa(componentObj, 'guiser.component.UIFigure')
                    registerApp(app, app.UIHandles.(tag));
                end
            end
            
            runStartupFcn(app, @startupFcn);
        end

        function delete(app)
            % DELETE Clean up all app resources, including the UI.
            
            % Stop and delete the timer to prevent memory leaks.
            if ~isempty(app.WindowConstraintTimer) && isvalid(app.WindowConstraintTimer)
                stop(app.WindowConstraintTimer);
                delete(app.WindowConstraintTimer);
            end

            % Loop over all UI handles and delete any figures. This ensures that
            % when the app object is deleted (e.g., by a test teardown), the
            % associated windows are also closed.
            if isstruct(app.UIHandles)
                componentTags = fieldnames(app.UIHandles);
                for i = 1:numel(componentTags)
                    tag = componentTags{i};
                    handle = app.UIHandles.(tag);
                    
                    % Check if the handle is a figure and is still valid
                    if isa(handle, 'matlab.ui.Figure') && isvalid(handle)
                        delete(handle);
                    end
                end
            end
        end

        function updateUIFromComponents(app)
            % UPDATEUIFROMCOMPONENTS Pushes state from all ComponentObjects to the live UI.
            componentTags = fieldnames(app.ComponentObjects);
            for i = 1:numel(componentTags)
                tag = componentTags{i};
                componentObj = app.ComponentObjects.(tag);
                handle = app.UIHandles.(tag);
                
                if isvalid(handle)
                    componentObj.updateLiveComponent(app, handle);
                end
            end
        end

        % Should we have an updateComponentsFromUI function?
        %
        % No. In this framework, the ComponentObjects are the "source of truth".
        % The live UI is just a reflection of the state of these objects.
        %
        % The correct way to update the model (the ComponentObjects) is through
        % event-driven callbacks (like ValueChangedFcn). When a user interacts
        % with the UI, the callback should be responsible for updating the
        % specific property of the specific component object that changed.
        %
        % A function that scrapes the entire UI and overwrites the model would
        % be inefficient and could lead to unintended side effects, as it
        % breaks the "single source of truth" principle. Therefore, this
        % function is intentionally omitted to enforce a cleaner, event-driven
        % architecture.

        function EnableDisable(app)
            % ENABLEDISABLE Central method for managing the enable/disable state of UI controls.
            app.TabNavigatorButtonEnableDisable();
            app.ListboxEditButtonEnableDisable();
        end

        function UserStartup(app)
            % UserStartup A placeholder for custom startup code in subclasses.
        end

        function shouldClose = UserCloseWindowFcn(app, figHandle)
            % UserCloseWindowFcn Determines if a window should be allowed to close.
            shouldClose = true;
        end

        function UserMenuOpeningFcn(app, src, evt)
            % UserMenuOpeningFcn Placeholder for custom logic before a context menu opens.
        end

        function UserMenuSelectedFcn(app, src, evt)
            % UserMenuSelectedFcn Placeholder for custom logic when a context menu item is selected.
        end
    end
    
    methods (Access = protected)
        
        function generateAppUID(app)
            symbols = ['a':'z' 'A':'Z' '0':'9'];
            rand_indices = randi(numel(symbols), [1, 8]);
            app.AppUID = symbols(rand_indices);
        end

        function parseDefinition(app)
            jsonText = fileread(app.DefinitionFile);
            fullStruct = jsondecode(jsonText);
            
            if ~isfield(fullStruct, 'dataStructure') || ~isfield(fullStruct, 'guiComponents')
                error('guiser:App:base:InvalidJSON', 'JSON must have "dataStructure" and "guiComponents".');
            end
            
            app.Data = fullStruct.dataStructure;
            app.GUIDefinition = fullStruct.guiComponents;
        end
        
        function buildUI(app)
            app.UIHandles = struct();
            app.ComponentObjects = struct();
            
            isRoot = arrayfun(@(def) isempty(def.properties.ParentTag), app.GUIDefinition);
            rootIndices = find(isRoot);

            if isempty(rootIndices)
                error('guiser:App:base:InvalidRoot', 'The JSON must define at least one root component with an empty ParentTag.');
            end

            for i = 1:numel(rootIndices)
                rootDef = app.GUIDefinition(rootIndices(i));
                rootComponentObj = guiser.util.StructSerializable.fromStruct(rootDef.className, rootDef.properties);
                
                if ~isa(rootComponentObj, 'guiser.component.UIFigure')
                    error('guiser:App:base:RootNotFigure', 'Root component with tag "%s" must be a guiser.component.UIFigure.', rootDef.properties.Tag);
                end

                h = rootComponentObj.createComponent(app);
                app.UIHandles.(rootComponentObj.Tag) = h;
                app.ComponentObjects.(rootComponentObj.Tag) = rootComponentObj;
                
                app.buildChildrenOf(rootDef.properties.Tag);
            end
            
            drawnow;

            componentTags = fieldnames(app.ComponentObjects);
            for i = 1:numel(componentTags)
                tag = componentTags{i};
                componentObj = app.ComponentObjects.(tag);
                componentObj.doPostBuild(app);
            end
        end

        function buildChildrenOf(app, parentTag)
            for i = 1:numel(app.GUIDefinition)
                def = app.GUIDefinition(i);
                if strcmp(def.properties.ParentTag, parentTag)
                    componentObj = guiser.util.StructSerializable.fromStruct(def.className, def.properties);
                    h = componentObj.createComponent(app);
                    if ~isempty(componentObj.Tag)
                        app.UIHandles.(def.properties.Tag) = h;
                        app.ComponentObjects.(def.properties.Tag) = componentObj;
                    end
                    app.buildChildrenOf(def.properties.Tag);
                end
            end
        end

        function startupFcn(app)
            componentTags = fieldnames(app.ComponentObjects);
            for i = 1:numel(componentTags)
                tag = componentTags{i};
                componentObj = app.ComponentObjects.(tag);
                if isa(componentObj, 'guiser.component.UIFigure')
                    figHandle = app.UIHandles.(tag);
                    if isvalid(figHandle)
                        figHandle.Visible = componentObj.Visible;
                    end
                end
            end
            app.UserStartup();
            app.EnableDisable();
        end

        function enforceWindowConstraints(app, ~, ~)
            % ENFORCEWINDOWCONSTRAINTS Checks and applies size limits to figures.
            % This method is called by a timer. It synchronizes the live UI
            % position back to the component object and then enforces size
            % constraints, keeping the top-left corner stationary.
            
            componentTags = fieldnames(app.ComponentObjects);
            for i = 1:numel(componentTags)
                tag = componentTags{i};
                componentObj = app.ComponentObjects.(tag);

                if isa(componentObj, 'guiser.component.UIFigure')
                    figHandle = app.UIHandles.(tag);
                    if ~isvalid(figHandle), continue; end
                    
                    originalPos = getpixelposition(figHandle);
                    
                    % Always update the component object with the latest position from the UI
                    componentObj.Position = originalPos;

                    newPos = originalPos;
                    wasResized = false;

                    if newPos(3) < componentObj.WidthMin, newPos(3) = componentObj.WidthMin; wasResized = true; end
                    if newPos(3) > componentObj.WidthMax, newPos(3) = componentObj.WidthMax; wasResized = true; end
                    if newPos(4) < componentObj.HeightMin, newPos(4) = componentObj.HeightMin; wasResized = true; end
                    if newPos(4) > componentObj.HeightMax, newPos(4) = componentObj.HeightMax; wasResized = true; end

                    if wasResized
                        % If a resize occurred, calculate the new position while keeping the top-left corner fixed
                        originalTop = originalPos(2) + originalPos(4);
                        newSize = newPos(3:4);
                        newBottom = originalTop - newSize(2);
                        finalPos = [originalPos(1), newBottom, newSize];
                        
                        % Apply the corrected position to the live handle
                        setpixelposition(figHandle, finalPos);
                        
                        % Also update the component object with the final corrected position
                        componentObj.Position = finalPos;
                    end
                    
                    % Write the modified object back
                    app.ComponentObjects.(tag) = componentObj;
                end
            end
        end
    end
end
