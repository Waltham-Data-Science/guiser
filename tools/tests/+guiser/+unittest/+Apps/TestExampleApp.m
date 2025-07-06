% TestExampleApp.m
classdef TestExampleApp < matlab.unittest.TestCase
    %TESTEXAMPLEAPP Unit tests for the complete ExampleApp functionality.
    
    properties
        App
    end
    
    methods(TestMethodSetup)
        function setupTest(testCase)
            % Create an instance of the ExampleApp in testing mode.
            testCase.App = guiser.App.class.ExampleApp('IsTesting', true);
            % Add a teardown to ensure the app is deleted even if a test fails.
            testCase.addTeardown(@() delete(testCase.App));
            % Ensure all graphics events are processed before running the test
            drawnow;
        end
    end
    
    methods(Test)
        
        function testAppInitialization(testCase)
            % Test that the app and its components are created correctly.
            testCase.verifyClass(testCase.App, 'guiser.App.class.ExampleApp');
            testCase.verifyNotEmpty(testCase.App.UIHandles);
            testCase.verifyNotEmpty(testCase.App.ComponentObjects);
            
            % Check for a few key components
            testCase.verifyTrue(isfield(testCase.App.UIHandles, 'guiserExampleApp'));
            testCase.verifyTrue(isfield(testCase.App.ComponentObjects, 'tab1TextBox1'));
        end

        function testEditFieldTwoWayBinding(testCase)
            % Test that changing a UI value updates the component object.
            
            editFieldHandle = testCase.App.UIHandles.tab1TextBox1;
            newValue = 'This is a test';
            
            % Programmatically change the value and then call the callback
            editFieldHandle.Value = newValue;
            drawnow; % Allow UI to process the change
            testCase.App.ValueChangedFcn(editFieldHandle, struct('Value', newValue, 'PreviousValue', ''));
            
            % Re-fetch the component object to get the updated state
            updatedEditFieldObj = testCase.App.ComponentObjects.tab1TextBox1;
            
            % Verify the component object's value was updated
            testCase.verifyEqual(string(updatedEditFieldObj.Value), string(newValue));
        end

        function testListboxTwoWayBinding(testCase)
            % Test that changing a listbox selection updates the component object.
            
            listboxHandle = testCase.App.UIHandles.tab4SampleListbox;
            newValue = 'Item C';
            
            % Programmatically change the value and then call the callback
            listboxHandle.Value = newValue;
            drawnow; % Allow UI to process the change
            testCase.App.ValueChangedFcn(listboxHandle, struct('Value', newValue, 'PreviousValue', ''));
            
            % Re-fetch the component object to get the updated state
            updatedListboxObj = testCase.App.ComponentObjects.tab4SampleListbox;

            % Verify the component object's value was updated
            testCase.verifyEqual(string(updatedListboxObj.Value), string(newValue));
        end

        function testTabNavigatorButtons(testCase)
            % Test the functionality of the Previous/Next tab buttons.
            
            prevButton = testCase.App.UIHandles.prevTabButton;
            nextButton = testCase.App.UIHandles.nextTabButton;
            tabGroup = testCase.App.UIHandles.mainTabGroup;
            
            % 1. Initial State - Use char() to handle OnOffSwitchState type
            testCase.verifyEqual(char(prevButton.Enable), 'off', 'Previous button should be disabled on the first tab.');
            testCase.verifyEqual(char(nextButton.Enable), 'on', 'Next button should be enabled on the first tab.');
            
            % 2. Press Next Button
            nextButton.ButtonPushedFcn(nextButton, []);
            drawnow;
            
            % Verify state on Tab 2
            testCase.verifyEqual(tabGroup.SelectedTab.Title, 'Tab 2');
            testCase.verifyEqual(char(prevButton.Enable), 'on', 'Previous button should be enabled after moving to the second tab.');
            
            % 3. Navigate to the last tab
            numTabs = numel(tabGroup.Children);
            for i = 3:numTabs
                nextButton.ButtonPushedFcn(nextButton, []);
                drawnow;
            end
            
            % Verify state on the last tab
            testCase.verifyEqual(tabGroup.SelectedTab.Title, ['Tab ' num2str(numTabs)]);
            testCase.verifyEqual(char(nextButton.Enable), 'off', 'Next button should be disabled on the last tab.');
        end

        function testListboxEditButtonEnableState(testCase)
            % Test the enable/disable logic of the listbox edit buttons.
            
            listboxHandle = testCase.App.UIHandles.tab4SampleListbox;
            removeButton = testCase.App.UIHandles.listboxRemoveButton;
            moveUpButton = testCase.App.UIHandles.listboxMoveUpButton;
            
            % 1. Initial State (no selection)
            listboxHandle.Value = {};
            testCase.App.EnableDisable(); % Manually trigger update
            drawnow;
            
            testCase.verifyEqual(char(removeButton.Enable), 'off');
            testCase.verifyEqual(char(moveUpButton.Enable), 'off');
            
            % 2. State with selection
            listboxHandle.Value = 'Item B';
            testCase.App.EnableDisable(); % Manually trigger update
            drawnow;
            
            testCase.verifyEqual(char(removeButton.Enable), 'on');
            testCase.verifyEqual(char(moveUpButton.Enable), 'on');
        end

    end
end