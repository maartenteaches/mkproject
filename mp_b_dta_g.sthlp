{smcl}
{* *! version 2.1.3}{...}
{vieweralsosee "mkproject" "help mkproject"}{...}
{vieweralsosee "boilerplate" "help boilerplate"}{...}
{title:Title}

{phang}
boilerplate template dta_g {hline 2} data preparation for a project using git


{title:Description}

{pstd} 
This is a template for a .do file that cleans the data.


{title:Boilerplate}

{pstd}
This template creates a .do file with the following content: 

{cmd}
{txt}

{title:Tags}

{pstd}
This file may contain one or more of the following tags:{p_end}
{pmore}{cmd:<stata_version>} will be replaced by the Stata version{p_end}
{pmore}{cmd:<date>} will be replaced by the date{p_end}
{pmore}{cmd:<fn>} will be replaced by the file name{p_end}
{pmore}{cmd:<stub>} will be replaced by the file name without the suffix{p_end}
{pmore}{cmd:<abbrev>} will be replaced by the file name without the suffix up to the last underscore{p_end}
{pmore}{cmd:<basedir>} will be replaced by the directory in which the file is saved{p_end}
{pmore}{cmd:<as of #>} will include whatever comes after that tag only if the Stata version is # or higher{p_end}


{title:Source code}

    {view "c:\ado\plus/m\mp_dta_g.mpb":mp_dta_g.mpb}