mata:
void mpcreate::create(string scalar what)
{
    string scalar fn_in, fn_out, EOF, line
    real scalar fh_out
    
    fn_in = st_local("create")
    fn_out = newname()
    EOF = J(0,0,"")
    
    if (fileexists(fn_in)==0) {
        errprintf("{p}file " + fn_in + " not found {p_end}")
        exit(601)
    }
    mpfread(fn_in)
    read_header(what, "relax")

    // wrong type of mkproject file
    if (reading.type != what) { 
        errprintf("{p}expected a file of type " + what + " but found a file of type " + reading.type + "{p_end}")
        exit(198)
    }
    // no header in source
    if (reading.open == 0) { 
        mpfread(fn_in)
    }
    fh_out = mpfopen(fn_out, "w")
    write_header(fh_out)
    
        
    while((line=mpfget())!=EOF) {
        chk_file(line)
        mpfput(fh_out, line)
    }
    mpfclose(reading.fh)
    mpfclose(fh_out)
}

void mpcreate::chk_file(string scalar line)
{
    transmorphic scalar t
    string scalar garbage, first, second
    
    t = tokeninit()
    tokenset(t, line)
    first = tokenget(t)
    if (first == "<file>") {
        second = tokenget(t)
        garbage = find_file(second)
    }
}

string scalar mpcreate::newname()
{
    string scalar path

    path = st_local("create")
    path = pathrmsuffix(pathbasename(path)) + ".txt"
    path = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_" + path)
    
    if (st_local("replace") == "" & fileexists(path)) {
        errprintf(pathrmsuffix(pathbasename(st_local("create"))) + " already exists" )
        exit(198)
    }
    else {
        unlink(path)
    }
    return(path)
} 
end