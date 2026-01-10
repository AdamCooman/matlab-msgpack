function pack = struct_scalar(data,computer_is_bigendian)
%STRUCT_SCALAR undefined

% from the spec:
% fixmap stores a map whose length is upto 15 elements
% +--------+~~~~~~~~~~~~~~~~~+
% |1000XXXX|   N*2 objects   |
% +--------+~~~~~~~~~~~~~~~~~+
% 
% map 16 stores a map whose length is upto (2^16)-1 elements
% +--------+--------+--------+~~~~~~~~~~~~~~~~~+
% |  0xde  |YYYYYYYY|YYYYYYYY|   N*2 objects   |
% +--------+--------+--------+~~~~~~~~~~~~~~~~~+
% 
% map 32 stores a map whose length is upto (2^32)-1 elements
% +--------+--------+--------+--------+--------+~~~~~~~~~~~~~~~~~+
% |  0xdf  |ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|   N*2 objects   |
% +--------+--------+--------+--------+--------+~~~~~~~~~~~~~~~~~+
% 
% where
% * XXXX is a 4-bit unsigned integer which represents N
% * YYYYYYYY_YYYYYYYY is a 16-bit big-endian unsigned integer which represents N
% * ZZZZZZZZ_ZZZZZZZZ_ZZZZZZZZ_ZZZZZZZZ is a 32-bit big-endian unsigned integer which represents N
% * N is the size of a map
% * odd elements in objects are keys of a map
% * the next element of a key is its associated value
arguments (Input)
    data (1,1) struct
    computer_is_bigendian (1,1) logical
end
arguments (Output)
    pack (1,:) uint8
end
fields = fieldnames(data);
pack = uint8.empty;
for ff = 1 : numel(fields)
    pack = [pack,...
        msgpack.dumptools.string_scalar(fields{ff},computer_is_bigendian),...
        data.(fields{ff})
        ];
end
number_of_fields = numel(fields);
if number_of_fields < 16
    header = 0b10000000+uint8(number_of_fields);
    number_bytes = [];
elseif number_of_fields < 2^16
    header = 0xde;
    number_bytes = uint16(number_of_fields);
else
    header = 0xdf;
    number_bytes = number_of_fields;
end
number_bytes = typecast(number_bytes,"uint8");
if ~computer_is_bigendian
    number_bytes = number_bytes(end:-1:1);
end
pack = [header,number_bytes,pack];
end