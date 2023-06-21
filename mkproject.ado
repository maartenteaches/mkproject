*! version 2.0.0 27Mar2023 MLB
program define mkproject
    version 10
    syntax [name], [debug CREATE(string) query default(string) RESETDEFault] *
	
    if "`default'" != "" & "`resetdefault'" != "" {
        di as err "{p}Cannot specify default() and resetdefault together{p_end}"
        exit 198
    }
    if "`create'`query'`default'`resetdefault'`namelist'" == "" {
        di as err "{p}A name for your project is required{p_end}"
        exit 198
    }
    if "`create'`query'`default'`resetdefault'" != "" & "`namelist'" != "" {
        di as err "{p}A name for a project cannot be specified together with the create(), query, default(), resetdefault options{p_end}"
        exit 198
    }    

   	local proj mkproject__class_instance
    
    if `"`create'"' != "" {
        capture noisily Create `create', proj(`proj') `options'
        Cleanup , proj(`proj') rc(`=_rc') `debug'
        if "`query'`default'`resetdefault'" == "" exit
    }
    if `"`default'"' != "" {
        capture noisily Default `default', proj(`proj') 
        Cleanup , proj(`proj') rc(`=_rc') `debug'
        if "`query'`resetdefault'" == "" exit
    }
    if "`resetdefault'" != "" {
        capture noisily Resetdefault, proj(`proj')
        Cleanup , proj(`proj') rc(`=_rc') `debug'
        if "`query'" == "" exit        
    }
    if "`query'" != "" {
        caputre noisily Query, proj(`proj')
        Cleanup, proj(`proj') rc(`=_rc') `debug'
        exit
    }
    capture noisily mkproject_main `namelist', `options' proj(`proj')
	Cleanup, proj(`proj') rc(`=_rc') `debug'	
end

program define Create
    syntax anything(name=create), proj(string) [replace] *
    mata: `proj' = mpcreate()
    mata: `proj'.create("stencil")
end

program define Query
    syntax, proj(string)
    mata: `proj' = mpquery()
    mata: `proj'.run("stencil")
end

program define Default
    syntax anything(name=default), proj(string) 
    mata: `proj' = mpdefaults()
    mata: `proj'.write_default("stencil", "`default'")
end

program define Resetdefault
    syntax, proj(string) 
    mata: `proj' = mpdefaults()
    mata: `proj'.reset()
end

program define mkproject_main 
	version 10
	syntax name(name=abbrev), proj(string) ///
           [ DIRectory(string) template(string)]
           
    mata: `proj' = mkproject()
	mata:`proj'.run()
end

program define Cleanup 
	version 10
	syntax, proj(string) rc(integer) [debug]
	
    if `rc' {
        mata:`proj'.graceful_exit()
    }
    if "`debug'" == "" {
		mata: mata drop `proj'
	}
    if `rc' {
        exit `rc'
    }
end
