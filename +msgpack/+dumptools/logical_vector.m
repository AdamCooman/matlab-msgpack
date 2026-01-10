function data = logical_vector(data,computer_is_bigendian)

% from the spec
% false:
% +--------+
% |  0xc2  |
% +--------+
% 
% true:
% +--------+
% |  0xc3  |
% +--------+
arguments (Input)
    data (:,1) logical
    computer_is_bigendian (1,1) logical
end
arguments (Output)
    data (1,:) uint8
end
data = 0xc2 + uint8(data);
data = msgpack.dumptools.add_array_header(data,numel(data),computer_is_bigendian);
end