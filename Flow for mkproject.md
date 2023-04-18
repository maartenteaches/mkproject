# Flow for `mkproject`

## `mkproject`

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

## `mkproject, create()`

* `run(mkproject create)`
    *  

## `mkproject, default()`



## `boilerplate`

## `boilerplate, create()`

## `boilerplate, default`

