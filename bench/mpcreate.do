// parse_req_line()
mata:
totest = mpcreate()
toreturn = "smclpres" \
		   "git"
sversion = 13	
totest.parse_req_line(toreturn, "dirtree", sversion)

true = J(3,1,"")
true[1,1] = "smclpres"
true[2,1] = "git"
true[3,1] = "dirtree"	   
assert(toreturn==true)
assert(sversion==13)

totest.parse_req_line(toreturn, "git", sversion)

true = J(3,1,"")
true[1,1] = "smclpres"
true[2,1] = "git"
true[3,1] = "dirtree"	   
assert(toreturn==true)
assert(sversion==13)

totest.parse_req_line(toreturn, "Stata 15", sversion)

true = J(3,1,"")
true[1,1] = "smclpres"
true[2,1] = "git"
true[3,1] = "dirtree"	   
assert(toreturn==true)
assert(sversion==15)
end

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
path = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_bar.mps")
assert(totest.newname("bar.do", "stencil") == path)
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

path = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_foo.mpb")
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

unlink("bench/foo.do")
    
end


// remove()
mata:
totest.write_default("boilerplate", "foo")
totest.read_defaults()
assert(totest.defaults.boilerplate=="foo")
assert(totest.defaults.stencil=="long")
totest.remove("foo", "boilerplate")
assert(!fileexists(path))
totest.read_defaults()
assert(totest.defaults.boilerplate=="dta")
assert(totest.defaults.stencil=="long")
end
