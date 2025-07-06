classdef UITable < guiser.component.UIElement & ...
                   guiser.component.mixin.UIVisualComponent & ...
                   guiser.component.mixin.UIVisible & ...
                   guiser.component.mixin.UIUnits & ...
                   guiser.component.mixin.UIInteractiveComponent

    % UITABLE Describes a table UI component.
    % This component displays data in a scrollable grid. It supports
    % custom column names, widths, and callbacks for cell editing and selection.

    properties
        % The data to be displayed in the table. Can be a numeric array,
        % cell array, or a MATLAB table object. Defaults to 'missing'.
        Data = missing

        % Names for the columns. Must be a column cell array of strings.
        ColumnName (:,1) cell = {'Column 1'}

        % Width for the columns. A row cell array where each element can be
        % a number (pixels), 'auto', or a weighted string like '1x'.
        ColumnWidth (1,:) cell = {'auto'}

        % Defines which columns are editable. Must be a logical row vector.
        ColumnEditable (1,:) logical = false

        % Names for the rows. Can be a column cell array of strings or the
        % keyword 'numbered' (default).
        RowName (:,1) cell = {'numbered'}

        % The name of the app method to execute when a user edits an editable cell.
        % The event data will contain .Indices and .NewData properties.
        CellEditCallback (1,1) string = "DefaultCellEditFcn"

        % The name of the app method to execute when a user selects a cell.
        CellSelectionCallback (1,1) string = missing
    end

    methods
        function set.Data(obj, value)
            % Custom setter to handle struct-to-table conversion from JSON.
            if isstruct(value)
                % Convert struct from JSON/struct definition into a MATLAB table.
                obj.Data = struct2table(value, 'AsArray', true);
            else
                % Assign other valid types (table, cell, numeric, etc.) directly.
                obj.Data = value;
            end
        end
    end

    methods (Static)
        function obj = fromAlphaNumericStruct(className, alphaS_in, options)
            % FROMALPHANUMERICSTRUCT Creates a UITable from an alphanumeric struct.
            % This override handles the custom conversion for table properties that
            % might be stored as delimited strings.
            arguments
                className (1,1) string
                alphaS_in (1,1) struct
                options.errorIfFieldNotPresent (1,1) logical = false
                options.dispatch (1,1) logical = true
            end

            S_in = alphaS_in;

            % Convert ColumnName from a delimited string back to a cell column vector
            if isfield(S_in, 'ColumnName') && (ischar(S_in.ColumnName) || isstring(S_in.ColumnName))
                items_str = char(S_in.ColumnName);
                if isempty(items_str)
                    S_in.ColumnName = {};
                else
                    S_in.ColumnName = strsplit(items_str, ', ')'; % Ensure column vector
                end
            end

            % Convert ColumnWidth from a delimited string back to a cell row vector
            if isfield(S_in, 'ColumnWidth') && (ischar(S_in.ColumnWidth) || isstring(S_in.ColumnWidth))
                items_str = char(S_in.ColumnWidth);
                if isempty(items_str)
                    S_in.ColumnWidth = {};
                else
                    S_in.ColumnWidth = strsplit(items_str, ', '); % Ensure row vector
                end
            end

            % Call the base class's method with dispatch turned OFF to prevent recursion
            obj = fromAlphaNumericStruct@guiser.util.StructSerializable(className, S_in, ...
                'errorIfFieldNotPresent', options.errorIfFieldNotPresent, ...
                'dispatch', false);
        end
    end

end