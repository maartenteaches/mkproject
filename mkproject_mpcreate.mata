mata:

void mpcreate::header_defaults(string scalar what)
{
    if (reading.type == "") { 
        reading.type = what
    }
    if (reading.sversion == "") {
        reading.sversion = invtokens(strofreal(current_version),".")
    }
    header_version(reading.sversion)
    // wrong type of mkproject file
    if (reading.type != what) { 
        errprintf("{p}expected a file of type " + what + " but found a file of type " + reading.type + "{p_end}")
        exit(198)
    }
}
void mpcreate::create(string scalar what)
{
    string scalar fn_in, fn_out, EOF, line
    real scalar fh_out
    
    fn_in = st_local("create")
    fn_out = newname(fn_in, what)
    EOF = J(0,0,"")
    
    if (fileexists(fn_in)==0) {
        errprintf("{p}file " + fn_in + " not found {p_end}")
        exit(601)
    }
    mpfread(fn_in)
    read_header()
    header_defaults(what)
    fh_out = mpfopen(fn_out, "w")
    write_header(fh_out)
    
    // no header in source
    if (reading.open == 0) { 
        mpfread(fn_in)
    }    
        
    while((line=mpfget())!=EOF) {
        chk_file(line)
        mpfput(fh_out, line)
    }
    mpfclose(reading.fh)
    mpfclose(fh_out)
}

void mpcreate::chk_file(string scalar line)
{
    transmorphic scalar t
    string scalar garbage, first, second
    
    t = tokeninit()
    tokenset(t, line)
    first = tokenget(t)
    if (first == "<file>") {
        second = tokenget(t)
        garbage = find_file(second, "boilerplate")
    }
}

string scalar mpcreate::newname(string scalar path, string scalar what)
{
    string scalar newpath, ext

	ext = type2ext(what)
    newpath = pathrmsuffix(pathbasename(path)) + ext
    newpath = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_" + newpath)
    
    if (st_local("replace") == "" & fileexists(newpath)) {
        errprintf(pathrmsuffix(pathbasename(newpath)) + " already exists" )
        exit(198)
    }
    else {
        unlink(newpath)
    }
    return(newpath)
} 

void mpcreate::remove(string scalar what, string scalar type)
{
	string scalar fn, ext
	
	ext = type2ext(type)
	fn = "m\mp_" + what + ext
	
	fn = pathjoin(pathsubsysdir("PERSONAL"), fn)
	if (!fileexists(fn)) {
		errprintf("{p}" + type + " " + what + " not found{p_end}")
		exit(601)
	}
	read_defaults()
	if (type == "boilerplate") {
		if (defaults.boilerplate == what) {
			reset(type)
		}
 	}
	else if (type == "stencil") {
		if (defaults.stencil == what) {
			reset(type)
		}
	}
	unlink(fn)
}

end