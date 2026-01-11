function data = array_header(number_of_objects,computer_is_bigendian)
% from the spec:
%
% fixarray stores an array whose length is up to 15 elements:
% +--------+~~~~~~~~~~~~~~~~~+
% |1001XXXX|    N objects    |
% +--------+~~~~~~~~~~~~~~~~~+
% 
% array 16 stores an array whose length is up to (2^16)-1 elements:
% +--------+--------+--------+~~~~~~~~~~~~~~~~~+
% |  0xdc  |YYYYYYYY|YYYYYYYY|    N objects    |
% +--------+--------+--------+~~~~~~~~~~~~~~~~~+
% 
% array 32 stores an array whose length is up to (2^32)-1 elements:
% +--------+--------+--------+--------+--------+~~~~~~~~~~~~~~~~~+
% |  0xdd  |ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|    N objects    |
% +--------+--------+--------+--------+--------+~~~~~~~~~~~~~~~~~+
% 
% where
% * XXXX is a 4-bit unsigned integer which represents N
% * YYYYYYYY_YYYYYYYY is a 16-bit big-endian unsigned integer which represents N
% * ZZZZZZZZ_ZZZZZZZZ_ZZZZZZZZ_ZZZZZZZZ is a 32-bit big-endian unsigned integer which represents N
% * N is the size of an array
arguments (Input)
    number_of_objects (1,1) uint32
    computer_is_bigendian (1,1) logical
end
arguments (Output)
    data (1,:) uint8
end
if number_of_objects < 16
    header = 0b10010000+uint8(number_of_objects);
    number_bytes = [];
elseif number_of_objects < 2^16
    header = 0xdc;
    number_bytes = uint16(number_of_objects);
else
    header = 0xdd;
    number_bytes = number_of_objects;
end
number_bytes = typecast(number_bytes,"uint8");
% if the computer is little-endian, we need to swap bytes
if ~computer_is_bigendian
    number_bytes = number_bytes(end:-1:1);
end
data = [header,number_bytes];
end