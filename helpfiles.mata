cscript

run mkproject_main.mata

mata:


string matrix parse_tree(string matrix toparse)
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
			tdir[n] = "{help mp_ft_" + toparse[i,1] + ":" + tdir[n] + "}"
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

void create_tree(string scalar templ)
{

	class mkproject scalar totest
	string matrix dirtree, filetree, newcols, toparse
	real scalar ncolsd, ncolsf
	
	totest.project = templ
	totest.abbrev = "proj_abbrev"
	totest.read_project()

	totest.reading.fn
	
	dirtree = parse_tree(totest.dirs)
	
	toparse = totest.files
	toparse[.,2] = subinstr(totest.files[.,2], "/", "\")
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
	dirtree = sort(dirtree \ filetree, (1..max((ncolsd, ncolsf))))
	dirtree = J(rows(dirtree), 1, (totest.abbrev, "/")), dirtree
	dirtree = ("proj_abbrev", "/", J(1,cols(dirtree)-2,"")) \ dirtree
	decorate_tree(dirtree)
	trdisplay(dirtree)
}

void decorate_tree(string matrix toparse)
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

void trdisplay(string matrix toparse)
{
	real scalar r
	
	for(r=1; r <= rows(toparse); r++) {
		printf("    " + invtokens(toparse[r,.], " ") + "\n")
	}
}

create_tree("research_git")
end