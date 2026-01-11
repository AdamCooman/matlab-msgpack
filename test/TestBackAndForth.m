classdef TestBackAndForth < matlab.unittest.TestCase
    properties (TestParameter)
        integer_type = num2cell(["uint"+[8,16,32,64] "int"+[8,16,32,64]])
        float_type = {"single","double"}
        array_size = {5,21,2^16+10}
    end
    methods (Test)
        function test_integer_scalar(test,integer_type)
            % generate a vector full of random data of the correct type
            values = typecast(randi(255,1,64*8,"uint8"),integer_type);
            % loop over the values
            for value = values
                pack = msgpack.dump(value);
                value_test = msgpack.parse(pack);
                % a uint8 can be turned into an int8 when it gets encoded
                % as a fixint, so we force a cast to uint8
                if integer_type == "uint8"
                    value_test = uint8(value_test);
                end
                test.assertEqual(value_test,value);
            end
        end
        function test_integer_vector(test,integer_type)
            % generate a vector full of random data of the correct type
            value = typecast(randi(255,1,64*8,"uint8"),integer_type);

            pack = msgpack.dump(value);
            value_test = msgpack.parse(pack);
            test.assertEqual(value_test,num2cell(value));
        end
        function test_float_scalar(test,float_type)
            values = randn(1,100,float_type);
            for value = values
                pack = msgpack.dump(value);
                value_test = msgpack.parse(pack);
                test.assertEqual(value_test,value);
            end
        end
        function test_float_vector(test,float_type,array_size)
            values = randn(1,array_size,float_type);
            pack = msgpack.dump(values);
            values_test = msgpack.parse(pack);
            test.assertEqual(values_test,num2cell(values));
        end
        function test_logical_scalar(test)
            for value = [true false]
                pack = msgpack.dump(value);
                value_test = msgpack.parse(pack);
                test.assertEqual(value_test,value);
            end
        end
        function test_logical_vector(test,array_size)
            values = randi(1,1,array_size,"logical");
            pack = msgpack.dump(values);
            values_test = msgpack.parse(pack);
            test.assertEqual(values_test,num2cell(values));
        end
        function test_ext(test,array_size)
            value = msgpack.Ext(-5,randi(255,1,array_size,"uint8"));
            pack = msgpack.dump(value);
            value_test = msgpack.parse(pack);
            test.assertEqual(value_test,value);
        end
        function test_bin(test,array_size)
            value = msgpack.Bin(randi(255,1,array_size,"uint8"));
            pack = msgpack.dump(value);
            value_test = msgpack.parse(pack);
            test.assertEqual(value_test,value);
        end
        function test_struct(test)
            for number_of_fields = 2.^(0:6)
                value = struct();
                for ind = 1 : number_of_fields 
                    value.("field_"+ind) = randi(255,1,1,"int8");
                end
                pack = msgpack.dump(value);
                value_test = msgpack.parse(pack);
                % msgpack.parse returns a msgpack.Map which we cast to a struct
                test.assertEqual(struct(value_test),value);
            end
        end
    end
end