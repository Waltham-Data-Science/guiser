% UIFigure.m
classdef UIFigure < guiser.component.mixin.UIContainer & ...
                   guiser.component.mixin.UIVisualComponent & ...
                   guiser.component.mixin.UIVisible & ...
                   guiser.component.mixin.UIUnits & ...
                   guiser.component.UIElement

    % UIFIGURE Describes the main application window (a uifigure).
    
    properties
        Name (1,:) char = 'MATLAB App'
        
        % The actual property name for a uifigure's color.
        Color {guiser.validators.mustBeValidColor(Color)} = [0.94 0.94 0.94]
        
        CloseRequestFcn (1,1) string = "CloseWindowFcn"
        WidthMin (1,1) {mustBeNumeric, mustBeNonnegative, mustBeFinite} = 0
        WidthMax (1,1) {mustBeNumeric, mustBeNonnegative} = Inf
        HeightMin (1,1) {mustBeNumeric, mustBeNonnegative, mustBeFinite} = 0
        HeightMax (1,1) {mustBeNumeric, mustBeNonnegative} = Inf
    end

end
