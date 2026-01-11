clear variables
close all
clc

addpath("..");

types = ["double" "single" "uint8" "uint16" "uint32" "uint64" "int8" "int16" "int32" "int64" "logical"];
number_of_elements = 2.^(1:2:16);
for type = types
    bytes_per_element = 8/numel(typecast(zeros(1,8,"uint8"),type));
    for ii = 1 : numel(number_of_elements)
        disp(type+" "+number_of_elements(ii))
        data = randi(255,1,bytes_per_element*number_of_elements(ii),"uint8");
        if type == "logical"
            data = data>0;
        else
            data = typecast(data,type);
        end
        pack = msgpack.dump(data);
        res(ii).(type+"_dump_time") = timeit(@()msgpack.dump(data),1);
        res(ii).(type+"_parse_time") = timeit(@()msgpack.parse(pack),1);
    end
end


%% plot the result
figure(1)
tiledlayout(1,2)

nexttile(1)
for type = types
    loglog(number_of_elements,[res.(type+"_dump_time")],DisplayName=type)
    hold on
end
grid on
legend show
title("dump")
ax = gca;
ax.LineStyleOrder = ["-","-+","-o"];

nexttile(2)
for type = types
    loglog(number_of_elements,[res.(type+"_parse_time")],DisplayName=type)
    hold on
end
grid on
legend show
title("parse")
ax = gca;
ax.LineStyleOrder = ["-","-+","-o"];

