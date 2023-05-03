mata:
mata set matastrict on

void mpdefaults::read_defaults()
{
    string scalar fn, EOF, line, first, second
    transmorphic scalar t
    
    EOF = J(0,0,"")
    t = tokeninit(" ", "", "<>")
    
    fn = find_file("defaults")
    mpfread(fn)
 
    read_header("defaults")
    
    while ((line=mpfget())!= EOF) {
        reading.lnr = reading.lnr+1
        tokenset(t,line)
        first = tokenget(t)
        second = tokenget(t)
        if (first == "<stencil>") {
            defaults.stencil = second
        }
        else if (first == "<boilerplate>") {
            defaults.boilerplate = second
        }
    }
    mpfclose(reading.fh)
    header_ok(defaults.stencil, "stencil")
    header_ok(defaults.boilerplate, "boilerplate")
}

end
