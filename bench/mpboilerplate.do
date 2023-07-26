// remove_usuffix()
mata:
totest = boilerplate()
foo = "ä_Ü_ßö"
assert(totest.remove_usuffix(foo) == "ä_Ü")
foo = "äÜ_ßö"
assert(totest.remove_usuffix(foo) == "äÜ")
foo = "äÜßö"
assert(totest.remove_usuffix(foo) == "äÜßö")
end

//parse_dest()
mata:
totest = boilerplate()
totest.parse_dest("bench/blä_föö_dta01.do")
assert(totest.torepl.fn == "blä_föö_dta01.do")
assert(totest.torepl.stub == "blä_föö_dta01")
assert(totest.torepl.abbrev == "blä_föö")
assert(strlower(totest.torepl.basedir) == strlower( pathresolve(pwd(),"bench") + "/"))


totest = boilerplate()
totest.parse_dest("bench/bläföö_dta01.do")
assert(totest.torepl.fn == "bläföö_dta01.do")
assert(totest.torepl.stub == "bläföö_dta01")
assert(totest.torepl.abbrev == "bläföö")
assert(strlower(totest.torepl.basedir) == strlower( pathresolve(pwd(),"bench") + "/"))

totest = boilerplate()
totest.parse_dest("bench/bläföödta01.do")
assert(totest.torepl.fn == "bläföödta01.do")
assert(totest.torepl.stub == "bläföödta01")
assert(totest.torepl.abbrev == "bläföödta01")
assert(strlower(totest.torepl.basedir) == strlower( pathresolve(pwd(),"bench") + "/"))
end

// parse_bline()
mata:
totest = boilerplate()
totest.parse_dest("bench/blä_föö_dta01.do")
fn = "bench/totest.txt"
fh = fopen(fn, "w")

line = "denkend aan <fn> zie ik"
totest.parse_bline(line,fh)

line = "zie ik <stub> rivieren"
totest.parse_bline(line,fh)

line = "traag door <basedir> laagland gaan"
totest.parse_bline(line,fh)

line = "rijen ondenkbaar <abbrev> populieren"
totest.parse_bline(line,fh)

line = "als hoge <stata_version> aan den einder staan"
totest.parse_bline(line,fh)

line = "en in het <date> landschap"
totest.parse_bline(line,fh)

line = "<as of 22>this should not appear"
totest.parse_bline(line,fh)

line = "<as of 14>this should appear"
totest.parse_bline(line,fh)

fclose(fh)

fh = fopen(fn, "r")
assert(fget(fh) == "denkend aan blä_föö_dta01.do zie ik")
assert(fget(fh) == "zie ik blä_föö_dta01 rivieren")
basedir = pathresolve(pwd(),"bench") + "/"
assert(fget(fh) ==  "traag door " + basedir + " laagland gaan")
assert(fget(fh) == "rijen ondenkbaar blä_föö populieren")
ver = strofreal(st_numscalar("c(stata_version)"))
assert(fget(fh) == "als hoge " + ver +  " aan den einder staan")
date = st_global("c(current_date)")  
assert(fget(fh) == "en in het " + date + " landschap")
assert(fget(fh) == "this should appear")
assert(fget(fh) == J(0,0,""))
fclose(fh)
unlink(fn)
end

//copy_boiler()
mata:
totest = boilerplate()
fn = "bench/myproj_dta02.do"
unlink(fn)
totest.copy_boiler(fn)


fh = fopen(`"bench/myproj_dta02.do"', "r")
assert(fget(fh)==`"capture log close"')
assert(fget(fh)==`"log using myproj_dta02.txt, replace text"')
assert(fget(fh)==`""')
assert(fget(fh)==`"// What this .do file does"')
assert(fget(fh)==`"// Who wrote it"')
assert(fget(fh)==`""')
ver = strofreal(st_numscalar("c(stata_version)"))
assert(fget(fh)==`"version "' + ver)
assert(fget(fh)==`"clear all"')
if (st_numscalar("c(stata_version)") >= 16) {
    assert(fget(fh)==`"frames reset"')
}
assert(fget(fh)==`"macro drop _all"')
assert(fget(fh)==`""')
assert(fget(fh)==`"*use ../posted/data/[original_data_file.dta]"')
assert(fget(fh)==`""')
assert(fget(fh)==`"*rename *, lower"')
assert(fget(fh)==`"*keep"')
assert(fget(fh)==`""')
assert(fget(fh)==`"// prepare data"')
assert(fget(fh)==`""')
assert(fget(fh)==`"*gen some_var = ..."')
assert(fget(fh)==`"*note some_var: based on [original vars] \ myproj_dta02.do \ [author] TS"')
assert(fget(fh)==`""')
assert(fget(fh)==`"*compress"')
assert(fget(fh)==`"*note: myproj##.dta \ [description] \ myproj_dta02.do \ [author] TS "')
assert(fget(fh)==`"*label data [description]"')
assert(fget(fh)==`"*datasignature set, reset"')
assert(fget(fh)==`"*save myproj##.dta, replace"')
assert(fget(fh)==`""')
assert(fget(fh)==`"log close"')
assert(fget(fh)==`"exit"')
assert(fget(fh)==J(0,0,""))
fclose(fh)


unlink(fn)
end
