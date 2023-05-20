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

//read_dir()
mata:
totest=mkproject()
totest.read_dir("foo/bar")
assert(totest.dirs == ("\foo\" \ "\foo\bar\"))
totest.read_dir("foo/blup")
assert(totest.dirs == ("\foo\" \ "\foo\bar\" \ "\foo\blup\"))
end