mata:

string scalar mpquery::truncstring(string scalar totrunc, real scalar maxl)
{
	if (ustrlen(totrunc) <= maxl) {
		return(totrunc)
	}
	else {
		return(usubstr(totrunc,1,maxl-2) + "~" + usubstr(totrunc, -1,1))
	}
	
}

void mpquery::collect_info(string scalar what)
{
	string matrix toparse
	real scalar i
	
	toparse = findfiles(what)
	parsefiles(what, toparse)
	fromheader()
	isdefault(what)
   
}

string matrix mpquery::findfiles(string scalar what) {
    string scalar path_per, path_plus, ext
    string matrix personal, plus	

	ext = type2ext(what)
    path_per = pathjoin(pathsubsysdir("PERSONAL"), "m")
    personal = dir(path_per, "files", "mp_*" + ext)

    path_plus = pathjoin(pathsubsysdir("PLUS"), "m")
    plus = dir(path_plus, "files", "mp_*" + ext)
    plus = dupldrop(plus, personal)
 
    personal = (J(rows(personal),1,path_per),personal) \ 
	           (J(rows(plus)    ,1,path_plus),plus)
    _sort(personal,2)

	return(personal)
}

void mpquery::parsefiles(string scalar what, string matrix toparse)
{
	real colvector select
	real scalar i
	
	select = J(rows(toparse),1,1)
	for(i=1; i<=rows(toparse); i++) {
		toparse[i,1] = pathjoin(toparse[i,1], toparse[i,2])
		mpfread(toparse[i,1])
		read_header()
		if (reading.open) mpfclose(reading.fh)
		if (reading.type != what) {
			select[i] = 0
		}
		toparse[i,2] = file2name(what, toparse[i,2])
	}
	toparse = select(toparse,select)
	files = queryinfo(rows(toparse),1)
	for(i=1; i<=rows(toparse); i++) {
		files[i].path = toparse[i,1]
		files[i].name = toparse[i,2]
	}
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

void mpquery::fromheader( )
{
    real scalar i

	for (i=1 ; i <= rows(files) ; i++) {
		mpfread(files[i].path)
		read_header()
		if (reading.open) mpfclose(reading.fh)

		files[i].lab  = reading.label
		files[i].reqs = reading.reqs 
		files[i].met  = collect_reqs()
	}
}

string colvector mpquery::mpparts(string scalar toprocess, real scalar lmax)
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
		parts[i] = truncstring(parts[i],lmax)
		newstring = newstring + (ustrlen(newstring)==0 ? "" :" ") +  parts[i]
		if (ustrlen(newstring) <= lmax) {
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

string colvector mpquery::collect_reqs()
{
	real scalar i, chk
	string colvector toreturn

	toreturn = J(rows(reading.reqs),1, "")
	
	for(i=1; i<= rows(reading.reqs); i++) {
		chk = _chkreq(reading.reqs[i])
		toreturn[i] = (chk == -1 ? "/" : (chk == 0 ? "-" : "+"))
	}
	return(toreturn)
}

void mpquery::isdefault(string scalar what)
{
    string scalar def
	real scalar i

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
	for(i=1; i<=rows(files); i++) {
		if (files[i].name == def) {
			files[i].default = "*"
		}
		else {
			files[i].default = " "
		}
	}
}

string scalar mpquery::file2name(string scalar toparse, string scalar what)
{
	string scalar ext, name
	
	ext = ustrreverse(type2ext(what))
    name = usubinstr(toparse,"mp_", "", 1)
    name = ustrreverse(name)
    name = usubinstr(name, ext, "", 1)
    name = ustrreverse(name)
    return(name)
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
   
}

void mpquery::parse_names(real scalar maxl, real scalar bigestl) {
	real scalar i

	for(i=1;i<=rows(files); i++) {
		files[i].name = truncstring(files[i].name, maxl)
		bigestl = max((ustrlen(files[i].name),bigestl))
		files[i].name = `"{view ""' + files[i].path +
		                 `"":"' + files[i].name + "}"
	}
}
void mpquery::setup_table()
{
	real scalar maxl, bigestl, i, pos
	
	maxl = floor(st_numscalar("c(linesize)")/3) - 2
	
	cname = "{txt}{col 2}"
	bigestl = 4
	parse_names(maxl, bigestl)
	
	pos = bigestl + 4
	creq = "{col " +strofreal(pos) + "}"
	bigestl = 8
	parse_reqs(maxl, bigestl)
	
	pos = pos + bigestl + 3
	clabel = "{col " + strofreal(pos) + "}"
	maxl = st_numscalar("c(linesize)") - pos + 1
	for(i=1; i<=rows(files); i++) {
		files[i].label = mpparts(files[i].label, maxl)
	}
}

void mpquery::print_header()
{
    string scalar toprint
   
	toprint = "{txt}" + cname + 
			  "Name" + cwhere + 
			  "Requires" + clabel + 
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

void mpquery::parse_reqs(real scalar maxl, real scalar bigestl)
{
	real scalar i, j
	
	for(i=1; i<=rows(files); i++) {
		for(j=1; j<=rows(files[i].reqs); j++) {
			files[i].reqs[j] = parse_req(i,j,maxl, bigestl)
		}
	}
}

string scalar mpquery::parse_req(real scalar i, real scalar j, real scalar maxl, real scalar bigestl)
{
	string scalar toreturn, req

	req = files[i].reqs[j]
	bigestl = max((ustrlen(req), bigestl))
	bigestl = min((bigestl, maxl))
	
	if (strlower(req)== "git") {
		toreturn = `"{browse "https://git-scm.com/":git}"'
	}
	else if (strmatch(strlower(req), "stata *")) {
		toreturn = files[i,`req']
	}
	else if (files[i].met[j]== "-") {
		toreturn = "{search " + req + ":" + truncstring(req, maxl) + "}"
	}
	else if (files[i].met.[j] == "+") {
		toreturn = "{help " + req + ":" + truncstring(req, maxl) + "}"
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
    print_table()
}
end