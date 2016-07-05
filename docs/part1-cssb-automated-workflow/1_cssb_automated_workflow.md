# Programming with __CSSB__

## Introduction

Using an automated work-flow start by running some command lines. I asume that you have install [git](https://git-scm.com/) and [node.js](https://nodejs.org/)

1. Download the project the last stable version

  > git clone https://github.com/xNok/Cssb/v0.5.1

  __OR__ the current work in progress version

  > git clone https://github.com/xNok/Cssb

2. Install dependencies - don't pay attention the the __WARN__ messages 

  > npm install

3. Configure your project

  The project is already configured. See the following section to configure the project by yourself.
  
4. Prepare your workspace

  > gulp init

## Directory structure

I recommend that you use the Cssb project as a [submodule](https://git-scm.com/docs/git-submodule), and structure your working directory as following :

```
+-- Cssb                // CSSB folder
+-- docs                // documentation markdown files
+-- docsBook            // Published gitbook
+-- frontdev            // your frontdev folder
+-- www                 // Published frontdev files
```

## Starting a new project

* Downloading CSSB from github
  > git clone 

* The project uses Gulp to run tasks. Thus start by intall gulp with [node.js](https://nodejs.org/en/) (I use node v5.6.0)
  > npm install -g gulp

* Then install dependencies
  > npm install

## Tasks

Two tasks are very important 

The first let you compile all your files

> gulp dist

The seconde one let you use the live relaod, this means your files are compile whenerer you changed them

> gulp
