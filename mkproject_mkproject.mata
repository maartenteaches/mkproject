mata:

void mkproject::run(){
    
    dir = st_local("dir")
    abbrev = st_local("abbrev")
    stencil  = st_local("stencil")
    
	parse_dir()
	read_stencil()
	mk_dirs()
	mk_files()
	do_cmds()
}

void mkproject::parse_dir()
{
	real scalar errcode
	string scalar ddir
	
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
	
	errcode = _mkdir(abbrev)
	if (errcode != 0) {
		errprintf("{p}{err}unable to create directory " + pathjoin(pwd(),abbrev) + "{p_end}")
		exit(errcode)
	}
	chdir(abbrev)
}

void mkproject::parse_sline(string scalar line)
{
	string       scalar first, boiler
	transmorphic scalar t

	t = tokeninit(" ", "", "<>")
	tokenset(t, line)
	first = tokenget(t)

	if (first == "<dir>" ) {
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
	else if (first == "<cmd>" ){
		line = tokenrest(t)
		line = usubinstr(line, "<abbrev>", abbrev,.)
		cmds = cmds \ line
	}
}


void mkproject::read_stencil()
{
	string       scalar EOF, fn, line
    
    if (stencil == "") {
        read_defaults()
        stencil = defaults.stencil
    }
	
	EOF = J(0,0,"")
	
	fn = find_file(stencil)
	
	mpfread(fn)
	read_header("stencil")
	while ((line=mpfget())!=EOF) {
		parse_tline(line)
	}
	mpfclose(reading.fh)
}

void mkproject::read_dir(string scalar newdir)
{
	transmorphic scalar t
	string scalar token, past
	
	if (pathisabs(newdir)) {
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

void mkproject::mk_dirs()
{
	real scalar i
	
	for(i=1; i<=rows(dirs);i++){
		mkdir(dirs[i])
	}
}

void mkproject::new()
{
    files = J(0,2,"")
}

end