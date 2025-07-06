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
        function app = ExampleApp(options)
            % EXAMPLEAPP Constructor for the example application.
            arguments
                options.IsTesting (1,1) logical = false
            end
            
            % Get the root directory of the toolbox.
            toolboxPath = guiser.toolboxdir();
            
            % Construct the full path to the JSON definition file.
            jsonPath = fullfile(toolboxPath, 'resources', 'apps', 'guiserExampleApp.json');
            
            % Call the superclass constructor, passing along any optional arguments.
            app@guiser.App.class.base(jsonPath, 'IsTesting', options.IsTesting);
        end

        function UserStartup(app)
            % UserStartup Overrides the base class method for custom startup code.
            
            % Any custom app startup code goes here
        end

        function EnableDisable(app)
            % EnableDisable Overrides the base class method for custom UI state logic.
            
            % Call the parent method first to handle default behavior (like tab buttons)
            EnableDisable@guiser.App.class.base(app);
            
            % custom enable/disable code goes here
        end

        function ValueChangedFcn(app, src, evt)
            % ValueChangedFcn Overrides the base class method for custom callback logic.
            
            % Call the parent method first to get all the default behavior.
            ValueChangedFcn@guiser.App.class.base(app, src, evt);

            % Custom user code to respond to the value change goes here.
            % For example:
            % disp(['Value changed for component with tag: ' src.Tag]);
        end

        function DropdownValueChangedFcn(app, src, evt)
            % DropdownValueChangedFcn Custom callback for the Add Item dropdown.

            % Do nothing if the user selected the blank item
            if strcmp(evt.Value, "")
                return;
            end

            % Get the component object for the listbox
            listboxObj = app.ComponentObjects.tab4SampleListbox;

            % Add the selected value from the dropdown to the listbox's items
            listboxObj.Items{end+1,1} = evt.Value;
            
            % Write the modified object back to the main app struct
            app.ComponentObjects.tab4SampleListbox = listboxObj;

            % Tell the framework to push all model changes to the live UI
            app.updateUIFromComponents();

            % Reset the dropdown to the blank value
            dropdownObj = app.ComponentObjects.addItemDropdown;
            dropdownHandle = app.UIHandles.addItemDropdown;
            dropdownObj.Value = "";
            app.ComponentObjects.addItemDropdown = dropdownObj; % Write back the change
            dropdownHandle.Value = "";
        end

        function shouldClose = UserCloseWindowFcn(app, figHandle)
            % UserCloseWindowFcn Overrides the base class method to add custom closing logic.
            
            % If running in test mode, always allow the close without prompting.
            if app.IsTesting
                shouldClose = true;
                return;
            end
            
            % Otherwise, prompt the user for confirmation.
            answer = uiconfirm(figHandle, 'Save changes before closing?', 'Confirm Close');
            switch answer
                 case 'OK'
                     shouldClose = true;
                 case 'Cancel'
                     shouldClose = false;
                 otherwise
                     shouldClose = false;
            end
        end

        function UserMenuOpeningFcn(app, src, evt)
            % UserMenuOpeningFcn Overrides the base class method for custom menu logic.
            UserMenuOpeningFcn@guiser.App.class.base(app, src, evt);
            
            % Example: Dynamically change a menu item's text before it is displayed
            % if isfield(app.UIHandles, 'menuItem2')
            %    menuItem2Handle = app.UIHandles.menuItem2;
            %    menuItem2Handle.Text = ['Time is ' datestr(now,'HH:MM:SS')];
            % end
        end

        function UserMenuSelectedFcn(app, src, evt)
            % UserMenuSelectedFcn Overrides the base class method for custom menu actions.
            UserMenuSelectedFcn@guiser.App.class.base(app, src, evt);
            
            % Example: Display which menu item was clicked
            tag_parts = strsplit(src.Tag, '_');
            baseTag = tag_parts{1};
            disp(['Menu item selected: ' baseTag]);
        end

        function UserListboxEditButtonAddAction(app, listboxHandle)
            % UserListboxEditButtonAddAction Overrides the base class method to add a new item.

            % Prompt the user for a new item
            newItem = inputdlg('Enter new item:','Add Item', [1 50]);
            
            % If the user provided an item and didn't cancel
            if ~isempty(newItem) && ~isempty(newItem{1})
                % Get the tag of the listbox to find the component object
                tag_parts = strsplit(listboxHandle.Tag, '_');
                baseTag = tag_parts{1};
                listboxObj = app.ComponentObjects.(baseTag);

                % Preserve the current selection
                currentValue = listboxHandle.Value;

                % Update the component object (the model)
                listboxObj.Items{end+1} = newItem{1};
                
                % Update the UI handle (the view)
                listboxHandle.Items = listboxObj.Items;

                % Restore the selection
                listboxHandle.Value = currentValue;
                
                % Update the enable/disable state of the buttons
                app.EnableDisable();
            end
        end
    end

end