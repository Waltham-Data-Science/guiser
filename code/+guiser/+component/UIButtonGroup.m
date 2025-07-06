% UIButtonGroup.m
classdef UIButtonGroup < guiser.component.mixin.UIContainer & ...
                         guiser.component.mixin.UIVisible & ...
                         guiser.component.mixin.UIVisualComponent & ...
                         guiser.component.mixin.UIUnits & ...
                         guiser.component.mixin.UIBackgroundColor & ...
                         guiser.component.mixin.UITextComponent & ...
                         guiser.component.mixin.UITitle & ...
                         guiser.component.mixin.UIBorderType & ...
                         guiser.component.mixin.UISelectionChangedFcn & ...
                         guiser.component.UIElement
    % UIBUTTONGROUP Describes a button group container.
    %   This component manages exclusive selection for UIRadioButton and
    %   UIToggleButton components.

    properties
        % SelectedTag - The Tag of the UIRadioButton that should be selected by default.
        SelectedTag (1,1) string = missing
    end

    methods
        function obj = UIButtonGroup()
            %UIBUTTENGROUP Construct an instance of this class.
            %   This constructor sets the default SelectionChangedFcn to ensure
            %   two-way data binding works out of the box.
            
            obj.SelectionChangedFcn = 'ValueChangedFcn';
        end
    end
    
end
