*! version 1.0.0 MLB
program define mkproject
	version 10
	syntax name(id="project abreviation" name=abrev), ///
	       DIRectory(string)

	qui cd `"`directory'"'
	if `"`: dir . dirs "bla"'"' != "" {
	    di as err "directory " as result `"`abrev'"' as err " already exists in " as result `"`directory'"'
		exit 693
	}
	mkdir `abrev'
	mkdir `abrev'/docu
	mkdir `abrev'/admin
	mkdir `abrev'/posted
	mkdir `abrev'/posted/data
	mkdir `abrev'/work
	
	qui cd `abrev'/work
	write_main `abrev'
	write_do `abrev'
	qui cd ../docu
	write_log 
	cd ../work
	doedit `abrev'_main.do 
end

program define write_main
	syntax name(id="project abreviation" name=abrev)
	
	local fn = "`abrev'_main.do"
	tempname main
	file open `main' using `fn', write text
	file write `main' "clear all"_n
	file write `main' "macro drop _all"_n
	file write `main' `"cd "`c(pwd)'""'_n
	file write `main' _n
	file write `main' "do `abrev'_dta01.do // some comment"_n
	file write `main' "do `abrev'_ana01.do // some comment"_n
	file write `main' _n
	file write `main' "exit"_n
	file close `main'
end

program define write_do
	syntax name(id="project abreviation" name=abrev)
	
	local fn = "`abrev'_dta01.do"
	tempname dta
	file open  `dta' using `fn', write text
	file write `dta' "capture log close"_n
	file write `dta' "log using `abrev'_dta01.txt, replace text"_n
	file write `dta' _n
	file write `dta' "// What this .do file does"_n
	file write `dta' "// Who wrote it"_n
	file write `dta' _n
	file write `dta' "version `c(stata_version)'"_n
	file write `dta' "clear all"_n
	file write `dta' "macro drop _all"_n
	file write `dta' _n
	file write `dta' "// use ../posted/data/<original_data_file.dta>"_n
	file write `dta' _n
	file write `dta' "// prepare data"_n
	file write `dta' _n
	file write `dta' "// compress"_n
	file write `dta' "// note: `abrev'01.dta \ <description> \ `abrev'_dta01.do \ <author> TS "_n
	file write `dta' "// label data"_n
	file write `dta' "// datasignature set, reset"_n
	file write `dta' "// save `abrev'01.dta, replace"_n
	file write `dta' _n
	file write `dta' "log close"_n
	file write `dta' "exit"_n
	file close `dta'
	
	local fn = "`abrev'_ana01.do"
	tempname ana
	file open  `ana' using `fn', write text
	file write `ana' "capture log close"_n
	file write `ana' "log using `abrev'_ana01.txt, replace text"_n
	file write `ana' _n
	file write `ana' "// What this .do file does"_n
	file write `ana' "// Who wrote it"_n
	file write `ana' _n
	file write `ana' "version `c(stata_version)'"_n
	file write `ana' "clear all"_n
	file write `ana' "macro drop _all"_n
	file write `ana' _n
	file write `ana' "// use `abrev'01.dta"_n
	file write `ana' "// datasignature confirm"_n
	file write `ana' "// codebook, compact"_n
	file write `ana' _n
	file write `ana' "// do your analysis"_n
	file write `ana' _n
	file write `ana' "log close"_n
	file write `ana' "exit"_n
	file close `ana'
end

program define write_log
	local fn = "research_log.txt"
	tempname log
	file open  `log' using `fn', write text
	file write `log' "============================"_n
	file write `log' "Research log: <Project name>"_n
	file write `log' "============================"_n
	file write `log' _n _n
	file write `log' "`c(current_date)': Preliminaries"_n
	file write `log' "=========================="_n
	file write `log' _n
	file write `log' "Author(s):"_n
	file write `log' "----------"_n
	file write `log' "Authors with affiliation and email"_n
	file write `log' _n _n
	file write `log' "Preliminary research question:"_n
	file write `log' "------------------------------"_n
	file write `log' _n _n
	file write `log' "Data:"_n
	file write `log' "-----"_n
	file write `log' "data, where and how to get it, when we got it, version"_n
	file write `log' _n _n
	file write `log' "Intended conference:"_n
	file write `log' "--------------------"_n
	file write `log' "conference, deadline"_n
	file write `log' _n _n
	file write `log' "Intended journal:"_n
	file write `log' "-----------------"_n
	file write `log' "journal, requirements, e.g. max word count"_n
end
