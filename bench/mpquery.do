// dupldrop()
mata:
totest = mpquery()
plus = "a" \ "b" \ "c"
personal = "b" \ "d" 
assert(totest.dupldrop(plus, personal) == ("a" \ "c"))

plus = "a" \ "b" \ "c"
personal = "d" \ "e" 
assert(totest.dupldrop(plus,personal) == ("a" \ "b" \ "c"))

plus = "a" \ "b" \ "c"
personal = "b" \ "a" \ "c" 
assert(totest.dupldrop(plus,personal) == J(0,1,""))
end

//getlab()
mata:
totest = mpquery()
path = pathjoin(pathsubsysdir("PLUS"), "m")        

files = dir(path, "files", "mp_*.mps")
assert(totest.getlab(files, "PLUS", "stencil") == (   "mp_long.mps",   "based on (Long 2009)",                   "PLUS"))


files = dir(path, "files", "mp_*.mpb")
assert(totest.getlab(files, "PLUS", "boilerplate") == ( "mp_ana.mpb",   "analysis .do file", "PLUS"  \
                                                      "mp_dta.mpb",        "data preparation",  "PLUS"  \
                                                     "mp_main.mpb",   "main project .do file",  "PLUS"  \
                                                     "mp_rlog.mpb",            "research log",  "PLUS" ))
end

//findfiles

mata:
path = pathjoin(pathsubsysdir("PLUS"), "m")
fn = pathjoin(path,"mp_totest1.mps")
unlink(fn)
fh = fopen(fn, "w")
fput(fh,"<header>")
fput(fh, "<mkproject> stencil")
fput(fh, "<version> 2.0.0")
fput(fh, "<label> testing testing")
fput(fh, "</header>")
fclose(fh)

path = pathjoin(pathsubsysdir("PERSONAL"), "m")
fn = pathjoin(path,"mp_totest1.mps")
unlink(fn)
fh = fopen(fn, "w")
fput(fh,"<header>")
fput(fh, "<mkproject> stencil")
fput(fh, "<version> 2.0.0")
fput(fh, "<label> testing testing")
fput(fh, "</header>")
fclose(fh)

totest.findfiles("stencil")
assert(totest.files == ("", "mp_long.mps"   , "", "PLUS"    , "based on (Long 2009)" \
                        "", "mp_totest1.mps", "", "PERSONAL", "testing testing" ))
end

//isdefault
mata:
totest.isdefault("stencil")
assert(totest.files == ("*", "mp_long.mps"   , "", "PLUS"    , "based on (Long 2009)" \
                        " ", "mp_totest1.mps", "", "PERSONAL", "testing testing" ))
end


//file2name
mata:
totest.file2name("stencil")
assert(totest.files == ("*", "mp_long.mps"   , "long", "PLUS"    , "based on (Long 2009)" \
                        " ", "mp_totest1.mps", "totest1", "PERSONAL", "testing testing" ))
end

//file2path
mata:
totest.file2path()
path1 = pathjoin(pathsubsysdir("PLUS"), "m\mp_long.mps")
path2 = pathjoin(pathsubsysdir("PERSONAL"), "m\mp_totest1.mps")
assert(totest.files == ("*", path1   , "long", "PLUS"    , "based on (Long 2009)" \
                        " ", path2, "totest1", "PERSONAL", "testing testing" ))
end

//collect_info()
mata:
totest = mpquery()
totest.collect_info("stencil")
assert(totest.files == ("*", path1   , "long", "PLUS"    , "based on (Long 2009)" \
                        " ", path2, "totest1", "PERSONAL", "testing testing" ))
end

//cleanup
mata:
path = pathjoin(pathsubsysdir("PERSONAL"), "m")
fn = pathjoin(path,"mp_totest1.mps")
unlink(fn)

path = pathjoin(pathsubsysdir("PLUS"), "m")
fn = pathjoin(path,"mp_totest1.mps")
unlink(fn)
end

//print
mata:
totest = mpquery()
totest.collect_info("boilerplate")
totest.print_table()
end