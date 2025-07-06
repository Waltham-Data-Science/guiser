% mustBeSingleElementStringEmptyOrMissing.m
function mustBeSingleElementStringEmptyOrMissing(value)
%mustBeSingleElementStringEmptyOrMissing Validate that the value is a single character string, an empty string, or missing.
%
%   mustBeSingleElementStringEmptyOrMissing(VALUE)
%   throws an error if VALUE is not a scalar string with 1 character, an
%   empty string (""), or the scalar 'missing' value.

    % Allow the 'missing' value
    if ismissing(value)
        return;
    end
    
    % Check if it's a scalar string
    if ~(isstring(value) && isscalar(value))
        error('guiser:validators:mustBeSingleElementStringEmptyOrMissing:InvalidType', ...
            'Value must be a scalar string.');
    end

    % Check if the string has a valid length (0 for empty, 1 for accelerator)
    if ~(strlength(value) == 0 || strlength(value) == 1)
        error('guiser:validators:mustBeSingleElementStringEmptyOrMissing:InvalidLength', ...
            'String value must be empty or have exactly one character.');
    end
end
