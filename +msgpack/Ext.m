classdef Ext
    properties (SetAccess=immutable)
        type (1,1) int8
        bytes (1,:) uint8
    end
    methods
        function self = Ext(type,bytes)
            self.type = type;
            self.bytes = bytes;
        end
    end
end