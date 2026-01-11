function data = int16_vector(data,computer_is_bigendian)
% from the spec
% int 16 stores a 16-bit big-endian signed integer
% +--------+--------+--------+
% |  0xd1  |ZZZZZZZZ|ZZZZZZZZ|
% +--------+--------+--------+
arguments (Input)
    data (:,1) int16
    computer_is_bigendian (1,1) logical
end
arguments (Output)
    data (1,:) uint8
end
number_of_elements = numel(data);
data = typecast(data,"uint8");
data = reshape(data,2,[]);
if ~computer_is_bigendian
    data = data(end:-1:1,:);
end
data = [repmat(0xd1,1,number_of_elements);data];
data = [msgpack.dumptools.array_header(number_of_elements,computer_is_bigendian),data(:).'];
end