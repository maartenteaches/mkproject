args home

//read_dir()
mata:
totest=mkproject()
totest.read_dir("foo/bar")
assert(totest.dirs == ("foo\" \ "foo\bar\"))
totest.read_dir("foo/blup")
assert(totest.dirs == ("foo\" \ "foo\bar\" \ "foo\blup\"))
end
//parse_dir
mata:
totest = mkproject()
totest.dir = "bench"
totest.abbrev = "test"
totest.parse_dir()
assert(strlower(pwd()) == strlower("`home'" + ":\mijn documenten\projecten\stata\mkproject\bench\test\"))
assert(strlower(totest.odir) == strlower("`home'" + ":\mijn documenten\projecten\stata\mkproject\"))
end
cd ..
rmdir test
cd ..
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
assert(totest.dirs == ("foo\" \ "foo\bar\"))
totest.parse_sline("<dir> foo\blup")
assert(totest.dirs == ("foo\" \ "foo\bar\" \ "foo\blup\"))
totest.abbrev = "blup"
totest.parse_sline("<dir> <abbrev>blup")
assert(totest.dirs == ("foo\" \ "foo\bar\" \ "foo\blup\" \ "blupblup\"))

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

// read_project
mata:
totest = mkproject()
totest.dir     = "bench"
totest.abbrev  = "test"
totest.project = "long"
totest.read_project()
assert(totest.dirs == ("docu\" \
                       "posted\" \
                       "posted\data\" \
                       "posted\analysis\" \
                       "posted\txt\" \
                       "work\" \
                       "work\analysis\" \
                       "work\txt\"))


true = J( 5, 1 , "")
true[1, 1] = `"qui cd work/analysis"'
true[2, 1] = `"projmanager "test.stpr""'
true[3, 1] = `"doedit "test_main.do""'
true[4, 1] = `"doedit "test_dta01.do""'
true[5, 1] = `"doedit "test_ana01.do""'
assert(totest.cmds == true)

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
assert `"`line'"'==`"version `c(stata_version)'"'
file read `fh' line
assert `"`line'"'==`"clear all"'
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
assert `"`line'"'==`"version `c(stata_version)'"'
file read `fh' line
assert `"`line'"'==`"clear all"'
file read `fh' line
assert `"`line'"'==`"macro drop _all"'
file read `fh' line
assert strlower(`"`line'"')==strlower(`"cd "`home':/mijn documenten/projecten/stata/mkproject/bench/test/""')
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

//do_cmds()
mata:
totest = mkproject()
totest.cmds = (`"local foo = "bar""'\
               `"local blup = "bla""')
totest.do_cmds()
assert(st_local("foo")=="bar")
assert(st_local("blup")=="bla")
			   
end

// run
local directory "bench"
local anything "test"
local project "long"
mata:
odir = pwd()
totest = mkproject()
totest.run()
assert(pwd()== pathjoin(odir, "bench\test\work\analysis")+"\")

assert(dir(".", "files", "*") == ("test.stpr" \
                           "test_ana01.do" \
                           "test_dta01.do" \
                           "test_main.do" ))   
unlink("test.stpr")
unlink("test_ana01.do")
unlink("test_dta01.do")
unlink("test_main.do")						   
chdir("..")
assert(dir(".", "dirs", "*") == ("analysis" \ "txt"))
rmdir("analysis")
rmdir("txt")
chdir("..")
assert(dir(".", "dirs", "*") == ("docu" \ "posted" \ "work"))
rmdir("work")
chdir("posted")
assert(dir(".", "dirs", "*") == ("analysis" \ "data" \ "txt"))
rmdir("analysis")
rmdir("data")
rmdir("txt")
chdir("..")
rmdir("posted")
chdir("docu")
assert(dir(".", "files", "*") == "research_log.md")
unlink("research_log.md")
chdir("..")
rmdir("docu")
chdir("..")
rmdir("test")
chdir(odir)

end

