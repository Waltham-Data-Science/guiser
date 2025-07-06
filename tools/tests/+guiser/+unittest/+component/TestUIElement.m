% TestUIElement.m
classdef TestUIElement < matlab.unittest.TestCase
    % TESTUIELEMENT Unit tests for the guiser.component.UIElement class.
    
    properties
        MockApp
    end
    
    methods(TestMethodSetup)
        function setupTest(testCase)
            % Create a mock app object for testing.
            testCase.MockApp = guiser.unittest.component.MockAppForTesting();
        end
    end
    
    methods(TestMethodTeardown)
        function cleanupTest(testCase)
            % Clean up any figures created during the test.
            % This method now correctly handles the multi-window architecture.
            
            if ~isempty(testCase.MockApp) && isstruct(testCase.MockApp.UIHandles)
                % Get all tags of created UI handles
                handleTags = fieldnames(testCase.MockApp.UIHandles);
                
                % Loop through all handles
                for i = 1:numel(handleTags)
                    tag = handleTags{i};
                    handle = testCase.MockApp.UIHandles.(tag);
                    
                    % Check if the handle is a figure and is still valid
                    if isa(handle, 'matlab.ui.Figure') && isvalid(handle)
                        delete(handle);
                    end
                end
            end
            testCase.MockApp = [];
        end
    end
    
    methods(Test)
        function testDependentProperties(testCase)
            % Test the dependent properties IsContainer and creatorFcn.
            
            % Test a non-container
            button = guiser.component.UIButton();
            testCase.verifyFalse(button.IsContainer);
            testCase.verifyEqual(button.creatorFcn, 'uibutton');
            
            % Test a container
            panel = guiser.component.UIPanel();
            testCase.verifyTrue(panel.IsContainer);
            testCase.verifyEqual(panel.creatorFcn, 'uipanel');

            % Test a figure
            fig = guiser.component.UIFigure();
            testCase.verifyTrue(fig.IsContainer);
            testCase.verifyEqual(fig.creatorFcn, 'uifigure');
        end
        
        function testGetMatlabTerm(testCase)
            % Test the static method for mapping GUISER terms to MATLAB terms.
            [matlabTerm, isReadOnly, isPostBuild] = guiser.component.UIElement.getMatlabTerm('guiser.component.UIButton', 'Text');
            testCase.verifyEqual(matlabTerm, 'Text');
            testCase.verifyFalse(isReadOnly);
            testCase.verifyFalse(isPostBuild);
            
            % Test a post-build property
            [matlabTerm, isReadOnly, isPostBuild] = guiser.component.UIElement.getMatlabTerm('guiser.component.UIButtonGroup', 'SelectedTag');
            testCase.verifyEqual(matlabTerm, 'SelectedObject');
            testCase.verifyFalse(isReadOnly);
            testCase.verifyTrue(isPostBuild);
        end
        
        function testCreateComponent(testCase)
            % Test the creation of a live MATLAB UI component.
            mockApp = testCase.MockApp;
            
            % Create a temporary figure to act as the parent for the test.
            testFig = uifigure('Visible', 'off');
            testCase.addTeardown(@() delete(testFig)); % Ensure it's deleted after the test
            
            % Set the tag on our temporary parent figure.
            parentTag = 'testParent';
            testFig.Tag = [parentTag, '_', mockApp.AppUID];
            
            % Define a button component object
            buttonObj = guiser.component.UIButton();
            buttonObj.ParentTag = parentTag;
            buttonObj.Tag = 'testButton';
            buttonObj.Text = 'Click Me';
            
            % Create the live component
            h = buttonObj.createComponent(mockApp);
            
            % Verify the handle is correct and properties were set
            testCase.verifyClass(h, 'matlab.ui.control.Button');
            testCase.verifyEqual(h.Text, 'Click Me');
            testCase.verifyEqual(h.Parent, testFig);
        end
    end
end
