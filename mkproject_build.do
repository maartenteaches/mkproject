cscript
mata: mata clear

cd "D:/mijn documenten/projecten/stata/mkproject"
do mkproject_main.mata

lmbuild lmkproject, replace
mata : mata describe using lmkproject

lmbuild lmkproject, dir(.) replace
mata : mata describe using lmkproject

local templs : dir "templates/" files "*.mpb"

foreach templ of local templs {
	boilerplate, create(templates/`templ') replace plus
	copy "`c(sysdir_personal)'m/mp_`templ'" "mp_`templ'", replace
	mata: st_local("templ", pathrmsuffix(st_local("templ")))
	copy "`c(sysdir_personal)'m/mp_b_`templ'.sthlp" "mp_b_`templ'.sthlp", replace
}

local templs : dir "templates/" files "*.mpp"
foreach templ of local templs {
	mkproject, create(templates/`templ') replace plus
	copy "`c(sysdir_personal)'m/mp_`templ'" "mp_`templ'", replace
	mata: st_local("templ", pathrmsuffix(st_local("templ")))
	copy "`c(sysdir_personal)'m/mp_p_`templ'.sthlp" "mp_p_`templ'.sthlp", replace
}
