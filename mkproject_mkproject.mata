mata:

void mkproject::run(){
    
    dir     = st_local("directory")
    abbrev  = st_local("anything")
    stencil = st_local("type")

	parse_dir()
	read_stencil()
	mk_dirs()
	mk_files()
	do_cmds()
}

void mkproject::parse_dir()
{
	real scalar errcode
	
	if (dir == "") {
		dir = pwd()
	}
	odir = pwd()
	
	errcode = _chdir(dir)
	if (errcode != 0) {
		errprintf("{p}{err}unable to change to directory " + dir + "{p_end}")
		exit(errcode)
	}
	errcode = _mkdir(abbrev)
	if (errcode != 0) {
		errprintf("{p}{err}unable to create directory " + pathjoin(pwd(),abbrev) + "{p_end}")
		exit(errcode)
	}
	chdir(abbrev)
}

string scalar mkproject::getrest(transmorphic scalar t) 
{
	string scalar line
	line = tokenrest(t)
	line = usubinstr(line, "<abbrev>", abbrev,.)
	line = ustrltrim(line)
	return(line)
}
void mkproject::parse_sline(string scalar line)
{
	string       scalar first, boiler
	transmorphic scalar t

	t = tokeninit(" ", "", "<>")
	tokenset(t, line)
	first = tokenget(t)

	if (first == "<dir>" ) {
		line = getrest(t)
		read_dir(line)
	}
	else if (first == "<file>") {
		boiler = tokenget(t)
		line = getrest(t)
		files = files \ (boiler, line)
	} 
	else if (first == "<cmd>" ){
		line = getrest(t)
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
		parse_sline(line)
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
	tokenset(t,newdir)
	
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
		copy_boiler(files[i,2], files[i,1])
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