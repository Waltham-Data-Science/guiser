% UIBackgroundColor.m
classdef UIBackgroundColor < handle
%UIBACKGROUNDCOLOR A mixin that provides the BackgroundColor property.
%   This is used by visual components that support setting a background color.

    properties
        BackgroundColor {guiser.validators.mustBeValidColor(BackgroundColor)} = [0.94 0.94 0.94]
    end

end
