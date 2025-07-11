classdef UIButton < guiser.component.UIElement & ...
                   guiser.component.mixin.UIVisible & ...
                   guiser.component.mixin.UIVisualComponent & ...
                   guiser.component.mixin.UITextComponent & ...
                   guiser.component.mixin.UIIconComponent & ...
                   guiser.component.mixin.UIBackgroundColor & ...
                   guiser.component.mixin.UIInteractiveComponent & ...
                   guiser.component.mixin.UIText
    % UIBUTTON Describes a push button UI component.
    %
    % This class uses multiple inheritance to compose all necessary features
    % from the elemental, visual, text, icon, and interactive mixin classes.

    properties
        % ButtonPushedFcn - The name of the function to be executed when the button is pushed.
        ButtonPushedFcn (1,1) string = missing
    end
   
end