# mkproject and boilerplate: automate the beginning

*Maarten L. Buis, University of Konstanz*

There is usually a set of commands that are included in every .do file a person makes, like **clear _al** or **log using**. What those commands are can differ from person to person, but most persons have such a standard set. Similarly, a project usually has a standard set of directories and files. Starting a new .do file or a new project thus involves a number of steps that could easily be automated. Automating has the advantage of reducing the amount of work you need to do. However, the more important advantage of automating the start of a .do file or project is that it makes it easier to maintain your own workflow: it is so easy to start "quick and dirty" and promise to yourself that you will fix that "later". If the start is automated, then you don't need to fix it. 

The **mkproject** command automates the beginning of a project. It comes with a set of "stencils" I find useful. A stencil contains all the actions (like create sub-directories, create files, run other Stata commands) that **mkproject** will take when it creates a new project. Since everybody's workflow is different, **mkproject** allows users to create their own stencil. Similarly, the **boilerplate** command creates a new .do file with boilerplate code in it. It comes with a set of templates, but the user can create their own.

This talk will illustrate the use of both **mkproject** and **boilerpate** and in particular how to create your own templates.


