mata:
mata set matastrict on

void mptools::write_header(real scalar fh )
{
	real scalar i
	
	mpfput(fh, "<header>")
	mpfput(fh, "<mkproject> " + reading.type)
	mpfput(fh, "<version> " + invtokens(strofreal(reading.fversion), "."))
	mpfput(fh, "<label> " + reading.label)
	
	for (i = 1 ; i<=rows(reading.reqs); i++) {
		mpfput(fh, "<reqs> " + reading.reqs[i])
	}
	
	if (rows(reading.description) > 0) {
		mpfput(fh, "<description>")
	}
	for(i = 1 ; i<=rows(reading.description); i++ ) {
		mpfput(fh, reading.description[i])
	}
	if (rows(reading.description) > 0) {
		mpfput(fh, "</description>")
	}
	mpfput(fh, "</header>")
}

void mptools::header_ok(string scalar what, string scalar type) 
{
    string scalar fn 
    
    fn = find_file(what, type)
    mpfread(fn)
    read_header(type)
    mpfclose(reading.fh)
}

void mptools::collect_header_info()
{
    real scalar header, descopen
    string scalar line, EOF, first, second
    transmorphic scalar t
    
    EOF      = J(0,0,"")
    t        = tokeninit(" ", "", "<>")
    header   = 0
	descopen = 0
    
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
		else if (first == "<body>" & header == 1) {
			where_err()
			errprintf("{p}A body was started while a header was still open; not a valid mkproject file{p_end}")
			mpfclose(reading.fh)
			exit(198)
		}
        else if (header) {
            second = ustrtrim(tokenrest(t))
            parse_header(first, second, descopen)
        }
    }
    mpfclose(reading.fh)
    if (header == 1) {
        where_err()
        errprintf("{p}Started a header but never closed it{p_end}")
        exit(198)
    }
	if (descopen == 1) {
		where_err()
		errprintf("{p}Started a description but never closed it{p_end}")
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

void mptools::descopenerr(real scalar descopen) {
	if (descopen == 1) {
		where_err()
		errprintf("cannot enter other tags when a description is open")
		exit(198)
	}
}

void mptools::parse_header(string scalar first, string scalar second,  real scalar descopen )
{
    if (first == "<mkproject>") {
		descopenerr(descopen)
        reading.type = second
    }
    if (first == "<version>") {
        descopenerr(descopen)
		reading.sversion = second
    }
    if (first == "<label>") {
		descopenerr(descopen)
        reading.label = second
    }
	if (first == "<reqs>") {
		descopenerr(descopen)
		reading.reqs = reading.reqs \ second
	}
	if (first == "</description>") {
		if (descopen == 0) {
			where_err()
			errprintf("{p}Tried to close a description when none was open{p_end}")
			exit(198)
		}
		descopen = 0
	}
	if (descopen == 1) {
		reading.description = 
		    reading.description \ (first + " " + second)
	}
	if (first == "<description>") {
		if (descopen == 1) {
			where_err()
			errprintf("{p}Tried to open a description when one was already open{p_end}")
			exit(198)
		}
		descopen = 1
	}

}

real scalar mptools::_chkreq(string scalar req)
{
	string rowvector parts
	real scalar ok, totest

	ok = 1
	parts = tokens(req)

	if (parts[1] == "Stata") {
		if (cols(parts) !=2) {
			errprintf(`"{p}You specified a requirement as "<reqs> "' + req + `""{p_end}"')
			errprintf(`"{p}The correct form of such a requirement is "<reqs> Stata #", where # is a number{p_end}"')
			exit(198)			
		}
		totest = strtoreal(parts[2])
		if (totest == . ) {
			errprintf(`"{p}You specified a requirement as "<reqs> "' + req + `""{p_end}"')
			errprintf(`"{p}The correct form of such a requirement is "<reqs> Stata #", where # is a number{p_end}"')
			exit(198)
		}
		ok = (st_numscalar("c(stata_version)") >= totest)
	}
	else if (parts[1] == "git") {
		if (cols(parts) !=1) {
			errprintf(`"{p}You specified a requirement as "<reqs> "' + req + `""{p_end}"')
			errprintf(`"{p}The correct form of such a requirement is "<reqs> git"{p_end}"')
			exit(198)			
		}
		ok = -1
	}
	else {
		if (cols(parts) !=1) {
			errprintf(`"{p}You specified a requirement as "<reqs> "' + req + `""{p_end}"')
			errprintf(`"{p}The correct form of such a requirement is "<reqs> cmd", where cmd is the command that should exist{p_end}"')
			exit(198)			
		}
		stata("capture which " + parts[1]) 
		totest = st_numscalar("c(rc)")
		if (!(totest ==0 | totest == 111)) {
			errprintf(`"{p}You specified a requirement as "<reqs> "' + req + `""{p_end}"')
			errprintf(`"{p}The correct form of such a requirement is "<reqs> git"{p_end}"')
			exit(198)			
		}
		ok = (totest == 0)
	}
	return(ok)
}
void mptools::chkreqs()
{
	real scalar i, problem
	problem = 0
	for(i=1 ; i <= rows(reading.reqs) ; i++) {
		if(_chkreq(reading.reqs[i])==0) {
			errprintf("{p}failed requirement: " + reading.reqs[i] +  "{p_end}")
			problem = 1
		}
	}
	if (problem) {
		exit(198)
	}
}

string scalar mptools::type2ext(string scalar type)
{
	string scalar extension
	string vector allowed
	allowed = "boilerplate", "project", "default"

	if (!anyof(allowed,type)) {
		errprintf("{p}Only types boilerplate, project, or default allowed in type2ext(){p_end}")
		exit(198)
	}
	extension = (type == "boilerplate" ? ".mpb" : (type == "project" ? ".mpp" : ".mpd"))
	
	return(extension)
}

string scalar mptools::find_file(string scalar what, string scalar type, | string scalar plus)
{
    string scalar path , extension

    extension = type2ext(type)
    path = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_" + what + extension)
    if (!fileexists(path) | plus != "") {
        path = pathjoin(pathsubsysdir("PLUS"), "m/mp_" + what + extension) 
        if (!fileexists(path)) {
            errprintf("{p}" + type + " " +  what + " cannot be found{p_end}")
            exit(601)
        }
    }
    return(path)
}

string scalar mptools::mppathgetparent(string scalar path) {
	real scalar pos
	
	pos = max((strrpos(path,"/"),strrpos(path,"\")))
	return(substr(path,1,pos))
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
