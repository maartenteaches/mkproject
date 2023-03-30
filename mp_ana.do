<mkproject boilerplate>
<version> 2.0.0
capture log close
log using <stub>.txt, replace text

// What this .do file does
// Who wrote it

version <stata_version>
clear all
<as of 16>frames reset
macro drop _all

*use <abbrev>##.dta
*datasignature confirm
*codebook, compact

// do your analysis

log close
exit