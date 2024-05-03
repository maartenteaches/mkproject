mata:

void mpcreate::header_defaults(string scalar what)
{
    if (reading.type == "") { 
        reading.type = what
    }
    if (reading.sversion == "") {
        reading.sversion = invtokens(strofreal(current_version),".")
    }
    header_version(reading.sversion)
    // wrong type of mkproject file
    if (reading.type != what) { 
        errprintf("{p}expected a file of type " + what + " but found a file of type " + reading.type + "{p_end}")
        exit(198)
    }
}
void mpcreate::create(string scalar what)
{
    string scalar fn_in, fn_out, EOF, line
    real scalar fh_out, plus, body, everbody
	string colvector reqs
    
    fn_in = st_local("create")
    fn_out = newname(fn_in, what)
    EOF = J(0,0,"")
	plus = (st_local("plus") != "")
    
    if (fileexists(fn_in)==0) {
        errprintf("{p}file " + fn_in + " not found {p_end}")
        exit(601)
    }
	reqs = integrate_reqs(fn_in)
    mpfread(fn_in)
    read_header()
    header_defaults(what)
	reading.reqs = reqs
    fh_out = mpfopen(fn_out, "w")
    write_header(fh_out)
    
    // no header in source
    if (reading.open == 0) { 
        mpfread(fn_in)
    }    
    
    body = 0
	everbody = lt(reading.fversion,(2,1,0))
    while((line=mpfget())!=EOF) {
		reading.lnr = reading.lnr + 1
		check_body(line, body, everbody)
        mpfput(fh_out, line)
    }
    mpfclose(reading.fh)
    mpfclose(fh_out)
	
	if (body = 1 & !lt(reading.fversion,(2,1,0))) {
		errprintf("{p}The body was never closed{p_end}")
		unlink(fn_out)
		exit(198)
	}
	if(everbody == 0) {
		errprintf("{p}No body found{p_end}")
		unlink(fn_out)
		exit(198)
	}
	
	write_help(what, fn_out, plus)
}

void mpcreate::check_body(string scalar line, real scalar body, real scalar everbody)
{
	string scalar first
	if (line != "") {
		first = tokens(line)[1]
	}
	else {
		first = ""
	}
	if (first == "<body>") {
		if (body == 1) {
			where_err()
			errprintf("{p}Started a body when one was already open; not a valid mkproject file{p_end}")
			exit(198)
		}
		body = 1
		everbody = 1
	}
	else if (first == "</body>") {
		if (body == 0) {
			where_err()
			errprintf("{p}closed a body when none was open; not a valid mkproject file{p_end}")
		}
		body = 0
	}
}

string colvector mpcreate::integrate_reqs(string scalar fn)
{
	string colvector toreturn
	string scalar EOF, line, s
	real scalar sversion, fh
	real colvector isstata

	EOF = J(0,0,"")
	mpfread(fn)
    read_header()
	if (reading.open == 1) {
		mpfclose(reading.fh)
		toreturn = reading.reqs
		if(rows(toreturn)>0) {
			isstata = strmatch(strlower(toreturn), "stata *")
			if(any(isstata)) {
				s = select(toreturn,isstata)
				sversion = strtoreal(tokens(s)[2])
				toreturn = select(toreturn, !isstata)
			}
		}
	}
	
	if (toreturn == J(0,0,"")) toreturn = J(0,1,"")
	fh = mpfopen(fn, "r")
	while((line=fget(fh))!=EOF) {
        chk_file(line, toreturn, sversion)
    }
    mpfclose(fh)
	
	if (sversion != .) {
		toreturn = ("Stata " + strofreal(sversion, "%9.1f")) \ toreturn
	}
	return(toreturn)
}

void mpcreate::chk_file(string scalar line, 
                        string colvector toreturn, 
						real scalar sversion)
{
    transmorphic scalar t
    string scalar fn, first, second
    real scalar i
	
    t = tokeninit()
    tokenset(t, line)
    first = tokenget(t)
    if (first == "<file>") {
        second = tokenget(t)
        fn = find_file(second, "boilerplate")
		mpfread(fn)
		read_header()
		for(i=1;i<=rows(reading.reqs); i++) {
			parse_req_line(toreturn,reading.reqs[i],sversion)
		}
		mpfclose(reading.fh)
    }
}

