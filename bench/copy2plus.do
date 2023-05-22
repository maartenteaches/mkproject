// copy boilerplate and stencils to PLUS

mata:

void copyfile(string scalar orig, string scalar dest)
{
    real scalar fho, fhd
    string scalar line, EOF

    EOF = J(0,0,"")
    unlink(dest)
    fho = fopen(orig, "r")
    fhd = fopen(dest, "w")
    while((line=fget(fho))!=EOF) {
        fput(fhd, line)
    }
    fclose(fho)
    fclose(fhd)
}

files = "mp_long.txt", 
        "mp_ana.txt",
        "mp_defaults.txt",
        "mp_main.txt",
        "mp_dta.txt",
        "mp_rlog.txt"

dir = pathjoin(pathsubsysdir("PLUS"),"m")

for (i=1; i<=cols(files); i++) {
    copyfile(files[i], pathjoin(dir,files[i]))
}
end
