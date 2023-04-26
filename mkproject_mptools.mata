mata:
mata set matastrict on

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
                errprintf("{p}A header is started when one was already open{p_end}")
                mpfclose(fh)
                exit(198)
            }
            header = 1
        }
        else if (first == "</header>") {
            if (header == 0) {
                errprintf("{p}A header was closed when none was open{p_end}")
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
    if (header == 1) {
        errprintf("{p}Started a header but never closed it{p_end}")
        mpfclose(fh)
        exit(198)
    }
    if (header == 0 & args() == 2) {
        errprintf("{p}No header found{p_end}")
        mpfclose(fh)
        exit(198)
        
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