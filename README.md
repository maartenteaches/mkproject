_v. v2.0.0_  

`mkproject` : Creates project folder with some boilerplate code
===============================================================

### License

Creative Commons Attribution 4.0

## Description

The purpose of mkproject is to create a standard directory structure and some files with boilerplate code in order to help get a project started. There is usually a set of commands that are included in every .do file a person makes, like `clear _all` or `log using`. What those commands are can differ from person to person, but most persons have such a standard set. Similarly, a project usually has a standard set of directories and files. Starting a new project thus involves a number of steps that could easily be automated.  Automating has the advantage of reducing the amount of work you need to do.  However, the more important advantage of automating the start of a project is that it makes it easier to maintain your own workflow: it is so easy to start "quick and dirty" and promise to yourself that you will fix that "later". If the start is automated, then you don't need to fix it. 

## Requirements and use

This package requires [Stata](https://www.stata.com) version 15 or higher. The easiest way to install this is using E. F. Haghish's [github](https://haghish.github.io/github/) command. After you have installed that, you can install `mkproject` by typing in Stata: `github install maartenteaches/mkproject`. Alternatively, `mkproject` can be installed without the `github` command by typing in Stata `net install mkproject, from("https://raw.githubusercontent.com/maartenteaches/mkproject/main")`.

Author
------

**Maarten L. Buis**  
University of Konstanz  
maarten.buis@uni-kn  
