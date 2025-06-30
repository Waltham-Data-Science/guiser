classdef UIVisualComponent < handle
    % UIVISUALCOMPONENT A mixin for describing visual UI properties.
    properties
        Position {guiser.validators.mustBe1x4NumericOrMissing} = missing
        Layout (1,1) guiser.component.mixin.UILayout = guiser.component.mixin.UILayout('Row',[],'Column',[])
        Tooltip (1,1) string = missing
    end
end