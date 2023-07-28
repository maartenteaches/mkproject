mata:
mata set matastrict on
void mpdefaults::new()
{
	string scalar path
	path = pathsubsysdir("PERSONAL")
	if(!direxists(path)) {
		mkdir(path)
	}
	path = pathjoin(path, "m") 
	if (!direxists(path)) {
		mkdir(path)
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
        if (first == "<stencil>") {
            defaults.stencil = second
        }
        else if (first == "<boilerplate>") {
            defaults.boilerplate = second
        }
    }
    mpfclose(reading.fh)
    header_ok(defaults.stencil, "stencil")
    header_ok(defaults.boilerplate, "boilerplate")
}

void mpdefaults::write_default(string scalar what, string scalar value)
{
    string scalar fn
    real scalar fh
    
    read_defaults()
    header_ok(value, what)
    if (what == "stencil") {
        defaults.stencil = value
    }
    else if (what == "boilerplate") {
        defaults.boilerplate = value
    }
    else {
        errprintf("{p}" + what + " is not a valid default type{p_end}")
        exit(198)
    }
 
    fn = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_defaults.mpd")
    unlink(fn)
    fh = mpfopen(fn, "w")
    reading.type = "defaults" 
    reading.fversion = current_version
    reading.label = "user specified defaults"
    write_header(fh) 
    mpfput(fh, "<stencil> " + defaults.stencil)
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
	else if (what == "stencil") {
		def = defaults.stencil
	}
	else {
		errprintf("{p}only boilerplate or stencil allowed in reset(){p_end}")
		exit(198)
	}
	
	write_default(what, def)
}

end
