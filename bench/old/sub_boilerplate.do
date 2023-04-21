cscript "sub-routines in boilerplate.ado"

run boilerplate.ado

//normaldo
normaldo, stub("boo_dta01") abbrev("boo") fn(bench/boo_dta01.do) dta

tempname fh
file open `fh' using `"bench/boo_dta01.do"', read text
file read `fh' line
assert `"`line'"'==`"capture log close"'
file read `fh' line
assert `"`line'"'==`"log using boo_dta01.txt, replace text"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"// What this .do file does"'
file read `fh' line
assert `"`line'"'==`"// Who wrote it"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"version `c(stata_version)'"'
file read `fh' line
assert `"`line'"'==`"clear all"'
file read `fh' line
assert `"`line'"'==`"macro drop _all"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"*use ../posted/data/<original_data_file.dta>"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"*rename *, lower"'
file read `fh' line
assert `"`line'"'==`"*keep"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"// prepare data"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"*compress"'
file read `fh' line
assert `"`line'"'==`"*note: boo##.dta \ <description> \ boo_dta01.do \ <author> TS "'
file read `fh' line
assert `"`line'"'==`"*label data <description>"'
file read `fh' line
assert `"`line'"'==`"*datasignature set, reset"'
file read `fh' line
assert `"`line'"'==`"*save boo##.dta, replace"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"log close"'
file read `fh' line
assert `"`line'"'==`"exit"'
file read `fh' line
assert r(eof)==1
file close `fh'
erase bench/boo_dta01.do 

normaldo, stub("boo_dta01") abbrev("boo") fn(bench/boo_dta01.do) dta git

tempname fh
file open `fh' using `"bench/boo_dta01.do"', read text
file read `fh' line
assert `"`line'"'==`"capture log close"'
file read `fh' line
assert `"`line'"'==`"log using boo_dta01.txt, replace text"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"// What this .do file does"'
file read `fh' line
assert `"`line'"'==`"// Who wrote it"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"version `c(stata_version)'"'
file read `fh' line
assert `"`line'"'==`"clear all"'
file read `fh' line
assert `"`line'"'==`"macro drop _all"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"*use ../protected/data/<original_data_file.dta>"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"*rename *, lower"'
file read `fh' line
assert `"`line'"'==`"*keep"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"// prepare data"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"*compress"'
file read `fh' line
assert `"`line'"'==`"*note: boo##.dta \ <description> \ boo_dta01.do \ <author> TS "'
file read `fh' line
assert `"`line'"'==`"*label data <description>"'
file read `fh' line
assert `"`line'"'==`"*datasignature set, reset"'
file read `fh' line
assert `"`line'"'==`"*save boo##.dta, replace"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"log close"'
file read `fh' line
assert `"`line'"'==`"exit"'
file read `fh' line
assert r(eof)==1
file close `fh'
erase bench/boo_dta01.do

normaldo, stub("boo_ana01") abbrev("boo") fn(bench/boo_ana01.do) ana
tempname fh
file open `fh' using `"bench/boo_ana01.do"', read text
file read `fh' line
assert `"`line'"'==`"capture log close"'
file read `fh' line
assert `"`line'"'==`"log using boo_ana01.txt, replace text"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"// What this .do file does"'
file read `fh' line
assert `"`line'"'==`"// Who wrote it"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"version `c(stata_version)'"'
file read `fh' line
assert `"`line'"'==`"clear all"'
file read `fh' line
assert `"`line'"'==`"macro drop _all"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"*use boo##.dta"'
file read `fh' line
assert `"`line'"'==`"*datasignature confirm"'
file read `fh' line
assert `"`line'"'==`"*codebook, compact"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"// do your analysis"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"log close"'
file read `fh' line
assert `"`line'"'==`"exit"'
file read `fh' line
assert r(eof)==1
file close `fh'
erase bench/boo_ana01.do

normaldo, stub("boo_ana01") abbrev("boo") fn(bench/boo_ana01.do) ana git
tempname fh
file open `fh' using `"bench/boo_ana01.do"', read text
file read `fh' line
assert `"`line'"'==`"capture log close"'
file read `fh' line
assert `"`line'"'==`"log using boo_ana01.txt, replace text"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"// What this .do file does"'
file read `fh' line
assert `"`line'"'==`"// Who wrote it"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"version `c(stata_version)'"'
file read `fh' line
assert `"`line'"'==`"clear all"'
file read `fh' line
assert `"`line'"'==`"macro drop _all"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"*use boo##.dta"'
file read `fh' line
assert `"`line'"'==`"*datasignature confirm"'
file read `fh' line
assert `"`line'"'==`"*codebook, compact"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"// do your analysis"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"log close"'
file read `fh' line
assert `"`line'"'==`"exit"'
file read `fh' line
assert r(eof)==1
file close `fh'
erase bench/boo_ana01.do

//smcldo
smcldo, fn(bench/pres.do)

tempname fh
file open `fh' using `"bench/pres.do"', read text
file read `fh' line
assert `"`line'"'==`"//version #.#.#"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"//layout toc"'
file read `fh' line
assert `"`line'"'==`"//toctitle"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"//titlepage --------------------------------------------------------------------"'
file read `fh' line
assert `"`line'"'==`"//title "'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"/*txt"'
file read `fh' line
assert `"`line'"'==`"{center:Author}"'
file read `fh' line
assert `"`line'"'==`"{center:institution}"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"{center:email}"'
file read `fh' line
assert `"`line'"'==`"txt*/"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"//endtitlepage -----------------------------------------------------------------"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"//section ......................................................................"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"//slide ------------------------------------------------------------------------"'
file read `fh' line
assert `"`line'"'==`"//title "'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"/*txt"'
file read `fh' line
assert `"`line'"'==`"{pstd}"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"txt*/"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"//ex"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"//endex"'
file read `fh' line
assert `"`line'"'==`""'
file read `fh' line
assert `"`line'"'==`"//slide ------------------------------------------------------------------------"'
file read `fh' line
assert r(eof)==1
file close `fh'
erase bench/pres.do

//Parsdirs
mata: Parsedirs("c:\mijn documenten\project_en\stata\sug\bern.2022/foo_bar.22_01.do")
assert "`fn'" == ""
assert "`stub'" == "foo_bar.22_01"
assert "`abbrev'" == "foo_bar.22"

mata: Parsedirs("c:\mijn documenten\project_en\stata\sug\bern.2022/foo_bar22_01")
assert "`fn'" == "c:\mijn documenten\project_en\stata\sug\bern.2022/foo_bar22_01.do"
assert "`stub'" == "foo_bar22_01"
assert "`abbrev'" == "foo_bar22"