function data = uint16_scalar(data,computer_is_bigendian)
% from the spec
% 
% uint 16 stores a 16-bit big-endian unsigned integer
% +--------+--------+--------+
% |  0xcd  |ZZZZZZZZ|ZZZZZZZZ|
% +--------+--------+--------+
% 
arguments (Input)
    data (1,1) uint16
    computer_is_bigendian (1,1) logical
end
arguments (Output)
    data (1,3) uint8
end
data = typecast(data,"uint8").';
if ~computer_is_bigendian
    data = data(end:-1:1);
end
data = [0xcd;data];
end