void mpcreate::parse_req_line(string colvector toreturn, 
                              string scalar req, 
							  real scalar sversion)
{
	real scalar newsversion
	
	if (strmatch(strlower(req), "stata *")) {
		newsversion = strtoreal(tokens(req)[2])
		sversion = max((sversion, newsversion))
	}
	else if (!anyof(toreturn, req)){
		toreturn = toreturn \ req
	}
}

string scalar mpcreate::newname(string scalar path, string scalar what)
{
    string scalar newpath, ext

	ext = type2ext(what)
    newpath = pathrmsuffix(pathbasename(path)) + ext
    newpath = pathjoin(pathsubsysdir("PERSONAL"), "m/mp_" + newpath)
    
    if (st_local("replace") == "" & fileexists(newpath)) {
        errprintf(pathrmsuffix(pathbasename(newpath)) + " already exists" )
        exit(198)
    }
    else {
        unlink(newpath)
    }
    return(newpath)
} 

void mpcreate::remove(string scalar what, string scalar type)
{
	string scalar fn, ext
	
	ext = type2ext(type)
	fn = "m\mp_" + what + ext
	
	fn = pathjoin(pathsubsysdir("PERSONAL"), fn)
	if (!fileexists(fn)) {
		errprintf("{p}" + type + " " + what + " not found{p_end}")
		exit(601)
	}
	read_defaults()
	if (type == "boilerplate") {
		if (defaults.boilerplate == what) {
			reset(type)
		}
 	}
	else if (type == "project") {
		if (defaults.project == what) {
			reset(type)
		}
	}
	unlink(fn)
	fn = "m\mp_" + (type=="project"? "p" : "b" ) + "_" + what + ".sthlp"
	fn = pathjoin(pathsubsysdir("PERSONAL"), fn)
	unlink(fn)
}

void mpcreate::write_help(string scalar what, string fn_in, real scalar plus ){
	string scalar templ
	
	templ = pathrmsuffix(pathbasename(fn_in)) 
	templ = substr(templ, 4)
	
	if (what == "project") {
		write_help_p(templ, plus)
	}
	else {
		write_help_b(fn_in, templ, plus)
	}
}

void mpcreate::write_help_p(string scalar templ, real scalar plus)
{
	string scalar fn_out 
	real scalar fh
	
	fn_out = pathjoin(pathsubsysdir("PERSONAL"), "m\mp_p_" + templ + ".sthlp")
	
	project = templ
	abbrev = "proj_abbrev"
	read_project()
	
	if (st_local("replace") == "" & fileexists(fn_out)) {
        errprintf("{p}" +fn_out + " already exists{p_end}" )
        exit(198)
    }
    else {
        unlink(fn_out)
    }
	
	fh = mpfopen(fn_out, "w")
	
	write_help_header(fh, templ, "project")
	write_help_p_body(fh)
	write_help_footer(fh, plus)
	
	mpfclose(fh)
}

void mpcreate::write_help_b(string scalar fn_in, string scalar templ, real scalar plus)
{
	string scalar fn_out
	real scalar fh
	
	fn_out = pathjoin(pathsubsysdir("PERSONAL"), "m\mp_b_" + templ + ".sthlp")
	
	mpfread(fn_in)
	collect_header_info()
	
	if (st_local("replace") == "" & fileexists(fn_out)) {
        errprintf("{p}" + fn_out + " already exists{p_end}" )
        exit(198)
    }
    else {
        unlink(fn_out)
    }
	
	fh = mpfopen(fn_out, "w")
	
	write_help_header(fh, templ, "boilerplate")
	write_help_b_body(fh)
	write_help_footer(fh, plus)
	
	mpfclose(fh)
	mpfclose(reading.fh)
}

