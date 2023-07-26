args home
// read_header
mata:
totest = mptools()
fn = "bench/test_header.txt"
totest.mpfread(fn)
totest.read_header()
assert(totest.reading.lnr == 7)
assert(totest.fhs.get(totest.reading.fh) == "open")
assert(totest.mpfget() == "some other text after the header")
assert(totest.reading.label == "something to test")
assert(totest.reading.type == "boilerplate")
assert(totest.reading.reqs == ("Stata 14" \ "dirtree"))
assert(totest.reading.sversion == "2.0.0")
totest.mpfclose(totest.reading.fh)

fn = "bench/test_header2.txt"
totest.mpfread(fn)
totest.read_header()
assert(totest.reading.lnr == 3)
assert(totest.reading.label == "")
assert(totest.reading.type == "")
assert(totest.reading.sversion == "")
assert(totest.fhs.get(totest.reading.fh) == "closed")

totest.mpfread(fn)
end

rcof `"noisily mata: totest.read_header("boilerplate")"' == 198

mata:
assert(totest.fhs.get(totest.reading.fh) == "closed")
fn = "bench/test_header3.txt"
totest.mpfread(fn)
end

rcof `"noisily mata: totest.read_header("boilerplate")"' == 198

mata:
assert(totest.fhs.get(totest.reading.fh) == "closed")
fn = "bench/test_header4.txt"
totest.mpfread(fn)
end

rcof `"noisily mata: totest.read_header("boilerplate")"' == 198

mata:
assert(totest.fhs.get(totest.reading.fh) == "closed")
end

//type2ext()
mata:
totest = mptools()
assert(totest.type2ext("boilerplate") == ".mpb")
assert(totest.type2ext("stencil") == ".mps")
assert(totest.type2ext("default") == ".mpd")
end
rcof `"noisily mata:totest.type2ext("foo")"' == 198

// findfile
mata:
fn = pathjoin(pathsubsysdir("PLUS"), "m\mp_certify1.mps")
unlink(fn)
fh = fopen(fn,"w")
fput(fh, "<header>")
fput(fh, "<mkproject> stencil")
fput(fh, "<version> 2.0.0")
fput(fh, "<label> used for certifying")
fput(fh, "</header>")
fclose(fh)
totest = mptools()
true = strlower(pathjoin(pathsubsysdir("PLUS"), "m\mp_certify1.mps"))
assert(strlower(totest.find_file("certify1", "stencil")) == true)
unlink(fn)

fn = pathjoin(pathsubsysdir("PLUS"), "m\mp_certify2.mpb")
unlink(fn)
fh = fopen(fn,"w")
fput(fh, "<header>")
fput(fh, "<mkproject> boilerplate")
fput(fh, "<version> 2.0.0")
fput(fh, "<label> used for certifying")
fput(fh, "</header>")
fclose(fh)

fn2 = pathjoin(pathsubsysdir("PERSONAL"), "m\mp_certify2.mpb")
unlink(fn2)
fh = fopen(fn2,"w")
fput(fh, "<header>")
fput(fh, "<mkproject> boilerplate")
fput(fh, "<version> 2.0.0")
fput(fh, "<label> used for certifying")
fput(fh, "</header>")
fclose(fh)

true = strlower(pathjoin(pathsubsysdir("PERSONAL"), "m\mp_certify2.mpb"))
true2 = strlower(pathjoin(pathsubsysdir("PLUS"), "m\mp_certify2.mpb"))
assert(strlower(totest.find_file("certify2", "boilerplate")) == true)
assert(strlower(totest.find_file("certify2", "boilerplate", "PLUS")) == true2)
unlink(fn)
unlink(fn2)
end

rcof `"noisily mata: totest.find_file("certivy2", "boilerplate")"' == 601

// graceful_exit
mata:
orig = pwd()
totest = mptools()
chdir("bench")
fh1 = totest.mpfopen("test_header.txt", "r")
fh2 = totest.mpfopen("test_header2.txt", "r")
totest.graceful_exit()
assert(pwd()==orig)
assert(totest.fhs.get(fh1)== "closed")
assert(totest.fhs.get(fh2)== "closed")
end


//write_header()
mata:
totest = mptools()
totest.reading.type = "boilerplate"
totest.reading.fversion = (2,0,0)
totest.reading.label = "bla blup"
fn = "bench/write_header.txt"
unlink(fn)
fh = fopen(fn, "w")
totest.write_header(fh)
fclose(fh)

fh = fopen(`"bench\write_header.txt"', "r")
assert(fget(fh)==`"<header>"')
assert(fget(fh)==`"<mkproject> boilerplate"')
assert(fget(fh)==`"<version> 2.0.0"')
assert(fget(fh)==`"<label> bla blup"')
assert(fget(fh)==`"</header>"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink(fn)
end

//_chkreq()
mata:
totest = mptools()
assert(totest._chkreq("Stata 1") == 1)
assert(totest._chkreq("Stata 500") == 0)
assert(totest._chkreq("git") == -1)
assert(totest._chkreq("dirtree")==1)
end

//chkreqs()
mata:
totest = mptools()
fn = "bench/test_header.txt"
totest.mpfread(fn)
totest.read_header()
totest.mpfclose(totest.reading.fh)
totest.chkreqs()
totest.reading.reqs = ("foo" \ "bar")
end
capture noisily mata: totest.chkreqs()
assert(_rc == 198)

//mppathgetparent()
mata:
totest = mptools()
assert(totest.mppathgetparent("c:\test\blup") == "c:\test\")
assert(totest.mppathgetparent("c:\test\blup\") == "c:\test\blup\")
assert(totest.mppathgetparent("c:\test/blup") == "c:\test/")
end
