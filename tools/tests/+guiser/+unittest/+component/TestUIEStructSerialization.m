classdef TestUIEStructSerialization < matlab.unittest.TestCase
    % TestUIEStructSerialization Verifies the serialization and deserialization
    % of UI element classes to and from structs and alphanumeric structs.

    methods (Test)

        function testUIButtonSerialization(testCase)
            testCase.runSerializationTest(guiser.component.UIButton());
        end

        function testUICheckboxSerialization(testCase)
            testCase.runSerializationTest(guiser.component.UICheckbox());
        end
        
        function testUIContextMenuSerialization(testCase)
            obj = guiser.component.UIContextMenu();
            obj.Items = {'Item 1'; 'Item 2'};
            testCase.runSerializationTest(obj);
        end

        function testUIDropdownSerialization(testCase)
            obj = guiser.component.UIDropdown();
            obj.Items = {'Option A'; 'Option B'};
            testCase.runSerializationTest(obj);
        end

        function testUIEditFieldSerialization(testCase)
            testCase.runSerializationTest(guiser.component.UIEditField());
        end

        function testUIFigureSerialization(testCase)
            testCase.runSerializationTest(guiser.component.UIFigure());
        end

        function testUIGridLayoutSerialization(testCase)
            obj = guiser.component.UIGridLayout();
            obj.RowHeight = {'1x', '22', 'fit'};
            obj.ColumnWidth = {'2x', '100'};
            testCase.runSerializationTest(obj);
        end

        function testUILabelSerialization(testCase)
            testCase.runSerializationTest(guiser.component.UILabel());
        end

        function testUIListboxSerialization(testCase)
            obj = guiser.component.UIListbox();
            obj.Items = {'List Item 1'; 'List Item 2'; 'List Item 3'};
            testCase.runSerializationTest(obj);
        end

        function testUIPanelSerialization(testCase)
            testCase.runSerializationTest(guiser.component.UIPanel());
        end

        function testUITabSerialization(testCase)
            testCase.runSerializationTest(guiser.component.UITab());
        end
        
        function testUITabGroupSerialization(testCase)
            testCase.runSerializationTest(guiser.component.UITabGroup());
        end

        function testUITextAreaSerialization(testCase)
            testCase.runSerializationTest(guiser.component.UITextArea());
        end

    end

    methods (Access = private)
        function runSerializationTest(testCase, obj)
            % Helper function to run the standard serialization test procedure.
            
            % Get the fully qualified class name as a string
            className = string(class(obj));

            % --- Test toStruct and fromStruct ---
            S = obj.toStruct();
            objFromS = guiser.util.StructSerializable.fromStruct(className, S);
            testCase.verifyEqual(objFromS, obj, ...
                ['Object recreated from struct does not match original for class: ' className]);

            % --- Test toAlphaNumericStruct and fromAlphaNumericStruct ---
            alphaS = obj.toAlphaNumericStruct();
            objFromAlphaS = guiser.util.StructSerializable.fromAlphaNumericStruct(className, alphaS);
            testCase.verifyEqual(objFromAlphaS, obj, ...
                ['Object recreated from alphanumeric struct does not match original for class: ' className]);
        end
    end
end
