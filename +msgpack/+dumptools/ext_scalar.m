function data = ext_scalar(data,computer_is_bigendian)
%
% from the spec:
% Ext format family stores a tuple of an integer and a byte array.
% 
% fixext 1 stores an integer and a byte array whose length is 1 byte
% +--------+--------+--------+
% |  0xd4  |  type  |  data  |
% +--------+--------+--------+
% 
% fixext 2 stores an integer and a byte array whose length is 2 bytes
% +--------+--------+--------+--------+
% |  0xd5  |  type  |       data      |
% +--------+--------+--------+--------+
% 
% fixext 4 stores an integer and a byte array whose length is 4 bytes
% +--------+--------+--------+--------+--------+--------+
% |  0xd6  |  type  |                data               |
% +--------+--------+--------+--------+--------+--------+
% 
% fixext 8 stores an integer and a byte array whose length is 8 bytes
% +--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+
% |  0xd7  |  type  |                                  data                                 |
% +--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+
% 
% fixext 16 stores an integer and a byte array whose length is 16 bytes
% +--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+
% |  0xd8  |  type  |                                  data                                                                                                         | 
% +--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+
% 
% ext 8 stores an integer and a byte array whose length is upto (2^8)-1 bytes:
% +--------+--------+--------+========+
% |  0xc7  |XXXXXXXX|  type  |  data  |
% +--------+--------+--------+========+
% 
% ext 16 stores an integer and a byte array whose length is upto (2^16)-1 bytes:
% +--------+--------+--------+--------+========+
% |  0xc8  |YYYYYYYY|YYYYYYYY|  type  |  data  |
% +--------+--------+--------+--------+========+
% 
% ext 32 stores an integer and a byte array whose length is upto (2^32)-1 bytes:
% +--------+--------+--------+--------+--------+--------+========+
% |  0xc9  |ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|  type  |  data  |
% +--------+--------+--------+--------+--------+--------+========+
% 
% where
% * XXXXXXXX is a 8-bit unsigned integer which represents N
% * YYYYYYYY_YYYYYYYY is a 16-bit big-endian unsigned integer which represents N
% * ZZZZZZZZ_ZZZZZZZZ_ZZZZZZZZ_ZZZZZZZZ is a big-endian 32-bit unsigned integer which represents N
% * N is a length of data
% * type is a signed 8-bit signed integer
% * type < 0 is reserved for future extension including 2-byte type information
arguments (Input)
    data (1,1) msgpack.Ext
    computer_is_bigendian (1,1) logical
end
arguments (Output)
    data (1,:) uint8
end
data = [get_header(numel(data.bytes),computer_is_bigendian),...
        typecast(data.type,"uint8"),...
        data.bytes];
end

function header = get_header(number_of_bytes,computer_is_bigendian)
switch number_of_bytes
    case 1
        % fixext 1
        header = 0xd4;
    case 2
        % fixext 2
        header = 0xd5;
    case 4
        % fixext 4
        header = 0xd6;
    case 8
        % fixext 8
        header = 0xd7;
    case 16
        % fixext 16
        header = 0xd8;
    otherwise
        if number_of_bytes < 256
            % ext 8
            header = 0xc7;
            amount = typecast(uint8(number_of_bytes),"uint8");
        elseif number_of_bytes < 65536
            % ext 16
            header = 0xc8;
            amount = typecast(uint16(number_of_bytes),"uint8");
        else
            % ext 32
            header = 0xc9;
            amount = typecast(uint32(number_of_bytes),"uint8");
        end
        if ~computer_is_bigendian
            amount = amount(end:-1:1);
        end
        header = [header,amount];
end
end