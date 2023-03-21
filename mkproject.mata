mata:
mata clear

class mkproject 
{
	string colvector dirs
	void             read_dir()
	void             mk_dirs()
	void             copy_boiler()
	real   scalar    mpfopen()
	void             mpfput()
	void             mpfclose()
}	

void mkproject::copy_boiler(string scalar boiler, string scalar dest)
{
	string scalar orig, EOF
	real scalar oh, dh
	
	EOF = J(0,0,"")
	
	orig = pathjoin(pathsubsysdir("PLUS"), "m\mp_" + boiler + ".do")
	if( !fileexists(orig)) {
		printf("{p}{err}boilerplate " + boiler +  " does not exist{p_end}")
		exit(601)
	}
	
	oh = fopen(orig, "r")
	dh = fopen(dest, "w")
	
	while ((line=fget(oh))!=EOF) {
		fput(dh, line)
    }
	fclose(oh)
	fclose(dh)
}

real scalar mkproject::
	
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