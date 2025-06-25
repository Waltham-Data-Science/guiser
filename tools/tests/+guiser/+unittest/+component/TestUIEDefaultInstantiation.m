classdef TestUIEDefaultInstantiation < matlab.unittest.TestCase
    % TestUIEDefaultInstantiation Verifies that all concrete UI element classes
    % can be instantiated with their default constructors.

    methods (Test)

        function testCreateUIButton(testCase)
            obj = guiser.component.UIButton();
            testCase.verifyClass(obj, ?guiser.component.UIButton);
        end

        function testCreateUICheckbox(testCase)
            obj = guiser.component.UICheckbox();
            testCase.verifyClass(obj, ?guiser.component.UICheckbox);
        end

        function testCreateUIContextMenu(testCase)
            obj = guiser.component.UIContextMenu();
            testCase.verifyClass(obj, ?guiser.component.UIContextMenu);
        end

        function testCreateUIDropdown(testCase)
            obj = guiser.component.UIDropdown();
            testCase.verifyClass(obj, ?guiser.component.UIDropdown);
        end

        function testCreateUIEditField(testCase)
            obj = guiser.component.UIEditField();
            testCase.verifyClass(obj, ?guiser.component.UIEditField);
        end

        function testCreateUIFigure(testCase)
            obj = guiser.component.UIFigure();
            testCase.verifyClass(obj, ?guiser.component.UIFigure);
        end

        function testCreateUIGridLayout(testCase)
            obj = guiser.component.UIGridLayout();
            testCase.verifyClass(obj, ?guiser.component.UIGridLayout);
        end

        function testCreateUILabel(testCase)
            obj = guiser.component.UILabel();
            testCase.verifyClass(obj, ?guiser.component.UILabel);
        end

        function testCreateUIListbox(testCase)
            obj = guiser.component.UIListbox();
            testCase.verifyClass(obj, ?guiser.component.UIListbox);
        end

        function testCreateUIPanel(testCase)
            obj = guiser.component.UIPanel();
            testCase.verifyClass(obj, ?guiser.component.UIPanel);
        end

        function testCreateUITab(testCase)
            obj = guiser.component.UITab();
            testCase.verifyClass(obj, ?guiser.component.UITab);
        end

        function testCreateUITabGroup(testCase)
            obj = guiser.component.UITabGroup();
            testCase.verifyClass(obj, ?guiser.component.UITabGroup);
        end

        function testCreateUITextArea(testCase)
            obj = guiser.component.UITextArea();
            testCase.verifyClass(obj, ?guiser.component.UITextArea);
        end

    end
end
