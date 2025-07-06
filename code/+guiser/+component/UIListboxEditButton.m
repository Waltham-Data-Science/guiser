% UIListboxEditButton.m
classdef UIListboxEditButton < guiser.component.UIButton
%UILISTBOXEDITBUTTON A specialized button for editing items in a UIListbox.
%
%   This component extends UIButton with an 'action' property that simplifies
%   the creation of buttons for adding, removing, or reordering listbox items.
%   Setting the 'action' automatically updates the button's icon and sets a
%   default callback function. It must be linked to a target listbox via the
%   'ListboxTag' property.

    properties
        % action - Specifies the editing action for the button.
        %
        % Must be one of the following strings: 'MoveUp', 'MoveDown', 'Add', or 'Remove'.
        action (1,:) char {mustBeMember(action, {'MoveUp', 'MoveDown', 'Add', 'Remove'})} = 'Add'

        % ListboxTag - The Tag of the UIListbox this button will edit.
        %
        % This must be a string matching the 'Tag' of a UIListbox component.
        ListboxTag (1,1) string = missing
    end

    methods
        function obj = UIListboxEditButton()
            %UILISTBOXEDITBUTTON Construct an instance of this class.
            %   This constructor sets the default callback function name.
            
            % Call the superclass constructor
            obj@guiser.component.UIButton();
            
            % Set the default callback for this specialized button
            obj.ButtonPushedFcn = 'ListboxEditButtonPushedFcn';
        end

        function set.action(obj, value)
            % SET.ACTION Custom setter for the 'action' property.
            %   This method validates the new action value and then automatically
            %   sets the button's Icon property based on the action.
            
            % Set the action property
            obj.action = value;
            
            % Set the icon based on the action
            switch value
                case 'MoveUp'
                    obj.Icon = 'resources/icons/up.png';
                case 'MoveDown'
                    obj.Icon = 'resources/icons/down.png';
                case 'Add'
                    obj.Icon = 'resources/icons/plus.png';
                case 'Remove'
                    obj.Icon = 'resources/icons/minus.png';
            end
        end
    end

end
