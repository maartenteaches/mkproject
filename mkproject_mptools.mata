mata:
mata set matastrict on

void mptools::write_header(real scalar fh)
{
	mpfput(fh, "<header>")
	mpfput(fh, "<mkproject> " + reading.type)
	mpfput(fh, "<version> " + invtokens(strofreal(reading.fversion), "."))
	mpfput(fh, "<label> " + reading.label)
	mpfput(fh, "</header>")
}

void mptools::read_header(string scalar what, | string scalar relax)
{
    real scalar header
    string scalar line, EOF, first, second
    transmorphic scalar t
        
    EOF = J(0,0,"")
    t = tokeninit(" ", "", "<>")
    header = 0
    
    while ((line=mpfget(reading.fh))!= EOF) {
        reading.lnr = reading.lnr + 1
        tokenset(t,line)
        first = tokenget(t)
        if (first == "<header>") {
            if (header == 1) {
                where_err()
                errprintf("{p}A header is started when one was already open; not a valide mkproject " + what + " file {p_end}")
                mpfclose(reading.fh)
                exit(198)
            }
            header = 1
        }
        else if (first == "</header>") {
            if (header == 0) {
                where_err()
                errprintf("{p}A header was closed when none was open; not a valide mkproject " + what + " file {p_end}")
                mpfclose(reading.fh)
                exit(198)
            }
            return
        }
        else if (header) {
            second = ustrtrim(tokenrest(t))
            parse_header(first, second, what)
        }
    }
    mpfclose(reading.fh)
    if (header == 1) {
        where_err()
        errprintf("{p}Started a header but never closed it{p_end}")
        exit(198)
    }
    if (header == 0 & args() == 1) {
        where_err()
        errprintf("{p}No header found; Not a valid mkproject "+ what + " file{p_end}")
        exit(198)
    }
    if (args()==2) {
        reading.fversion = current_version
        reading.type = what
    }
}

void mptools::parse_header(string scalar first, string scalar second, string scalar what)
{
    string scalar errmsg
    
    if (first == "<mkproject>") {
        if (second != what) {
            where_err()
            errmsg = "{p}Expected to find a mkproject file of type " + what + 
                     " but found a mkproject file of type " + second + "{p_end}"
            errprintf(errmsg)
            exit(198)
        }
        reading.type = second
    }
    if (first == "<version>") {
        header_version(second)
    }
    if (first == "<label>") {
        reading.label = second
    }
}

string scalar mptools::find_file(string scalar what)
{
    string scalar path 
    
    path = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_" + what + ".txt")
    if (!fileexists(path)) {
        path = pathjoin(pathsubsysdir("PLUS"), "m/mp_" + what + ".txt") 
        if (!fileexists(path)) {
            errprintf("{p}{err}"+  what + " cannot be found{p_end}")
            exit(601)
        }
    }
    return(path)
}

void mptools::parse_dir()
{
	string scalar dir, abbrev
	real scalar errcode
	
	dir = st_local("dir")
	if (dir == "") {
		dir = pwd()
	}
	odir = pwd()
	
	errcode = _chdir(dir)
	if (errcode != 0) {
		errprintf("{p}{err}unable to change to directory " + dir + "{p_end}")
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

void mptools::graceful_exit() 
{
	mpfclose_all()
	chdir(odir)
}

void mptools::new() 
{
    odir = pwd()
}
end