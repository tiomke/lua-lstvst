

local inspect = require("3rd/inspect/inspect")
local msgpack = require("3rd/messagepack/src/MessagePack")
local lstvst = require("lstvst")
rawset(lstvst,"msgpack",msgpack)
rawset(lstvst,"inspect",inspect)
Schema = lstvst.schema

-- Static Access: Access through static functions provided by the lstvst table. The advantage is that the type only needs to be written once at the beginning, but the disadvantage is that static access to multiple original tables does not support interleaved execution.
local SSampleData = Schema("Name","Price","Alias")
lstvst.init(SSampleData,{[2]=10}) -- Pass the Schema type and the original table
lstvst.Name = "book"
lstvst.Price = lstvst.Price + 5
lstvst.Alias = {"wiki","doc"}

-- Get the total length
lstvst.size()

-- Get the original table
print(inspect(lstvst.tbl()))
-- Generate readable data
print(lstvst.str())
-- Generate msgpack serialized string
print(lstvst.bstr())

-- Traverse the original table
for i,k,v in lstvst.pairs() do
    print(i,k,v)
end

-- Functional Access: Access the original table through a closure accessor returned by a function call. The advantage is that functional access to multiple original tables can be interleaved, but the disadvantage is that the experience of using function calls for reading and writing is relatively poor.
local SSampleData = Schema("Name","Price","Alias")
local data = {"Little Prince",nil,"Le Petit Prince"}
local BookAcc = lstvst.access(SSampleData,data)
-- Set initial value
BookAcc("Price",20)
-- Access and assign value
BookAcc("Price",BookAcc("Price")+5)
-- Clear data
print(BookAcc("Price",nil,true)) -- When the third parameter is set to true, it indicates data clearance.
print(inspect(BookAcc("Alias"))) -- Get table
-- (None) Get the original table
-- (None) Generate readable data
-- (None) Generate msgpack serialized string
-- (None) Traverse the original table
