args home
// read_header
mata:
totest = mptools()
fn = "bench/test_header.txt"
fh = totest.mpfopen(fn, "r")
totest.read_header(fh, fn, "boilerplate")
assert(totest.fhs.get(fh) == "open")
assert(totest.mpfget(fh) == "some other text after the header")
assert(totest.header_label == "something to test")
assert(totest.header_type == "boilerplate")
assert(totest.header_version == (2,0,0))
totest.mpfclose(fh)

fn = "bench/test_header2.txt"
fh = totest.mpfopen(fn, "r")
totest.read_header(fh,fn, "boilerplate", "relax")
assert(totest.header_label == "something to test")
assert(totest.header_type == "boilerplate")
assert(totest.header_version == (2,0,0))
assert(totest.fhs.get(fh) == "closed")

fh = totest.mpfopen(fn, "r")
end

rcof `"noisily mata: totest.read_header(fh, fn, "boilerplate")"' == 198

mata:
assert(totest.fhs.get(fh) == "closed")
fn = "bench/test_header3.txt"
fh = totest.mpfopen(fn, "r")
end

rcof `"noisily mata: totest.read_header(fh, fn, "boilerplate")"' == 198

mata:
assert(totest.fhs.get(fh) == "closed")
fn = "bench/test_header4.txt"
fh = totest.mpfopen(fn, "r")
end

rcof `"noisily mata: totest.read_header(fh, fn, "boilerplate")"' == 198

mata:
assert(totest.fhs.get(fh) == "closed")
end

// write_header
mata:
totest = mptools()
totest.header_type = "template"
totest.header_version = (2,0,0)
totest.header_label = "something interesting"
fh = totest.mpfopen("bench/test_write_header.txt", "w")
totest.write_header(fh)
totest.mpfclose(fh)

fh = totest.mpfopen(`"bench\test_write_header.txt"', "r")
assert(totest.mpfget(fh)==`"<header>"')
assert(totest.mpfget(fh)==`"<mkproject> template"')
assert(totest.mpfget(fh)==`"<version> 2.0.0"')
assert(totest.mpfget(fh)==`"<label> something interesting"')
assert(totest.mpfget(fh)==`"</header>"')
totest.mpfclose(fh)
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
