//parse_dir()
local dir "bench/"
local abbrev "foo"
mata:
odir = pwd()
totest = mkproject()
totest.parse_dir()
assert(totest.odir==odir)
assert(pwd() == pathjoin(odir, "bench\foo\"))
chdir("..")
rmdir("foo")
chdir("..")
end