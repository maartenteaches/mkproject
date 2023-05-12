mata: 
mata set matastrict on

struct repl 
{
	string scalar abbrev
	string scalar fn
	string scalar basedir
	string scalar stub
}

struct reading_file
{
    real   rowvector fversion
    string scalar    type
    string scalar    label
    string scalar    fn
    real   scalar    fh
    real   scalar    lnr
	real   scalar    open
}
struct defaults
{
    string scalar boilerplate
    string scalar stencil
}

class mpversion{
    real                   rowvector current_version
	struct reading_file    scalar    reading

    real                   rowvector parse_version()
    void                             header_version()
  	void                             where_err()
    void                             new()
    real                   scalar    lt()
    void                             toonew()
}

class mpfile extends mpversion{
    class AssociativeArray scalar    fhs

    real                   scalar    mpfopen()
    void                             mpfread()
    void                             mpfput()
    string                 matrix    mpfget()  
    void                             mpfclose()
    void                             mpferror()
    void                             mpfclose_all()
    void                             new()
}

class mptools extends mpfile{
    string                 scalar    odir
	string                 scalar    header_label
	string                 scalar    header_type
	
    void                             graceful_exit()
    string                 scalar    find_file()
    void                             read_header()
    void                             parse_header()
    void                             write_header()
    void                             parse_dir()
    void                             header_ok()
    void                             new() // sets default for odir
}

class mpdefaults extends mptools{
    struct defaults       scalar     defaults
    
    void                             read_defaults()
    void                             write_default()
    void                             reset()
}

class boilerplate extends mpdefaults{
    struct repl           scalar     torepl
    
    void                             run()
    void                             copy_boiler()
    string                scalar     remove_usuffix()
    void                             parse_dest()
    void                             parse_bline()
}

class mkproject extends boilerplate{
    string                matrix     files
   	string                colvector  dirs
    string                colvector  cmds
    string                scalar     dir
    string                scalar     abbrev
    string                scalar     stencil
    
    void                             run()
    void                             read_stencil()
    void                             parse_sline()
    void                             read_dir()
    void                             mk_dirs()
    void                             mk_files()
    void                             do_cmds()
    void                             new()
}

class mpcreate extends mptools{
    void                             run()
    void                             create()
}
end

do mkproject_version.mata
do mkproject_mpfile.mata
do mkproject_mptools.mata
do mkproject_mpdefaults.mata
do mkproject_mpboilerplate.mata
do mkproject_mkproject.mata