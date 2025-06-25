classdef UIDropdown < guiser.component.UIElement & ...
                       guiser.component.mixin.UIVisualComponent & ...
                       guiser.component.mixin.UITextComponent & ...
                       guiser.component.mixin.UIInteractiveComponent & ...
                       guiser.component.mixin.UIValue & ...
                       guiser.component.mixin.UIValueChangedFcn & ...
                       guiser.component.mixin.UIItems & ...
                       guiser.component.mixin.UIEditable                       

    % UIDROPDOWN Describes a dropdown (pop-up menu) UI component.
    
    methods (Static)
        function obj = fromAlphaNumericStruct(className, alphaS_in, options)
            % FROMALPHANUMERICSTRUCT Create a UIDropdown from an alphanumeric struct.
            %
            % This method overrides the base class implementation to provide custom
            % handling for the 'Items' property.
            arguments
                className (1,1) string
                alphaS_in (1,1) struct
                options.errorIfFieldNotPresent (1,1) logical = false
                options.dispatch (1,1) logical = true
            end
            
            S_in = alphaS_in;
            
            if isfield(S_in, 'Items') && (ischar(S_in.Items) || isstring(S_in.Items))
                items_str = char(S_in.Items);
                if isempty(items_str)
                    items_cell = {};
                else
                    % Assuming default delimiter from StructSerializable
                    items_cell = strsplit(items_str, ', ');
                end

                if isrow(items_cell)
                    S_in.Items = items_cell'; % Enforce column vector
                else
                    S_in.Items = items_cell;
                end
            end
            
            % Call the base class's method with dispatch turned OFF to perform the final conversion.
            obj = fromAlphaNumericStruct@guiser.util.StructSerializable(className, S_in, ...
                'errorIfFieldNotPresent', options.errorIfFieldNotPresent, ...
                'dispatch', false);
        end
    end
end