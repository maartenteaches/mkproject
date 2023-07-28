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
true = J( 7, 2 , "")
true[1, 1] = `"c:\ado\plus/m"'
true[1, 2] = `"mp_course.mps"'
true[2, 1] = `"c:\ado\plus/m"'
true[2, 2] = `"mp_long.mps"'
true[3, 1] = `"c:\ado\plus/m"'
true[3, 2] = `"mp_longt.mps"'
true[4, 1] = `"c:\ado\plus/m"'
true[4, 2] = `"mp_research_git.mps"'
true[5, 1] = `"c:\ado\plus/m"'
true[5, 2] = `"mp_researcht_git.mps"'
true[6, 1] = `"c:\ado\plus/m"'
true[6, 2] = `"mp_smclpres.mps"'
true[7, 1] = `"c:\ado\personal/m"'
true[7, 2] = `"mp_totest1.mps"'

assert(out == true)

end

// parsefiles()
mata:
totest = mpquery()
out = totest.findfiles("stencil")
totest.parsefiles("stencil", out)
assert(rows(totest.files)==7)
assert(totest.files[1].name == "course")
assert(totest.files[2].name == "long")
assert(totest.files[3].name == "longt")
assert(totest.files[4].name == "research_git")
assert(totest.files[5].name == "researcht_git")
assert(totest.files[6].name == "smclpres")
assert(totest.files[7].name == "totest1")
assert(totest.files[1].path == "c:\ado\plus/m\mp_course.mps")
assert(totest.files[2].path == "c:\ado\plus/m\mp_long.mps")
assert(totest.files[3].path == "c:\ado\plus/m\mp_longt.mps")
assert(totest.files[4].path == "c:\ado\plus/m\mp_research_git.mps")
assert(totest.files[5].path == "c:\ado\plus/m\mp_researcht_git.mps")
assert(totest.files[6].path == "c:\ado\plus/m\mp_smclpres.mps")
assert(totest.files[7].path == "c:\ado\personal/m\mp_totest1.mps")
end

//file2name()
mata:
totest = mpquery()
assert(totest.file2name("mp_bla_blÜp3.mps", "stencil")=="bla_blÜp3")
assert(totest.file2name("mp_dta.mpb", "boilerplate")=="dta")
end

//fromheader()
mata:
totest = mpquery()
out = totest.findfiles("stencil")
totest.parsefiles("stencil", out)
totest.fromheader()

assert(totest.files[1].lab == "Small research project as part of a course")
assert(totest.files[2].lab == "based on (Long 2009)")
assert(totest.files[3].lab == "based on (Long 2009), display project with dirtree")
assert(totest.files[4].lab == "Research with git")
assert(totest.files[5].lab == "Research project with git, display project with dirtree")
assert(totest.files[6].lab == "a smclpres presentation project")
assert(totest.files[7].lab == "testing testing")

assert(totest.files[1].reqs == "dirtree")
assert(totest.files[2].reqs == J(0,1,""))
assert(totest.files[3].reqs == "dirtree")
assert(totest.files[4].reqs == "git")
assert(totest.files[5].reqs == ("git" \ "dirtree" ))
assert(totest.files[6].reqs == "smclpres")
assert(totest.files[7].reqs == J(0,1,""))

assert(totest.files[1].met == "+")
assert(totest.files[2].met == J(0,1,""))
assert(totest.files[3].met == "+")
assert(totest.files[4].met == "/")
assert(totest.files[5].met == ("/" \ "+"))
assert(totest.files[6].met == "+")
assert(totest.files[7].met == J(0,1,""))

end

//collect_reqs()
mata:
path = pathjoin(pathsubsysdir("PLUS"), "m")
path = pathjoin(path,"mp_longt.mps")
totest.mpfread(path)
totest.read_header()
totest.mpfclose(totest.reading.fh)
totest.collect_reqs() == "+"

end

