% base.m
classdef base < matlab.apps.AppBase
% BASE A base class for GUISER applications.

    properties (SetAccess = protected)
        DefinitionFile (1,:) char
        GUIDefinition (1,:) struct % An array of component definitions
        Data (1,1) struct
        UIHandles (1,1) struct
        Figure (1,1) matlab.ui.Figure
    end
    
    properties (SetAccess = protected, GetAccess = public)
        AppUID (1,:) char
    end

    methods
        function app = base(jsonFilePath)
            arguments
                jsonFilePath (1,:) char {mustBeFile}
            end
            
            app.generateAppUID();
            app.DefinitionFile = jsonFilePath;
            app.parseDefinition();
            
            app.buildUI();
            registerApp(app, app.Figure);
            runStartupFcn(app, @startupFcn);
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
            % BUILDUI Orchestrates the GUI build from a flat component list.
            app.UIHandles = struct();
            
            isRoot = arrayfun(@(def) isempty(def.properties.ParentTag), app.GUIDefinition);
            
            if sum(isRoot) ~= 1
                error('guiser:App:base:InvalidRoot', 'The JSON must define exactly one root component with an empty ParentTag.');
            end
            
            rootDef = app.GUIDefinition(isRoot);
            
            % Create the guiser object and then the graphics handle
            rootComponentObj = guiser.util.StructSerializable.fromStruct(rootDef.className, rootDef.properties);
            app.Figure = rootComponentObj.createComponent(app); % Corrected call
            app.UIHandles.(rootComponentObj.Tag) = app.Figure;
            
            drawnow;

            % Build all children of the root.
            app.buildChildrenOf(rootDef.properties.Tag);
        end

        function buildChildrenOf(app, parentTag)
            % BUILDCHILDRENOF Finds and builds all direct children of a given parent tag.
            
            for i = 1:numel(app.GUIDefinition)
                def = app.GUIDefinition(i);
                if strcmp(def.properties.ParentTag, parentTag)
                    
                    componentObj = guiser.util.StructSerializable.fromStruct(def.className, def.properties);
                    h = componentObj.createComponent(app); % Corrected call
                    
                    if ~isempty(componentObj.Tag)
                        app.UIHandles.(def.properties.Tag) = h;
                    end
                    
                    app.buildChildrenOf(def.properties.Tag);
                end
            end
        end

        function startupFcn(app)
            % STARTUPFCN Code that executes after component creation.
            app.Figure.Visible = 'on';
        end
    end
end
