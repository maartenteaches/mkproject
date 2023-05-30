local default = 1
local path    = 2
local name    = 3
local where   = 4
local lab     = 5
mata:

string colvector mpquery::dupldrop(string colvector plus, string colvector personal)
{
    real scalar i 
    real colvector selection

    selection = J(rows(plus),1,1)
    
    for (i=1; i<=rows(plus); i++) {
        if (anyof(personal,plus[i])) {
            selection[i] = 0
        }
    }
    return(select(plus,selection))
}


string matrix mpquery::selecttype(string colvector files, string scalar where, string scalar what)
{
    real colvector selection
    real scalar i
    string colvector lab
    string scalar path

    path = pathjoin(pathsubsysdir(where), "m")
    selection = J(rows(files),1,.)
    lab = J(rows(files),1, "")
    for(i=1; i<=rows(files); i++) {
        mpfread(pathjoin(path,files[i]))
        read_header(what, "relax")
        mpfclose(reading.fh)
        selection[i] = (reading.type == what)
        lab[i] = reading.label
    }
    files = select(files, selection)
    lab = select(lab, selection)
    return((files,lab, where))
}

void mpquery::findfiles(string scalar what) {
    string scalar path
    string matrix personal, plus

    path = pathjoin(pathsubsysdir("PERSONAL"), "m")
    personal = dir(path, "files", "mp_*.txt")
    personal = selecttype(personal,"PERSONAL", what)
    
    path = pathjoin(pathsubsysdir("PLUS"), "m")
    plus = dir(path, "files", "mp_*.txt")
    plus = dupldrop(plus, personal[.,1])
    plus = selecttype(plus,"PLUS", what)
    
    personal = personal \ plus
    _sort(personal,1)
    files = J(rows(personal),5,"")
    files[., `path'] = personal[.,1]
    files[.,`where'] = personal[.,3]
    files[.,`lab']   = personal[.,2]
}


void mpquery::isdefault(string scalar what)
{
    string scalar def
    real scalar tochange

    files[.,`default'] = J(rows(files), 1,"  ")
    read_defaults()
    if (what == "boilerplate") {
        def  = defaults.boilerplate
    }
    else if (what == "stencil") {
        def = defaults.stencil
    }
    else {
        errprintf("what can only be boilerplate or stencil")
        exit(198)
    }
    def = "mp_" + def + ".txt"
    tochange = selectindex(files[.,`path']:==def)
    files[tochange,`default'] = "* "
}

void mpquery::file2name()
{
    string colvector name 
    
    name = usubinstr(files[.,`path'],"mp_", "", 1)
    name = ustrreverse(name)
    name = usubinstr(name, "txt.", "", 1)
    name = ustrreverse(name)
    files[.,`name'] = name
}

void mpquery::file2path()
{
    real scalar i
    string scalar path
    
    for(i=1; i<=rows(files);i++) {
        path = pathjoin(files[i,`where'], "m")
        path = pathjoin(path, files[i,`path'])
        files[i,`path'] = path
    }
}

void mpquery::collect_info(string scalar what)
{
    findfiles(what)
    isdefault(what)
    file2name()
    file2path()
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



void mpquery::print_table()
{
    
}

void mpquery::run(string scalar what)
{
    collect_info(what)
    print_table()
}
end