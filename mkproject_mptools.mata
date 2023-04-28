mata:
mata set matastrict on

void mptools::write_header(real scalar fh)
{
	mpfput(fh, "<header>")
	mpfput(fh, "<mkproject> " + header_type)
	mpfput(fh, "<version> " + invtokens(strofreal(header_version), "."))
	mpfput(fh, "<label> " + header_label)
	mpfput(fh, "</header>")
}

void mptools::read_header(real scalar fh, string scalar fn, string scalar what, | string scalar relax)
{
    real scalar header, lnr
    string scalar line, EOF, errmsg, first, second
    transmorphic scalar t
    
    EOF = J(0,0,"")
    t = tokeninit(" ", "", "<>")
    header = 0
    lnr = 0
    
    while ((line=mpfget(fh, fn , ++lnr))!= EOF) {
        tokenset(t,line)
        first = tokenget(t)
        if (first == "<header>") {
            if (header == 1) {
                where_err(fn,lnr)
                errprintf("{p}A header is started when one was already open; not a valide mkproject " + what + " file {p_end}")
                mpfclose(fh)
                exit(198)
            }
            header = 1
        }
        else if (first == "</header>") {
            if (header == 0) {
                where_err(fn,lnr)
                errprintf("{p}A header was closed when none was open; not a valide mkproject " + what + " file {p_end}")
                mpfclose(fh)
                exit(198)
            }
            return
        }
        else if (header) {
            second = ustrtrim(tokenrest(t))
            parse_header(first, second, what, fn, lnr)
        }
    }
    mpfclose(fh)
    if (header == 1) {
        where_err(fn)
        errprintf("{p}Started a header but never closed it{p_end}")
        exit(198)
    }
    if (header == 0 & args() == 3) {
        where_err(fn)
        errprintf("{p}No header found; Not a valid mkproject "+ what + " file{p_end}")
        exit(198)
    }
    if (args()==4) {
        header_version = current_version
        header_type = what
    }
}

void mptools::parse_header(string scalar first, string scalar second, string scalar what, string scalar fn, real scalar lnr)
{
    string scalar errmsg
    
    if (first == "<mkproject>") {
        if (second != what) {
            where_err(fn, lnr)
            errmsg = "{p}Expected to find a mkproject file of type " + what + 
                     " but found a mkproject file of type " + second + "{p_end}"
            errprintf(errmsg)
            exit(198)
        }
        header_type = second
    }
    if (first == "<version>") {
        header_version(second, fn, lnr)
    }
    if (first == "<label>") {
        header_label = second
    }
}

string scalar mptools::find_file(string scalar what, string scalar extension)
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
            errprintf("{p}{err}"+ thing + " " +  what + " cannot be found{p_end}")
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
	abbrev
	errcode = _mkdir(abbrev)
	if (errcode != 0) {
		errprintf("{p}{err}unable to create directory " + pathjoin(pwd(),abbrev) + "{p_end}")
		exit(errcode)
	}
	chdir(abbrev)
}

void mptools::new() 
{
    odir = pwd()
}
end