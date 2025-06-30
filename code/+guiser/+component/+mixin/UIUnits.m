% UIUnits.m
classdef UIUnits < handle
%UIUNITS A mixin class that provides the 'Units' property.
%   This is used by visual components that support different units for
%   their Position property.

    properties
        Units (1,:) char {mustBeMember(Units,{'pixels','normalized','inches','centimeters','points','characters'})} = 'pixels'
    end

end
