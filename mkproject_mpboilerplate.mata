mata:
void boilerplate::parse_anything()
{
	string scalar dest, dir, errmsg
	
	dest = st_local("anything")
	dir = st_local("directory")
	
	if (dir != "") {
		if (pathisabs(dest)) {
			errmsg = "{p}the filename " + dest + " is absolute{p_end}"
			errprintf(errmsg)
			errmsg = "{p}you cannot combine the directory() option with an absolute path{p_end}"
			errprintf(errmsg)
			exit(198)
		}
		dest = pathresolve(dir, dest)
	}
	
	if(pathsuffix(dest)=="") {
		dest = dest + ".do"
	}
	
	st_local("anything",dest)
}

void boilerplate::parse_dest(string scalar dest)
{
	torepl.fn = pathbasename(dest)
	torepl.stub = pathrmsuffix(torepl.fn)
	torepl.abbrev = remove_usuffix(torepl.stub)
	if (!pathisabs(dest)) {
		dest = pathresolve(pwd(),dest)
	}
	torepl.basedir = mppathgetparent(dest)
}

string scalar boilerplate::remove_usuffix(string scalar stub)
{
  	transmorphic scalar t
    string scalar reverse, garbage, result
    
    reverse = strreverse(stub)
	t = tokeninit("", "_")
	tokenset(t,reverse)
    garbage = tokenget(t) 
    garbage = tokenget(t) 
    result = strreverse(tokenrest(t))
    if (result == "") {
        result = stub
    }
    return(result)
}

void boilerplate::parse_bline(string scalar line, real scalar dh)
{
    
    transmorphic scalar t
    string scalar first
    string rowvector asof
    real scalar minversion, tocopy
    
    line = usubinstr(line, "<stata_version>", strofreal(st_numscalar("c(stata_version)")), .)
    line = usubinstr(line, "<date>"         , st_global("c(current_date)")               , .)
	line = usubinstr(line, "<fn>"           , torepl.fn                                  , .)
	line = usubinstr(line, "<stub>"         , torepl.stub                                , .)
	line = usubinstr(line, "<basedir>"      , torepl.basedir                             , .)
	line = usubinstr(line, "<abbrev>"       , torepl.abbrev                              , .)
    
    tocopy = 1
    t = tokeninit(" ", "", "<>")
    tokenset(t, line)
    first = tokenget(t)
    if (strmatch(first, "<as of *>")) {
        asof = tokens(first)
        asof = asof[3]
        asof = usubinstr(asof, ">", "",.)
        minversion = strtoreal(asof)
        if (minversion == .) {
            errprintf("{p}Tried to parse <as of #>, and # is not a number{p_end}")
            exit(198)
        }
        if (st_numscalar("c(stata_version)")<minversion) {
            tocopy = 0
        }
        else {
            line = tokenrest(t)
        }
    }
    if (tocopy) mpfput(dh, line)
}

void boilerplate::copy_boiler(string scalar dest, | string scalar boiler)
{
	string scalar orig
	real scalar dh
	
    if (boiler == "") {
        read_defaults()
        boiler = defaults.boilerplate
    }

	orig = find_file(boiler, "boilerplate")

	parse_dest(dest)

	mpfread(orig)
    read_header("boilerplate")
	chkreqs()

	dh = mpfopen(dest, "w")
	
	if (lt(reading.fversion,(2,1,0))){
		parse_bbody2_0_4(dh)
	}
	else{
		parse_bbody(dh)
	}
}

void boilerplate::parse_bbody(real scalar dh)
{
	real scalar body
	string scalar line, EOF, first

	EOF = J(0,0,"")
	body = 0

	while ((line=mpfget())!=EOF) {
		reading.lnr = reading.lnr + 1
		if (line != "") {
			first = tokens(line)[1]
		}
		else {
			first = ""
		}
		if (first == "</body>") {
			if (body == 0) {
				where_err()
				errprintf("Tried to close a body when none was open")
				exit(198)
			}
			body = 0
			break
		}
		if (body == 1) parse_bline(line, dh)
		if (first == "<body>") {
			if (body == 1) {
				where_err()
				errprintf("{p}Tried to open a body when one was already open{p_end}")
				exit(198)
			}
			body = 1
		}
	}
	mpfclose(reading.fh)
	mpfclose(dh)
	if (body == 1) {
		errprintf("{p}A body was open but never closed{p_end}")
		exit(198)
	}
}

void boilerplate::parse_bbody2_0_4(real scalar dh)
{
	string scalar line, EOF
	
	EOF = J(0,0,"")
	while ((line=mpfget())!=EOF) {
		parse_bline(line, dh)
	}

	mpfclose(reading.fh)
	mpfclose(dh)

}


end
