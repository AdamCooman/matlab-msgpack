function data = uint32_scalar(data,computer_is_bigendian)


% arguments (Input)
%     data (1,1) uint32
%     computer_is_bigendian (1,1) logical
% end
% arguments (Output)
%     data (1,5) uint8
% end

data = typecast(data,"uint8");
if ~computer_is_bigendian
    data = data(end:-1:1);
end
data = [0xce,data];
end