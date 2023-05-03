mata:
totest = mpdefaults()
totest.read_defaults()
assert(totest.defaults.mptemplate == "long")
assert(totest.defaults.boilerplate== "dta")
assert(totest.fhs.get(totest.reading.fh) == "closed")
assert(totest.reading.open == 0)
end