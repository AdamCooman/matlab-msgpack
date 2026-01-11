function data = int32_scalar(data,computer_is_bigendian)
% from the spec
% int 32 stores a 32-bit big-endian signed integer
%     +--------+--------+--------+--------+--------+
%     |  0xd2  |ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|
%     +--------+--------+--------+--------+--------+

% arguments (Input)
%     data (1,1) int32
%     computer_is_bigendian (1,1) logical
% end
% arguments (Output)
%     data (1,:) uint8
% end

data = typecast(data,"uint8");
if ~computer_is_bigendian
    data = data(end:-1:1);
end
data = [0xd2,data];
end

