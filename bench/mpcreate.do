// write_header
mata:
totest = mpcreate()
totest.reading.type = "stencil"
totest.reading.fversion = (2,0,0)
totest.reading.label = "something interesting"
fh = totest.mpfopen("bench/test_write_header.txt", "w")
totest.write_header(fh)
totest.mpfclose(fh)

totest.mpfread(`"bench\test_write_header.txt"')
assert(totest.mpfget()==`"<header>"')
assert(totest.mpfget()==`"<mkproject> stencil"')
assert(totest.mpfget()==`"<version> 2.0.0"')
assert(totest.mpfget()==`"<label> something interesting"')
assert(totest.mpfget()==`"</header>"')
totest.mpfclose(totest.reading.fh)
unlink("bench/test_write_header.txt")
end