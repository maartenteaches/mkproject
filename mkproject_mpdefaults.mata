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
        fn = find_file(second)
        if (first == "<template>") {
            defaults.mptemplate = second
        }
        else if (first == "<boilerplate>") {
            defaults.boilerplate = second
        }
    }
    mpfclose(reading.fh)
}
end
