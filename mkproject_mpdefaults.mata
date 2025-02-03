mata:
mata set matastrict on
void mpdefaults::fix_no_personal()
{
	string scalar path
	real scalar ret
	
	path = pathsubsysdir("PERSONAL")
	if(!direxists(path)) {
		ret = _mkdir(path)
		mkdirerr(ret, path)
	}
	path = pathjoin(path, "m") 
	if (!direxists(path)) {
		ret = _mkdir(path)
		mkdirerr(ret, path)
	}
}

void mpdefaults::mkdirerr(real scalar ret, string scalar path)
{
	if (ret!=0) {
		errprintf("{p}could not create directory " + displaypath(path) + "{p_end}")
		exit(ret)
	}
}

void mpdefaults::read_defaults(| string scalar plus)
{
    string scalar fn, EOF, line, first, second
    transmorphic scalar t
    
    EOF = J(0,0,"")
    t = tokeninit(" ", "", "<>")
    
	fn = find_file("defaults", "default", plus)
    mpfread(fn)
 
    read_header("defaults")
    
    while ((line=mpfget())!= EOF) {
        reading.lnr = reading.lnr+1
        tokenset(t,line)
        first = tokenget(t)
        second = tokenget(t)
        if (first == "<project>") {
            defaults.project = second
        }
        else if (first == "<boilerplate>") {
            defaults.boilerplate = second
        }
    }
    mpfclose(reading.fh)
    header_ok(defaults.project, "project")
    header_ok(defaults.boilerplate, "boilerplate")
}

void mpdefaults::write_default(string scalar what, string scalar value)
{
    string scalar fn
    real scalar fh
    
    read_defaults()
    header_ok(value, what)
    if (what == "project") {
        defaults.project = value
    }
    else if (what == "boilerplate") {
        defaults.boilerplate = value
    }
    else {
        errprintf("{p}" + what + " is not a valid default type{p_end}")
        exit(198)
    }
 
	fix_no_personal()
    fn = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_defaults.mpd")
    unlink(fn)
    fh = mpfopen(fn, "w")
    reading.type = "defaults" 
    reading.fversion = current_version
    reading.label = "user specified defaults"
	reading.description = J(0,1, "")
	reading.reqs = J(0,1,"")
    write_header(fh) 
    mpfput(fh, "<project> " + defaults.project)
    mpfput(fh, "<boilerplate> " + defaults.boilerplate)
    mpfclose(fh)
}

void mpdefaults::reset(string scalar what)
{
	string scalar def

    read_defaults("PLUS")
	if (what == "boilerplate") {
		def = defaults.boilerplate
	}
	else if (what == "project") {
		def = defaults.project
	}
	else {
		errprintf("{p}only boilerplate or project allowed in reset(){p_end}")
		exit(198)
	}
	
	write_default(what, def)
}

end
