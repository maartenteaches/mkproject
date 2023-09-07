cscript
mata: mata clear

cd "d:/mijn documenten/projecten/stata/mkproject"
do mkproject_main.mata
lmbuild lmkproject, dir(.) replace
mata : mata describe using lmkproject

local templs : dir "templates/" files "*.mpb"
foreach templ of local templs {
	boilerplate, create(templates/`templ') replace
}

local templs : dir "templates/" files "*.mpp"
foreach templ of local templs {
	mkproject, create(templates/`templ') replace
}
