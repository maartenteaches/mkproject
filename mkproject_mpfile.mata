mata:
mata set matastrict on

void mpfile::mpferror(real scalar errcode)
{
	errprintf("%s\n", ferrortext(errcode))
	exit(freturncode(errcode))
}

real scalar mpfile::mpfopen(string scalar fn, string scalar mode)
{
	real scalar fh
	
	fh = _fopen(fn, mode)
	if (fh < 0 ) {
		mpferror(fh)
	}
	fhs.put(fh,"open")
	return(fh)
}

void mpfile::mpfread(string scalar fn)
{
    if (reading.open == 1) {
		errprintf("{p}trying to read " + fn + " while " + reading.fn + " is still open{p_end}")
		exit(198)
	}
	reading.fn = fn
    reading.fh = mpfopen(fn, "r")
    reading.lnr = 0
    reading.label = ""
    reading.fversion = J(1,3,.)
    reading.sversion = ""
    reading.type = ""
	reading.open = 1
    reading.reqs = J(0,1,"")
}

void mpfile::mpfclose(real scalar fh)
{
	real scalar errcode
	errcode = _fclose(fh)
	if (errcode < 0 ) {
		mpferror(errcode)
	}
	if (fh == reading.fh) reading.open = 0
	fhs.put(fh,"closed")
}

void mpfile::mpfput(real scalar fh, string scalar s)
{
	real scalar errcode
	errcode = _fput(fh, s)
	if (errcode < 0 ) {
		mpferror(errcode)
	}
}

string matrix mpfile::mpfget()
{
	real   scalar errcode
	string scalar result
	
	result = _fget(reading.fh)
	errcode = fstatus(reading.fh)
	if (errcode < -1 ) {
        where_err()
		mpferror(errcode)
	}
	return(result)
}

void mpfile::new()
{
	fhs.reinit("real")	
}

void mpfile::mpfclose_all()
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
end