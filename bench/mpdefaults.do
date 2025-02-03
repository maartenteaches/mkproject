// read_defaults
mata:
totest = mpdefaults()
totest.reset("boilerplate")
totest.reset("project")
totest.read_defaults()
assert(totest.defaults.project == "long")
assert(totest.defaults.boilerplate== "dta")
assert(totest.fhs.get(totest.reading.fh) == "closed")
assert(totest.reading.open == 0)
end

//mkdirerr()
mata:
totest = mpdefaults()
end
rcof `"noi mata: totest.mkdirerr(2, "c:/temp" )"' == 2
rcof `"noi mata: totest.mkdirerr(693, "c:\temp" )"' == 693

//write_default
mata:
fn = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_test.mpp")
unlink(fn)
fh = fopen(fn, "w")
fput(fh, "<header>")
fput(fh, "<mkproject> project")
fput(fh, "<version> 2.0.0")
fput(fh, "<label> some test project")
fput(fh, "</header>")
fclose(fh)

totest = mpdefaults()
totest.write_default("project", "test")
totest.read_defaults()
assert(totest.defaults.project == "test")
assert(totest.defaults.boilerplate == "dta")
end

//read_defaults plus
mata:
totest.read_defaults("PLUS")
assert(totest.defaults.project == "long")
assert(totest.defaults.boilerplate== "dta")
assert(totest.fhs.get(totest.reading.fh) == "closed")
assert(totest.reading.open == 0)
end

//reset
mata:
totest = mpdefaults()
totest.read_defaults()
assert(totest.defaults.project == "test")
assert(totest.defaults.boilerplate == "dta")
totest.reset("project")
totest.read_defaults()
assert(totest.defaults.project == "long")
assert(totest.defaults.boilerplate== "dta")

unlink(fn)
end
