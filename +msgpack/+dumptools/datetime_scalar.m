function pack = datetime_scalar(data,computer_is_bigendian)
% From the spec (we use the first)
%
% timestamp 32 stores the number of seconds that have elapsed since 1970-01-01 00:00:00 UTC
% in an 32-bit unsigned integer:
% +--------+--------+--------+--------+--------+--------+
% |  0xd6  |   -1   |   seconds in 32-bit unsigned int  |
% +--------+--------+--------+--------+--------+--------+
% 
% timestamp 64 stores the number of seconds and nanoseconds that have elapsed since 1970-01-01 00:00:00 UTC
% in 32-bit unsigned integers:
% +--------+--------+--------+--------+--------+------|-+--------+--------+--------+--------+
% |  0xd7  |   -1   | nanosec. in 30-bit unsigned int |   seconds in 34-bit unsigned int    |
% +--------+--------+--------+--------+--------+------^-+--------+--------+--------+--------+
% 
% timestamp 96 stores the number of seconds and nanoseconds that have elapsed since 1970-01-01 00:00:00 UTC
% in 64-bit signed integer and 32-bit unsigned integer:
% +--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+
% |  0xc7  |   12   |   -1   |nanoseconds in 32-bit unsigned int |                   seconds in 64-bit signed int                        |
% +--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+
% 
arguments (Input)
    data (1,1) datetime
    computer_is_bigendian (1,1) logical
end

arguments (Output)
    pack (1,:) uint8
end
seconds = uint32(posixtime(data));
seconds = typecast(seconds,"uint8");
if ~computer_is_bigendian
    seconds = seconds(end:-1:1);
end
pack = [0xd6,typecast(int8(-1),"uint8"),seconds];
end