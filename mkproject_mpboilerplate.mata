mata:
void boilerplate::parse_dest(string scalar dest)
{
	torepl.fn = pathbasename(dest)
	torepl.stub = pathrmsuffix(torepl.fn)
	torepl.abbrev = remove_usuffix(torepl.stub)
	if (!pathisabs(dest)) {
		dest = pathresolve(pwd(),dest)
	}
	torepl.basedir = pathgetparent(dest)
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
	string scalar orig, EOF, line
	real scalar dh
	
    if (boiler == "") {
        read_defaults()
        boiler = defaults.boilerplate
    }
    	
	EOF = J(0,0,"")
	
	orig = find_file(boiler)

	parse_dest(dest)
	
	mpfread(orig)
    read_header("boilerplate")
	dh = mpfopen(dest, "w")
	
	while ((line=mpfget())!=EOF) {
        parse_bline(line, dh)
	}
	mpfclose(reading.fh)
	mpfclose(dh)

}

end