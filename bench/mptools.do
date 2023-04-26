// read_header
mata:
totest = mptools()
fh = totest.mpfopen("bench/test_header.do", "r")
totest.read_header(fh, "boilerplate")
assert(totest.mpfget(fh) == "some other text after the header")
assert(totest.header_label == "something to test")
assert(totest.header_type == "boilerplate")
assert(totest.header_version == (2,0,0))
totest.mpfclose(fh)
end

// write_header
// defaults
mata:
totest = mptools()
fh = totest.mpfopen("bench/test_write_header.txt", "w")
totest.write_header(fh, "template")
totest.mpfclose(fh)

fh = totest.mpfopen(`"bench\test_write_header.txt"', "r")
assert(totest.mpfget(fh)==`"<header>"')
assert(totest.mpfget(fh)==`"<mkproject> template"')
assert(totest.mpfget(fh)==`"<version> 2.0.0"')
assert(totest.mpfget(fh)==`"<label> "')
assert(totest.mpfget(fh)==`"</header>"')
totest.mpfclose(fh)
unlink("bench/test_write_header.txt")

// when headings are set
totest = mptools()
totest.header_version = (1,2,2)
totest.header_type = "boilerplate"
totest.header_label = "something interesting"
fh = totest.mpfopen("bench/test_write_header.txt", "w")
totest.write_header(fh, "template")
totest.mpfclose(fh)

fh = totest.mpfopen(`"bench\test_write_header.txt"', "r")
assert(totest.mpfget(fh)==`"<header>"')
assert(totest.mpfget(fh)==`"<mkproject> boilerplate"')
assert(totest.mpfget(fh)==`"<version> 1.2.2"')
assert(totest.mpfget(fh)==`"<label> something interesting"')
assert(totest.mpfget(fh)==`"</header>"')
totest.mpfclose(fh)
unlink("bench/test_write_header.txt")

end