function data = uint8_vector(data,computer_is_bigendian)
% from the spec
% uint 8 stores a 8-bit unsigned integer
% +--------+--------+
% |  0xcc  |ZZZZZZZZ|
% +--------+--------+

% arguments (Input)
%     data (:,1) uint8
%     computer_is_bigendian (1,1) logical
% end
% arguments (Output)
%     data (1,:) uint8
% end

number_of_elements = numel(data);
data = [repmat(0xcc,1,number_of_elements);data.'];
data = [msgpack.dumptools.array_header(number_of_elements,computer_is_bigendian),data(:).'];
end