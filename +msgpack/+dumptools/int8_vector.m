function data = int8_vector(data,computer_is_bigendian)
% from the spec
% int 8 stores a 8-bit signed integer
% +--------+--------+
% |  0xd0  |ZZZZZZZZ|
% +--------+--------+

% arguments (Input)
%     data (:,1) int8
%     computer_is_bigendian (1,1) logical
% end
% arguments (Output)
%     data (1,:) uint8
% end

number_of_elements = numel(data);
data = typecast(data,"uint8");
data = [repmat(0xd0,1,number_of_elements);data.'];
data = [msgpack.dumptools.array_header(number_of_elements,computer_is_bigendian),data(:).'];
end

