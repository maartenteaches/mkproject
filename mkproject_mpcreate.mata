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
	string colvector reqs
    
    fn_in = st_local("create")
    fn_out = newname(fn_in, what)
    EOF = J(0,0,"")
    
    if (fileexists(fn_in)==0) {
        errprintf("{p}file " + fn_in + " not found {p_end}")
        exit(601)
    }
	reqs = integrate_reqs()
    mpfread(fn_in)
    read_header()
    header_defaults(what)
	reading.reqs = reqs
    fh_out = mpfopen(fn_out, "w")
    write_header(fh_out)
    
    // no header in source
    if (reading.open == 0) { 
        mpfread(fn_in)
    }    
        
    while((line=mpfget())!=EOF) {
        mpfput(fh_out, line)
    }
    mpfclose(reading.fh)
    mpfclose(fh_out)
}

string colvector mpcreate::integrate_reqs(string scalar fn)
{
	string colvector toreturn
	string scalar EOF, line, s
	real scalar sversion, fh
	real colvector isstata

	EOF = J(0,0,"")
	mpfread(fn)
    read_header()
	if (reading.open == 1) {
		mpfclose(reading.fh)
		toreturn = reading.reqs
		isstata = strmatch(strlower(toreturn), "stata *")
		if(any(isstata)) {
			s = select(toreturn,isstata)
			sversion = strtoreal(tokens(s)[2])
			toreturn = select(toreturn, !isstata)
		}
	}
	
	if (toreturn == J(0,0,"")) toreturn = J(0,1,"")
	fh = fopen(fn, "r")
	while((line=fget(fh))!=EOF) {
        chk_file(line, toreturn, sversion)
    }
    fclose(fh)
	
	if (sversion != .) {
		toreturn = ("Stata " + strofreal(sversion, "%9.1f")) \ toreturn
	}
	return(toreturn)
}

void mpcreate::chk_file(string scalar line, 
                        string colvector toreturn, 
						real scalar sversion)
{
    transmorphic scalar t
    string scalar fn, first, second
    real scalar i
	
    t = tokeninit()
    tokenset(t, line)
    first = tokenget(t)
    if (first == "<file>") {
        second = tokenget(t)
        fn = find_file(second, "boilerplate")
		mpfread(fn)
		read_header()
		if (reading.open == 1) {
			mpfclose(reading.fh)
		}
		for(i=1;i<=rows(reading.reqs); i++) {
			parse_req_line(toreturn,reading.reqs[i],sversion)
		}
    }
}

void mpcreate::parse_req_line(string colvector toreturn, 
                              string scalar req, 
							  real scalar sversion)
{
	real scalar newsversion
	
	if (strmatch(strlower(req), "stata *")) {
		newsversion = strtoreal(tokens(req)[2])
		sversion = max((sversion, newsversion))
	}
	else if (!anyof(toreturn, req)){
		toreturn = toreturn \ req
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