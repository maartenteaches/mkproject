program define cleanup

    local odir = c(pwd)
    capture noisily main `0'
    if _rc {
        qui cd "`odir'"
        exit _rc
    }
    qui cd "`odir'"
end

program define main
    syntax anything(name=dir)
    
    local dir : list clean dir
    mata: fillindir()
    capture cd "`dir'"
	if _rc {
		exit
	}
    local dirs: dir "." dirs "*"
    local files: dir "." files "*"
    foreach file of local files {
        erase "`file'"
    }
    foreach subdir of local dirs {
        main "`subdir'"
    }
    qui cd ..
    rmdir "`dir'"
    
end

mata:
void fillindir()
{
    string scalar dir
    
    dir = st_local("dir")
    if(!pathisabs(dir)) {
        dir = pathresolve(pwd(),dir)
    }
    st_local("dir",dir)
}
end

