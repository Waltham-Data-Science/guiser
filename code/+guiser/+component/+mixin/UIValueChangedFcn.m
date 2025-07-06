% UIValueChangedFcn.m
classdef UIValueChangedFcn < handle
    % UIVALUECHANGEDFCN A mixin class for naming the ValueChangedFcn callback.
    %
    % This is for components where an action should be taken after the user
    % finalizes a change (e.g., pressing Enter or clicking away from an
    % edit field).

    properties
        % ValueChangedFcn - The name of the function to execute after the value changes.
        %
        % This should be a character vector with the name of a public method
        % in the corresponding app class.
        ValueChangedFcn (1,1) string = "ValueChangedFcn"
    end
end
