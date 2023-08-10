cscript
mata: mata clear

cd "c:/mijn documenten/projecten/stata/mkproject"
do mkproject_main.mata
lmbuild lmkproject, dir(.) replace
mata : mata describe using lmkproject
