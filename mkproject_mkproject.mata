mata:

void mkproject::run(){
    
    dir     = st_local("directory")
    abbrev  = st_local("anything")
    project = st_local("template1")

	parse_dir()
	read_project()
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


void mkproject::read_project()
{
	string scalar fn
    
    if (project == "") {
        read_defaults()
        project = defaults.project
    }
	
	fn = find_file(project, "project")
	
	mpfread(fn)
	read_header("project")
	chkreqs()
	if (lt(reading.fversion,(2,1,0))) {
		parse_pbody2_0_4()
	}
	else {
		parse_pbody()
	}
	
	mpfclose(reading.fh)
}

void mkproject::parse_pbody()
{
	string scalar line, first, EOF
	real scalar body

	EOF = J(0,0,"")
	body = 0
	
	while ((line=mpfget())!=EOF) {
		reading.lnr = reading.lnr +1
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
		if (body == 1) parse_sline(line)
		if (first == "<body>") {
			if (body == 1) {
				where_err()
				errprintf("{p}Tried to open a body when one was already open{p_end}")
				exit(198)
			}
			body = 1
		}
	}
	if (body == 1) {
		errprintf("{p}Body was not closed{p_end}")
		exit(198)
	}
}

void mkproject::parse_pbody2_0_4() {
	string scalar line, EOF
	
	EOF = J(0,0,"")
	
	while ((line=mpfget())!=EOF) {
		parse_sline(line)
	}
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
	ppos = 0
}
end
