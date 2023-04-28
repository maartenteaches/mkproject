
// parse_version()
mata:
totest = mpversion()
totest.reading.fn = "foo"
totest.reading.lnr = 3
assert(totest.parse_version("1.22.7")==(1,22,7))
end

rcof `"noisily mata totest.parse_version("1.22")"' == 198
rcof `"noisily mata totest.parse_version("1.22.")"' == 198
rcof `"noisily mata totest.parse_version("1.22.7.4")"' == 198
rcof `"noisily mata totest.parse_version("1.22.a")"' == 198
rcof `"noisily mata totest.parse_version("2.1.0")"' == 198


// header_version()
mata:
totest = mpversion()
totest.reading.fn = "foo"
totest.reading.lnr = 3
totest.header_version("1.22.7")
assert(totest.reading.fversion==(1,22,7))
end

// lt()
mata:
totest = mpversion()
assert(totest.lt((1,2,1),(1,2,0))==0)
assert(totest.lt((1,2,1),(1,2,2))==1)
assert(totest.lt((2,0,0),(1,2,0))==0)
assert(totest.lt((1,2,2),(1,2,2))==0)
assert(totest.lt((1,2,2),(1,3,1))==1)
end

// toonew()
mata:
totest = mpversion()
totest.reading.fn = "foo"
totest.reading.lnr = 3
totest.toonew((1,2,0))
totest.toonew((2,0,0))
end
rcof `"noisily mata totest.toonew((2,1,0))"' == 198
