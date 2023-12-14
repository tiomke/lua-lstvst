# lua-lstvst
Lua Sequence Table Accessor


lstvst is a simple sequence accessor that separates data from definition. Before using it, you need to define the sequence fields, and then access the sequence using the predefined fields.

Advantages:
    1. With the help of [MessagePack](https://github.com/markstinson/lua-MessagePack) serialization, it supports complex nested structures.
    1. By separating structure definition from data, it reduces the volume of serialized data, thereby increasing serialization speed.
    1. The structured definition enhances the readability of data operations, making it easier to maintain.
    1. Utilizing the [inspect](https://github.com/kikito/inspect.lua) library to view raw data facilitates debugging.


The Lua serialization is required to adhere to the following structure format: 

```CFG
sequence :: [value, value, ...]
value :: number | string | nil | boolean | sequence
```

read test.lua for more coding details.
