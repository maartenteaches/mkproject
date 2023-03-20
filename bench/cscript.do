cscript
cd "D:\Mijn documenten\projecten\stata\mkproject\1.0.0"
capture erase c:\temp\bla\work\bla_main.do
capture erase c:\temp\bla\work\bla_dta01.do
capture erase c:\temp\bla\work\bla_ana01.do
capture rmdir c:\temp\bla\work
capture erase c:\temp\bla\docu\research_log.txt
capture rmdir c:\temp\bla\docu
capture rmdir c:\temp\bla\admin
capture rmdir c:\temp\bla\posted\data
capture rmdir c:\temp\bla\posted
capture rmdir c:\temp\bla

mkproject bla, dir(c:/temp)
