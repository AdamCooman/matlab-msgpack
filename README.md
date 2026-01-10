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
|    double scalar | float64  |
|    double vector | array* of float64 |
|    single scalar | float32 |
|    single vector | array* of float32 |
|   logical scalar | bool |
|   logical vector | array* of bool  |
|      int8 scalar | int 8 or fixint when possible  |
|      intX scalar | int X (X = 16,32,64)  |
|      intX vector | array of int X  |
|     uintX scalar | uint X  |
|     uintX vector | array* of uint X  |
|    string scalar | fixstr or str 8, str 16 or str 32 depending on the length |
|    string vector | array* of fixstr or str 8, str 16 or str 32  |
|      char scalar | fixstr  |
|      char vector | fixstr or str 8, str 16 or str 32 depending on the length |
|       cell array | array*  |
|    struct scalar | fixmap, map16 or map32 depending on the number of fields  |
|    struct vector | array* of fixmap, map16 or map32 depending on the number of fields  |
|  datetime scalar | timestamp 32  |

array is fixarray, array 16 or array 32 depending on the length
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
| string         | string         |
| number         | scalar         |
| `true`/`false` | logical        |
| nil            | empty matrix   |
| array          | cell array     |
| map            | containers.Map |
| bin            | uint8          |
| ext            | uint8          |

Note that since `structs` don't support arbitrary field names, 
they can't be used for representing `maps`. We use `containers.Map` instead.

