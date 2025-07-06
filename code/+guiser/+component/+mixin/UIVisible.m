% UIVisible.m
classdef UIVisible < handle
%UIVISIBLE A mixin class that provides the 'Visible' property.
%   This is used by any component that can be shown or hidden in the UI.

    properties
        % Visible - Controls the visibility of the component.
        %
        % Must be either 'on' (default) or 'off'.
        Visible (1,:) char {mustBeMember(Visible,{'on','off'})} = 'on'
    end

end
