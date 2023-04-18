/*
boilerplate
boilerplate, create
boilerplate, default
mkproject
mkproject, create
mkproject, default
*/

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
    real                   rowvector current_version
	real                   scalar    ignore
	
	void                             parse_dir()
	
    string                 colvector read_header() 
	void                             read_template()
    string                 scalar    find_file()
	void                             parse_tline()    
	void                             read_dir()
	void                             mk_dirs()
	void                             mk_files()
	void                             do_cmds()
	
	void                             copy_boiler()
	struct repl            scalar    parse_dest()
    real                   scalar    parse_bheader()
	void                             parse_bline()
	
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
    void                             read_default()
    string                 colvector read_defaults()
    void                             write_default()
    
    void                             create()
    string                 scalar    newname()
     
}	

string scalar mkproject::newname(string scalar what)
{
    string scalar path

    path = st_local("create")
    path = pathrmsuffix(pathbasename(path)) + (what == "template" ? ".txt" : ".do")
    path = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_" + path)
    
    if (st_local("replace") == "" & fileexists(path)) {
        errprintf(what + " " + pathrmsuffix(pathbasename(st_local("create"))) + " already exists" )
        exit(198)
    }
    else {
        unlink(path)
    }
    return(path)
}   

string colvector mkproject::read_header(real scalar fh, string scalar what)
{
    real scalar header
    string scalar line, EOF, errmsg, first, second
    string colvector result
    transmorphic scalar t
    
    EOF = J(0,0,"")
    t = tokeninit(" ", "", "<>")
    result = J(3,1,"")
    header = 0
    
    while ((line=mpfget(fh))!= EOF) {
        tokenset(t,line)
        first = tokenget(t)
        if (first == "<header>") {
            if (header == 1) {
                errprintf("{p}A header is started when one was already open{p_end}")
                exit(198)
            }
            header = 1
        }
        else if (first == "</header>") {
            if (header == 0) {
                errprintf("{p}A header was closed when none was open{p_end}")
                exit(198)
            }
            break
        }
        else if (header) {
            if (first == "<mkproject") {
                if ((second=tokenget(t)) != what) {
                    errmsg = "{p}Expected to find a mkproject file of type " + what + 
                             " but found a mkproject file of type " + second + "{p_end}"
                    errprintf(errmsg)
                    exit(198)
                }
                result[1] = second
            }
            if (first == "<version>") {
                second = tokenget(t)
                parse_version(second)
                result[2] = second
            }
            if (first == "<label>") {
                second = tokenrest(t)
                result[3] = second
            }
        }
    }
    return(result)
}

void mkproject::create(string scalar what)
{
    string scalar fn_in, fn_out, EOF, line, first, second, garbage
    real scalar fh_in, fh_out, ignore
    transmorphic scalar t
    
    fn_in = st_local("create")
    fn_out = newname(what)
    EOF = J(0,0,"")
    ignore = 1
    t = tokeninit(" ", "", "<>")
    
    fh_in = mpfopen(fn_in, "r")
    fh_out = mpfopen(fn_out, "w")
        
    while((line=mpfget(fh_in))!=EOF) {
        tokenset(t,line)
        first = tokenget(t)
        if (first == "<mkproject " + what + ">") {
            ignore = 0
            mpfput(fh_out, line)
            
            line=mpfget(fh_in)
            tokenset(t, line)
            first = tokenget(t)
            if (!strmatch(first, "<version *>")) {
                mpfput(fh_out, "<version " + invtokens(strofreal(current_version), ".")+">")
            }
            else {
                parse_version(line)
            }
            
            line = mpfget(fh_in)
            tokenset(t, line)
            first = tokenget(t)
            if (first != "<label>") {
                mpfput(fh_out, "<label>")
                if (first == "<file>") {
                    second = tokenget(t)
                    garbage = find_file(second, ".do")
                }
                mpfput(fh_out, line)
            }
        }
        else if (first == "<file>" & !ignore) {
            second = tokenget(t)
            garbage = find_file(second, ".do")
        }
        
        if (!ignore) {
            mpfput(fh_out, line)
        }
    }
    mpfclose(fh_in)
    mpfclose(fh_out)
    if (ignore) {
        
    }
}
void mkproject::parse_version(string scalar ver)
{
	string rowvector verspl

  	verspl = tokens(verspl, ".")
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
    string scalar path , thing
    
    path = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_" + what + extension)
    if (!fileexists(path)) {
        path = pathjoin(pathsubsysdir("PLUS"), "m/mp_" + what + extension) 
        if (!fileexists(path)) {
            if (what == "defaults") {
                thing = ""
            }
            else if (extension == ".txt") {
                thing = "template "
            }
            else if (extension == ".do") {
                thing = "boilerplate"
            }
            errprintf("{p}{err}"+ thing + what + " cannot be found{p_end}")
            exit(601)
        }
    }
    return(path)
}

