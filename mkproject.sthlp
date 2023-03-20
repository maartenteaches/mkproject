{smcl}
{* *! version 1.0.0}{...}
{viewerjumpto "Syntax" "mkproject##syntax"}{...}
{viewerjumpto "Description" "mkproject##description"}{...}
{viewerjumpto "Options" "examplehelpfile##option"}{...}
{viewerjumpto "Examples" "mkproject##example"}{...}
{title:Title}

{phang}
{bf:mkproject} {hline 2} Creates project folder with some boilerplate code and research log


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:mkproject}
{it:project_abbreviation} ,
{opt dir:ectory(dir)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mkproject} creates a project directory (folder) called {it:project_abbreviation}
inside the directory {it:dir}. The project directory will have the following structure:

{p 4 4 2}{it:project_abbreviation}{p_end}
{p 8 8 2}admin{p_end}
{p 8 8 2}docu{p_end}
{p 8 8 2}posted{p_end}
{p 12 12 2}data{p_end}
{p 8 8 2}work{p_end}

{pstd}
Moreover, the work folder will contain 3 .do files {it:project_abbreviation}_main.do,
{it:project_abbreviation}_dta01.do and {it:project_abbreviation}_ana01.do. These 
.do files will contain boilerplate code. The docu folder will contain the file
research_log.txt, with some boilerplate for the start for a research log.

{pstd}
Once {cmd:mkproject} has done that, it will change the working directory to the
directory work, and opens the main .do file in the do file editor. 

{pstd}
This command was inspired by the book by {help mkproject##ref:Scott Long (2009)}. 


{marker option}{...}
{title:Option}

{phang}
{opt dir:ectory(dir)} specifies the directory in which the project is to be created.


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

