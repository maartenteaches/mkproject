local linetype = 1
local default  = 2
local path     = 3
local name     = 4
local where    = 5
local lab      = 6
local met      = 7
local req      = 8

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


string matrix mpquery::getlab(string colvector files, string scalar where, string scalar what)
{
    real colvector selection
    real scalar i
    string colvector lab
    string scalar path
	string matrix toreturn

    path = pathjoin(pathsubsysdir(where), "m")
    selection = J(rows(files),1,.)
    lab = J(rows(files),1, "")
    for(i=1; i<=rows(files); i++) {
        mpfread(pathjoin(path,files[i]))
        read_header()
        if (reading.open) mpfclose(reading.fh)
        selection[i] = (reading.type == what)
        lab[i] = reading.label
    }
    files = select(files, selection)
    lab = select(lab, selection)
	if (rows(files) == 0) {
		toreturn = J(0,3, "")
	}
	else {
		toreturn = (files,lab, J(rows(files),1,where))
	}
    return(toreturn)
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
        path = pathjoin(pathsubsysdir(files[i,`where']), "m")
        path = pathjoin(path, files[i,`path'])
        files[i,`path'] = path
    }
}

string colvector mpquery::mpparts(string scalar toprocess, real scalar l)
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
		if (ustrlen(parts[i])>l) {
			parts[i] = usubstr(parts[i],1,l-2) + "~" + usubstr(parts[i], -1,1)
		}
		newstring = newstring + (ustrlen(newstring)==0 ? "" :" ") +  parts[i]
		if (ustrlen(newstring) <= l) {
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

void mpquery::multilinelab()
{
	real scalar i, l
	string matrix newlab
	string matrix filler
	
	l=st_numscalar("c(linesize)")
	l = l - 24
	for(i=1; i<= rows(files); i++) {
		newlab = mpparts(files[i,`lab'], l)
		if 
		filler = J(rows(newlab)-1, 4, "")
		newlab = (files[|i,1\i,4|] / filler) ,newlab
		files[|i-1,1\i-1,5] \ newlab \ 
		
	}
}

void mpquery::collect_info(string scalar what)
{
	string matrix toparse, temp
	real scalar i
	
	toparse = findfiles(what)
	files = J(0,9,"")
	for(i=1; i <= rows(toparse) ; i++) {
		temp = fromheader(what, toparse )
		files \ temp
	}
	isdefault(what)
	file2name(what)
	file2path()	    
}



void mpquery::new()
{
    cname  = "{col 2}"
    cwhere = "{col 16}"
    clabel = "{col 25}"
}

void mpquery::print_header(string scalar basicreq)
{
    string scalar toprint
   
    if (basicreq == "basic") {
		toprint = "{txt}" + cname + 
				  "Name" + cwhere + 
				  "Where" + clabel + 
				  "Label\n"
	}
	else if (basicreq == "reqs") {
		toprint = "{txt}" + cname +
		          "Name" + cwhere + 
				  "Requirement\n"
	}
   
    printf("{hline}\n")
    printf(toprint)
    printf("{hline}\n")
}

void mpquery::print_footer(string scalar basicreq)
{
	printf("{hline}\n")
	if (basicreq == "basic") {
		printf("{txt}* indicates default\n")
	}
	else {
		printf("{txt}+ indicates requirement met\n")
		printf("{txt}- indicates requirement not met\n")
		printf("{txt}/ indicates requirement not checked\n")
	}
}

void mpquery::print_line(real scalar i, string scalar basicreq)
{
    string scalar toprint, lab

	if (basicreq == "basic") {
		lab = ustrleft(files[i,5],l)
		toprint = files[i,1] + `"{view ""' + files[i,2] + `"":"' +
				  files[i,3] + "}" + cwhere + files [i,4] + 
				  clabel + lab + "\n"
	}
	else if (basicreq == "reqs") {
		toprint = "{txt}" + cname + reqlist[i,1] + cwhere + reqlist[i,2]
		if (strlower(reqlist[i,3])== "git") {
			toprint = toprint + 
			          `"{browse "https://git-scm.com/":git}"'
		}
		else if (strmatch(strlower(reqlist[i,3]), "stata *")) {
			toprint = toprint + reqlist[i,3]
		}
		else if (reqlist[i,2]== "-") {
			toprint = toprint + 
			          "{search " + reqlist[i,3] + "}"
		}
		else if (reqlist[i,2] == "+") {
			toprint = toprint +
			          "{help " + reqlist[i,3]+ "}"
		}
		toprint = toprint + "\n"
	}
	printf(toprint)
}

void mpquery::collect_reqs(string colvector fns, string colvector names)
{
	real scalar i, j, chk
	string matrix toadd

	reqlist = J(0,3,"")
	for (i=1; i<=rows(fns); i++) {
		mpfread(fns[i])
        read_header()
		if (reading.open) mpfclose(reading.fh)
		toadd = J(rows(reading.reqs),3, "")
		for(j=1; j<= rows(reading.reqs); j++) {
			toadd[j,1] = (j==1 ? names[i] : "")
			chk = _chkreq(reading.reqs[j])
			toadd[j,2] = (chk == -1 ? "/" : (chk == 0 ? "-" : "+"))
			toadd[j,3] = reading.reqs[j]
		}
		reqlist = reqlist \ toadd
	}
}


void mpquery::print_table(string scalar basicreq)
{
    real scalar i, j
    
    print_header(basicreq)
	j = (basicreq == "basic"? rows(files): rows(reqlist))
    for(i=1; i<= j; i++) {
        print_line(i, basicreq)
    }
    print_footer(basicreq)
}

void mpquery::run(string scalar what)
{
    collect_info(what)
    print_table("basic")
	
	collect_reqs(files[.,`path'], files[.,`name'])
	if (rows(reqlist) > 0) {
		printf("\n")
		print_table("reqs")
	}
}
end