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
	real                   rowvector mp_version
	real                   scalar    ignore
	
	void                             parse_dir()
	
	void                             read_template()
    string                 scalar    find_file()
	string                 scalar    parse_tline()    
	void                             read_dir()
	void                             mk_dirs()
	void                             mk_files()
	void                             do_cmds()
	
	void                             copy_boiler()
	struct repl            scalar    parse_dest()
	string                 scalar    parse_bline()
	
	real                   scalar    mpfopen()
	void                             mpfput()
	string                 scalar    mpfget()  
	void                             mpfclose()
	void                             mpferror()
	void                             mpfclose_all()
	
	void                             new()
	void                             run()
	void                             graceful_exit()
	
	void                             parse_version()
}	

void mkproject::parse_version(string scalar ver)
{
	string rowvector verspl

	verspl = tokens(ver, ".")
	if (cols(verspl)!= 5){
		errprintf("{p}A version has the form #.#.#{p_end}")
		exit(198)
	}
	mp_version = strtoreal(verspl[(1,3,5)])
	if (anyof(mp_version, .)){
		errprintf("{p}A version has the form #.#.#{p_end}")
		exit(198)
	}
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

string scalar mkproject::find_file(string scalar what, string scalar extension)
{
    string scalar path 
    
    path = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_" + what + extension)
    if (!fileexists(path)) {
        path = pathjoin(pathsubsysdir("PLUS"), "m/mp_" + what + extension) 
        if (!fileexists(path)) {
            errprintf("{p}{err}"+ (extension == ".txt" ? "template ": "boilerplate ") + what +  " cannot be found{p_end}")
            exit(601)
        }
    }
    return(path)
}

string scalar mkproject::parse_tline(string scalar line)
{
	string       scalar first, boiler, abbrev
	transmorphic scalar t

	abbrev = st_local("abbrev")
	
	t = tokeninit(" ", "", "<>")
	tokenset(t, line)
	first = tokenget(t)

	if (first == "<mkproject template>") {
		ignore = 0
	}
	else if (first == "<version>" & !ignore) {
		parse_version(tokenrest(t))
	}
	else if (first == "<dir>" & !ignore) {
		line = tokenrest(t)
		line = usubinstr(line, "<abbrev>", abbrev,.)
		read_dir(line)
	}
	else if (first == "<file>" & !ignore) {
		boiler = tokenget(t)
		line = tokenrest(t)
		line = usubinstr(line, "<abbrev>", abbrev,.)
		files = files \ (boiler, line)
	} 
	else if (first == "<cmd>" & !ignore){
		line = tokenrest(t)
		line = usubinstr(line, "<abbrev>", abbrev,.)
		cmds = cmds \ line
	}
}

void mkproject::read_template()
{
	string       scalar templ, EOF, templfile, line
	real         scalar fh
	
	templ  = st_local("template")
		
	EOF = J(0,0,"")
	
	templfile = find_file(templ, ".txt")
	
	fh = mpfopen(templfile, "r")
	
	ignore = 1
	
	while ((line=mpfget(fh))!=EOF) {
		parse_tline(line)
	}
	mpfclose(fh)
	if (ignore == 1) {
		errprintf("{p}"+ templ + " is not valid mkproject template file{p_end}")
		exit(198)
	}
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

string scalar mkproject::parse_bline(string scalar line, struct repl torepl)
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
	
	orig = find_file(boiler, ".do")

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