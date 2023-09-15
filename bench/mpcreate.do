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

// header_defaults()
mata:
totest = mpcreate()
totest.header_defaults("boilerplate")
assert(totest.reading.type=="boilerplate")
assert(totest.reading.sversion=="2.0.1")
assert(totest.reading.fversion==(2,0,1))

end


// chk_file
mata:
basefn = pathjoin(pathsubsysdir("PERSONAL"), "m")
fn1 = pathjoin(basefn,"mp_test1.mpb")
fn2 = pathjoin(basefn,"mp_test2.mpb")
fn3 = pathjoin(basefn,"mp_test1.mpp")
fn4 = pathjoin(basefn,"mp_test2.mpp")
fn5 = "bench/test3.do"
fn6 = pathjoin(basefn,"mp_test3.mpb")
unlink(fn1)
unlink(fn2)
unlink(fn3)
unlink(fn4)
unlink(fn5)
end

mata:
totest = mpcreate()

fh1 = fopen(fn1, "w")
fput(fh1, "<header>")
fput(fh1, "<mkproject> boilerplate")
fput(fh1, "<reqs> Stata 18")
fput(fh1, "<reqs> smclpres")
fput(fh1, "</header>")
fclose(fh1)

fh2 = fopen(fn2, "w")
fput(fh2, "<header>")
fput(fh2, "<mkproject> boilerplate")
fput(fh2, "</header>")
fclose(fh2)

toreturn = "git" \ "dirtree"
sversion = 14

totest.chk_file("<dir> foo", toreturn, sversion)
assert(toreturn == ("git" \ "dirtree"))
assert(sversion == 14)

totest.chk_file("<file> test2 somename.do", toreturn, sversion)
assert(toreturn == ("git" \ "dirtree"))
assert(sversion == 14)

totest.chk_file("<file> test1 somename.do", toreturn, sversion)
assert(toreturn == ("git" \ "dirtree" \ "smclpres"))
assert(sversion == 18)

totest.chk_file("<dir> bar", toreturn, sversion)
assert(toreturn == ("git" \ "dirtree" \ "smclpres"))
assert(sversion == 18)
end

//integrate_reqs()
mata:
fh3 = fopen(fn3, "w")
fput(fh3, "<header>")
fput(fh3, "<mkproject> project")
fput(fh3, "<reqs> Stata 14")
fput(fh3, "<reqs> git")
fput(fh3, "<reqs> dirtree")
fput(fh3, "</header>")
fput(fh3, "<file> test1 somefilename1")
fput(fh3, "<file> test2 somefilename2")
fclose(fh3)

fh4 = fopen(fn4, "w")
fput(fh4, "<header>")
fput(fh4, "<mkproject> project")
fput(fh4, "<reqs> Stata 19")
fput(fh4, "</header>")
fput(fh4, "<file> test1 somefilename1")
fput(fh4, "<file> test2 somefilename2")
fclose(fh4)


totest= mpcreate()
toreturn = totest.integrate_reqs(fn3)
true = J(4,1,"")
true[1,1] = "Stata 18.0"
true[2,1] = "git"
true[3,1] = "dirtree"
true[4,1] = "smclpres"
assert(toreturn == true)

toreturn = totest.integrate_reqs(fn4)
true = J(2,1,"")
true[1,1] = "Stata 19.0"
true[2,1] = "smclpres"
assert(toreturn == true)
end

//newname
local create bar.do
mata:
totest = mpcreate()
path = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_bar.mpp")
assert(totest.newname("bar.do", "project") == path)
end

//create()
local create bench/test3.do
local replace replace

mata:
fh1 = fopen(fn5, "w")
fput(fh1, "<header>")
fput(fh1, "<mkproject> boilerplate")
fput(fh1, "<label> minimalist boilerplate")
fput(fh1, "<reqs> Stata 18")
fput(fh1, "<reqs> smclpres")
fput(fh1, "</header>")
fput(fh1, "clear all")
fclose(fh1)

path = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_test3.mpb")
totest = mpcreate()
totest.create("boilerplate")

assert(fileexists(path))

fh = fopen(path, "r")
assert(fget(fh)==`"<header>"')
assert(fget(fh)==`"<mkproject> boilerplate"')
assert(fget(fh)==`"<version> 2.0.1"')
assert(fget(fh)==`"<label> minimalist boilerplate"')
assert(fget(fh)==`"<reqs> Stata 18.0"')
assert(fget(fh)==`"<reqs> smclpres"')
assert(fget(fh)==`"</header>"')
assert(fget(fh)==`"clear all"')
assert(fget(fh)==J(0,0,""))
fclose(fh)


//project and inherrit some reqs  
end


// cleanup
mata:
unlink(fn1)
unlink(fn2)
unlink(fn3)
unlink(fn4)
unlink(fn5)
end


// remove()
mata:
totest.write_default("boilerplate", "test3")
totest.read_defaults()
assert(totest.defaults.boilerplate=="test3")
assert(totest.defaults.project=="long")
totest.remove("test3", "boilerplate")
assert(!fileexists(fn6))
totest.read_defaults()
assert(totest.defaults.boilerplate=="dta")
assert(totest.defaults.project=="long")
end
