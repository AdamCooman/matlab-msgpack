function obj = parse(bytes)
% parses a msgpack byte buffer into Matlab object
% 
%   res = msgpack.parse(bytes)
%
% where bytes is a vector of uint8
%
% The following conversions are applied
%
%     MsgPack  |  Matlab
% -------------|------------------------
%          nil | missing
%      float64 | double
%      float32 | single
%       string | string
%         bool | logical
%       fixint | int8
%        uintX | uintX (X=8,16,32,64)
%         intX |  intX (X=8,16,32,64)
%        array | cell array
%          map | msgpack.Map
%          bin | msgpack.Bin
%          ext | msgpack.Ext
%    timestamp | datetime

% Based on the code by Bastian Bechtold and Christopher Nadler
arguments
    bytes (1,:) uint8
end
obj = parse_local(bytes, 1, msgpack.dumptools.is_bigendian());
end

function [obj, idx] = parse_local(bytes, idx, computer_is_bigendian)
arguments
    bytes (1,:) uint8
    idx (1,1) double
    computer_is_bigendian (1,1) logical
end
current_byte = bytes(idx);
if bitand(0b10000000, current_byte) == 0b00000000
    % decode positive fixint
    obj = typecast(current_byte, "int8");
    idx = idx + 1;
    return
elseif bitand(0b11100000, current_byte) == 0b11100000
    % decode negative fixint
    obj = typecast(current_byte, "int8");
    idx = idx + 1;
    return
elseif bitand(0b11110000, current_byte) == 0b10000000
    % decode fixmap
    len = bitand(0b00001111, current_byte);
    [obj, idx] = parse_map(len, bytes, idx+1, computer_is_bigendian);
    return
elseif bitand(0b11110000, current_byte) == 0b10010000
    % decode fixarray
    len = bitand(0b00001111, current_byte);
    [obj, idx] = parse_array(len, bytes, idx+1, computer_is_bigendian);
    return
elseif bitand(0b11100000, current_byte) == 0b10100000
    % decode fixstr
    len = bitand(0b00011111, current_byte);
    [obj, idx] = parse_string(len, bytes, idx + 1);
    return
end

