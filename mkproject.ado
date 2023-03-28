*! version 2.0.0 27Mar2023 MLB
program define mkproject
    version 10
    syntax [name], [debug CREATE(string) query] *
	
	local proj mkproject__class_instance
	mata: `proj' = mkproject()
	if  {
        di as err "{p}{p_end}"
        exit 198
    }
    if "`create'" != "" {
        confirm file "`create'"
        mata: templname()
        copy `create' `newpath'
        if "`query'" == "" exit
    }
    if "`query'" != "" {
        Query
        exit
    }
    if "`create'`query'`namelist'" == "" {
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

program define Query
    version 10
    
    local personal : dir `"`c(sysdir_personal)'/m/"' files "mp_*.txt"
    local plus     : dir `"`c(sysdir_plus)'/m/"'     files "mp_*.txt"
    local all = `"`personal' `plus'"'
    local all : list uniq all
    local all : list sort all
    
    foreach file of local alll {
        local name = usubinstr("`file'", "mp_" , "" ,1)
        local name = ustrreverse("`name'")
        local name = usubinstr("`name'", "txt.","",1)
        local name = ustrreverse("`name'")
        if `: list file in personal' {
            local path = `"`c(sysdir_personal)'/m/`file'"' 
            local where "personal"
        }
        else {
            local path = `"`c(sysdir_plus)'/m/`file'"'
            local where "plus"
        }
        display `"    {view "`path'":`name'}"' as txt "{col 19} `where'"
    }
end
	
mata:
void templname()
{
    path = st_local("create")
    path = pathrmsuffix(pathbasename(path)) + ".txt"
    path = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_" + path)
    st_local("newpath", path)
}    
end
