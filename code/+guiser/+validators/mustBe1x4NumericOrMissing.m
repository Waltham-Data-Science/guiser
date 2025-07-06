function mustBe1x4NumericOrMissing(value)
    % First, check for the single, specific 'missing' case.
    % In a numeric context, missing is NaN. ismissing() is the
    % correct way to check for this. We also check that it's a scalar.
    if isscalar(value) && ismissing(value)
        % The value is 'missing', which is allowed. Exit the function.
        return;
    end
    
    % If the value is not 'missing', it MUST be a 1x4 numeric array.
    % This check will now correctly throw an error for an empty array []
    % because its size is [0,0], not [1,4].
    validateattributes(value, {'numeric'}, {'size', [1, 4]});
end
