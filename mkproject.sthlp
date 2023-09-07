{smcl}
{* *! version 1.2.0}{...}
{vieweralsosee "boilerplate" "help boilerplate"}{...}
{vieweralsosee "smclpres (if installed)" "help smclpres"}{...}
{vieweralsosee "dirtree (if installed)" "help dirtree"}{...}
{viewerjumpto "Syntax" "mkproject##syntax"}{...}
{viewerjumpto "Description" "mkproject##description"}{...}
{viewerjumpto "Options" "mkproject##option"}{...}
{viewerjumpto "Example" "mkproject##example"}{...}
{title:Title}

{phang}
{bf:mkproject} {hline 2} Creates project folder with some boilerplate code and research log


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:mkproject}
{it:proj_abbrev}
[{cmd:,} {opt template(templet)} 
{opt dir(directory)} ]

{p 8 17 2}
{cmd:mkproject}
[{cmd:,} {opt query} 
{opt create(filename)} 
{opt remove(template_name)} 
{opt default(template_name)} 
{opt resetdefault}
{opt replace}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt template(template)}}choose the template for the projects. The 
{it:query} option displays a list of templates available and the default{p_end}
{synopt:{opt dir(directory)}}specifies the directory in which the project 
directory is to be created{p_end}
{synopt:{opt query}}displays a list of templates available{p_end}

{syntab:Modify templates}
{synopt:{opt create(filename)}}create a template from {it:filename}{p_end}
{synopt:{opt remove(template_name)}}removes the template {it:template_name}{p_end}
{synopt:{opt default(template_name)}}set the default template to {it:template_name}{p_end}
{synopt:{opt resetdef:ault}}sets the default template to {it:long}{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
the purpose of {cmd:mkproject} is to create a standard directory structure and 
some files with boilerplate code in order to help get a project started. There 
is usually a set of commands that are included in every .do file a person makes, 
like {cmd:clear _all} or {cmd:log using}. What those commands are can differ 
from person to person, but most persons have such a standard set. Similarly, a 
project usually has a standard set of directories and files. Starting a new a 
new project thus involves a number of steps that could easily be automated. 
Automating has the advantage of reducing the amount of work you need to do. 
However, the more important advantage of automating the start of a project is 
that it makes it easier to maintain your own workflow: it is so easy to start 
"quick and dirty" and promise to yourself that you will fix that "later". If the 
start is automated, then you don't need to fix it. 

{pstd}
The {cmd:mkproject} command automates the beginning of a project. It comes with 
a set of "templates" I find useful. A template contains all the actions (like 
create sub-directories, create files, run other Stata commands) that 
{cmd:mkproject} will take when it creates a new project. Since everybody's 
workflow is different, {cmd:mkproject} allows users to create their own template. 

{pstd}
You can get a list of available templates at your computer by typing 
{cmd:mkproject, query}. It will show for each template a short label, which can
give a quick idea of what templates could potentially be useful for you. You can 
also click on the name of the template to open it in the viewer, to see what it
exactly does. 

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


{it:A data-analysis project}

{pstd}
{cmd:mkproject} creates a project directory (folder) called {it:proj_abbrev}
inside the directory {it:dir}. If {cmd:directory()} has not been specified, the
project directory will be created in the {help pwd:current working directory}.
By default the project directory will have the following structure:

{p 4 4 2}{it:proj_abbrev}{p_end}
{p 8 8 2}admin{p_end}
{p 8 8 2}docu{p_end}
{p 8 8 2}posted{p_end}
{p 12 12 2}data{p_end}
{p 8 8 2}work{p_end}

{pstd}
Moreover, the work folder will contain 3 .do files {it:proj_abbrev}_main.do,
{it:proj_abbrev}_dta01.do and {it:proj_abbrev}_ana01.do. These 
.do files will contain boilerplate code. The docu folder will contain the file
research_log.txt, with some boilerplate for the start for a research log. The 
main {it:proj_abbrev} folder will contain a {it:proj_abbrev}.stpr
Stata {help Project Manager:Stata project file}.

{pstd}
Once {cmd:mkproject} has done that, it will change the working directory to the
directory work, and opens the Stata project file. 

{pstd}
If the {opt git} option is specified, then the {it:posted} directory will be 
called {it:protected} 


{it:A smclpres project}

{pstd}
The purpose of a smclpres project is to create a presentation inside Stata using
.smcl files (like help files) with the {stata ssc desc smclpres:smclpres} package.
It needs to be installed separately by typing in Stata {cmd:ssc install smclpres}. 

{pstd}
If the {opt smclpres} option is specified the project directory will have the following structure:

{p 4 4 2}{it:proj_abbrev}{p_end}
{p 8 8 2}handout{p_end}
{p 8 8 2}presentation{p_end}
{p 8 8 2}source{p_end}

{pstd}
The source folder will contain one .do file {it:proj_abbrev}.do, with boilerplate code for a smclpres presentation. The main {it:proj_abbrev} folder contains readme.txt
explaining to a potential participant who got my presentation after a talk how to
use the files.


{it:Git}

{pstd}
If the {opt git} options is specified, then a .ignore file will be created in the 
main directory, which tells git to ignore all *.dta files. The reason for that is
that if you wish to upload your project on a site like github and your project 
uses individual level data, then in some countries you can get into really serious
legal trouble for uploading that data. Beware, if the raw data comes in a non-Stata
format, like .csv, then you will need to modify the .ignore file accordingly. If you
know it is safe to upload data, then you can specify to {opt opendata} option. 

{pstd}
In addition, {cmd:mkproject} will also start a readme.md file. Finally, it will 
initialize the git repository and make the first commit.  


{it:Other}

{pstd}
Additional .do files with boilerplate code can be created with {help boilerplate}.

{pstd}
This command was inspired by the book by {help mkproject##ref:Scott Long (2009)}. 


{marker option}{...}
{title:Options}

{phang}
{opt dir:ectory(dir)} specifies the directory in which the project is to be created.

{phang}
{opt smclpres} specifies that a smclpres project is to be created

{phang}
{opt git} specifies that the user wants to use Git for this project 

{phang}
{opt opendata} specifies that Git can track .dta files 


{marker example}{...}
{title:Example}

{phang}{cmd:. mkproject foo, dir(c:/temp)}{p_end}


{marker ref}{...}
{title:Reference}

{phang}
J. Scott Long (2009) {it:The Workflow of Data Analysis Using Stata}. College Station, TX: Stata Press.


{title:Author}

{pstd}Maarten Buis, University of Konstanz{break} 
      maarten.buis@uni.kn   

