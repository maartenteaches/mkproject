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

out = totest.findfiles("stencil")
true = J( 3, 2 , "")
true[1, 1] = `"PLUS"'
true[1, 2] = `"mp_long.mps"'
true[2, 1] = `"PLUS"'
true[2, 2] = `"mp_longt.mps"'
true[3, 1] = `"PERSONAL"'
true[3, 2] = `"mp_totest1.mps"'
assert(out == true)

end

//mpparts
mata:
totest = mpquery()
foo = "Denkend aan Holland zie ik breede rivieren traag door oneindig laagland gaan, rijen ondenkbaar ijle populieren als hooge pluimen aan den einder staat"
out = totest.mpparts(foo)

true = J( 3, 1 , "")
true[1, 1] = `"Denkend aan Holland zie ik breede rivieren traag door"'
true[2, 1] = `"oneindig laagland gaan, rijen ondenkbaar ijle"'
true[3, 1] = `"populieren als hooge pluimen aan den einder staat"'
assert(out == true)
end

//collect_reqs()
mata:
path = pathjoin(pathsubsysdir("PLUS"), "m")
path = pathjoin(path,"mp_longt.mps")
totest.mpfread(path)
totest.read_header()
totest.mpfclose(totest.reading.fh)
out = totest.collect_reqs()

true = J( 2, 8 , "")
true[1, 1] = `"req1"'
true[1, 2] = `""'
true[1, 3] = `""'
true[1, 4] = `""'
true[1, 5] = `""'
true[1, 6] = `""'
true[1, 7] = `"+"'
true[1, 8] = `"dirtree"'
true[2, 1] = `"req"'
true[2, 2] = `""'
true[2, 3] = `""'
true[2, 4] = `""'
true[2, 5] = `""'
true[2, 6] = `""'
true[2, 7] = `"+"'
true[2, 8] = `"Stata 14"'
assert(out == true)
end

//fromheader()
mata:
totest = mpquery()
out = totest.findfiles("stencil")
out = totest.fromheader("stencil", out[2,.])

true = J( 3, 8 , "")
true[1, 1] = `"main"'
true[1, 2] = `""'
true[1, 3] = `"mp_longt.mps"'
true[1, 4] = `""'
true[1, 5] = `"PLUS"'
true[1, 6] = `"based on (Long 2009)"'
true[1, 7] = `""'
true[1, 8] = `""'
true[2, 1] = `"req1"'
true[2, 2] = `""'
true[2, 3] = `""'
true[2, 4] = `""'
true[2, 5] = `""'
true[2, 6] = `""'
true[2, 7] = `"+"'
true[2, 8] = `"dirtree"'
true[3, 1] = `"req"'
true[3, 2] = `""'
true[3, 3] = `""'
true[3, 4] = `""'
true[3, 5] = `""'
true[3, 6] = `""'
true[3, 7] = `"+"'
true[3, 8] = `"Stata 14"'
assert(out == true)
end


//isdefault
mata:
totest = mpquery()
toparse = totest.findfiles("stencil")
totest.files = J(0,8,"")
temp = totest.fromheader("stencil", toparse[1,.])
totest.files = totest.files \ temp
temp = totest.fromheader("stencil", toparse[2,.])
totest.files = totest.files \ temp
temp = totest.fromheader("stencil", toparse[3,.])
totest.files = totest.files \ temp
totest.isdefault("stencil")

true = J( 5, 8 , "")
true[1, 1] = `"main"'
true[1, 2] = `"*"'
true[1, 3] = `"mp_long.mps"'
true[1, 4] = `""'
true[1, 5] = `"PLUS"'
true[1, 6] = `"based on (Long 2009)"'
true[1, 7] = `""'
true[1, 8] = `""'
true[2, 1] = `"main"'
true[2, 2] = `" "'
true[2, 3] = `"mp_longt.mps"'
true[2, 4] = `""'
true[2, 5] = `"PLUS"'
true[2, 6] = `"based on (Long 2009)"'
true[2, 7] = `""'
true[2, 8] = `""'
true[3, 1] = `"req1"'
true[3, 2] = `" "'
true[3, 3] = `""'
true[3, 4] = `""'
true[3, 5] = `""'
true[3, 6] = `""'
true[3, 7] = `"+"'
true[3, 8] = `"dirtree"'
true[4, 1] = `"req"'
true[4, 2] = `" "'
true[4, 3] = `""'
true[4, 4] = `""'
true[4, 5] = `""'
true[4, 6] = `""'
true[4, 7] = `"+"'
true[4, 8] = `"Stata 14"'
true[5, 1] = `"main"'
true[5, 2] = `" "'
true[5, 3] = `"mp_totest1.mps"'
true[5, 4] = `""'
true[5, 5] = `"PERSONAL"'
true[5, 6] = `"testing testing"'
true[5, 7] = `""'
true[5, 8] = `""'
assert(totest.files == true)
end


//file2name
mata:
totest.file2name("stencil")

true = J( 5, 8 , "")
true[1, 1] = `"main"'
true[1, 2] = `"*"'
true[1, 3] = `"mp_long.mps"'
true[1, 4] = `"long"'
true[1, 5] = `"PLUS"'
true[1, 6] = `"based on (Long 2009)"'
true[1, 7] = `""'
true[1, 8] = `""'
true[2, 1] = `"main"'
true[2, 2] = `" "'
true[2, 3] = `"mp_longt.mps"'
true[2, 4] = `"longt"'
true[2, 5] = `"PLUS"'
true[2, 6] = `"based on (Long 2009)"'
true[2, 7] = `""'
true[2, 8] = `""'
true[3, 1] = `"req1"'
true[3, 2] = `" "'
true[3, 3] = `""'
true[3, 4] = `""'
true[3, 5] = `""'
true[3, 6] = `""'
true[3, 7] = `"+"'
true[3, 8] = `"dirtree"'
true[4, 1] = `"req"'
true[4, 2] = `" "'
true[4, 3] = `""'
true[4, 4] = `""'
true[4, 5] = `""'
true[4, 6] = `""'
true[4, 7] = `"+"'
true[4, 8] = `"Stata 14"'
true[5, 1] = `"main"'
true[5, 2] = `" "'
true[5, 3] = `"mp_totest1.mps"'
true[5, 4] = `"totest1"'
true[5, 5] = `"PERSONAL"'
true[5, 6] = `"testing testing"'
true[5, 7] = `""'
true[5, 8] = `""'
assert(totest.files == true)

end

//file2path
mata:
totest.file2path()
mata:
true = J( 5, 8 , "")
true[1, 1] = `"main"'
true[1, 2] = `"*"'
true[1, 3] = `"c:\ado\plus/m\mp_long.mps"'
true[1, 4] = `"long"'
true[1, 5] = `"PLUS"'
true[1, 6] = `"based on (Long 2009)"'
true[1, 7] = `""'
true[1, 8] = `""'
true[2, 1] = `"main"'
true[2, 2] = `" "'
true[2, 3] = `"c:\ado\plus/m\mp_longt.mps"'
true[2, 4] = `"longt"'
true[2, 5] = `"PLUS"'
true[2, 6] = `"based on (Long 2009)"'
true[2, 7] = `""'
true[2, 8] = `""'
true[3, 1] = `"req1"'
true[3, 2] = `" "'
true[3, 3] = `""'
true[3, 4] = `""'
true[3, 5] = `""'
true[3, 6] = `""'
true[3, 7] = `"+"'
true[3, 8] = `"dirtree"'
true[4, 1] = `"req"'
true[4, 2] = `" "'
true[4, 3] = `""'
true[4, 4] = `""'
true[4, 5] = `""'
true[4, 6] = `""'
true[4, 7] = `"+"'
true[4, 8] = `"Stata 14"'
true[5, 1] = `"main"'
true[5, 2] = `" "'
true[5, 3] = `"c:\ado\personal/m\mp_totest1.mps"'
true[5, 4] = `"totest1"'
true[5, 5] = `"PERSONAL"'
true[5, 6] = `"testing testing"'
true[5, 7] = `""'
true[5, 8] = `""'
assert(totest.files == true)
end

//collect_info()
mata:
totest = mpquery()
totest.collect_info("stencil")
assert(totest.files == true)
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
totest.collect_info("stencil")
totest.print_table()
end