capture log close
log using <stub>.txt, replace text

// What this .do file does
// Who wrote it

version 17
clear all
frames reset
macro drop _all

*use <abbrev>##.dta
*datasignature confirm
*codebook, compact

// do your analysis

log close
exit
