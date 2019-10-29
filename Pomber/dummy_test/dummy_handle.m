classdef dummy_handle <handle
    
    properties
        Property1
    end
    
    methods
        function obj = dummy_handle(value)
            %DUMMY_HANDLE Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = value;
        end
        
        function outputArg = return_value(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1;
        end
        
        function change_value(self,x)
            self.Property1=x;
        end
    end
end

