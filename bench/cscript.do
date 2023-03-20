cscript
cd "D:\Mijn documenten\projecten\stata\mkproject\1.1.0"
capture erase c:\temp\bla\work\bla_main.do
capture erase c:\temp\bla\work\bla_dta01.do
capture erase c:\temp\bla\work\bla_ana01.do
capture rmdir c:\temp\bla\work
capture erase c:\temp\bla\docu\research_log.txt
capture rmdir c:\temp\bla\docu
capture rmdir c:\temp\bla\admin
capture rmdir c:\temp\bla\posted\data
capture rmdir c:\temp\bla\posted
capture erase c:\temp\bla\bla.stpr
capture rmdir c:\temp\bla

capture erase c:\temp\foo\work\foo_main.do
capture erase c:\temp\foo\work\foo_dta01.do
capture erase c:\temp\foo\work\foo_dta02.do
capture erase c:\temp\foo\work\foo_dta03.do
capture erase c:\temp\foo\work\foo_ana01.do
capture erase c:\temp\foo\work\foo_ana02.do
capture rmdir c:\temp\foo\work
capture erase c:\temp\foo\docu\research_log.txt
capture rmdir c:\temp\foo\docu
capture rmdir c:\temp\foo\admin
capture rmdir c:\temp\foo\posted\data
capture rmdir c:\temp\foo\posted
capture erase c:\temp\foo\bla.stpr
capture rmdir c:\temp\foo


run boilerplate.ado
run mkproject.ado

Parsedirs using working/foo_bla.do
assert `"`s(abbrev)'"' == `"foo"'
assert `"`s(stub)'"'   == `"foo_bla"'

Parsedirs using working\foo_bla.do
assert `"`s(abbrev)'"' == `"foo"'
assert `"`s(stub)'"'   == `"foo_bla"'

Parsedirs using c:/working\foo_bla.do
assert `"`s(abbrev)'"' == `"foo"'
assert `"`s(stub)'"'   == `"foo_bla"'


*set trace on
mkproject bla, dir(c:/temp)
cd c:/temp
mkproject foo
boilerplate foo_dta02.do
boilerplate foo_dta03
boilerplate foo_ana02.do, ana


