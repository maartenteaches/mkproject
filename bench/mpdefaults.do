// read_defaults
mata:
totest = mpdefaults()
totest.reset("boilerplate")
totest.reset("stencil")
totest.read_defaults()
assert(totest.defaults.stencil == "long")
assert(totest.defaults.boilerplate== "dta")
assert(totest.fhs.get(totest.reading.fh) == "closed")
assert(totest.reading.open == 0)
end

//write_default
mata:
fn = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_test.mps")
unlink(fn)
fh = fopen(fn, "w")
fput(fh, "<header>")
fput(fh, "<mkproject> stencil")
fput(fh, "<version> 2.0.0")
fput(fh, "<label> some test stencil")
fput(fh, "</header>")
fclose(fh)

totest = mpdefaults()
totest.write_default("stencil", "test")
totest.read_defaults()
assert(totest.defaults.stencil == "test")
assert(totest.defaults.boilerplate == "dta")
end

//read_defaults plus
mata:
totest.read_defaults("PLUS")
assert(totest.defaults.stencil == "long")
assert(totest.defaults.boilerplate== "dta")
assert(totest.fhs.get(totest.reading.fh) == "closed")
assert(totest.reading.open == 0)
end

//reset
mata:
totest = mpdefaults()
totest.read_defaults()
assert(totest.defaults.stencil == "test")
assert(totest.defaults.boilerplate == "dta")
totest.reset("stencil")
totest.read_defaults()
assert(totest.defaults.stencil == "long")
assert(totest.defaults.boilerplate== "dta")

unlink(fn)
end
