function data = uint8_scalar(data)
% from the spec
% positive fixint stores 7-bit positive integer
% +--------+
% |0XXXXXXX|
% +--------+
% uint 8 stores a 8-bit unsigned integer
% +--------+--------+
% |  0xcc  |ZZZZZZZZ|
% +--------+--------+

% arguments (Input)
%     data (1,1) uint8
% end
% arguments (Output)
%     data (1,:) uint8
% end

if data>127
    data = [0xcc,data];
end
end