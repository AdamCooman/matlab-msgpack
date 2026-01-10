function pack = string_vector(data,computer_is_bigendian)
arguments (Input)
    data (:,1) string
    computer_is_bigendian (1,1) logical
end
arguments (Output)
    pack (1,:) uint8
end
number_of_elements = numel(data);
pack = uint8.empty();
for value = data.'
    pack = [pack,msgpack.dumptools.string_scalar(value,computer_is_bigendian)];
end
pack = msgpack.dumptools.add_array_header(data,number_of_elements,computer_is_bigendian);
end