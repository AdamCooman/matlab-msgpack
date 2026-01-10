function data = int8_scalar(data)
% from the spec

% positive fixint stores 7-bit positive integer
% +--------+
% |0XXXXXXX|
% +--------+
% 
% negative fixint stores 5-bit negative integer
% +--------+
% |111YYYYY|
% +--------+
%
% int 8 stores a 8-bit signed integer
% +--------+--------+
% |  0xd0  |ZZZZZZZZ|
% +--------+--------+

arguments (Input)
    data (1,1) int8
end
arguments (Output)
    data (1,:) uint8
end
if data > int8(-32)
    data = typecast(data,"uint8");
else
    data = [0xd0,typecast(data,"uint8")];
end
end

