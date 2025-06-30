% ExampleApp.m
classdef ExampleApp < guiser.App.class.base
% EXAMPLEAPP A minimal example application built on the GUISER framework.
%
% This class demonstrates the basic architecture of a GUISER app. It
% inherits from the base class and, in its constructor, specifies the
% path to its JSON definition file. The base class handles all the
% heavy lifting of parsing the JSON and building the GUI.
%
% To run this example:
%   app = guiser.App.class.ExampleApp();
%
% See also: guiser.App.class.base

    methods
        function app = ExampleApp()
            % EXAMPLEAPP Constructor for the example application.
            %
            % This constructor determines the absolute path to the app's
            % JSON definition file and passes it to the superclass
            % constructor.
            
            % Get the root directory of the toolbox.
            toolboxPath = guiser.toolboxdir();
            
            % Construct the full path to the JSON definition file.
            jsonPath = fullfile(toolboxPath, 'resources', 'apps', 'guiserExampleApp.json');
            
            % Call the superclass constructor with the file path.
            app@guiser.App.class.base(jsonPath);
        end
    end

end
