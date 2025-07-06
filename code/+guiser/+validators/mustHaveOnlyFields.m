% mustHaveOnlyFields.m
function mustHaveOnlyFields(structInstance, allowedFieldNames)
%MUSTHAVEONLYFIELDS Validates that a structure only contains fields from a specified list.
%   MUSTHAVEONLYFIELDS(STRUCTINSTANCE, ALLOWEDFIELDNAMES) checks if all field
%   names in STRUCTINSTANCE are present in the cell array ALLOWEDFIELDNAMES.
%   If STRUCTINSTANCE contains any field not in ALLOWEDFIELDNAMES, an error is thrown.
%
%   Inputs:
%       STRUCTINSTANCE (1,1 struct): The structure to validate.
%       ALLOWEDFIELDNAMES (cell array of char/string): A cell array where each
%           element is a character vector or string scalar representing an
%           allowed field name.
%
%   Throws:
%       MException with identifier 'guiser.validators:mustHaveOnlyFields:ExtraFields'
%       if one or more fields in STRUCTINSTANCE are not found in ALLOWEDFIELDNAMES.

arguments
    structInstance (1,1) struct % Ensure it's a scalar struct
    allowedFieldNames (1,:) cell % Ensure it's a row cell array
end

% Validate contents of allowedFieldNames
if ~isempty(allowedFieldNames)
    isCharOrString = cellfun(@(x) (ischar(x) && isrow(x)) || (isstring(x) && isscalar(x)), allowedFieldNames);
    if ~all(isCharOrString)
        error('guiser.validators:mustHaveOnlyFields:InvalidAllowedNamesInput', ...
              'ALLOWEDFIELDNAMES must be a cell array of character row vectors or scalar strings.');
    end
end
% Convert allowedFieldNames to char cell array for setdiff if they might be strings
allowedFieldNamesChar = cellfun(@char, allowedFieldNames, 'UniformOutput', false);

actualFieldNames = fieldnames(structInstance);

% Use setdiff to find fields in actualFieldNames that are not in allowedFieldNamesChar
extraFields = setdiff(actualFieldNames, allowedFieldNamesChar);

if ~isempty(extraFields)
    % Format the list of extra fields and allowed fields for the error message
    extraFieldsStr = strjoin(cellfun(@(x) ['"', x, '"'], extraFields, 'UniformOutput', false), ', ');
    allowedFieldsStr = strjoin(cellfun(@(x) ['"', x, '"'], allowedFieldNamesChar, 'UniformOutput', false), ', ');

    if numel(extraFields) == 1
        errID = 'guiser:validators:mustHaveOnlyFields:ExtraField';
        msg = sprintf('Input struct contains an unexpected field: %s. Allowed fields are: %s.', ...
              extraFieldsStr, allowedFieldsStr);
    else
        errID = 'guiser:validators:mustHaveOnlyFields:ExtraFields';
        msg = sprintf('Input struct contains unexpected fields: %s. Allowed fields are: %s.', ...
              extraFieldsStr, allowedFieldsStr);
    end
    
    % Create and throw an MException object for a more detailed error report
    ME = MException(errID, msg);
    throwAsCaller(ME);
end

end