string colvector mkproject::read_defaults(string scalar what, string scalar val)
{
    string scalar path, line, EOF, first, fn
    string colvector res
    real scalar ignore, fh
    transmorphic scalar t
    
    what = "<"+what+">"
    res = J(0,1,"")
    fn = find_file("defaults", ".txt")
    ignore = 1
    EOF = J(0,0,"")
    t = tokeninit(" ", "", "<>")
    fh = mpfopen(fn, "r")
    
    while( (line=mpfget(fh)) != EOF) {
        tokenset(t,line)
        first = tokenget()
        if (first == "<mkproject defaults>") {
            ignore = 0
        }
       	else if (strmatch(first, "<version *>") & !ignore) {
            parse_version(first)
        }
        else if (first == what) {
            res = res \ (what + " " + val)
        }
        else {
            res = res\line
        }
    }
    if (ignore) {
        errprintf("{p}not a valid mkproject defaults file{p_end}")
        exit(198)
    }
    mpfclose(fh)
    return(res)
}

void mkproject::write_default(string scalar what, string scalar val)
{
    string scalar path, garbage
    string matrix newdefs
    real scalar fh, i
    
    garbage = find_file(what, (what=="template"?".txt":".do"))
    newdefs = read_defaults(what,val)
    
    path = pathjoin(pathsubsysdir("PERSONAL"), "/m")
    if (!direxists(path)) {
        mkdir(path)
    }
    path = pathjoin(path, "mp_defaults.txt")
    unlink(path)
    
    fh = mpfopen(path, "w")
    mpfput(fh, "<makeproject defaults>")
    mpfput(fh, "<version " + invtokens(strofreal(current_version, ".")) + ">")
    for(i=1; i<= rows(newdefs); i++) {
        mpfput(fh, newdefs[i])
    }
    mpfclose(fh)
}

void mkproject::read_default(string scalar what)
{
    string scalar EOF, first, line, fn
    real scalar fh, ignore
    transmorphic scalar t
  
    fn = find_file("defaults", ".txt")
    what = "<" + what + ">"
    ignore = 1
    EOF = J(0,0,"")
    fh = mpfopen(fn, "r")
    t = tokeninit(" ", "", "<>")
    while( (line=mpfget(fh)) != EOF) {
        tokenset(t,line)
        first = tokenget()
        if (first == "<mkproject defaults>") {
            ignore = 0
        }
       	else if (strmatch(first, "<version *>") & !ignore) {
            parse_version(first)
        }
        else if (first == what & !ignore) {
            st_local("default", tokenrest(t))
        }
    }
    if (ignore) {
        errprintf("{p}not a valid mkproject defaults file{p_end}")
        exit(198)
    }
    mpfclose(fh)
}

void mkproject::parse_tline(string scalar line)
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
	else if (strmatch(first, "<version *>") & !ignore) {
		parse_version(first)
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
    current_version = (2,0,0)
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

real scalar mkproject::parse_bheader(string scalar line) {
    transmorphic scalar t
    string scalar first
    real scalar header
    
    t = tokeninit(" ", "", "<>")
    tokenset(t, line)
    first = tokenget(t)
    header = 0
    if (first == "<mkproject boilerplate>") {
        header = 1
        ignore = 0
    }
    if (strmatch(first, "<version *>")) {
        parse_version(first)
        header = 1
    }
    return(header)
}

void mkproject::parse_bline(string scalar line, struct repl torepl, real scalar dh)
{
    
    transmorphic scalar t
    string scalar first
    string rowvector asof
    real scalar minversion, tocopy
    
    line = usubinstr(line, "<stata_version>", st_numscalar("c(stata_version)"), .)
    line = usubinstr(line, "<date>"         , st_global("c(current_date)")    , .)
	line = usubinstr(line, "<fn>"           , torepl.fn                       , .)
	line = usubinstr(line, "<stub>"         , torepl.stub                     , .)
	line = usubinstr(line, "<basedir>"      , torepl.basedir                  , .)
	line = usubinstr(line, "<abbrev>"       , torepl.abbrev                   , .)
    
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

void mkproject::copy_boiler(string scalar boiler, string scalar dest)
{
	string scalar orig, EOF, line
	struct repl scalar torepl
	real scalar oh, dh, header
	
	
	EOF = J(0,0,"")
	
	orig = find_file(boiler, ".do")

	torepl = parse_dest(dest)
	
	oh = mpfopen(orig, "r")
	dh = mpfopen(dest, "w")
	
    ignore = 1
	while ((line=mpfget(oh))!=EOF) {
        header = parse_bheader(line)
		if (!ignore & !header) {
            parse_bline(line,torepl, dh)
        }
	}
	mpfclose(oh)
	mpfclose(dh)
    if (ignore == 1) {
		errprintf("{p}"+ boiler + " is not valid mkproject boilerplate file{p_end}")
		exit(198)
	}
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