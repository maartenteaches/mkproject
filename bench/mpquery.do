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
fn = pathjoin(path,"mp_totest1.mpp")
unlink(fn)
fh = fopen(fn, "w")
fput(fh,"<header>")
fput(fh, "<mkproject> project")
fput(fh, "<version> 2.0.0")
fput(fh, "<label> testing testing")
fput(fh, "</header>")
fclose(fh)

path = pathjoin(pathsubsysdir("PERSONAL"), "m")
fn = pathjoin(path,"mp_totest1.mpp")
unlink(fn)
fh = fopen(fn, "w")
fput(fh,"<header>")
fput(fh, "<mkproject> project")
fput(fh, "<version> 2.0.0")
fput(fh, "<label> testing testing")
fput(fh, "</header>")
fclose(fh)

out = totest.findfiles("project")
true = J( 8, 2 , "")
true[1, 1] = `"c:\ado\plus/m"'
true[1, 2] = `"mp_course.mpp"'
true[2, 1] = `"c:\ado\plus/m"'           
true[2, 2] = `"mp_excer.mpp"' 
true[3, 1] = `"c:\ado\plus/m"'
true[3, 2] = `"mp_long.mpp"'
true[4, 1] = `"c:\ado\plus/m"'
true[4, 2] = `"mp_longt.mpp"'
true[5, 1] = `"c:\ado\plus/m"'
true[5, 2] = `"mp_research_git.mpp"'
true[6, 1] = `"c:\ado\plus/m"'
true[6, 2] = `"mp_researcht_git.mpp"'
true[7, 1] = `"c:\ado\plus/m"'
true[7, 2] = `"mp_smclpres.mpp"'
true[8, 1] = `"c:\ado\personal/m"'
true[8, 2] = `"mp_totest1.mpp"'

assert(out == true)

end

// parsefiles()
mata:
totest = mpquery()
out = totest.findfiles("project")
totest.parsefiles("project", out)
assert(rows(totest.files)==8)
assert(totest.files[1].name == "course")
assert(totest.files[2].name == "excer")
assert(totest.files[3].name == "long")
assert(totest.files[4].name == "longt")
assert(totest.files[5].name == "research_git")
assert(totest.files[6].name == "researcht_git")
assert(totest.files[7].name == "smclpres")
assert(totest.files[8].name == "totest1")
assert(totest.files[1].path == "c:\ado\plus/m\mp_course.mpp")
assert(totest.files[2].path == "c:\ado\plus/m\mp_excer.mpp")
assert(totest.files[3].path == "c:\ado\plus/m\mp_long.mpp")
assert(totest.files[4].path == "c:\ado\plus/m\mp_longt.mpp")
assert(totest.files[5].path == "c:\ado\plus/m\mp_research_git.mpp")
assert(totest.files[6].path == "c:\ado\plus/m\mp_researcht_git.mpp")
assert(totest.files[7].path == "c:\ado\plus/m\mp_smclpres.mpp")
assert(totest.files[8].path == "c:\ado\personal/m\mp_totest1.mpp")
end

//file2name()
mata:
totest = mpquery()
assert(totest.file2name("mp_bla_blÜp3.mpp", "project")=="bla_blÜp3")
assert(totest.file2name("mp_dta.mpb", "boilerplate")=="dta")
end

//fromheader()
mata:
totest = mpquery()
out = totest.findfiles("project")
totest.parsefiles("project", out)
totest.fromheader()

assert(totest.files[1].lab == "Small research project as part of a course")
assert(totest.files[2].lab == "excercise for a course")
assert(totest.files[3].lab == "based on (Long 2009)")
assert(totest.files[4].lab == "based on (Long 2009), display project with dirtree")
assert(totest.files[5].lab == "Research with git")
assert(totest.files[6].lab == "Research project with git, display project with dirtree")
assert(totest.files[7].lab == "a smclpres presentation project")
assert(totest.files[8].lab == "testing testing")

assert(totest.files[1].reqs == "dirtree")
assert(totest.files[2].reqs == J(0,1,""))
assert(totest.files[3].reqs == J(0,1,""))
assert(totest.files[4].reqs == "dirtree")
assert(totest.files[5].reqs == "git")
assert(totest.files[6].reqs == ("git" \ "dirtree" ))
assert(totest.files[7].reqs == "smclpres")
assert(totest.files[8].reqs == J(0,1,""))

assert(totest.files[1].met == "+")
assert(totest.files[2].met == J(0,1,""))
assert(totest.files[3].met == J(0,1,""))
assert(totest.files[4].met == "+")
assert(totest.files[5].met == "/")
assert(totest.files[6].met == ("/" \ "+"))
assert(totest.files[7].met == "+")
assert(totest.files[8].met == J(0,1,""))

end

//collect_reqs()
mata:
path = pathjoin(pathsubsysdir("PLUS"), "m")
path = pathjoin(path,"mp_longt.mpp")
totest.mpfread(path)
totest.read_header()
totest.mpfclose(totest.reading.fh)
totest.collect_reqs() == "+"

end

