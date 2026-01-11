classdef TestParse < matlab.unittest.TestCase
    methods (Test)
        function test_integer(test)
            pack_value_pairs = {
                uint8(0), int8(0);
                uint8(1), int8(1);
                uint8(255), int8(-1);
                uint8([208, 128]), int8(-128);
                uint8([204, 128]), uint8(128);
                uint8([205, 1, 0]), uint16(256);
                uint8([206, 0, 1, 0, 0]), uint32(2^16);
                uint8([207, 0, 0, 0, 1, 0, 0, 0, 0]), uint64(2^32);
                uint8([209, 255, 0]), int16(-256);
                uint8([210, 255, 255, 0, 0]), int32(-2^16);
                uint8([211, 255, 255, 255, 255, 0, 0, 0, 0]), int64(-2^32);
            };
            for tt = 1 : size(pack_value_pairs,1)
                test.assertEqual( ...
                    msgpack.parse(pack_value_pairs{tt,1}), ...
                    pack_value_pairs{tt,2})
            end
        end
        function test_float(test)
            pack_value_pairs = {
                uint8([202, 63, 192, 0, 0]), single(1.5);
                uint8([203, 63, 248, 0, 0, 0, 0, 0, 0]), double(1.5);
                };
            for tt = 1 : size(pack_value_pairs,1)
                test.assertEqual( ...
                    msgpack.parse(pack_value_pairs{tt,1}), ...
                    pack_value_pairs{tt,2})
            end
        end
        function test_string(test)
            pack_value_pairs = {
                uint8([163, 102, 111, 111]), "foo";
                uint8([217, 32, ones(1, 32)*'a']), string(repmat('a', [1, 32]));
                uint8([218, 1, 0, ones(1, 2^8)*'a']), string(repmat('a', [1, 2^8]));
                uint8([219, 0, 1, 0, 0, ones(1, 2^16)*'a']), string(repmat('a', [1, 2^16]));
                };
            for tt = 1 : size(pack_value_pairs,1)
                test.assertEqual( ...
                    msgpack.parse(pack_value_pairs{tt,1}), ...
                    pack_value_pairs{tt,2})
            end
        end
        function test_bin(test)
            pack_value_pairs = {
                uint8([196, 32, ones(1, 32)*42]), msgpack.Bin(repmat(uint8(42), [1, 32]));
                uint8([197, 1, 0, ones(1, 2^8)*42]), msgpack.Bin(repmat(uint8(42), [1, 2^8]));
                uint8([198, 0, 1, 0, 0, ones(1, 2^16)*42]), msgpack.Bin(repmat(uint8(42), [1, 2^16]));
                };
            for tt = 1 : size(pack_value_pairs,1)
                test.assertEqual( ...
                    msgpack.parse(pack_value_pairs{tt,1}), ...
                    pack_value_pairs{tt,2})
            end
        end
        function test_array(test)
            c = msgpack.parse(uint8([146, 1, 2]));
            d = {int8(1), int8(2)};
            test.assertEqual(c,d)
            
            c = msgpack.parse(uint8([220, 0, 16, repmat(42, [1, 16])]));
            d = num2cell(repmat(int8(42), [1, 16]));
            test.assertEqual(c,d)
        end
        function test_map(test)
            c = msgpack.parse(uint8([130, msgpack.dump('one'), 1, msgpack.dump('two'), 2]));
            d = struct('one', uint8(1), 'two', uint8(2));
            test.assertEqual(c,d)
            
            data = struct();
            pack = uint8([222, 0, 16]);
            for n=[1 10 11 12 13 14 15 16 2 3 4 5 6 7 8 9] % default struct field order
                data.(['x' num2str(n)]) = uint8(n);
                pack = [pack msgpack.dump(['x' num2str(n)]) uint8(n)];
            end
            c = msgpack.parse(pack);
            d = data;
            test.assertEqual(c,d)
            
        end
    end

end