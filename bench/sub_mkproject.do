cscript "sub-routines in mkproject.ado"

run mkproject.ado
run boilerplate.ado
cd bench

// git ---------------------------------
git

confirm file .ignore
confirm file readme.md
assert `: dir . dirs ".git"' == ".git"

tempname fh
file open `fh' using `".ignore"', read text
file read `fh' line
assert `"`line'"'==`"*.dta"'
file read `fh' line
assert r(eof)==1
file close `fh'

tempname fh
file open `fh' using `"readme.md"', read text
file read `fh' line
assert `"`line'"'==`"# <Project name>"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"## Description"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"## Requirements"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"These .do files require Stata version `c(version)'."'
file read `fh' line
assert `"`line'"'==`"For legal/privacy reasons the raw data is not included in this repository."'
file read `fh' line
assert `"`line'"'==`"To run these .do files one must first obtain the raw data separately from <website>"'
file read `fh' line
assert r(eof)==1
file close `fh'

! rmdir .git /S /Q
! rmdir .git /S /Q
erase readme.md
erase .ignore

// opendata
git, opendata
capture confirm file .ignore
assert _rc == 601
confirm file readme.md
assert `: dir . dirs ".git"' == ".git"

tempname fh
file open `fh' using `"readme.md"', read text
file read `fh' line
assert `"`line'"'==`"# <Project name>"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"## Description"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"## Requirements"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"These .do files require Stata version `c(version)'."'
file read `fh' line
assert r(eof)==1
file close `fh'

! rmdir .git /S /Q
! rmdir .git /S /Q
erase readme.md

//normalproj
normalproj, abbrev(bla)
assert `"`: dir . dirs "*"'"' == `""admin" "docu" "posted" "work""'
cd posted
assert `"`: dir . dirs "*"'"' == `""data""'
cd ../work
confirm file "bla_dta01.do"
confirm file "bla_ana01.do"
confirm file "bla_main.do"
cd ../docu
confirm file "research_log.txt"
cd ../..
assert `"`: dir . dirs "bla"'"' == `""bla""'
! rmdir bla /S /Q

//smclproj
smclproj, abbrev(blup)
assert `"`: dir . dirs "*"'"' == `""handout" "presentation" "source""'
cd source
confirm file "blup.do"
cd ../..
assert `"`: dir . dirs "blup"'"' == `""blup""'
! rmdir blup /S /Q

//write_main
write_main foo

tempname fh
file open `fh' using `"foo_main.do"', read text
file read `fh' line
assert `"`line'"'==`"version `c(version)'"'
file read `fh' line
assert `"`line'"'==`"clear all"'
file read `fh' line
assert `"`line'"'==`"macro drop _all"'
file read `fh' line
assert `"`line'"'==`"cd "`c(pwd)'""'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"do foo_dta01.do // some comment"'
file read `fh' line
assert `"`line'"'==`"do foo_ana01.do // some comment"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"exit"'
file read `fh' line
assert r(eof)==1
file close `fh'
erase foo_main.do

//write_log
write_log
tempname fh
file open `fh' using `"research_log.txt"', read text
file read `fh' line
assert `"`line'"'==`"============================"'
file read `fh' line
assert `"`line'"'==`"Research log: <Project name>"'
file read `fh' line
assert `"`line'"'==`"============================"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"`c(current_date)': Preliminaries"'
file read `fh' line
assert `"`line'"'==`"=========================="'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"Author(s):"'
file read `fh' line
assert `"`line'"'==`"----------"'
file read `fh' line
assert `"`line'"'==`"Authors with affiliation and email"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"Preliminary research question:"'
file read `fh' line
assert `"`line'"'==`"------------------------------"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"Data:"'
file read `fh' line
assert `"`line'"'==`"-----"'
file read `fh' line
assert `"`line'"'==`"data, where and how to get it, when we got it, version"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"Intended conference:"'
file read `fh' line
assert `"`line'"'==`"--------------------"'
file read `fh' line
assert `"`line'"'==`"conference, deadline"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"Intended journal:"'
file read `fh' line
assert `"`line'"'==`"-----------------"'
file read `fh' line
assert `"`line'"'==`"journal, requirements, e.g. max word count"'
file read `fh' line
assert r(eof)==1
file close `fh'
erase research_log.txt

cd ..
