
// parse_version()
mata:
totest = mpversion()
assert(totest.parse_version("1.22.7", "foo", 3)==(1,22,7))
end

rcof `"noisily mata totest.parse_version("1.22", "foo", 3)"' == 198
rcof `"noisily mata totest.parse_version("1.22.", "foo", 3)"' == 198
rcof `"noisily mata totest.parse_version("1.22.7.4", "foo", 3)"' == 198
rcof `"noisily mata totest.parse_version("1.22.a", "foo", 3)"' == 198
rcof `"noisily mata totest.parse_version("2.1.0", "foo", 3)"' == 198


// proj_version()
mata:
totest = mpversion()
totest.header_version("1.22.7", "foo", 3)
assert(totest.header_version==(1,22,7))
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
totest.toonew((1,2,0), "foo", 3)
totest.toonew((2,0,0), "foo", 3)
end
rcof `"noisily mata totest.toonew((2,1,0), "foo", 3)"' == 198
