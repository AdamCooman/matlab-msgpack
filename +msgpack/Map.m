classdef Map
    properties (SetAccess=immutable)
        keys (1,:) cell
        values (1,:) cell
    end
    methods
        function self = Map(keys,values)
            self.keys = keys;
            self.values = values;
        end
        function res = struct(self)
            keyvalues = [self.keys;self.values];
            res = struct(keyvalues{:});
        end
    end
end