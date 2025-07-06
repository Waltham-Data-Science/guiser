% UIMenu.m
classdef UIMenu < guiser.component.UIElement & ...
                  guiser.component.mixin.UIText & ...
                  guiser.component.mixin.UIInteractiveComponent
%UIMENU Describes a single menu item within a UIContextMenu.

    properties
        % MenuSelectedFcn - The name of the app method to execute when the menu item is selected.
        MenuSelectedFcn (1,1) string = missing

        % Separator - Controls whether a dividing line appears above this menu item.
        Separator (1,:) char {mustBeMember(Separator,{'on','off'})} = 'off'
        
        % Accelerator - A single character keyboard shortcut for the menu item.
        Accelerator (1,1) string {guiser.validators.mustBeSingleElementStringEmptyOrMissing} = missing
    end

    methods
        function obj = UIMenu()
            %UIMENU Construct an instance of this class.
        end
    end

end