//isdefault
mata:
totest = mpquery()
toparse = totest.findfiles("stencil")
totest.parsefiles("stencil", toparse)
totest.fromheader()
totest.isdefault("stencil")
assert(totest.files[1].isdefault == " ")
assert(totest.files[2].isdefault == "*")
assert(totest.files[3].isdefault == " ")
assert(totest.files[4].isdefault == " ")
assert(totest.files[5].isdefault == " ")
assert(totest.files[6].isdefault == " ")
assert(totest.files[7].isdefault == " ")
end


//mpparts
mata:
totest = mpquery()
foo = "Denkend aan Holland zie ik breede rivieren traag door oneindig laagland gaan, rijen ondenkbaar ijle populieren als hooge pluimen aan den einder staat"
out = totest.mpparts(foo, 25)


true = J( 7, 1 , "")
true[1, 1] = `"Denkend aan Holland zie"'
true[2, 1] = `"ik breede rivieren traag"'
true[3, 1] = `"door oneindig laagland"'
true[4, 1] = `"gaan, rijen ondenkbaar"'
true[5, 1] = `"ijle populieren als hooge"'
true[6, 1] = `"pluimen aan den einder"'
true[7, 1] = `"staat"'

assert(out == true)
end

// truncstring()
mata:
totest = mpquery()
longstring = "DènkendaanHollandzieikbreederivierentraagdooroneindiglaaglandgaan"
assert(totest.truncstring(longstring, 10) == "Dènkenda~n")
end

//collect_info()
mata:
totest = mpquery()
totest.collect_info("stencil")
assert(totest.files[1].isdefault=="*")
assert(totest.files[1].path     ==pathjoin(pathsubsysdir("PLUS"),"m\mp_long.mps"))
assert(totest.files[1].name     == "long")
assert(totest.files[1].lab      == "based on (Long 2009)")
assert(totest.files[1].met      == J(0,1,""))
assert(totest.files[1].reqs     == J(0,1,""))

assert(totest.files[2].isdefault==" ")
assert(totest.files[2].path     ==pathjoin(pathsubsysdir("PLUS"),"m\mp_longt.mps"))
assert(totest.files[2].name     == "longt")
assert(totest.files[2].lab      == "based on (Long 2009)")
assert(totest.files[2].met      == J(2,1,"+"))
assert(totest.files[2].reqs     == ("dirtree"\ "Stata 14"))

assert(totest.files[3].isdefault==" ")
assert(totest.files[3].path     ==pathjoin(pathsubsysdir("PERSONAL"),"m\mp_totest1.mps"))
assert(totest.files[3].name     == "totest1")
assert(totest.files[3].lab      == "testing testing")
assert(totest.files[3].met      == J(0,1,""))
assert(totest.files[3].reqs     == J(0,1,""))
end

// parse_names
mata:
totest = mpquery()
totest.collect_info("stencil")
bigestl=2 
totest.parse_names(4, bigestl)
assert(totest.files[2].name == `"  {view "c:\ado\plus/m\mp_longt.mps":lo~t}"')
assert(bigestl == 4)
end

//parse_req()
mata:
totest = mpquery()
totest.collect_info("stencil")
bigestl = 4
assert(totest.parse_req(2,1,5, bigestl) == `"+ {help dirtree:dir~e}"')
assert(bigestl==5)
end

//parse_reqs()
mata:
totest = mpquery()
totest.collect_info("stencil")
bigestl = 6
totest.parse_reqs(10,bigestl)
assert(totest.files[2].reqs[1] == `"+ {help dirtree:dirtree}"')
assert(totest.files[2].reqs[2] == `"+ Stata 14"')
assert(bigestl==8)
end

//setup_table()
mata:
totest = mpquery()
totest.collect_info("stencil")
totest.setup_table()
assert(totest.cname == "{txt}{col 3}")
assert(totest.creq == "{col 11}")
assert(totest.clab == "{col 22}")
assert(totest.files[2].name == `"  {view "c:\ado\plus/m\mp_longt.mps":longt}"')
assert(totest.files[2].reqs[1] == `"+ {help dirtree:dirtree}"')
assert(totest.files[2].reqs[2] == `"+ Stata 14"')
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