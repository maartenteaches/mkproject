<header>
<mkproject> stencil
<version> 2.0.0
<label> Research project with git, display project with dirtree
<reqs> git
<reqs> dirtree
</header>

<dir> docu
<dir> data
<dir> ana
<dir> txt

<file> readme readme.md
<file> ignore .ignore
<file> rlog   docu/research_log.md
<file> main   ana/<abbrev>_main.do
<file> dta    ana/<abbrev>_dta01.do
<file> ana    ana/<abbrev>_ana01.do

<cmd> !git init -b main
<cmd> !git add .
<cmd> !git commit -m "initial commit"
<cmd> dirtree