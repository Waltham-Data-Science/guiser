% MockAppForTesting.m
classdef MockAppForTesting < guiser.App.class.base
    % MOCKAPPFORTESTING A lightweight app object for unit testing components.
    % This class creates a temporary, minimal JSON file to satisfy the
    % superclass constructor, allowing for isolated testing of components
    % without needing a full app definition.

    properties
        TempJsonPath (1,:) char
    end

    methods
        function app = MockAppForTesting()
            % Create a temporary JSON file path as a local variable.
            tempPath = [tempname, '.json'];
            
            % Define the absolute minimum valid JSON structure, which now
            % includes a single root UIFigure component.
            minimalDef.dataStructure = struct();
            rootComponent.className = 'guiser.component.UIFigure';
            rootComponent.properties.Tag = 'mockRootFigureForTesting';
            rootComponent.properties.ParentTag = '';
            rootComponent.properties.Visible = 'off'; % Keep it hidden during tests
            minimalDef.guiComponents = rootComponent;
            
            % Write the JSON file.
            jsonText = jsonencode(minimalDef);
            fid = fopen(tempPath, 'w');
            fprintf(fid, '%s', jsonText);
            fclose(fid);
            
            % Call the superclass constructor FIRST, using the local variable.
            app@guiser.App.class.base(tempPath);
            
            % NOW that the object is constructed, we can set its properties.
            app.TempJsonPath = tempPath;
        end

        function delete(app)
            % DELETE Clean up the temporary JSON file.
            
            % Call the superclass delete method first.
            delete@guiser.App.class.base(app);
            
            % Delete the temporary file if it still exists.
            if ~isempty(app.TempJsonPath) && isfile(app.TempJsonPath)
                delete(app.TempJsonPath);
            end
        end
    end
end
