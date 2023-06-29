// query
log using bench/totest , replace nomsg
mkproject , query
boilerplate , query
log close

tempname fh
file open `fh' using `"bench/totest.smcl"', read text
file read `fh' line
file read `fh' line
file read `fh' line
assert `"`line'"'==`"{com}. mkproject , query"'
file read `fh' line
assert `"`line'"'==`"{res}{hline}"'
file read `fh' line
assert `"`line'"'==`"{txt}{col 2}Name{col 16}Where{col 25}Label"'
file read `fh' line
assert `"`line'"'==`"{hline}"'
file read `fh' line
assert `"`line'"'==`"*{view "c:\ado\plus/m\mp_long.txt":long}{col 16}PLUS{col 25}based on (Long 2009)"'
file read `fh' line
assert `"`line'"'==`"{hline}"'
file read `fh' line
assert `"`line'"'==`"{txt}* indicates default"'
file read `fh' line
assert `"`line'"'==`"{com}. boilerplate , query"'
file read `fh' line
assert `"`line'"'==`"{res}{hline}"'
file read `fh' line
assert `"`line'"'==`"{txt}{col 2}Name{col 16}Where{col 25}Label"'
file read `fh' line
assert `"`line'"'==`"{hline}"'
file read `fh' line
assert `"`line'"'==`" {view "c:\ado\plus/m\mp_ana.txt":ana}{col 16}PLUS{col 25}analysis .do file"'
file read `fh' line
assert `"`line'"'==`"*{view "c:\ado\plus/m\mp_dta.txt":dta}{col 16}PLUS{col 25}data preparation"'
file read `fh' line
assert `"`line'"'==`" {view "c:\ado\plus/m\mp_main.txt":main}{col 16}PLUS{col 25}main project .do file"'
file read `fh' line
assert `"`line'"'==`" {view "c:\ado\plus/m\mp_rlog.txt":rlog}{col 16}PLUS{col 25}research log"'
file read `fh' line
assert `"`line'"'==`"{hline}"'
file read `fh' line
assert `"`line'"'==`"{txt}* indicates default"'
file read `fh' line
assert `"`line'"'==`"{com}. log close"'
file read `fh' line
assert `"`line'"'==`"{smcl}"'
file read `fh' line
assert `"`line'"'==`"{com}{sf}{ul off}"'
file read `fh' line
assert r(eof)==1
file close `fh'

//create
mata:
unlink("bench/testcreate.txt")
fh = fopen("bench/testcreate.txt", "w")
fput(fh, "<header>")
fput(fh, "<label> something to test")
fput(fh, "</header>")
fput(fh, "clear all")
fclose(fh)
end
boilerplate, create("bench/testcreate.txt")

mata:
file = pathjoin(pathsubsysdir("PERSONAL"), "m")
file = pathjoin(file, "mp_testcreate.txt")
fh = fopen(file, "r")
assert(fget(fh)==`"<header>"')
assert(fget(fh)==`"<mkproject> boilerplate"')
assert(fget(fh)==`"<version> 2.0.0"')
assert(fget(fh)==`"<label> something to test"')
assert(fget(fh)==`"</header>"')
assert(fget(fh)==`"clear all"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink(file)
end

mata:
unlink("bench/testcreate.txt")
fh = fopen("bench/testcreate.txt", "w")
fput(fh, "<header>")
fput(fh, "<label> something to test")
fput(fh, "</header>")
fput(fh, "<dir> main")
fput(fh, "<cmd> dirtree")
fclose(fh)
end

mkproject, create("bench/testcreate.txt")

mata:
fh = fopen(file, "r")
assert(fget(fh)==`"<header>"')
assert(fget(fh)==`"<mkproject> stencil"')
assert(fget(fh)==`"<version> 2.0.0"')
assert(fget(fh)==`"<label> something to test"')
assert(fget(fh)==`"</header>"')
assert(fget(fh)==`"<dir> main"')
assert(fget(fh)==`"<cmd> dirtree"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink(file)
unlink("bench/testcreate.txt")
end


//default resetdefault
boilerplate, default(ana)
mata:
file = pathjoin(pathsubsysdir("PERSONAL"), "m")
file = pathjoin(file,"mp_defaults.txt")
fh = fopen(file, "r")
assert(fget(fh)==`"<header>"')
assert(fget(fh)==`"<mkproject> defaults"')
assert(fget(fh)==`"<version> 2.0.0"')
assert(fget(fh)==`"<label> user specified defaults"')
assert(fget(fh)==`"</header>"')
assert(fget(fh)==`"<stencil> long"')
assert(fget(fh)==`"<boilerplate> ana"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
end
boilerplate, resetdef
mata:
assert(!fileexists(file))
end

cleanup bench/totest
mkproject totest, dir(bench)
cd ../..
assert (`"`:dir . dirs "*" '"') == (`""docu" "posted" "work""')
cd ../..
cleanup bench/totest

capture erase bench/totest_ana02.do
boilerplate bench/totest_ana02.do, type(ana)
erase bench/totest_ana02.do // returns error if file does not exist

