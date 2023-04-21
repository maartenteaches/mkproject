cscript "mkproject"
*cd "c:\Mijn documenten\projecten\stata\mkproject\1.2.0"
cd h:\1.2.0

do bench/mkproject.do
do bench/boilerplate.do
do bench/sub_mkproject.do
do bench/sub_boilerplate.do
