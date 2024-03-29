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

dir = pwd()
bench = pathjoin(dir, "bench")
chdir(pathjoin(pathsubsysdir("PLUS"), "m"))
files = dir(".", "files", "mp*.mpp") \ 
        dir(".", "files", "mp*.mpb")
for(i=1; i<=rows(files); i++) {
	unlink(files[i])
}
chdir(pathjoin(pathsubsysdir("PERSONAL"), "m"))
files = dir(".", "files", "mp*.mpp") \ 
        dir(".", "files", "mp*.mpb")

for(i=1; i<=rows(files); i++) {
	path = pathjoin(bench,files[i])
	unlink(path)
	copyfile(files[i], path)
	unlink(files[i])
}
chdir(dir)

files = "mp_course.mpp", 
"mp_long.mpp",
"mp_longt.mpp",
"mp_researcht_git.mpp",
"mp_research_git.mpp",
"mp_smclpres.mpp",
"mp_ana.mpb",
"mp_excer.mpb",
"mp_excer.mpp",
"mp_dta.mpb",
"mp_dta_c.mpb",
"mp_ignore.mpb",
"mp_main.mpb",
"mp_readme.mpb",
"mp_rlog.mpb",
"mp_rlogc.mpb",
"mp_smclpres.mpb",
"mp_defaults.mpd"
		
dir = pathjoin(pathsubsysdir("PLUS"),"m")

for (i=1; i<=cols(files); i++) {
    copyfile(files[i], pathjoin(dir,files[i]))
}
end
