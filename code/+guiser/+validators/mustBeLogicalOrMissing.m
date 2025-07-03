% mustBeLogicalOrMissing.m
function mustBeLogicalOrMissing(value)
%mustBeLogicalOrMissing Validate that the input is a logical or the 'missing' value.
%
%   mustBeLogicalOrMissing(VALUE)
%   throws an error if VALUE is not a logical scalar (true/false) or the
%   scalar 'missing' value.
%
%   This is useful for properties that represent a state (on/off) but can
%   also be explicitly unassigned.
%
%   Example:
%       arguments
%           IsActive {guiser.validators.mustBeLogicalOrMissing}
%       end

    % Check for the scalar 'missing' case first.
    if isscalar(value) && ismissing(value)
        return; % The value is 'missing', which is allowed.
    end

    % If not 'missing', it must be a logical.
    % We also check for 'scalar' to ensure it's a single true/false, not an array.
    if ~islogical(value) || ~isscalar(value)
        error('guiser:validators:mustBeLogicalOrMissing:InvalidType', ...
            'Value must be a scalar logical (true or false) or the ''missing'' value.');
    end
end
