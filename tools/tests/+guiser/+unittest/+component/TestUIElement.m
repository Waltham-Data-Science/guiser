% TestUIElement.m
classdef TestUIElement < matlab.unittest.TestCase
    %TESTUIELEMENT Unit tests for the guiser.component.UIElement class.

    properties
        MockApp
        DummyJsonPath
    end

    methods(TestMethodSetup)
        function createMockApp(testCase)
            % Create a dummy JSON file for the mock app's constructor
            testCase.DummyJsonPath = 'dummyAppDefForTest.json';
            dummyStruct.dataStructure.gui = struct();
            dummyStruct.guiComponents = { ...
                struct('className', 'guiser.component.UIFigure', ...
                       'properties', struct('ParentTag', '', 'Tag', 'dummyRoot')) ...
            };
            fid = fopen(testCase.DummyJsonPath, 'w');
            fprintf(fid, '%s', jsonencode(dummyStruct));
            fclose(fid);

            % Instantiate the mock app, which now inherits from the base class
            testCase.MockApp = guiser.unittest.component.MockAppForTesting(testCase.DummyJsonPath);
        end
    end

    methods(TestMethodTeardown)
        function cleanupTest(testCase)
            % Delete the mock app figure and the dummy JSON file
            if ~isempty(testCase.MockApp) && isvalid(testCase.MockApp.Figure)
                delete(testCase.MockApp.Figure);
            end
            if isfile(testCase.DummyJsonPath)
                delete(testCase.DummyJsonPath);
            end
        end
    end

    methods (Test)

        function testDependentProperties(testCase)
            % Test the IsContainer and creatorFcn dependent properties.
            panelObj = guiser.component.UIPanel();
            testCase.verifyTrue(panelObj.IsContainer, 'IsContainer should be true for a UIPanel.');

            buttonObj = guiser.component.UIButton();
            testCase.verifyFalse(buttonObj.IsContainer, 'IsContainer should be false for a UIButton.');

            figureObj = guiser.component.UIFigure();
            testCase.verifyEqual(figureObj.creatorFcn, 'uifigure', 'creatorFcn for UIFigure should be ''uifigure''.');

            testCase.verifyEqual(buttonObj.creatorFcn, 'uibutton', 'creatorFcn for UIButton should be ''uibutton''.');
        end

        function testGetMatlabTerm(testCase)
            % Test the static getMatlabTerm method with various inputs.
            matlabTerm = guiser.component.UIElement.getMatlabTerm('guiser.component.UIButton', 'Text');
            testCase.verifyEqual(matlabTerm, 'Text', 'Failed to map a valid common property.');

            matlabTerm = guiser.component.UIElement.getMatlabTerm('guiser.component.UIFigure', 'Color');
            testCase.verifyEqual(matlabTerm, 'Color', 'Failed to map a valid class-specific property.');

            matlabTerm = guiser.component.UIElement.getMatlabTerm('guiser.component.UIFigure', 'WidthMin');
            testCase.verifyEmpty(matlabTerm, 'Should return empty for a guiser property with no MATLAB mapping.');

            matlabTerm = guiser.component.UIElement.getMatlabTerm('guiser.component.UIButton', 'NonExistentProperty');
            testCase.verifyEmpty(matlabTerm, 'Should return empty for a non-existent guiser property.');
                
            matlabTerm = guiser.component.UIElement.getMatlabTerm('guiser.component.NonExistentClass', 'Text');
            testCase.verifyEmpty(matlabTerm, 'Should return empty for a non-existent class name.');
        end

        function testCreateComponent(testCase)
            % Test the instance method createComponent.
            
            % Use the MockApp created in the TestMethodSetup
            mockApp = testCase.MockApp;
            
            % Set the Tag of the mock app's figure so the button can find it
            mockApp.Figure.Tag = ['testParent_', mockApp.AppUID];
            
            buttonObj = guiser.component.UIButton();
            buttonObj.Tag = 'testButton';
            buttonObj.ParentTag = 'testParent';
            buttonObj.Text = 'Click Me';
            buttonObj.ButtonPushedFcn = 'aCallbackMethod';
            
            % Call the method under test, which no longer needs the properties struct
            buttonHandle = buttonObj.createComponent(mockApp);
            
            testCase.verifyTrue(isvalid(buttonHandle), 'createComponent did not return a valid handle.');
            testCase.verifyClass(buttonHandle, 'matlab.ui.control.Button');
            testCase.verifyEqual(buttonHandle.Parent, mockApp.Figure, 'Parent was not set correctly.');
            testCase.verifyEqual(buttonHandle.Tag, ['testButton_', mockApp.AppUID], 'Tag was not made unique.');
            testCase.verifyEqual(buttonHandle.Text, 'Click Me', 'Text property was not set.');
            
            testCase.verifyClass(buttonHandle.ButtonPushedFcn, 'function_handle');
            mockApp.CallbackWasCalled = false;
            buttonHandle.ButtonPushedFcn(0,0); % Simulate click
            testCase.verifyTrue(mockApp.CallbackWasCalled, 'Callback did not execute as expected.');
        end
    end
end
