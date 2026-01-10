function data = logical_scalar(data)

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
    data (1,1) logical
end
arguments (Output)
    data (1,1) uint8
end
data = 0xc2 + uint8(data);
end