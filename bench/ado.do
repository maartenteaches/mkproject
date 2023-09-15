// query
log using bench/totest , replace nomsg
mkproject , query
boilerplate , query
log close

tempname fh
file open `fh' using `"bench/totest.smcl"', read text
file read `fh' line
assert `"`line'"'==`"{smcl}"'
file read `fh' line
assert `"`line'"'==`"{com}{sf}{ul off}{txt}"'
file read `fh' line
assert `"`line'"'==`"{com}. mkproject , query"'
file read `fh' line
assert `"`line'"'==`"{res}{hline}"'
file read `fh' line
assert `"`line'"'==`"{txt}{txt}{col 3}Name{col 17}Requires{col 28}Label"'
file read `fh' line
assert `"`line'"'==`"{hline}"'
file read `fh' line
assert `"`line'"'==`"{txt}  {help "mp_p_course":course}{col 17}+ {help dirtree:dirtree}{col 28}Small research project as part of a course"'
file read `fh' line
assert `"`line'"'==`"{txt}  {help "mp_p_excer":excer}{col 17}{col 28}excercise for a course"'
file read `fh' line
assert `"`line'"'==`"{txt} *{help "mp_p_long":long}{col 17}{col 28}based on (Long 2009)"'
file read `fh' line
assert `"`line'"'==`"{txt}  {help "mp_p_longt":longt}{col 17}+ {help dirtree:dirtree}{col 28}based on (Long 2009), display project with dirtree"'
file read `fh' line
assert `"`line'"'==`"{txt}  {help "mp_p_research_git":research_git}{col 17}/ {browse "https://git-scm.com/":git}{col 28}Research with git"'
file read `fh' line
assert `"`line'"'==`"{txt}  {help "mp_p_researcht_git":researcht_git}{col 17}/ {browse "https://git-scm.com/":git}{col 28}Research project with git, display project with"'
file read `fh' line
assert `"`line'"'==`"{txt}{col 17}+ {help dirtree:dirtree}{col 28}dirtree"'
file read `fh' line
assert `"`line'"'==`"{txt}  {help "mp_p_smclpres":smclpres}{col 17}+ {help smclpres:smclpres}{col 28}a smclpres presentation project"'
file read `fh' line
assert `"`line'"'==`"{hline}"'
file read `fh' line
assert `"`line'"'==`"{txt}* indicates default"'
file read `fh' line
assert `"`line'"'==`"{txt}+ indicates requirement met"'
file read `fh' line
assert `"`line'"'==`"{txt}- indicates requirement not met"'
file read `fh' line
assert `"`line'"'==`"{txt}/ indicates requirement not checked"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"{com}. boilerplate , query"'
file read `fh' line
assert `"`line'"'==`"{res}{hline}"'
file read `fh' line
assert `"`line'"'==`"{txt}{txt}{col 3}Name{col 12}Requires{col 23}Label"'
file read `fh' line
assert `"`line'"'==`"{hline}"'
file read `fh' line
assert `"`line'"'==`"{txt}  {help "mp_b_ana":ana}{col 12}{col 23}analysis .do file"'
file read `fh' line
assert `"`line'"'==`"{txt} *{help "mp_b_dta":dta}{col 12}{col 23}data preparation"'
file read `fh' line
assert `"`line'"'==`"{txt}  {help "mp_b_dta_c":dta_c}{col 12}{col 23}data preparation for course"'
file read `fh' line
assert `"`line'"'==`"{txt}  {help "mp_b_excer":excer}{col 12}{col 23}course exercise"'
file read `fh' line
assert `"`line'"'==`"{txt}  {help "mp_b_ignore":ignore}{col 12}{col 23}.ignore file for git, ignores everything in directory"'
file read `fh' line
assert `"`line'"'==`"{txt}{col 12}{col 23}data, and all .dta and .csv files"'
file read `fh' line
assert `"`line'"'==`"{txt}  {help "mp_b_main":main}{col 12}{col 23}main project.do file"'
file read `fh' line
assert `"`line'"'==`"{txt}  {help "mp_b_readme":readme}{col 12}{col 23}readme.md for when you want to put your project on github"'
file read `fh' line
assert `"`line'"'==`"{txt}{col 12}{col 23}or the like"'
file read `fh' line
assert `"`line'"'==`"{txt}  {help "mp_b_rlog":rlog}{col 12}{col 23}research log"'
file read `fh' line
assert `"`line'"'==`"{txt}  {help "mp_b_rlogc":rlogc}{col 12}{col 23}research log for a course"'
file read `fh' line
assert `"`line'"'==`"{txt}  {help "mp_b_smclpres":smclpres}{col 12}+ {help smclpres:smclpres}{col 23}a smclpres presentation"'
file read `fh' line
assert `"`line'"'==`"{hline}"'
file read `fh' line
assert `"`line'"'==`"{txt}* indicates default"'
file read `fh' line
assert `"`line'"'==`"{txt}+ indicates requirement met"'
file read `fh' line
assert `"`line'"'==`"{txt}- indicates requirement not met"'
file read `fh' line
assert `"`line'"'==`"{txt}/ indicates requirement not checked"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"{com}. log close"'
file read `fh' line
assert `"`line'"'==`"{smcl}"'
file read `fh' line
assert `"`line'"'==`"{com}{sf}{ul off}"'
file read `fh' line
assert r(eof)==1
file close `fh'




