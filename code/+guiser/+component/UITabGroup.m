classdef UITabGroup < guiser.component.mixin.UIContainer & ...
                guiser.component.mixin.UIVisualComponent & ...
                guiser.component.mixin.UIUnits & ...             
                guiser.component.mixin.UIBackgroundColor & ...                                   
                guiser.component.UIElement
    % UITABGROUP Describes a container for a group of tabs.

    properties
        % TabLocation - The location of the tab labels within the container.
        TabLocation (1,:) char {mustBeMember(TabLocation,{'top','bottom','left','right'})} = 'top'

        % SelectedTab - The Tag of the UITab that should be selected by default.
        SelectedTab (1,1) string = missing
    end
end