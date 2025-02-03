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
	string scalar proj_abbrev
	string scalar proj_basedir
}

struct reading_file
{
    real   rowvector fversion
    string scalar    sversion
    string scalar    type
    string scalar    label
	string colvector description
	string colvector reqs
    string scalar    fn
    real   scalar    fh
    real   scalar    lnr
	real   scalar    open
}
struct defaults
{
    string scalar boilerplate
    string scalar project
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
	real                   scalar    nlines()
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
	void                             descopenerr()
	real                   scalar    _chkreq()
	void                             chkreqs()
    void                             collect_header_info()
    void                             chk_header()
    void                             write_header()
    void                             header_ok()
	string                 scalar    type2ext()
	string                 scalar    mppathgetparent()
    void                             new() // sets default for odir
	string                 scalar    gettoken()
	string                 scalar    displaypath()
}

class mpdefaults extends mptools{
    struct defaults       scalar     defaults
    
    void                             read_defaults()
    void                             write_default()
    void                             reset()
	void                             fix_no_personal()
	void                             mkdirerr()
}

class boilerplate extends mpdefaults{
    struct repl           scalar     torepl
    
	void                             parse_anything()
    void                             copy_boiler()
    string                scalar     remove_usuffix()
    void                             parse_dest()
    void                             parse_bline()
	void                             parse_bbody()
	void                             parse_bbody2_0_4()
}

class mkproject extends boilerplate{
    string                matrix     files
   	string                colvector  dirs
    string                colvector  cmds
    string                scalar     dir
    string                scalar     abbrev
    string                scalar     project
	string                scalar     profile_path
	string                colvector  prcontent
	real                  scalar     ppos
	
	void                             read_profile()
	void                             parse_pbody()
	void                             parse_pbody2_0_4()
	string                scalar     parse_pline()
    void                             read_project()
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

class mpcreate extends mkproject {
    string                scalar    newname()
    void                            chk_file()
	void                            check_body()
    void                            create()
	void                            remove()
    void                            header_defaults()
	string                colvector integrate_reqs()
	void                            parse_req_line()
	string                matrix    parse_tree()
	void                            create_tree()
	void                            decorate_tree()
	void                            write_tree()
	void                            write_help()
	void                            write_help_p()
	void                            write_help_b()
	void                            copy_b_help()
	void                            write_help_header()
	void                            write_help_footer()
	void                            write_help_p_body()
	void                            write_help_b_body()
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
