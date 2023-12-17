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
	string       scalar EOF, fn, line
    
    if (project == "") {
        read_defaults()
        project = defaults.project
    }
	
	EOF = J(0,0,"")
	
	fn = find_file(project, "project")
	
	mpfread(fn)
	read_header("project")
	chkreqs()
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
	ppos = 0
}

void mkproject::read_profile()
{	
	real scalar l, i, fh
	
	profile_path = findfile("profile.do")
	if (profile_path != "") {
		l = nlines(profile_path)
		prcontent = J(l,1,"")
		fh = mpfopen(profile_path,"r")
		for(i=1; i<=l; i++) {
			prcontent[i] = fget(fh)
		}
		mpfclose(fh)
	}
}

void mkproject::modify_profile(string scalar fkey)
{
	real scalar l, i
	
	l = rows(prcontent)
	for(i=1;i<=l;i++){
		prcontent[i] = parse_pline(prcontent[i],fkey,i)
	}
}

string colvector mkproject::pr2insert(string scalar fkey)
{
	"noi di as txt " + fkey + " as result " ABM talk" 
	global F4 cd "C:\Mijn documenten\projecten\stata\abm\sug\london\abm_buis\presentation"; 

}

string scalar mkproject::parse_pline(string scalar line, string scalar fkey, real scalar i)
{
	string rowvector parts
	
	parts = tokens(line)
	if (cols(parts) >  5) {
		if ( usubstr(parts[1],1,3) == "noi" &
			 usubstr(parts[2],1,2) == "di" &
			 parts[3] == "as" &
			 parts[4] == "txt" & 
			 parts[5] == fkey) {
 				ppos = max(ppos,i)
			 	return("//[modified by mkproject] " + line )
			 }
	}
	if (cols(parts) >= 3){
		if ( parts[1] == "global" & 
		     parts[2] == fkey) {
			 	ppos = max(ppos,i)
				return("//[modified by mkproject] " + line)
			 }
	}
	return(line)
}

end
