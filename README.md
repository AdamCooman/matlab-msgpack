# A MessagePack implementation for Matlab

The code is written in pure Matlab, and has no dependencies beyond Matlab itself.

## Basic Usage:

```matlab
data = {'life, the universe, and everything', struct('the_answer', 42)};
bytes = msgpack.dump(data)
data = msgpack.parse(bytes)
% returns: {'life, the universe, and everything', containers.Map('the_answer', 42)}
```

## Converting Matlab to MsgPack:

|          Matlab  |  MsgPack   |
| -----------------|------------------ |
|    double  | float64  |
|    single  | float32 |
|   logical  | bool |
|      int8 scalar | int 8 or fixint when possible  |
|      intX | int X (X = 16,32,64)  |
|     uint8 | uint 8 or fixint when possible |
|     uintX | uint X (X = 16,32,64) |
|    string scalar | fixstr or str 8, str 16 or str 32 depending on the length |
|      char vector | fixstr or str 8, str 16 or str 32 depending on the length |
|       cell array | fixarray, array 16 or array 32 depending on the length  |
|    struct  | fixmap, map16 or map32 depending on the number of fields  |
|  datetime | timestamp 32  |
|     missing   | nil |

To allow dumping custom types and raw binary vectors, we also support two classes:

|          Matlab  |  MsgPack |
| -----------------|------------------ |
|      msgpack.Bin | bin 8,16,32 depending on the size |
|      msgpack.Ext | fixext 1,2,4,8 or ext 8,16,32 depending on the size |

There is no way of encoding exts

## Converting MsgPack to Matlab

| MsgPack        | Matlab         |
| -------------- | -------------- |
| nil            | missing   |
| float64       | double         |
| float32       | single         |
| fixint         | int8           |
| int8         | int8           |
| int16         | int16           |
| int32         | int32           |
| int64         | int64           |
| uint8         | uint8           |
| uint16         | uint16           |
| uint32         | uint32           |
| uint64         | uint64           |
| fixstr, str8, str16 str32  | string         |
| bool           | logical        |
| fixarray, array16 or array32  | cell array     |
| fixmap, map16, map32 | msgpack.Map |
| bin8, bin16, bin32   | msgpack.Bin    |
| ext8,ext16,ext32  | msgpack.Ext    |
| fixext1, fixext2, fixext4, fixext8, fixext16 | msgpack.Ext |

Note that since `structs`, `containers.Map` nor `dictionary` support the flexibility of the maps used in msgpack, 
we return an object of class `msgpack.Map` instead.
This object has a `struct(obj)` method to try casting it to a matlab struct.

