mata:

string colvector mpquery::dupldrop(string scalar plus, string scalar personal)
{
    
}

string matrix mpquery::selecttype(string colvector files, string scalar what)
{
    
}

void mpquery::isdefault()
{
    
}

void mpquery::file2name()
{
    
}

void mpquery::file2path()
{
    
}

void mpquery::print_header()
{
    
}

void mpquery::print_footer()
{
    
}

void mpquery::print_line()
{
    
}

void mpquery::collect_info()
{
    
}

void mpquery::print_table()
{
    
}

void mpquery::run(string scalar what)
{
    
}

void mpquery::findfiles(string scalar what) {
    string scalar path
    real scalar i
    string colvector personal, plus, labpe, labpl
    real colvector selection

    path = pathjoin(pathsubsysdir("PERSONAL"), "m")
    personal = dir(path, "files", "mp_*.txt")
    selection = J(rows(personal,1,.))
    labpe = J(rows(personal),1, "")
    for(i=1; i<=rows(personal); i++) {
        mpfread(pathjoin(path,personal[i]))
        read_header(what, "relax")
        mpfclose(reading.fh)
        selection[i] = (reading.type == what)
        labpe[i] = reading.label
    }
    personal = select(personal, selection)
    labpe = select(labpe, selection)
       
    path = pathjoin(pathsubsysdir("PLUS"), "m")
    plus = dir(path, "files", "mp_*.txt")
    selection = J(rows(plus),1,.)
    labpl = J(rows(plus),1,"")
    for (i=1; i<=rows(plus); i++) {
        if (anyof(personal,plus[i])) {
            selection[i] = 0
        }
        else {
            mpfread(pathjoin(path,plus[i]))
            read_header(what, "relax")
            mpfclose(reading.fh)
            selection[i] = (reading.type == what)
            labpl[i] = reading.label 
        }
    }
    plus = select(plus, selection)
    labpl = select(labpl,selection)
}

void mpquery::new()  {
    files = J(0,5,"")
}
end