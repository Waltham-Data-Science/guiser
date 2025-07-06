% UITabNavigatorButton.m
classdef UITabNavigatorButton < guiser.component.UIButton
%UITABNAVIGATORBUTTON A specialized button for navigating through a UITabGroup.
%
%   This component extends the standard UIButton with a 'direction' property
%   to simplify the creation of 'Previous' and 'Next' buttons for a tabbed
%   interface. It automatically sets its callback function to
%   'TabNavigatorButtonPushedFcn', which is a method that should be
%   implemented in the app class to handle tab navigation logic.

    properties
        % direction - Specifies the navigation action for the button.
        %
        % Must be one of the following strings: 'previous' or 'next'.
        direction (1,:) char {mustBeMember(direction, {'previous', 'next'})} = 'next'
    end

    methods
        function obj = UITabNavigatorButton()
            %UITABNAVIGATORBUTTON Construct an instance of this class.
            %   This constructor sets the default callback function name.
            
            % Call the superclass constructor
            obj@guiser.component.UIButton();
            
            % Set the default callback for this specialized button
            obj.ButtonPushedFcn = 'TabNavigatorButtonPushedFcn';
        end
    end

end
