clear variables
close all
clc

addpath("..");
profile on

types = ["double" "single" "uint8" "uint16" "uint32" "uint64" "int8" "int16" "int32" "int64"];
number_of_fields = 1:10:256;

for ii = 1 : numel(number_of_fields)
    disp(number_of_fields(ii))
    data = random_struct(number_of_fields(ii));
    pack = msgpack.dump(data);
    res(ii).dump_time = timeit(@()msgpack.dump(data),1);
    res(ii).parse_time = timeit(@()msgpack.parse(pack),1);
end


profile off
profile viewer


figure(1)
tiledlayout(1,2)

nexttile(1)
loglog(number_of_fields,[res.dump_time])
hold on
grid on
legend show
title("dump")
ax = gca;
ax.LineStyleOrder = ["-","-+","-o"];

nexttile(2)
loglog(number_of_fields,[res.parse_time])
hold on
grid on
legend show
title("parse")
ax = gca;
ax.LineStyleOrder = ["-","-+","-o"];

function res = random_struct(number_of_fields)
for ind = 1 : number_of_fields
    res.("field_"+ind) = random_data();
end
end

function res = random_data()
switch randi(4)
    case 0
        res = randi(1,1,"logical");
    case 1
        res = typecast(randi(255,1,"uint8"),"int8");
    case 2
        res = [1 2 3];
    case 3
        res = "example string";
    case 4
        res = struct("a",1,"b","hello");
end
end