classdef Bin
    properties (SetAccess=immutable)
        bytes (1,:) uint8
    end

    methods
        function self = Bin(bytes)
            self.bytes = bytes;
        end
    end
end