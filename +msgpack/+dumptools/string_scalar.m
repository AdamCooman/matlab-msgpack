function data = string_scalar(data,computer_is_bigendian)
% creates the msgpack bytestream for a string scalar

% fixstr stores a byte array whose length is up to 31 bytes:
% +--------+========+
% |101XXXXX|  data  |
% +--------+========+
% 
% str 8 stores a byte array whose length is up to (2^8)-1 bytes:
% +--------+--------+========+
% |  0xd9  |YYYYYYYY|  data  |
% +--------+--------+========+
% 
% str 16 stores a byte array whose length is up to (2^16)-1 bytes:
% +--------+--------+--------+========+
% |  0xda  |ZZZZZZZZ|ZZZZZZZZ|  data  |
% +--------+--------+--------+========+
% 
% str 32 stores a byte array whose length is up to (2^32)-1 bytes:
% +--------+--------+--------+--------+--------+========+
% |  0xdb  |AAAAAAAA|AAAAAAAA|AAAAAAAA|AAAAAAAA|  data  |
% +--------+--------+--------+--------+--------+========+
% 
% where
% * XXXXX is a 5-bit unsigned integer which represents N
% * YYYYYYYY is a 8-bit unsigned integer which represents N
% * ZZZZZZZZ_ZZZZZZZZ is a 16-bit big-endian unsigned integer which represents N
% * AAAAAAAA_AAAAAAAA_AAAAAAAA_AAAAAAAA is a 32-bit big-endian unsigned integer which represents N
% * N is the length of data

arguments (Input)
    data (1,1) string
    computer_is_bigendian (1,1) logical
end
arguments (Output)
    data (1,:) uint8
end

data = unicode2native(data,"utf-8");
number_of_bytes = length(data);
if number_of_bytes < 32
    header = 0b10100000+uint8(number_of_bytes);
    number_bytes = [];
elseif number_of_bytes < 256
    header = 0xd9;
    number_bytes = uint8(number_of_bytes);
elseif number_of_bytes < 2^16
    header = 0xda;
    number_bytes = uint16(number_of_bytes);
else
    header = 0xdb;
    number_bytes = uint32(number_of_bytes);
end
number_bytes = typecast(number_bytes,"uint8");
if ~computer_is_bigendian
    number_bytes = number_bytes(end:-1:1);
end
data = [header,number_bytes,data];
end