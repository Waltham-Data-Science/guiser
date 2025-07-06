classdef UIListbox < guiser.component.UIElement & ...
                     guiser.component.mixin.UIVisualComponent & ...
                     guiser.component.mixin.UIVisible & ...
                     guiser.component.mixin.UIBackgroundColor & ...  
                     guiser.component.mixin.UIInteractiveComponent & ...
                     guiser.component.mixin.UIValue & ...
                     guiser.component.mixin.UIValueChangedFcn & ...
                     guiser.component.mixin.UIDoubleClickFcn & ...
                     guiser.component.mixin.UIMultiselect & ...
                     guiser.component.mixin.UIItems

    % UILISTBOX Describes a list box UI component.

    methods (Static)
        function obj = fromAlphaNumericStruct(className, alphaS_in, options)
            % FROMALPHANUMERICSTRUCT Create a UIListbox from an alphanumeric struct.
            %
            % This method overrides the base class implementation to provide custom
            % handling for the 'Items' property.
            arguments
                className (1,1) string
                alphaS_in (1,1) struct
                options.errorIfFieldNotPresent (1,1) logical = false
                options.dispatch (1,1) logical = false
            end
            
            options.dispatch = false; % not used
            
            S_in = alphaS_in;
            
            if isfield(S_in, 'Items') && (ischar(S_in.Items) || isstring(S_in.Items))
                items_str = char(S_in.Items);
                if isempty(items_str)
                    items_cell = {};
                else
                    items_cell = strsplit(items_str, ', ');
                end

                if isrow(items_cell)
                    S_in.Items = items_cell'; % Enforce column vector
                else
                    S_in.Items = items_cell;
                end
            end
            
            % Note: We use the 'className' input here for consistency, even though
            % mfilename('class') would also work within this specific implementation.
            obj = guiser.util.StructSerializable.fromStruct(className, S_in, 'errorIfFieldNotPresent', options.errorIfFieldNotPresent);
        end
    end
end