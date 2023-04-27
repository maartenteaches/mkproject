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

void mptools::read_header(real scalar fh, string scalar what, | string scalar relax)
{
    real scalar header
    string scalar line, EOF, errmsg, first, second
    transmorphic scalar t
    
    EOF = J(0,0,"")
    t = tokeninit(" ", "", "<>")
    header = 0
    
    while ((line=mpfget(fh))!= EOF) {
        tokenset(t,line)
        first = tokenget(t)
        if (first == "<header>") {
            if (header == 1) {
                errprintf("{p}A header is started when one was already open; not a valide mkproject " + what + " file {p_end}")
                mpfclose(fh)
                exit(198)
            }
            header = 1
        }
        else if (first == "</header>") {
            if (header == 0) {
                errprintf("{p}A header was closed when none was open; not a valide mkproject " + what + " file {p_end}")
                mpfclose(fh)
                exit(198)
            }
            return
        }
        else if (header) {
            second = ustrtrim(tokenrest(t))
            parse_header(first, second, what)
        }
    }
    mpfclose(fh)
    if (header == 1) {
        errprintf("{p}Started a header but never closed it{p_end}")
        exit(198)
    }
    if (header == 0 & args() == 2) {
        errprintf("{p}No header found; Not a valid mkproject "+ what + " file{p_end}")
        exit(198)
    }
    if (args()==3) {
        header_version = current_version
        header_type = what
    }
}

void mptools::parse_header(string scalar first, string scalar second, string scalar what)
{
    string scalar errmsg
    
    if (first == "<mkproject>") {
        if (second != what) {
            errmsg = "{p}Expected to find a mkproject file of type " + what + 
                     " but found a mkproject file of type " + second + "{p_end}"
            errprintf(errmsg)
            exit(198)
        }
        header_type = second
    }
    if (first == "<version>") {
        header_version(second)
    }
    if (first == "<label>") {
        header_label = second
    }
}

void mptools::new() 
{
    odir = pwd()
}
end