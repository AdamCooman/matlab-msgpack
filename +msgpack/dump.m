function data = dump(data,computer_is_bigendian)
% creates a msgpack byte sequence from the provided matlab object
%
%   data = msgpack.dump(object)
% 
% where object can be any of the types listed below
% data is a uint8 vector with the bytes of the msgpack
%
% The mapping between Matlab and MsgPack types is the following:
% 
%          Matlab  |  MsgPack
% -----------------|------------------
%    double scalar | float64 
%    double vector | array* of float64
%    single scalar | float32
%    single vector | array* of float32
%   logical scalar | bool 
%   logical vector | array* of bool 
%      int8 scalar | int 8 or fixint when possible
%      intX scalar | int X (X = 16,32,64)
%      intX vector | array of int X
%     uintX scalar | uint X
%     uintX vector | array* of uint X
%    string scalar | fixstr or str 8, str 16 or str 32 depending on the length
%    string vector | array* of fixstr or str 8, str 16 or str 32
%      char scalar | fixstr
%      char vector | fixstr or str 8, str 16 or str 32 depending on the length
%       cell array | array*
%    struct scalar | fixmap, map16 or map32 depending on the number of fields
%    struct vector | array* of fixmap, map16 or map32 depending on the number of fields  
%  datetime scalar | timestamp 32
%
% * array is fixarray, array 16 or array 32 depending on the length
%
% To allow dumping custom types and raw binary vectors, we also support two
% classes:
%
%          Matlab  |  MsgPack
% -----------------|------------------
%      msgpack.Bin | bin 8,16,32 depending on the size
%      msgpack.Ext | fixext 1,2,4,8 or ext 8,16,32 depending on the size
%
arguments (Input)
    data 
    computer_is_bigendian (1,1) logical = msgpack.dumptools.is_bigendian()
end
arguments (Output)
    data (1,:) uint8
end
switch class(data)
    case "double"
        if isscalar(data)
            data = msgpack.dumptools.double_scalar(data,computer_is_bigendian);
            return
        end
        data = msgpack.dumptools.double_vector(data(:),computer_is_bigendian);
    case "single"
        if isscalar(data)
            data = msgpack.dumptools.single_scalar(data,computer_is_bigendian);
            return
        end
        data = msgpack.dumptools.single_vector(data(:),computer_is_bigendian);
    case "logical"
        if isscalar(data)
            data = msgpack.dumptools.logical_scalar(data);
            return
        end
        data = msgpack.dumptools.logical_vector(data(:),computer_is_bigendian);
    case "uint8"
        if isscalar(data)
            data = msgpack.dumptools.uint8_scalar(data);
            return
        end
        data = msgpack.dumptools.uint8_vector(data(:),computer_is_bigendian);
    case "uint16"
        if isscalar(data)
            data = msgpack.dumptools.uint16_scalar(data,computer_is_bigendian);
            return
        end
        data = msgpack.dumptools.uint16_vector(data(:),computer_is_bigendian);
    case "uint32"
        if isscalar(data)
            data = msgpack.dumptools.uint32_scalar(data,computer_is_bigendian);
            return
        end
        data = msgpack.dumptools.uint32_vector(data(:),computer_is_bigendian);
    case "uint64"
        if isscalar(data)
            data = msgpack.dumptools.uint64_scalar(data,computer_is_bigendian);
            return
        end
        data = msgpack.dumptools.uint64_vector(data(:),computer_is_bigendian);
    case "int8"
        if isscalar(data)
            data = msgpack.dumptools.int8_scalar(data);
            return
        end
        data = msgpack.dumptools.int8_vector(data(:),computer_is_bigendian);
    case "int16"
        if isscalar(data)
            data = msgpack.dumptools.int16_scalar(data,computer_is_bigendian);
            return
        end
        data = msgpack.dumptools.int16_vector(data(:),computer_is_bigendian);
    case "int32"
        if isscalar(data)
            data = msgpack.dumptools.int32_scalar(data,computer_is_bigendian);
            return
        end
        data = msgpack.dumptools.int32_vector(data(:),computer_is_bigendian);
    case "int64"
        if isscalar(data)
            data = msgpack.dumptools.int64_scalar(data,computer_is_bigendian);
            return
        end
        data = msgpack.dumptools.int64_vector(data(:),computer_is_bigendian);
    case "string"
        if isscalar(data)
            data = msgpack.dumptools.string_scalar(data,computer_is_bigendian);
            return
        end
        data = msgpack.dumptools.string_vector(data(:),computer_is_bigendian);
    case "missing"
        data = uint8(192);
    case "char"
        data = msgpack.dumptools.char_vector(data(:).',computer_is_bigendian);
    case "datetime"
        if ~isscalar(data)
            % TODO: fast version of this which avoids the num2cell
            data = num2cell(data(:));
            data = msgpack.dump(data,computer_is_bigendian);
            return
        end
        data = msgpack.dumptools.datetime_scalar(data,computer_is_bigendian);
    case "struct"
        if ~isscalar(data)
            % TODO: fast version of this which avoids the num2cell
            data = num2cell(data(:));
            data = msgpack.dump(data,computer_is_bigendian);
            return
        end
        fields = fieldnames(data);
        values = struct2cell(data);
        data = msgpack.dumptools.map_header(numel(fields),computer_is_bigendian);
        for ii = 1 : numel(values)
            data = [data,...
                    msgpack.dumptools.string_scalar(fields{ii},computer_is_bigendian),...
                     msgpack.dump(values{ii},computer_is_bigendian)];
        end
    case "dictionary"
        if ~isscalar(data)
            % TODO: fast version of this which avoids the num2cell
            data = num2cell(data(:));
            data = msgpack.dump(data,computer_is_bigendian);
            return
        end
        fields = data.keys();
        values = data.values();
        data = msgpack.dumptools.map_header(numel(fields),computer_is_bigendian);
        for ii = 1 : numel(values)
            data = [data,...
                msgpack.dumptools.string_scalar(fields(ii),computer_is_bigendian),...
                msgpack.dump(values(ii),computer_is_bigendian)];
        end
    case "cell"
        number_of_elements = numel(data);
        for ii = 1 : number_of_elements
            data{ii} = msgpack.dump(data{ii},computer_is_bigendian);
        end
        data = cat(2,msgpack.dumptools.array_header(number_of_elements,computer_is_bigendian),data{:});
    case "msgpack.Bin"
        if ~isscalar(data)
            % TODO: fast version of this which avoids the num2cell
            data = num2cell(data(:));
            data = msgpack.dump(data,computer_is_bigendian);
            return
        end
        data = msgpack.dumptools.bin_scalar(data,computer_is_bigendian);
    case "msgpack.Ext"
        if ~isscalar(data)
            % TODO: fast version of this which avoids the num2cell
            data = num2cell(data(:));
            data = msgpack.dump(data,computer_is_bigendian);
            return
        end
        data = msgpack.dumptools.ext_scalar(data,computer_is_bigendian);
    otherwise
        error("unsuppported class: '"+class(data)+"'")
end
end