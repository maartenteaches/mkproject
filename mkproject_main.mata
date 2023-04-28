mata: 
mata set matastrict on

struct repl 
{
	string scalar abbrev
	string scalar fn
	string scalar basedir
	string scalar stub
}

class mpversion{
    real                   rowvector current_version
    real                   rowvector header_version

	void                             header_version()
    real                   rowvector parse_version()
  	void                             where_err()
    void                             new()
    real                   scalar    lt()
    void                             toonew()
}

class mpfile extends mpversion{
    class AssociativeArray scalar    fhs

    real                   scalar    mpfopen()
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
    void                             new() // sets default for odir
}

class mpdefaults extends mptools{
    string                 scalar    read_default()
    string                 colvector read_defaults()
    void                             write_default()
}

class boilerplate extends mpdefaults{
    void                             run()
    void                             copy_boiler()
    struct repl           scalar     parse_dest()
    void                             parse_bline()
}

class mkproject extends boilerplate{
    void                             run()
    void                             new()
    void                             read_template()
    void                             parse_tline()
    void                             read_dir()
    void                             mk_dirs()
    void                             mk_files()
    void                             do_cmds()
}

class mpcreate extends mptools{
    void                             run()
    void                             create()
}
end

do mkproject_version.mata
do mkproject_mpfile.mata

do mkproject_mptools.mata