//isdefault
mata:
totest = mpquery()
toparse = totest.findfiles("project")
totest.parsefiles("project", toparse)
totest.fromheader()
totest.isdefault("project")
assert(totest.files[1].isdefault == " ")
assert(totest.files[2].isdefault == " ")
assert(totest.files[3].isdefault == "*")
assert(totest.files[4].isdefault == " ")
assert(totest.files[5].isdefault == " ")
assert(totest.files[6].isdefault == " ")
assert(totest.files[7].isdefault == " ")
assert(totest.files[8].isdefault == " ")
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
totest.collect_info("project")
assert(totest.files[1].name == "course")
assert(totest.files[2].name == "excer")
assert(totest.files[3].name == "long")
assert(totest.files[4].name == "longt")
assert(totest.files[5].name == "research_git")
assert(totest.files[6].name == "researcht_git")
assert(totest.files[7].name == "smclpres")
assert(totest.files[8].name == "totest1")

assert(totest.files[1].path == "c:\ado\plus/m\mp_course.mpp")
assert(totest.files[2].path == "c:\ado\plus/m\mp_excer.mpp")
assert(totest.files[3].path == "c:\ado\plus/m\mp_long.mpp")
assert(totest.files[4].path == "c:\ado\plus/m\mp_longt.mpp")
assert(totest.files[5].path == "c:\ado\plus/m\mp_research_git.mpp")
assert(totest.files[6].path == "c:\ado\plus/m\mp_researcht_git.mpp")
assert(totest.files[7].path == "c:\ado\plus/m\mp_smclpres.mpp")
assert(totest.files[8].path == "c:\ado\personal/m\mp_totest1.mpp")

assert(totest.files[1].isdefault == " ")
assert(totest.files[2].isdefault == " ")
assert(totest.files[3].isdefault == "*")
assert(totest.files[4].isdefault == " ")
assert(totest.files[5].isdefault == " ")
assert(totest.files[6].isdefault == " ")
assert(totest.files[7].isdefault == " ")
assert(totest.files[8].isdefault == " ")

assert(totest.files[1].lab == "Small research project as part of a course")
assert(totest.files[2].lab == "excercise for a course")
assert(totest.files[3].lab == "based on (Long 2009)")
assert(totest.files[4].lab == "based on (Long 2009), display project with dirtree")
assert(totest.files[5].lab == "Research with git")
assert(totest.files[6].lab == "Research project with git, display project with dirtree")
assert(totest.files[7].lab == "a smclpres presentation project")
assert(totest.files[8].lab == "testing testing")

assert(totest.files[1].reqs == "dirtree")
assert(totest.files[2].reqs == J(0,1,""))
assert(totest.files[3].reqs == J(0,1,""))
assert(totest.files[4].reqs == "dirtree")
assert(totest.files[5].reqs == "git")
assert(totest.files[6].reqs == ("git" \ "dirtree" ))
assert(totest.files[7].reqs == "smclpres")
assert(totest.files[8].reqs == J(0,1,""))

assert(totest.files[1].met == "+")
assert(totest.files[2].met == J(0,1,""))
assert(totest.files[3].met == J(0,1,""))
assert(totest.files[4].met == "+")
assert(totest.files[5].met == "/")
assert(totest.files[6].met == ("/" \ "+"))
assert(totest.files[7].met == "+")
assert(totest.files[8].met == J(0,1,""))
end

// parse_names
mata:
totest = mpquery()
totest.collect_info("project")
bigestl=2 
totest.parse_names(4, bigestl)
assert(totest.files[4].name == `"  {view "c:\ado\plus/m\mp_longt.mpp":lo~t}"')
assert(bigestl == 4)
end

//parse_req()
mata:
totest = mpquery()
totest.collect_info("project")
bigestl = 4
assert(totest.parse_req(4,1,5, bigestl) == `"+ {help dirtree:dir~e}"')
assert(bigestl==5)
end

//parse_reqs()
mata:
totest = mpquery()
totest.collect_info("project")
bigestl = 6
totest.parse_reqs(10,bigestl)
assert(totest.files[1].reqs[1] == `"+ {help dirtree:dirtree}"')
assert(rows(totest.files[2].reqs) == 0)
assert(rows(totest.files[3].reqs) == 0)
assert(totest.files[4].reqs[1] == `"+ {help dirtree:dirtree}"')
assert(totest.files[5].reqs[1] ==`"/ {browse "https://git-scm.com/":git}"')
assert(totest.files[6].reqs[1] ==`"/ {browse "https://git-scm.com/":git}"')
assert(totest.files[6].reqs[2] == `"+ {help dirtree:dirtree}"')
assert(totest.files[7].reqs[1] == `"+ {help smclpres:smclpres}"')
assert(rows(totest.files[8].reqs) == 0)
assert(bigestl==8)
end

//setup_table()
mata:
totest = mpquery()
totest.collect_info("project")
totest.setup_table()
assert(totest.cname == "{txt}{col 3}")
assert(totest.creq == "{col 17}")
assert(totest.clab == "{col 28}")
assert(totest.files[1].name == `"  {view "c:\ado\plus/m\mp_course.mpp":course}"')
assert(totest.files[1].reqs[1] == `"+ {help dirtree:dirtree}"')
end

//cleanup
mata:
path = pathjoin(pathsubsysdir("PERSONAL"), "m")
fn = pathjoin(path,"mp_totest1.mpp")
unlink(fn)

path = pathjoin(pathsubsysdir("PLUS"), "m")
fn = pathjoin(path,"mp_totest1.mpp")
unlink(fn)
end

//print
mata:
totest = mpquery()
totest.collect_info("project")
totest.print_table()
end