//create and remove
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
file = pathjoin(file, "mp_testcreate.mpb")
fh = fopen(file, "r")
assert(fget(fh)==`"<header>"')
assert(fget(fh)==`"<mkproject> boilerplate"')
assert(fget(fh)==`"<version> 2.0.1"')
assert(fget(fh)==`"<label> something to test"')
assert(fget(fh)==`"</header>"')
assert(fget(fh)==`"clear all"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
end

boilerplate, remove("testcreate")
mata: 
assert(!fileexists(file))
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
file = pathjoin(pathsubsysdir("PERSONAL"), "m")
file = pathjoin(file, "mp_testcreate.mpp")
fh = fopen(file, "r")
assert(fget(fh)==`"<header>"')
assert(fget(fh)==`"<mkproject> project"')
assert(fget(fh)==`"<version> 2.0.1"')
assert(fget(fh)==`"<label> something to test"')
assert(fget(fh)==`"</header>"')
assert(fget(fh)==`"<dir> main"')
assert(fget(fh)==`"<cmd> dirtree"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/testcreate.txt")
end

mkproject, remove("testcreate")
mata: 
assert(!fileexists(file))
end

//default resetdefault
boilerplate, default(ana)
mata:
file = pathjoin(pathsubsysdir("PERSONAL"), "m")
file = pathjoin(file,"mp_defaults.mpd")
fh = fopen(file, "r")
assert(fget(fh)==`"<header>"')
assert(fget(fh)==`"<mkproject> defaults"')
assert(fget(fh)==`"<version> 2.0.1"')
assert(fget(fh)==`"<label> user specified defaults"')
assert(fget(fh)==`"</header>"')
assert(fget(fh)==`"<project> long"')
assert(fget(fh)==`"<boilerplate> ana"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
end
boilerplate, resetdef 
mata:
file = pathjoin(pathsubsysdir("PERSONAL"), "m")
file = pathjoin(file,"mp_defaults.mpd")
fh = fopen(file, "r")
assert(fget(fh)==`"<header>"')
assert(fget(fh)==`"<mkproject> defaults"')
assert(fget(fh)==`"<version> 2.0.1"')
assert(fget(fh)==`"<label> user specified defaults"')
assert(fget(fh)==`"</header>"')
assert(fget(fh)==`"<project> long"')
assert(fget(fh)==`"<boilerplate> dta"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
end

cleanup bench/totest
mkproject totest, dir(bench)
cd ../..
assert (`"`:dir . dirs "*" '"') == (`""docu" "posted" "work""')
cd ../..
cleanup bench/totest

capture erase bench/totest_ana02.do
boilerplate bench/totest_ana02.do, template(ana)
erase bench/totest_ana02.do // returns error if file does not exist

