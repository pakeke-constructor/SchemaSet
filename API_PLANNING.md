

# API PLANNING:


```lua

local schema = API.newSchema({
    "zero", "elem2", ..., "elem_3"
})


local scSet0 = schema:newSet({
    "zero"
})
local scSet1 = schema:newSet({
    "zero", "elem2"
})
local scSet2 = schema:newSet({
    "zero", "elem_3"
})


local sc_ERR = schema:newSet({
    "elem_3", "FOOBAR_UNDEFINED_ELEMENT"
})
-- ERROR: Attempt to create a schema-set with an undefined element




scSet0:logicalAnd(scSet1) --> scSet{ "zero" }
scSet0:logicalOr(scSet1) --> scSet{ "zero", "elem2" }
-- ^^^ warning: these operations aren't particularly efficient.

scSet0:isSubsetOf(scSet1) --> scSet{ "zero" }
-- ^^^ this operation is VERY efficient, however.
-- If you need to

scSet0:getKey() --> "SKD9349EJRFKJRF4985FHDF"
-- a unique string-key that represents the elements of the set (useful for caching)

scSet0:getElements() -- {"zero", ... }  list of elements for this set


```

