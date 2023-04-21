cscript "mkproject"

mkproject foo, dir(bench)
confirm file foo_ana01.do
confirm file foo_dta01.do
confirm file foo_main.do
cd ..
assert `"`: dir . dirs "*"'"' == `""admin" "docu" "posted" "work""'
cd posted
assert `"`: dir . dirs "*"'"' == `""data""'
cd ../docu
confirm file research_log.txt
cd ../..
! rmdir foo /S /Q
cd ..

mkproject foo, dir(bench) git
confirm file foo_ana01.do
confirm file foo_dta01.do
confirm file foo_main.do
cd ..
assert `"`: dir . dirs "*"'"' == `"".git" "admin" "docu" "protected" "work""'
cd protected
assert `"`: dir . dirs "*"'"' == `""data""'
cd ../docu
confirm file research_log.txt
cd ../..
! rmdir foo /S /Q
cd ..

