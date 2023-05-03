args home
// read_header
mata:
totest = mptools()
fn = "bench/test_header.txt"
totest.mpfread(fn)
totest.read_header("boilerplate")
assert(totest.reading.lnr == 5)
assert(totest.fhs.get(fh) == "open")
assert(totest.mpfget() == "some other text after the header")
assert(totest.reading.label == "something to test")
assert(totest.reading.type == "boilerplate")
assert(totest.reading.fversion == (2,0,0))
totest.mpfclose(totest.reading.fh)

fn = "bench/test_header2.txt"
totest.mpfread(fn)
totest.read_header("boilerplate", "relax")
assert(totest.reading.lnr == 3)
assert(totest.reading.label == "")
assert(totest.reading.type == "boilerplate")
assert(totest.reading.fversion == (2,0,0))
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

// write_header
mata:
totest = mptools()
totest.reading.type = "template"
totest.reading.fversion = (2,0,0)
totest.reading.label = "something interesting"
fh = totest.mpfopen("bench/test_write_header.txt", "w")
totest.write_header(fh)
totest.mpfclose(fh)

totest.mpfread(`"bench\test_write_header.txt"')
assert(totest.mpfget()==`"<header>"')
assert(totest.mpfget()==`"<mkproject> template"')
assert(totest.mpfget()==`"<version> 2.0.0"')
assert(totest.mpfget()==`"<label> something interesting"')
assert(totest.mpfget()==`"</header>"')
totest.mpfclose(totest.reading.fh)
unlink("bench/test_write_header.txt")
end

// findfile
mata:
totest = mptools()
assert(strlower(totest.find_file("certify1")) == strlower("C:\ado\plus/m\mp_certify1.txt"))
assert(strlower(totest.find_file("certify2")) == strlower("C:\ado\personal/m\mp_certify2.txt"))
end

rcof `"noisily mata: totest.find_file("certivy2")"' == 601

//parse_dir
local dir bench
local abbrev test
mata:
totest = mptools()
totest.parse_dir()
assert(strlower(pwd()) == strlower("`home'" + ":\mijn documenten\projecten\stata\mkproject\bench\test\"))
assert(strlower(totest.odir) == strlower("`home'" + ":\mijn documenten\projecten\stata\mkproject\"))
end
cd ..
rmdir test
cd ..


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
