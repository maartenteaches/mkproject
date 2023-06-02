mata:
mata set matastrict on

void mptools::write_header(real scalar fh )
{
	mpfput(fh, "<header>")
	mpfput(fh, "<mkproject> " + reading.type)
	mpfput(fh, "<version> " + invtokens(strofreal(reading.fversion), "."))
	mpfput(fh, "<label> " + reading.label)
	mpfput(fh, "</header>")
}

void mptools::header_ok(string scalar what, string scalar type) 
{
    string scalar fn 
    
    fn = find_file(what)
    mpfread(fn)
    read_header(type)
    mpfclose(reading.fh)
    
}

void mptools::collect_header_info()
{
    real scalar header
    string scalar line, EOF, first, second
    transmorphic scalar t
    
    EOF = J(0,0,"")
    t = tokeninit(" ", "", "<>")
    header = 0
    
    while ((line=mpfget())!= EOF) {
        reading.lnr = reading.lnr + 1
        tokenset(t,line)
        first = tokenget(t)
        if (first == "<header>") {
            if (header == 1) {
                where_err()
                errprintf("{p}A header is started when one was already open; not a valide mkproject file {p_end}")
                mpfclose(reading.fh)
                exit(198)
            }
            header = 1
        }
        else if (first == "</header>") {
            if (header == 0) {
                where_err()
                errprintf("{p}A header was closed when none was open; not a valide mkproject file {p_end}")
                mpfclose(reading.fh)
                exit(198)
            }
            return
        }
        else if (header) {
            second = ustrtrim(tokenrest(t))
            parse_header(first, second)
        }
    }
    mpfclose(reading.fh)
    if (header == 1) {
        where_err()
        errprintf("{p}Started a header but never closed it{p_end}")
        exit(198)
    }
}

void mptools::read_header(| string scalar what)
{
   collect_header_info()
   if (args()==1) {
       chk_header(what)
   }
}

void mptools::chk_header(string scalar what)
{
    string scalar errmsg
    if (reading.type != what) {
        errmsg = "{p}Expected to find a mkproject file of type " + what + 
                 " but found a mkproject file of type " + reading.type + "{p_end}"
        errprintf(errmsg)
        exit(198)
    }
    header_version(reading.sversion)
}

void mptools::parse_header(string scalar first, string scalar second)
{
    if (first == "<mkproject>") {
        reading.type = second
    }
    if (first == "<version>") {
        reading.sversion = second
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