function data = uint64_scalar(data,computer_is_bigendian)

% uint 64 stores a 64-bit big-endian unsigned integer
% +--------+--------+--------+--------+--------+--------+--------+--------+--------+
% |  0xcf  |ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|
% +--------+--------+--------+--------+--------+--------+--------+--------+--------+

arguments (Input)
    data (1,1) uint64
    computer_is_bigendian (1,1) logical
end
arguments (Output)
    data (1,9) uint8
end
data = typecast(data,"uint8");
if ~computer_is_bigendian
    data = data(end:-1:1);
end
data = [0xcf,data];
end