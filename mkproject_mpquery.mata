local linetype = 1
local default  = 2
local path     = 3
local name     = 4
local where    = 5
local lab      = 6
local met      = 7
local req      = 8

/*
linetypes:
  main 
  lab_cnt
  req1
  req
*/

mata:

void mpquery::collect_info(string scalar what)
{
	string matrix toparse, temp
	real scalar i
	
	toparse = findfiles(what)
	files = J(0,8,"")
	for(i=1; i <= rows(toparse) ; i++) {
		temp = fromheader(what, toparse[i, .] )
		files = files \ temp
	}
	isdefault(what)
	file2name(what)
	file2path()	    
}

string matrix mpquery::findfiles(string scalar what) {
    string scalar path, ext
    string matrix personal, plus

	ext = type2ext(what)
    path = pathjoin(pathsubsysdir("PERSONAL"), "m")
    personal = dir(path, "files", "mp_*" + ext)

    path = pathjoin(pathsubsysdir("PLUS"), "m")
    plus = dir(path, "files", "mp_*" + ext)
    plus = dupldrop(plus, personal)
 
    personal = (J(rows(personal),1,"PERSONAL"),personal) \ 
	           (J(rows(plus)    ,1,"PLUS"    ),plus)
    _sort(personal,2)
	return(personal)
}

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

string matrix mpquery::fromheader(string scalar what, string rowvector fn)
{
    real scalar add
    string scalar path
	string colvector lab
	string matrix toreturn

    path = pathjoin(pathsubsysdir(fn[1]), "m")
	path = pathjoin(path,fn[2])
    mpfread(path)
    read_header()
    if (reading.open) mpfclose(reading.fh)
    if (reading.type != what) return(J(0,9,""))
	
    lab = mpparts(reading.label)
	toreturn = "main", "", fn[2], "", fn[1], lab[1], "", ""
    if (rows(lab) > 1) {
		add = rows(lab) - 1
		toreturn = toreturn \
		(J(add,1, "lab_cnt"), J(add,4,""), lab[|2,1 \ .,1 |] , J(add,2,""))
	}
	toreturn = toreturn \ collect_reqs()
    return(toreturn)
}

string colvector mpquery::mpparts(string scalar toprocess)
{
	string rowvector parts
	string colvector result
	real scalar k, i
	string scalar newstring
	
	parts = tokens(toprocess)
	result = ""
	k = 1
	newstring = ""
	for (i = 1 ; i <= cols(parts) ; i++ ) {
		if (ustrlen(parts[i])>llabel) {
			parts[i] = usubstr(parts[i],1,llabel-2) + "~" + usubstr(parts[i], -1,1)
		}
		newstring = newstring + (ustrlen(newstring)==0 ? "" :" ") +  parts[i]
		if (ustrlen(newstring) <= llabel) {
			result[k] = newstring
		}
		else {
			result = result \ parts[i]
			newstring = parts[i]
			k = k+1
		}
	}
	return(result)
}

string matrix mpquery::collect_reqs()
{
	real scalar i, chk
	string matrix toreturn

	toreturn = J(rows(reading.reqs),8, "")
	toreturn[.,`linetype'] = J(rows(reading.reqs), 1, "req")
	for(i=1; i<= rows(reading.reqs); i++) {
		if (i==1) toreturn[1,`linetype'] = "req1"
		chk = _chkreq(reading.reqs[i])
		toreturn[i,`met'] = (chk == -1 ? "/" : (chk == 0 ? "-" : "+"))
		toreturn[i,`req'] = reading.reqs[i]
	}
	return(toreturn)
}

void mpquery::isdefault(string scalar what)
{
    string scalar def, ext
    real scalar tochange

    files[.,`default'] = J(rows(files), 1," ")
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
	ext = type2ext(what)
    def = "mp_" + def + ext
    tochange = selectindex(files[.,`path']:==def)
    files[tochange,`default'] = "*"
}

void mpquery::file2name(string scalar what)
{
    string colvector name 
	string scalar ext
	
	ext = ustrreverse(type2ext(what))
    name = usubinstr(files[.,`path'],"mp_", "", 1)
    name = ustrreverse(name)
    name = usubinstr(name, ext, "", 1)
    name = ustrreverse(name)
    files[.,`name'] = name
}

void mpquery::file2path()
{
    real scalar i
    string scalar path
    
    for(i=1; i<=rows(files);i++) {
		if (files[i,`where'] == "") continue
        path = pathjoin(pathsubsysdir(files[i,`where']), "m")
        path = pathjoin(path, files[i,`path'])
        files[i,`path'] = path
    }
}

void mpquery::new()
{
    cname  = "{col 2}"
    cwhere = "{col 16}"
    clabel = "{col 25}"
	creq   = "{col 4}"
	llabel = st_numscalar("c(linesize)") - 24
}

void mpquery::print_header()
{
    string scalar toprint
   
	toprint = "{txt}" + cname + 
			  "Name" + cwhere + 
			  "Where" + clabel + 
			  "Label\n"
    printf("{hline}\n")
    printf(toprint)
    printf("{hline}\n")
}

void mpquery::print_footer()
{
	printf("{hline}\n")
	printf("{txt}* indicates default\n")
	if (anyof(files[.,`linetype'], "req1")) {
		printf("{txt}+ indicates requirement met\n")
		printf("{txt}- indicates requirement not met\n")
		printf("{txt}/ indicates requirement not checked\n")
	}
}

void mpquery::print_line(real scalar i)
{
    string scalar toprint
	string matrix reqlist

	if (files[i,`linetype']== "main") {
		toprint = "{txt}" + files[i,`default'] + `"{view ""' + files[i,`path'] +
		          `"":"' + files[i,`name'] + "}" + cwhere + files [i,`where'] + 
				  clabel + files[i,`lab'] + "\n"		
	}
	else if(files[i, `linetype'] == "lab_cnt") {
		toprint = "{txt}" + clabel + files[i,`lab'] + "\n"
	}
	else if(files[i, `linetype'] == "req1") {
		toprint = "{txt}" + creq + "requires:" + cwhere + files[i,`met'] + 
		          " "  +parse_req(i) + "\n"
 	}
	else if(files[i,`linetype'] == "req") {
		toprint = "{txt}" + cwhere + files[i, `met'] + " " + parse_req(i) + "\n"
	}

	printf(toprint)
}

string scalar mpquery::parse_req(real scalar i)
{
	string scalar toreturn
	
	if (strlower(files[i,`req'])== "git") {
		toreturn = `"{browse "https://git-scm.com/":git}"'
	}
	else if (strmatch(strlower(files[i,`req']), "stata *")) {
		toreturn = files[i,`req']
	}
	else if (files[i,`met']== "-") {
		toreturn = "{search " + files[i,`req'] + "}"
	}
	else if (files[i,`met'] == "+") {
		toreturn = "{help " + files[i,`req']+ "}"
	}
	return(toreturn)	
}


void mpquery::print_table()
{
    real scalar i, j
    
    print_header()
	j = rows(files)
    for(i=1; i<= j; i++) {
        print_line(i)
    }
    print_footer()
}

void mpquery::run(string scalar what)
{
    collect_info(what)
    print_table("basic")
}
end