function pack = string_vector(data,computer_is_bigendian)
% arguments (Input)
%     data (:,1) string
%     computer_is_bigendian (1,1) logical
% end
% arguments (Output)
%     pack (1,:) uint8
% end

pack = msgpack.dumptools.array_header(numel(data),computer_is_bigendian);
for value = data.'
    pack = [pack,msgpack.dumptools.string_scalar(value,computer_is_bigendian)];
end
end