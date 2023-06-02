// chk_file
mata:
totest = mpcreate()
totest.chk_file("<file> dta somename.do")
end
rcof `"noisily mata: totest.chk_file("<file> bar somename.do")"' == 601

//newname
local create bar.do
mata:
totest = mpcreate()
path = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_bar.txt")
assert(totest.newname() == path)
end

//create()

local create bench/foo.do
local replace replace
mata:
fn = "bench/foo.do"
unlink(fn)
fh = fopen(fn,"w")
fput(fh, "bla")
fclose(fh)

path = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_foo.txt")
unlink(path)
totest = mpcreate()
totest.create("boilerplate")

assert(fileexists(path))

fh = fopen(path, "r")
assert(fget(fh)==`"<header>"')
assert(fget(fh)==`"<mkproject> boilerplate"')
assert(fget(fh)==`"<version> 2.0.0"')
assert(fget(fh)==`"<label> "')
assert(fget(fh)==`"</header>"')
assert(fget(fh)==`"bla"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

unlink(path)
unlink("bench/foo.do")
    
end