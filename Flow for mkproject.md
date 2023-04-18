# Flow for `mkproject`

## Class inheritance 
mpversion --> mpfile -->mptools -->  mpdefaults -->  boilerplate --> mkproject

mptools --> mpcreate

## Class definitions
```
class mpversion{
    real                   rowvector current_version
    real                   rowvector proj_version
    
    void                             parse_version()
    void                             new()
    real                   scalar    lt()
    void                             toonew()
}
```
```
class mpfile extends mpversion{
    class AssociativeArray scalar    fhs
    
	real                   scalar    mpfopen()
	void                             mpfput()
	string                 scalar    mpfget()  
	void                             mpfclose()
	void                             mpferror()
	void                             mpfclose_all()
	void                             new()
}
```

```
class mptools extends mpfile{
   string                  scalar    odir

    void                             graceful_exit()
    string                 scalar    find_file()
    string                 colvector read_header() 
    void                             write_header()
    void                             parse_dir()
    void                             new() // sets default for odir
}
```

```
class mpdefaults extends mptools{
    string                 scalar    read_default()
    string                 colvector read_defaults()
    void                             write_default()
}
```

```
class boilerplate extends mpdefaults{
    void                             run()
    void                             copy_boiler()
    struct repl           scalar     parse_dest()
    void                             parse_bline()
}
```

```
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
```

```
class mpcreate extends mptools{
    void                             run()
    void                             create()
}
```

### `mkproject`

* `run("mkproject")`
    * `parse_dir()` --> *ddir*, *odir*
    * `read_default()` --> 1x1 string
    * `read_template()`
        * `find_file()`  --> 1x1 string
        * `read_header()` --> 3x1 string
            * `parse_version()` --> *mp_version*
        * `parse_tline()` --> *files*, *cmds*
            * `read_dir()` --> *dirs*
    * `mk_dirs()` <-- *dirs*
    * `mk_files()` <-- *files*
    * `do_cmds()` <-- *cmds*
    * (`graceful_exit()` <-- * odir*)

## `mkproject, create()`

* `run(mkproject create)`
    *  `newname()` --> 1x1 string
    *  `read_hearder()` --> 3x1 string
        *  `parse_version()` --> *mp_version*
    

## `mkproject, default()`



## `boilerplate`

## `boilerplate, create()`

## `boilerplate, default`


```

```