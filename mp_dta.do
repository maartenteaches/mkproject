<header>
<mkproject> boilerplate
<version> 2.0.0
<label> data preparation
</header>
capture log close
log using <stub>.txt, replace text

// What this .do file does
// Who wrote it

version <stata_version>
clear all
<as of 16>frames reset
macro drop _all

*use ../posted/data/[original_data_file.dta]

*rename *, lower
*keep

// prepare data

*gen some_var = ...
*note some_var: based on [original vars] \ <fn> \ [author] TS

*compress
*note: <abbrev>##.dta \ [description] \ <fn> \ [author] TS 
*label data [description]
*datasignature set, reset
*save <abbrev>##.dta, replace

log close
exit
