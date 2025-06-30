% MockAppForTesting.m
classdef MockAppForTesting < guiser.App.class.base
% MOCKAPPFORTESTING A mock app that inherits from the base class for testing.
%
% This class provides a valid 'app' object for unit tests that call
% UIElement.createComponent, satisfying the type validation requirement.

    properties
        CallbackWasCalled = false
    end
    
    methods
        function app = MockAppForTesting(jsonFilePath)
            % The constructor simply passes the path to a dummy JSON file
            % up to the superclass constructor.
            app@guiser.App.class.base(jsonFilePath);
        end
        
        function aCallbackMethod(app, ~, ~)
            % A simple callback method to be triggered by the test.
            app.CallbackWasCalled = true;
        end
    end
end
