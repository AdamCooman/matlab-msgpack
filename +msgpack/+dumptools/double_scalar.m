function data = double_scalar(data,computer_is_bigendian)
% creates a msgpack bytestream for a scalar double

% from the spec
%
% float 32 stores a floating point number in IEEE 754 single precision floating point number format:
% +--------+--------+--------+--------+--------+
% |  0xca  |XXXXXXXX|XXXXXXXX|XXXXXXXX|XXXXXXXX|
% +--------+--------+--------+--------+--------+
% 
% float 64 stores a floating point number in IEEE 754 double precision floating point number format:
% +--------+--------+--------+--------+--------+--------+--------+--------+--------+
% |  0xcb  |YYYYYYYY|YYYYYYYY|YYYYYYYY|YYYYYYYY|YYYYYYYY|YYYYYYYY|YYYYYYYY|YYYYYYYY|
% +--------+--------+--------+--------+--------+--------+--------+--------+--------+
% 
% where
% * XXXXXXXX_XXXXXXXX_XXXXXXXX_XXXXXXXX is a big-endian IEEE 754 single precision floating point number.
% Extension of precision from single-precision to double-precision does not lose precision.
% * YYYYYYYY_YYYYYYYY_YYYYYYYY_YYYYYYYY_YYYYYYYY_YYYYYYYY_YYYYYYYY_YYYYYYYY is a big-endian
% IEEE 754 double precision floating point number

% arguments (Input)
%     data (1,1) double
%     computer_is_bigendian (1,1) logical
% end
% arguments (Output)
%     data (1,9) uint8
% end

data = typecast(data,"uint8");
if ~computer_is_bigendian
    data = data(end:-1:1);
end
data = [0xcb,data];
end