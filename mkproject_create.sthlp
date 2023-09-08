{smcl}
{* *! version 1.2.0}{...}
{vieweralsosee "boilerplate" "help boilerplate"}{...}
{vieweralsosee "mkproject" "help mkproject"}{...}
{vieweralsosee "smclpres (if installed)" "help smclpres"}{...}
{vieweralsosee "dirtree (if installed)" "help dirtree"}{...}
{viewerjumpto "Syntax" "mkproject##syntax"}{...}
{viewerjumpto "Description" "mkproject##description"}{...}
{viewerjumpto "Example" "mkproject##example"}{...}
{title:Title}

{phang}
{bf:mkproject, create} {hline 2} Create new templates for the {cmd:mkproject} command.



{title:Description}

{pstd}
If {cmd:mkproject} makes a project folder it does three things:

{pmore} 
First, it creates the project folder, and any sub-folders specified in the 
template. It changes the current working directory to the project folder.

{pmore}
Second, it creates any files specified in the template, using {help boilerplate}.

{pmore}
Third, it executes any commands specified in the template.

{pstd}
So a template should tell {cmd:mkproject} what subdirectories it needs to create,
what files it needs to create, and what commands it needs to execute. On top of 
that you can add various meta-data in the header.

{pstd}
To create a new template you are going to create a text file with that information
and then type in Stata {cmd:mkproject, create(}{it:that_text_file}{cmd:)}. Based
on that text file {cmd:mkproject} will create the template, and the corresponding 
help file.

{pstd}
Lets look at an example. Below is the template for {help mp_p_course:course}. 
You can look at the source code for any template by typing {cmd:mkproject, query}, 
click on any template you are interested in, that opens a help-file, and at the 
bottom there is a link that will show the source code for that template in the 
viewer.

    --------------- begin template -------------------
{cmd}{...}
    <header>
    <mkproject> project
    <version> 2.0.0
    <label> Small research project as part of a course
    <reqs> dirtree
    <description>
    {c -(}pstd{c )-} 
    This template is for a small research project that takes place over a
    short period of time that does not require snapshots. A typical example
    would be a project someone has to do for a course.
    </description>
    </header>
    
    <dir> docu
    <dir> data
    <dir> ana
    <dir> txt
    
    <file> rlogc  docu/research_log.md
    <file> main   ana/<abbrev>_main.do
    <file> dta_c  ana/<abbrev>_dta01.do
    <file> ana    ana/<abbrev>_ana01.do
    
    <cmd> dirtree
{txt}{...}
    -------------- end template --------------------

{pstd}
The easiest way to create a new 

{pmore}
Lines between {cmd:<header>} and {cmd:</header>} contain 
meta-information, like the label for that template. 

{pmore}
Lines starting with {cmd:<dir>} tell you what sub-directories that template will
create

{pmore}
Lines starting with {cmd:<file>} have two elements, the first "word" is the name
of the template that {help boilerplate} will use to create a file, and the second
"word" is the filename. This filename can contain the tag {cmd:<abbrev>} which 
{cmd:mkproject} will replace with the {it:proj_abbrev} you will specify when using
{cmd:mkproject} to create a project folder.  

{pmore}
Lines starting with {cmd:<cmd>} tell you what commands {cmd:mkproject} will run
after creating those directories and files
