function data = bin_scalar(data,computer_is_bigendian)
% from spec
%
% Bin format family stores an byte array in 2, 3, or 5 bytes of extra bytes
% in addition to the size of the byte array. 
% 
% bin 8 stores a byte array whose length is upto (2^8)-1 bytes:
% +--------+--------+========+
% |  0xc4  |XXXXXXXX|  data  |
% +--------+--------+========+
% 
% bin 16 stores a byte array whose length is upto (2^16)-1 bytes:
% +--------+--------+--------+========+
% |  0xc5  |YYYYYYYY|YYYYYYYY|  data  |
% +--------+--------+--------+========+
% 
% bin 32 stores a byte array whose length is upto (2^32)-1 bytes:
% +--------+--------+--------+--------+--------+========+
% |  0xc6  |ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|  data  |
% +--------+--------+--------+--------+--------+========+
% 
% where
% * XXXXXXXX is a 8-bit unsigned integer which represents N
% * YYYYYYYY_YYYYYYYY is a 16-bit big-endian unsigned integer which represents N
% * ZZZZZZZZ_ZZZZZZZZ_ZZZZZZZZ_ZZZZZZZZ is a 32-bit big-endian unsigned integer which represents N
% * N is the length of data

% arguments (Input)
%     data (1,1) msgpack.Bin
%     computer_is_bigendian (1,1) logical
% end
% arguments (Output)
%     data (1,:) uint8
% end

number_of_bytes = numel(data.bytes);
if number_of_bytes < 256
    header = 0xc4;
    amount = uint8(number_of_bytes);
elseif number_of_bytes < 2^16
    header = 0xc5;
    amount = typecast(uint16(number_of_bytes),"uint8");
else
    header = 0xc6;
    amount = typecast(uint32(number_of_bytes),"uint8");
end
if ~computer_is_bigendian
    amount = amount(end:-1:1);
end
data = [header,amount,data.bytes];
end