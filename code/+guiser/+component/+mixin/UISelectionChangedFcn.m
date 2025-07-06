% UISelectionChangedFcn.m
classdef UISelectionChangedFcn < handle
    % UISELECTIONCHANGEDFCN A mixin for naming the SelectionChangedFcn callback.
    %
    % This is for components like button groups where an action should be
    % taken after the user changes the selection.

    properties
        % SelectionChangedFcn - The name of the function to execute after the selection changes.
        %
        % This should be a character vector with the name of a public method
        % in the corresponding app class.
        SelectionChangedFcn (1,1) string = missing
    end

end