void mpcreate::write_help_b_body(real scalar fh)
{
	string scalar line, EOF

	EOF = J(0,0,"")
	
	mpfput(fh, "{title:Boilerplate}")
	mpfput(fh, "")
	mpfput(fh, "{pstd}")
	mpfput(fh, "This template creates a .do file with the following content: ")
	mpfput(fh, "")
	mpfput(fh, "{cmd}")
	
	while ((line=mpfget())!= EOF) {
		mpfput(fh, "    " + line)
	}
	mpfput(fh, "{txt}")
	mpfput(fh,"")
	mpfput(fh, "{title:Tags}")
	mpfput(fh, "")
	mpfput(fh, "{pstd}")
	mpfput(fh,"This file may contain one or more of the following tags:{p_end}")
	mpfput(fh, "{pmore}{cmd:<stata_version>} will be replaced by the Stata version{p_end}")
	mpfput(fh, "{pmore}{cmd:<date>} will be replaced by the date{p_end}")
	mpfput(fh, "{pmore}{cmd:<fn>} will be replaced by the file name{p_end}")
	mpfput(fh, "{pmore}{cmd:<stub>} will be replaced by the file name without the suffix{p_end}")
	mpfput(fh, "{pmore}{cmd:<abbrev>} will be replaced by the file name without the suffix up to the last underscore{p_end}")
	mpfput(fh, "{pmore}{cmd:<basedir>} will be replaced by the directory in which the file is saved{p_end}")
	mpfput(fh, "{pmore}{cmd:<as of #>} will include whatever comes after that tag only if the Stata version is # or higher{p_end}")
	mpfput(fh, "")
	mpfput(fh, "")
}


