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