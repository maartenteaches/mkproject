<mkproject boilerplate>
<version> 2.0.0
version <stata_version>
clear all
<as of 16>frames reset
macro drop _all
cd "<basedir>"

do <abbrev>_dta01.do // some comment
do <abbrev>_ana01.do // some comment

exit
