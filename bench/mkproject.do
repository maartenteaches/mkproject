//parse_dir()
local dir "bench/"
local abbrev "foo"
mata:
odir = pwd()
totest = mkproject()
totest.parse_dir()
assert(totest.odir==odir)
assert(pwd() == pathjoin(odir, "bench\foo\"))
chdir("..")
rmdir("foo")
chdir("..")
end

//read_dir()
mata:
totest=mkproject()
totest.read_dir("foo/bar")
assert(totest.dirs == ("\foo\" \ "\foo\bar\"))
totest.read_dir("foo/blup")
assert(totest.dirs == ("\foo\" \ "\foo\bar\" \ "\foo\blup\"))
end

//getrest()
mata:
t=tokeninit(" ")
tokenset(t,"denkend aan holland zie ik <abbrev> rivieren")
tokenget(t)

totest=mkproject()
totest.abbrev = "kleine"
assert(totest.getrest(t) == "aan holland zie ik kleine rivieren")

//parse_sline()
mata:
//<dir>
totest=mkproject()
totest.parse_sline("<dir> foo/bar")
assert(totest.dirs == ("\foo\" \ "\foo\bar\"))
totest.parse_sline("<dir> foo\blup")
assert(totest.dirs == ("\foo\" \ "\foo\bar\" \ "\foo\blup\"))
totest.abbrev = "blup"
totest.parse_sline("<dir> <abbrev>blup")
assert(totest.dirs == ("\foo\" \ "\foo\bar\" \ "\foo\blup\" \ "\blupblup\"))

//<file>
totest.parse_sline("<file> dta <abbrev>_dta01.do")
assert(totest.files == ("dta", "blup_dta01.do"))
totest.parse_sline("<file> ana <abbrev>_ana01.do")
assert(totest.files == ("dta", "blup_dta01.do" \ "ana", "blup_ana01.do"))

//cmds
totest.parse_sline("<cmd> cd working")
totest.parse_sline("<cmd> ! git init -b main")
totest.parse_sline("<cmd> ! git add . ")
totest.parse_sline(`"<cmd> ! git commit -m "initial commit" "')
totest.parse_sline("to ignore")
totest.parse_sline("<cmd> doedit <abbrev>_main.do")
assert(totest.cmds == ("cd working" \
                       "! git init -b main" \
		         	   "! git add . " \
		         	   `"! git commit -m "initial commit" "' \
		         	   "doedit blup_main.do"))
end

// read_stencil
mata:
totest = mkproject()
totest.dir     = "bench"
totest.abbrev  = "test"
totest.stencil = "long"
totest.read_stencil()
assert(totest.dirs == ("\docu\" \
                       "\posted\" \
                       "\posted\data\" \
                       "\posted\analysis\" \
                       "\posted\txt\" \
                       "\work\" \
                       "\work\analysis\" \
                       "\work\txt\"))

assert(totest.cmds == ("qui cd work/analysis" \
 "projmanager test.stpr"))


assert(totest.files== ("rlog",        "docu/research_log.md" \
                       "main",  "work/analysis/test_main.do" \
                       "dta" , "work/analysis/test_dta01.do" \
                       "ana" , "work/analysis/test_ana01.do" ))

end

//mk_dirs, mk_files
cd bench
mata:
totest = mkproject()
totest.dirs = ("test" \ "test\again")
totest.mk_dirs()
assert(direxists("test"))
assert(direxists("test/again"))

chdir("test")
totest.files = ("main" , "test_main.do" \
                "ana"  , "test_ana.do")
totest.mk_files()				
end

tempname fh
file open `fh' using `"test_ana.do"', read text
file read `fh' line
assert `"`line'"'==`"capture log close"'
file read `fh' line
assert `"`line'"'==`"log using test_ana.txt, replace text"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"// What this .do file does"'
file read `fh' line
assert `"`line'"'==`"// Who wrote it"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"version 17"'
file read `fh' line
assert `"`line'"'==`"clear all"'
file read `fh' line
assert `"`line'"'==`"frames reset"'
file read `fh' line
assert `"`line'"'==`"macro drop _all"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"*use test##.dta"'
file read `fh' line
assert `"`line'"'==`"*datasignature confirm"'
file read `fh' line
assert `"`line'"'==`"*codebook, compact"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"// do your analysis"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"log close"'
file read `fh' line
assert `"`line'"'==`"exit"'
file read `fh' line
assert r(eof)==1
file close `fh'

tempname fh
file open `fh' using `"test_main.do"', read text
file read `fh' line
assert `"`line'"'==`"version 17"'
file read `fh' line
assert `"`line'"'==`"clear all"'
file read `fh' line
assert `"`line'"'==`"frames reset"'
file read `fh' line
assert `"`line'"'==`"macro drop _all"'
file read `fh' line
assert `"`line'"'==`"cd "C:\mijn documenten\projecten\stata\mkproject\bench\test""'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"do test_dta01.do // some comment"'
file read `fh' line
assert `"`line'"'==`"do test_ana01.do // some comment"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"exit"'
file read `fh' line
assert r(eof)==1
file close `fh'

mata
unlink("test_main.do")
unlink("test_ana.do")
chdir("..")
rmdir("test/again")
rmdir("test")
chdir("..")
end

