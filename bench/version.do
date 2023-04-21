
// parse_version()
mata:
totest = mpversion()
assert(totest.parse_version("1.22.7")==(1,22,7))
end

rcof `"noisily mata totest.parse_version("1.22")"' == 198
rcof `"noisily mata totest.parse_version("1.22.")"' == 198
rcof `"noisily mata totest.parse_version("1.22.7.4")"' == 198
rcof `"noisily mata totest.parse_version("1.22.a")"' == 198
rcof `"noisily mata totest.parse_version("2.1.0")"' == 198


// proj_version()
mata:
totest = mpversion()
totest.proj_version("1.22.7")
assert(totest.proj_version==(1,22,7))
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
totest.toonew((1,2,0))
totest.toonew((2,0,0))
end
rcof "noisily mata totest.toonew((2,1,0))" == 198