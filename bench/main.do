cscript
mata: mata clear

*local home "D"
local home "C"

cd "`home':\mijn documenten\projecten\stata\mkproject"
do mkproject_main.mata

do bench/copy2plus.do
do bench/version.do
do bench/mpfile.do
do bench/mptools.do "`home'"
do bench/mpdefaults.do
do bench/mpboilerplate.do
do bench/mkproject.do

