function res = is_bigendian()
%IS_BIGENDIAN returns true when the system is big endian
res = typecast(uint16(1), 'uint8');
% when the first byte equals 1, then we have a little-endian system
res = ~(res(1)==1);
end