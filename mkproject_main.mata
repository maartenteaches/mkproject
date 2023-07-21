mata: 
mata set matastrict on

struct queryinfo
{
	string scalar    isdefault
	string scalar    path
	string scalar    name
	string scalar    lab
	string colvector met
	string colvector reqs
}

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
    string scalar    sversion
    string scalar    type
    string scalar    label
	string colvector reqs
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
	real                   scalar    _chkreq()
	void                             chkreqs()
    void                             collect_header_info()
    void                             chk_header()
    void                             write_header()
    void                             header_ok()
	string                 scalar    type2ext()
    void                             new() // sets default for odir
}

class mpdefaults extends mptools{
    struct defaults       scalar     defaults
    
    void                             read_defaults()
    void                             write_default()
    void                             reset()
	void                             new()
}

class boilerplate extends mpdefaults{
    struct repl           scalar     torepl
    
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
    
    void                             read_stencil()
    void                             parse_sline()
	string                scalar     getrest()
    void                             read_dir()
    void                             parse_dir()
    void                             mk_dirs()
    void                             mk_files()
    void                             do_cmds()
    void                             new()
	void                             run()
}

class mpquery extends mpdefaults {
    struct queryinfo      colvector files
	string                scalar    cname
	string                scalar    creq
	string                scalar    clab
    
    string                matrix    findfiles()
    string                colvector dupldrop()
    void                            fromheader()
    string                scalar    file2name()
    void                            isdefault()
    void                            print_header()
    void                            print_entry()
    void                            print_footer()
    void                            collect_info()
    void                            print_table()
	void                            parse_reqs()
	string                scalar    parse_req()
	void                            parse_names()
	string                colvector collect_reqs()
	void                            multilinelab()
	string                scalar    truncstring()
	string                colvector mpparts()
	void                            parsefiles()
    void                            run()
	void                            setup_table()
}

class mpcreate extends mpdefaults {
    string                scalar    newname()
    void                            chk_file()
    void                            create()
	void                            remove()
    void                            header_defaults()
	string                colvector integrate_reqs()
	void                            parse_req_line()
}
end

do mkproject_version.mata
do mkproject_mpfile.mata
do mkproject_mptools.mata
do mkproject_mpdefaults.mata
do mkproject_mpboilerplate.mata
do mkproject_mkproject.mata
do mkproject_mpquery.mata
do mkproject_mpcreate.mata