void mpcreate::write_help_header(real scalar fh, string scalar templ, string scalar what)
{
	real scalar r
	
	mpfput(fh, "{smcl}")
	mpfput(fh, "{* *! version " + invtokens(strofreal(current_version), ".") + "}{...}")
	mpfput(fh, `"{vieweralsosee "mkproject" "help mkproject"}{...}"')
	mpfput(fh, `"{vieweralsosee "boilerplate" "help boilerplate"}{...}"')
	mpfput(fh, "{title:Title}")
	mpfput(fh, "")
	mpfput(fh, "{phang}")
	mpfput(fh, what + " template " + templ + " {hline 2} " + reading.label )
	mpfput(fh, "")
	mpfput(fh, "")
	if (rows(reading.description) > 0) {
		mpfput(fh, "{title:Description}")
		mpfput(fh, "")
		for(r=1; r<=rows(reading.description); r++) {
			mpfput(fh, reading.description[r])
		}
		mpfput(fh, "")
		mpfput(fh, "")
	}
}

void mpcreate::write_help_p_body(real scalar fh)
{
	real scalar i
	
	mpfput(fh, "{title:File structure}")
	mpfput(fh, "")
	mpfput(fh, "{pstd}")
	mpfput(fh, "This template will create the following sub-directories and files:")
	mpfput(fh, "")
	create_tree(fh)
	if (rows(cmds)> 0) { 
		mpfput(fh, "")
		mpfput(fh, "")
		mpfput(fh, "{title:Commands}")
		mpfput(fh, "")
		mpfput(fh, "{pstd}")
		mpfput(fh, "After creating these sub-directories and files it will change the working directory to {it:proj_abbrev} directory.")
		mpfput(fh, "Subsequently it will execute the following commands:{p_end}")
		for(i=1; i <= rows(cmds) ; i++) {
			mpfput(fh, "{pmore}{cmd:" + cmds[i] + "}{p_end}")
		}
	}
	mpfput(fh, "")
	mpfput(fh, "")
}

void mpcreate::write_help_footer(real scalar fh, real scalar plus)
{
	string scalar fn
	
	fn = pathbasename(reading.fn)
	if (plus) fn = pathjoin(pathsubsysdir("PLUS"), "m/" +fn)
	
	mpfput(fh, "{title:Source code}")
	mpfput(fh, "")
	mpfput(fh, `"    {view ""' + fn + `"":"' + pathbasename(reading.fn) + "}")
}

void mpcreate::create_tree(real scalar fh)
{
	string matrix dirtree, filetree, newcols, toparse
	real scalar ncolsd, ncolsf
	
	dirtree = parse_tree(dirs)
	
	toparse = files
	if (rows(toparse) != 0) {
		toparse[.,2] = subinstr(files[.,2], "/", "\")
		filetree = parse_tree(toparse)
		ncolsd = cols(dirtree)
		ncolsf = cols(filetree)
		if (ncolsf > ncolsd) {
			newcols = J(rows(dirtree), ncolsf - ncolsd, "")
			dirtree = dirtree , newcols
		}
		else if(ncolsf < ncolsd) {
			newcols = J(rows(filetree), ncolsd - ncolsf, "")
			filetree = filetree , newcols
		}
		dirtree = dirtree \ filetree
	}
	dirtree = sort(dirtree, (1..cols(dirtree)))
	dirtree = J(rows(dirtree), 1, (abbrev, "/")), dirtree
	dirtree = ("proj_abbrev", "/", J(1,cols(dirtree)-2,"")) \ dirtree
	decorate_tree(dirtree)
	write_tree(fh, dirtree)
}

string matrix mpcreate::parse_tree(string matrix toparse)
{   
	real scalar ncols, nrows, i, n, files
	string matrix parsed, newcols
	string rowvector tdir
	string colvector paths
	transmorphic scalar t

	if (cols(toparse) == 1) {
		paths = toparse
		files = 0
	}
	else if (cols(toparse)== 2) {
		paths = toparse[.,2]
		files = 1
	}
	else {
		errprintf("{p}parse_tree() expected a matrix with 1 or 2 colums{p_end}")
		exit(198)
	}
	ncols = 1	   
	nrows = rows(paths)
	parsed = J(nrows,ncols, "")
	t = tokeninit("\")

	for (i=1; i<= nrows; i++) {
		tokenset(t,paths[i])
		tdir = tokengetall(t)
		n = cols(tdir)
		if (files==1) {
			tdir[n] = "{help mp_b_" + toparse[i,1] + ":" + tdir[n] + "}"
		}
		else {
			tdir = tdir, "/"
			n = n + 1
		}
		if (n > ncols) {
			newcols = J(nrows, n - ncols, "")
			parsed = parsed, newcols
			ncols = n
		}
		else if (n < ncols) {
			newcols = J(1, ncols - n, "")
			tdir = tdir, newcols
		}
		parsed[i,.] = tdir 
	}
	_sort(parsed, (1..ncols))
	return(parsed)
}

void mpcreate::decorate_tree(string matrix toparse)
{
	real scalar r, c, nextc, first
	string scalar lastchild, child, dir
	
    lastchild = "└──"
    child     = "├──"
	dir       = "/"
	
	for (c=1; c < cols(toparse); c++) {
		first = 1
		for (r= rows(toparse); r>1  ; r--) {
			if (toparse[r,c] == dir | toparse[r,c] == "") continue
			nextc = c + 1
			nextc = nextc + (toparse[r, nextc] == dir)
			
			if (toparse[r,c] == toparse[r-1,c]) {
				toparse[r,c] = (first ? "   ": "|  " )
				if (toparse[r, c+1] == dir) {
					toparse[r, c+1] = ""
				}
			}
			else {
				first = 1
			}
			
			if (nextc > cols(toparse)) continue
			if (toparse[r,nextc]!= toparse[r-1,nextc] & anyof(("|  ", "   "),toparse[r,c])) {
				toparse[r,c] = (first ? lastchild : child)
				first = 0
				if (toparse[r,c+1] == dir) {
					toparse[r, c+1] = ""
				}
			}
		}
	}
}

void mpcreate::write_tree(real scalar fh, string matrix toparse)
{
	real scalar r
	
	for(r=1; r <= rows(toparse); r++) {
		mpfput(fh, "    " + invtokens(toparse[r,.], " "))
	}
}


end
