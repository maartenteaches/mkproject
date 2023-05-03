mata:
totest = mpdefaults()
totest.read_defaults()
assert(totest.defaults.stencil == "long")
assert(totest.defaults.boilerplate== "dta")
assert(totest.fhs.get(totest.reading.fh) == "closed")
assert(totest.reading.open == 0)
end