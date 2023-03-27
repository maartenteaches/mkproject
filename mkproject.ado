*! version 2.0.0 27Mar2023 MLB
program define mkproject
    version 10
    syntax name, [debug] *
	
	local proj mkproject__class_instance
	mata: `proj' = mkproject()
	
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
	
