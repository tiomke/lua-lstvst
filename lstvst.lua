-- https://github.com/tiomke/lua-lstvst
-- Author:
--   Tiomke
-- License:
--   MIT License

-- switch list {a,b,c,d} to dict {a=1,b=2,c=3,d=4}
local function lst2dict(list)
	local tbl = {}
	for i, v in ipairs(list) do
		tbl[v] = i
	end
	return tbl
end

local lstvst = {__schema = {}, __data = {},
__newindex=function (data,key,value)
    local _schema = rawget(data,"__schema")
    local _data = rawget(data,"__data")
    local idx = _schema.__SchemaDict[key]
    rawset(_data,idx,value)
end,
__index=function(data,key)
    local _schema = rawget(data,"__schema")
    local _data = rawget(data,"__data")
    local idx = _schema.__SchemaDict[key]
    return _data[idx]
end}
lstvst.init = function (schema,data)
    if not (schema and schema.__SchemaList) then
        lstvst.__schema = nil
        lstvst.__data = nil
        return
    end
    if not data then
        data = {}--CreateTable_lua(schema._Capacity, 0)
    end
    lstvst.__schema = schema
    lstvst.__data = data
end
lstvst.tbl = function ()
    return lstvst.__data
end
lstvst.str = function ()
    return lstvst.inspect(lstvst.__data)
end
lstvst.bstr = function ()
    return lstvst.msgpack.pack(lstvst.__data)
end
local _viter = function(t,i)
    if i >= t.__schema.__Capacity then
        return nil
    end
    return i+1,t.__schema.__SchemaList[i+1],t.__data[i+1] -- index,name,value
end
lstvst.pairs = function () -- i,v
    return _viter,lstvst,0
end
lstvst.empty = function()
    return not next(lstvst.__data)
end
lstvst.size = function()
    local schema = rawget(lstvst,"__schema")
    return schema.__Capacity
end
-- Suitable for scenarios where multiple lstvst structures may be used interchangeably
-- data cannot be empty
lstvst.access = function (schema,data)
    return function (key,value,bSet)
        key = schema.__SchemaDict[key] or key
        -- When setting to nil, bSet must be passed. For other cases, the second parameter is used to indicate the value to be set by default.
        if value or bSet then
            data[key]=value
        end
        return data[key]
    end
end
-- Returns an accessor instance
lstvst.agent = function (schema,data)
    if not data then
        data = {} --CreateTable_lua(schema._Capacity, 0)
    end
    local agent = {}
    agent.__schema = schema
    agent.__data = data
    setmetatable(agent, _lstvst.agent_mt)
    return agent
end

lstvst.schema = function (list,...)
    if type(list) == "string" or type(list) == "nil" then
        list = {list,...}
    end
    
    local ret = lst2dict(list)
    local dict = lst2dict(list)
    for i,key in ipairs(list) do
        ret[i]=key
    end
    ret.__Capacity = #list
    ret.__SchemaList = list
    ret.__SchemaDict = dict
    -- for debug
    ret.__hook = {} -- 

    -- callback(obj,key,value)
    ret.sethook = function(_self,key,callback)
        _self.__hook[key] = callback
    end

    return ret
end

lstvst.msgpack = {pack= function() print("not binded") end}
lstvst.inspect = function() print("not binded") end

lstvst._VERSION = "0.1.0"
lstvst._DESCRIPTION = "lua-lstvst: Lua Sequence Table Accessor"
lstvst._LICENSE = [[
  MIT LICENSE

  Copyright (c) 2023 tiomke

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the
  "Software"), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be included
  in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]


setmetatable(lstvst, lstvst)
return lstvst
