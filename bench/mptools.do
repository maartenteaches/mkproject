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