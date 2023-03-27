mata:
mata clear
mata set matastrict on

struct repl 
{
	string scalar abbrev
	string scalar fn
	string scalar basedir
	string scalar stub
}

class mkproject 
{
	class AssociativeArray scalar    fhs
	
	string                 colvector dirs
	string                 matrix    files
	string                 colvector cmds
	string                 scalar    odir
	string                 scalar    ddir
	
	void                             parse_dir()
	
	void                             read_template()
	void                             read_dir()
	void                             mk_dirs()
	void                             mk_files()
	void                             do_cmds()
	
	void                             copy_boiler()
	struct repl            scalar    parse_dest()
	string                 scalar    parse_line()
	
	real                   scalar    mpfopen()
	void                             mpfput()
	string                 scalar    mpfget()  
	void                             mpfclose()
	void                             mpferror()
	void                             mpfclose_all()
	
	void                             new()
	void                             run()
	void                             graceful_exit()
}	

void mkproject::run(){
	parse_dir()
	read_template()
	mk_dirs()
	mk_files()
	do_cmds()
}

void mkproject::mk_files(){
	real scalar i
	
	for(i=1; i<=rows(files); i++) {
		copy_boiler(files[i,1], files[i,2])
	}
}

void mkproject::do_cmds(){
	real scalar i
	
	for(i=1; i<=rows(cmds); i++){
		stata(cmds[i])
	}
}

void mkproject::graceful_exit() 
{
	mpfclose_all()
	chdir(odir)
}

void mkproject::parse_dir()
{
	string scalar dir, abbrev
	real scalar errcode
	
	dir = st_local("dir")
	if (dir == "") {
		ddir = pwd()
	}
	else {
		ddir = dir
	}
	odir = pwd()
	
	errcode = _chdir(ddir)
	if (errcode != 0) {
		errprintf("{p}{err}unable to change to directory " + ddir + "{p_end}")
		exit(errcode)
	}
	abbrev = st_local("abbrev")
	errcode = _mkdir(abbrev)
	if (errcode != 0) {
		errprintf("{p}{err}unable to create directory " + pathjoin(pwd(),abbrev) + "{p_end}")
		exit(errcode)
	}
	chdir(abbrev)
}

void mkproject::read_template()
{
	string       scalar abbrev, templ, EOF, templfile, line, first, boiler
	real         scalar fh
	transmorphic scalar t
	
	templ  = st_local("template")
	abbrev = st_local("abbrev")
	
	EOF = J(0,0,"")
	
	templfile = pathjoin(pathsubsysdir("PLUS"), "m\mp_" + templ + ".txt")
	if( !fileexists(templfile)) {
		errprintf("{p}{err}template " + templ +  " does not exist{p_end}")
		exit(601)
	}
	
	fh = mpfopen(templfile, "r")
	
	t = tokeninit(" ")
	while ((line=mpfget(fh))!=EOF) {
		tokenset(t, line)
		first = tokenget(t)
		if (first == "<dir>") {
			line = tokenrest(t)
			line = usubinstr(line, "<abbrev>", abbrev,.)
			read_dir(line)
		}
		else if (first == "<file>") {
			boiler = tokenget(t)
			line = tokenrest(t)
			line = usubinstr(line, "<abbrev>", abbrev,.)
			files = files \ (boiler, line)
		} 
		else if (first == "<cmd>"){
			line = tokenrest(t)
			line = usubinstr(line, "<abbrev>", abbrev,.)
			cmds = cmds \ line
		}
	}
	mpfclose(fh)
}

void mkproject::new() {
	fhs.reinit("real")
	files = J(0,2,"")
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


struct repl scalar mkproject::parse_dest(string scalar dest)
{
	struct repl scalar res
	transmorphic scalar t
	
	res.fn = pathbasename(dest)
	res.stub = pathrmsuffix(res.fn)
	t = tokeninit("_")
	tokenset(t,res.stub)
	res.abbrev = tokenget(t)
	if (!pathisabs(dest)) {
		dest = pathresolve(pwd(),dest)
	}
	res.basedir = pathgetparent(dest)
	return(res)
}

string scalar mkproject::parse_line(string scalar line, struct repl torepl)
{
	line = usubinstr(line, "<fn>"     , torepl.fn     , .)
	line = usubinstr(line, "<stub>"   , torepl.stub   , .)
	line = usubinstr(line, "<basedir>", torepl.basedir, .)
	line = usubinstr(line, "<abbrev>" , torepl.abbrev , .)
	return(line)
}

void mkproject::copy_boiler(string scalar boiler, string scalar dest)
{
	string scalar orig, EOF, line
	struct repl scalar torepl
	real scalar oh, dh
	
	
	EOF = J(0,0,"")
	
	orig = pathjoin(pathsubsysdir("PLUS"), "m\mp_" + boiler + ".do")
	if( !fileexists(orig)) {
		errprintf("{p}{err}boilerplate " + boiler +  " does not exist{p_end}")
		exit(601)
	}

	torepl = parse_dest(dest)
	
	oh = mpfopen(orig, "r")
	dh = mpfopen(dest, "w")
	
	while ((line=mpfget(oh))!=EOF) {
		line = parse_line(line,torepl)
		mpfput(dh, line)
	}
	mpfclose(oh)
	mpfclose(dh)
}
	
void mkproject::read_dir(string scalar dir)
{
	transmorphic scalar t
	string scalar token, past
	
	if (pathisabs(dir)) {
		errprintf("{p}{err}Directories in template should not be absolute{p_end}")
		exit(198)
	}
	
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