switch current_byte
    case uint8(192) % nil
        obj = missing;
        idx = idx+1;
    case uint8(194) % false
        obj = false;
        idx = idx+1;
    case uint8(195) % true
        obj = true;
        idx = idx+1;
    case uint8(196) % bin8
        len = bytes(idx+1);
        [obj, idx] = parse_bin(double(len), bytes, idx+2);
    case uint8(197) % bin16
        len = bytes_to_scalar(bytes(idx+1:idx+2), "uint16", computer_is_bigendian);
        [obj, idx] = parse_bin(double(len), bytes, idx+3);
    case uint8(198) % bin32
        len = bytes_to_scalar(bytes(idx+1:idx+4), "uint32", computer_is_bigendian);
        [obj, idx] = parse_bin(len, bytes, idx+5);
    case uint8(199) % ext8
        len = bytes(idx+1);
        [obj, idx] = parse_ext(double(len), bytes, idx+2);
    case uint8(200) % ext16
        len = bytes_to_scalar(bytes(idx+1:idx+2), "uint16", computer_is_bigendian);
        [obj, idx] = parse_ext(double(len), bytes, idx+3);
    case uint8(201) % ext32
        len = bytes_to_scalar(bytes(idx+1:idx+4), "uint32", computer_is_bigendian);
        [obj, idx] = parse_ext(double(len), bytes, idx+5);
    case uint8(202) % float32
        if computer_is_bigendian
            obj = typecast(bytes(idx+1:idx+4),"single");
        else
            obj = typecast(bytes(idx+4:-1:idx+1),"single");
        end
        idx = idx+5;
    case uint8(203) % float64
        if computer_is_bigendian
            obj = typecast(bytes(idx+1:idx+8),"double");
        else
            obj = typecast(bytes(idx+8:-1:idx+1),"double");
        end
        idx = idx+9;
    case uint8(204) % uint8
        obj = bytes(idx+1);
        idx = idx+2;
    case uint8(205) % uint16
        if computer_is_bigendian
            obj = typecast(bytes([idx+1 idx+2]),"uint16");
        else
            obj = typecast(bytes([idx+2 idx+1]),"uint16");
        end
        idx = idx+3;
    case uint8(206) % uint32
        if computer_is_bigendian
            obj = typecast(bytes(idx+1:idx+4),"uint32");
        else
            obj = typecast(bytes(idx+4:-1:idx+1),"uint32");
        end
        idx = idx+5;
    case uint8(207) % uint64
        if computer_is_bigendian
            obj = typecast(bytes(idx+1:idx+8),"uint64");
        else
            obj = typecast(bytes(idx+8:-1:idx+1),"uint64");
        end
        idx = idx+9;
    case uint8(208) % int8
        obj = typecast(bytes(idx+1), "int8");
        idx = idx+2;
    case uint8(209) % int16
        if computer_is_bigendian
            obj = typecast(bytes([idx+1,idx+2]),"int16");
        else
            obj = typecast(bytes([idx+2,idx+1]),"int16");
        end
        idx = idx+3;
    case uint8(210) % int32
        if computer_is_bigendian
            obj = typecast(bytes(idx+1:idx+4),"int32");
        else
            obj = typecast(bytes(idx+4:-1:idx+1),"int32");
        end
        idx = idx+5;
    case uint8(211) % int64
        if computer_is_bigendian
            obj = typecast(bytes(idx+1:idx+8),"int64");
        else
            obj = typecast(bytes(idx+8:-1:idx+1),"int64");
        end
        idx = idx+9;
    case uint8(212) % fixext1
        [obj, idx] = parse_ext(1, bytes, idx+1);
    case uint8(213) % fixext2
        [obj, idx] = parse_ext(2, bytes, idx+1);
    case uint8(214) % fixext4
        [obj, idx] = parse_ext(4, bytes, idx+1);
    case uint8(215) % fixext8
        [obj, idx] = parse_ext(8, bytes, idx+1);
    case uint8(216) % fixext16
        [obj, idx] = parse_ext(16, bytes, idx+1);
    case uint8(217) % str8
        len = bytes(idx+1);
        [obj, idx] = parse_string(double(len), bytes, idx+2);
    case uint8(218) % str16
        len = bytes_to_scalar(bytes(idx+1:idx+2), "uint16", computer_is_bigendian);
        [obj, idx] = parse_string(double(len), bytes, idx+3);
    case uint8(219) % str32
        len = bytes_to_scalar(bytes(idx+1:idx+4), "uint32",computer_is_bigendian);
        [obj, idx] = parse_string(double(len), bytes, idx+5);
    case uint8(220) % array16
        len = bytes_to_scalar(bytes(idx+1:idx+2), "uint16",computer_is_bigendian);
        [obj, idx] = parse_array(double(len), bytes, idx+3, computer_is_bigendian);
    case uint8(221) % array32
        len = bytes_to_scalar(bytes(idx+1:idx+4), "uint32",computer_is_bigendian);
        [obj, idx] = parse_array(double(len), bytes, idx+5, computer_is_bigendian);
    case uint8(222) % map16
        len = bytes_to_scalar(bytes(idx+1:idx+2), "uint16",computer_is_bigendian);
        [obj, idx] = parse_map(double(len), bytes, idx+3, computer_is_bigendian);
    case uint8(223) % map32
        len = bytes_to_scalar(bytes(idx+1:idx+4), "uint32",computer_is_bigendian);
        [obj, idx] = parse_map(double(len), bytes, idx+5, computer_is_bigendian);
    otherwise
        error("msgpack:parse:unknowntype", ...
            "Unknown type '"+dec2bin(current_byte)+"'");
end
end

function bytes = bytes_to_scalar(bytes, type, computer_is_bigendian)
if ~computer_is_bigendian
    bytes = bytes(end:-1:1);
end
bytes = typecast(bytes, type);
end

function [str, idx] = parse_string(len, bytes, idx)
str = string(native2unicode(bytes(idx:idx+len-1), "utf-8"));
idx = idx + len;
end

function [out, idx] = parse_bin(len, bytes, idx)
out = msgpack.Bin(bytes(idx:idx+len-1));
idx = idx + len;
end

function [out, idx] = parse_ext(len, bytes, idx)
out = msgpack.Ext(typecast(bytes(idx),"int8"),bytes(idx+1:idx+len));
idx = idx + len + 1;
end

function [out, idx] = parse_array(len, bytes, idx, computer_is_bigendian)
out = cell(1, len);
for n=1:len
    [out{n}, idx] = parse_local(bytes, idx, computer_is_bigendian);
end
end

function [out, idx] = parse_map(len, bytes, idx, computer_is_bigendian)
keyvalues = parse_array(2*len,bytes,idx,computer_is_bigendian);
out = msgpack.Map(keyvalues(1:2:end),keyvalues(2:2:end));
end
