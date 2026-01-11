function data = double_vector(data,computer_is_bigendian)

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
arguments (Input)
    data (:,1) double
    computer_is_bigendian (1,1) logical
end
arguments (Output)
    data (1,:) uint8
end
number_of_values = numel(data);
data = typecast(data,"uint8");
data = reshape(data,8,[]);
if ~computer_is_bigendian
    data = data(end:-1:1,:);
end
data = cat(1,repmat(0xcb,1,number_of_values),data);
data = [msgpack.dumptools.array_header(number_of_values,computer_is_bigendian),data(:).'];
end