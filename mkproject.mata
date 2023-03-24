mata:
mata clear
mata set matastrict on


class mkproject 
{
	class AssociativeArray scalar    fhs
	string                 colvector dirs
	void                             read_dir()
	void                             mk_dirs()
	void                             copy_boiler()
	real                   scalar    mpfopen()
	void                             mpfput()
	string                 scalar    mpfget()  
	void                             mpfclose()
	void                             mpferror()
	void                             mpfclose_all()
	void                             new()
}	

void mkproject::new() {
	fhs.reinit("real")
}

void mkproject::mpfclose_all()
{
	real colvector K
	real scalar i, fh
	
	K = fhs.keys()
	for (i=1; i<=rows(K); i++) {
		fh = K[i]
		if (fhs.get(fh)!="closed") {
			mpfclose(fh)
		}
	}
	
}

void mkproject::mpferror(real scalar errcode)
{
	errprintf("%s\n", ferrortext(errcode))
    exit(freturncode(errcode))
}

real scalar mkproject::mpfopen(string scalar fn, string scalar mode)
{
	real scalar fh
	
	fh = _fopen(fn, mode)
    if (fh < 0 ) {
		mpferror(fh)
    }
	fhs.put(fh,"open")
	return(fh)
}

void mkproject::mpfclose(real scalar fh)
{
	real scalar errcode
	errcode = _fclose(fh)
    if (errcode < 0 ) {
		mpferror(errcode)
    }
	fhs.put(fh,"closed")
}

void mkproject::mpfput(real scalar fh, string scalar s)
{
	real scalar errcode
	errcode = _fput(fh, s)
    if (errcode < 0 ) {
		mpferror(errcode)
    }
}

string scalar mkproject::mpfget(real scalar fh)
{
	real   scalar errcode
	string scalar result
	
	result = _fget(fh)
    errcode = fstatus(fh)
	if (errcode < 0 ) {
		mpferror(errcode)
    }
	return(result)
}


void mkproject::copy_boiler(string scalar boiler, string scalar dest)
{
	string scalar orig, EOF, fn, stub, line
	real scalar oh, dh
	
	EOF = J(0,0,"")
	
	orig = pathjoin(pathsubsysdir("PLUS"), "m\mp_" + boiler + ".do")
	if( !fileexists(orig)) {
		errprintf("{p}{err}boilerplate " + boiler +  " does not exist{p_end}")
		exit(601)
	}

	fn = pathbasename(dest)
	stub = pathrmsuffix(fn)
	
	
	oh = mpfopen(orig, "r")
	dh = mpfopen(dest, "w")
	
	while ((line=mpfget(oh))!=EOF) {
		line = usubinstr(line, "<fn>", fn,.)
		line = usubinstr(line, "<stub>", stub,.)
		mpfput(dh, line)
    }
	mpfclose(oh)
	mpfclose(dh)
}
	
void mkproject::read_dir(string scalar dir)
{
	transmorphic scalar t
	string scalar token, past
	
	t = tokeninit("/\")
	tokenset(t,dir)
	
	past = ""
	while ( (token = tokenget(t)) != "") {
		past = past + token + "\"
		if (!anyof(dirs, past)) {
			dirs = dirs \ past
		}
    }
}

void mkproject::mk_dirs()
{
	real scalar i
	
	for(i=1; i<=rows(dirs);i++){
		mkdir(dirs[i])
	}
}


end