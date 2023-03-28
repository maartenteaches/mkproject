*! version 2.0.0 27Mar2023 MLB
program define mkproject
    version 10
    syntax [name], [debug CREATETemplate(string) CREATEBoilerplate(string)] *
	
	local proj mkproject__class_instance
	mata: `proj' = mkproject()
	if  {
        di as err "{p}{p_end}"
        exit 198
    }
    if "`createtemplate'" != "" {
        mata: templname()
        copy `createtemplate' `newpath'
        if "`createboilerplate'" == "" exit
    }
    if "`createboilerplate'" != "" {
        mata: boilername()
        copy `createboilerplate' `newpath'
        exit 
    }    
    if "`namelist'" == ""  & "`createboilerplate'`createtemplate'" == "" {
        di as err "{p}A name for your project is required{p_end}"
        exit 198
    }
    
	capture noisily mkproject_main `namelist', `options' proj(`proj')

	if _rc {
		`proj'.graceful_exit()
		cleanup, proj(`proj') `debug'
		exit _rc
	}
	cleanup, proj(`proj') `debug'	
end

program define mkproject_main 
	version 10
	syntax name(name=abbrev), proj(string) ///
           [ DIRectory(string) template(string)]
		   
	mata:`proj'.run()
end

program define cleanup 
	version 10
	syntax, proj(string) [debug]
	if "`debug'" == "" {
		mata: mata drop `proj'
	}
end
	
mata:
void templname()
{
    path = st_local("createtemplate")
    path = pathrmsuffix(pathbasename(path)) + ".txt"
    path = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_" + path)
    st_local("newpath", path)
}    
void boilername()
{
    path = st_local("createboilerplate")
    path = pathrmsuffix(pathbasename(path)) + ".do"
    path = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_" + path)
    st_local("newpath", path)
}    
end
