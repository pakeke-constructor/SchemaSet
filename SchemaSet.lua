
local bit = rawget(_G, "bit") or require("bit")



local api = {}


---@class SchemaSet.Schema
---@field elementToIndex table<any, integer>
---@field indexToElement table<integer, any>
---@field cachedSets table<string, SchemaSet.Set>
local Schema = {}

local Schema_mt = {
    __index = Schema
}


---@param elements any[]
---@return SchemaSet.Schema
function api.newSchema(elements)
    local self = setmetatable({}, Schema_mt)

    self.elementToIndex = {--[[
        [element] -> bit-index
    ]]}
    self.indexToElement = {--[[
        [bit-index] -> element
    ]]}

    self.cachedSets = {--[[
        [setKey] --> SchemaSet
    ]]}

    local i = 0
    for _, elem in ipairs(elements) do
        self.elementToIndex[elem] = i
        self.indexToElement[i] = elem
        i = i + 1
    end

    return self
end


local function defensiveCopy(tabl)
    local ret = {}
    for _, v in ipairs(tabl) do
        table.insert(ret,v)
    end
    return ret
end



---@class SchemaSet.Set
---@field bitVec integer[]
---@field schema SchemaSet.Schema
---@field elements any[]
local Set = {}
local Set_mt = {__index=Set}



local BITS = 32
-- 32 bits per number
-- https://bitop.luajit.org/semantics.html#range



local function setBit(scSet, i, bool)
    local bitVec = scSet.bitVec
    local j = math.floor(i / BITS) + 1 -- index of num in bitVec
    local num = bitVec[j]
    local shift = i % BITS
    if bool then
        -- set bit to 1
        local t = bit.lshift(1, shift)
        num = bit.bor(num, t)
    else
        -- set bit to 0
        local t = bit.bnot(bit.lshift(1, shift))
        num = bit.band(num, t)
    end

    bitVec[j] = num
end


local function getBit(scSet, i)
    local bitVec = scSet.bitVec
    local j = math.floor(i / BITS) + 1 -- index of num in bitVec
    local num = bitVec[j]
    local shift = i % BITS
    local t = bit.lshift(1, shift)
    local res = bit.band(t, num)
    if res == 0 then
       return false
    else
        return true
    end
end



---@param elements any[]
---@return SchemaSet.Set
function Schema:newSet(elements)
    ---@type SchemaSet.Set
    local scSet = setmetatable({
        bitVec = {},

        -- caching for efficiency
        cachedKey = false,
        cachedElements = defensiveCopy(elements),
    }, Set_mt)

    local bitNumLen = math.floor(#self.indexToElement / 32) + 1
    for i=1, bitNumLen do
        -- initialize with zeros
        table.insert(scSet.bitVec, 0)
    end

    for _, elem in ipairs(elements) do
        local i = self.elementToIndex[elem]
        setBit(scSet, i, true)
    end

    return scSet
end


function Set:isSubsetOf(otherSet)
    local otherBitVec = otherSet.bitVec
    for i, n in ipairs(self.bitVec) do
        local n2 = otherBitVec[i]
        if bit.band(n, n2) ~= n then
            return false
        end
    end
    return true
end



function Set:equals(otherSet)
    local otherBitVec = otherSet.bitVec
    for i, n in ipairs(self.bitVec) do
        local n2 = otherBitVec[i]
        if n ~= n2 then
            return false
        end
    end
    return true
end



local TEST = true
if not TEST then
    return
end

--- tests
do
local sc = api.newSchema({"a", "b", "bb", "c"})
local s = sc:newSet({"a","b","c"})
end

