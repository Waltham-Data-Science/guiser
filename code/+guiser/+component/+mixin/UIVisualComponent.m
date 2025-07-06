classdef UIVisualComponent < handle
    % UIVISUALCOMPONENT A mixin for describing visual UI properties.
    properties
        Position = missing
        Layout (1,1) guiser.component.mixin.UILayout = guiser.component.mixin.UILayout('Row',[],'Column',[])
        Tooltip (1,1) string = missing
        ContextMenuTag (1,1) string = missing        
    end
    methods
        function set.Position(obj, value)
            % First, allow the 'missing' value to be set directly.
            if isscalar(value) && ismissing(value)
                obj.Position = missing;
                return;
            end

            % Next, check if the value is a 4x1 column vector and transpose it.
            if isnumeric(value) && iscolumn(value) && numel(value) == 4
                value = value'; % Transpose to a 1x4 row vector
            end

            % Now, perform the validation on the potentially reshaped value.
            validateattributes(value, {'numeric'}, {'size', [1, 4]});

            % Finally, assign the validated value to the property.
            obj.Position = value;
        end
    end
end