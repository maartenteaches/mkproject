mata:
mata set matastrict on

void mpdefaults::read_defaults()
{
    string scalar fn, EOF, line, first, second
    real scalar fh, lnr
    transmorphic scalar t
    
    EOF = J(0,0,"")
    t = tokeninit(" ", "", "<>")
    
    fn = find_file("defaults")
    fh = mpfopen(fn, "r")
    
    lnr = read_header(fh, fn, "defaults")
    
    while ((line=mpfget(fh, fn , ++lnr))!= EOF) {
        tokenset(t,line)
        first = tokenget(t)
        second = tokenget(t)
        if (first == "<template>") {
            def_template = second
        }
        else if (first == "<boilerplate>") {
            def_boiler = second
        }
    }
}
end