

# Schema-Sets

---

## What are these things, and when are they useful?

Schema-Sets are sets that use bitops under the hood to do operations fast.   
They are mainly useful when you have a finite, pre-defined set of elements, and you want to ask questions about them:  

EG: "Is `set-Alfa` a subset of `set-Bravo`?  
"Give me the set that is the LOGICAL-AND of `set-Zulu` and `set-Oscar`"

^^^ great use-cases, very efficient.

---

## When are these NOT useful?
- When we need to add dynamic elements at run-time
- If we want to mutate sets all the time
- If we only want to store data, and not make queries between the sets.

If you just want to store data in a set, DON'T use these things!  
Just use a regular sparse-set implementation


# API

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

scSet0:isSubsetOf(scSet1) --> scSet{ "zero" }
scSet0:equals(scSet1) --> bool
-- ^^^ These two operations are VERY efficient.


scSet0:getKey() --> "SKD9349EJRFKJRF4985FHDF"
-- a unique string-key that represents the set (useful for caching)
scSet0:getElements() -- {"zero", ... }  
-- gets a list of elements for this set

-- WARNING: these last 2 calls are expensive operations, 
-- Since it must poll for the elements from the schema.


```

