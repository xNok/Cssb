# Programming with the automated __CSSB__ work-flow


## Introduction

Using an automated work-flow start by running some command lines. I asume that you have install [git](https://git-scm.com/) and [node.js](https://nodejs.org/)

1. Download the project the last stable version

  > git clone https://github.com/xNok/Cssb/v0.4

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

### Frontdev

I recommend that you use following structure inside the __frontdev__ folder, but you can easily changed that configuration with the config.coffee file. To simplifies organizing large websites CSSB support by default a single level subdirectory.

Keeping a simple lvl of subdirectory let navigate so easily into your project. This is one reason why I choose to prefix assets folders with **assets__** rather than using a directory.

```
+-- assets__css     // CSS, SCSS, SASS resources
+-- assets__img     // images
+-- assets__js      // JS resources
+-- content         // JSON, text, HTML, Markdown blocks that can be edited separately from the page or layout
+-- layout          // All page scaffolds
+-- pages           // Web page
+-- partials        // contain reusable HTML that an be include or used as a macro
+-- vendors         // external libraries
```

## Personalised the directory structure

First, Open the file *config.coffee* and define your project structure :

```coffeescript
# directory where you want to publish the project
project_src       = "../www"
# your frontend development directory
project_frontdev  = "../frontdev"
# your project documentation directory
project_doc       = "../docs"
```

Then you can change the output directories via the variable **path_frontdev** :

```coffee
export.path_frontdev =
  in:
    ********
  out:
    src:    project_src
    css:    project_src + '/css/'
    js:     project_src + '/js/'
    images: project_src + '/img/'
    vendors:project_src + '/vendors' 
```

Finally you can define the structure of your dev directory. These variables are use by the gulp task with the following rules :

* __src__:      directory definition
* __dev__:      development files to compile
* __watch__:    development files to watch
* __ignore__:   development files to ignore

```coffee
export.path_frontdev =
  in:
    src:      project_frontdev + "/"
    scss:
      dev:    project_frontdev + '/assets__css/*.scss'
      watch:  project_frontdev + '/assets__css/**/*.scss'
    js:
      watch:  project_frontdev + '/assets__js/**/*.js'
      ignore: project_frontdev + '/assets__js/vendors/**/*'
    swig:
      dev:    project_frontdev + '/pages/**/*.html'
      watch: [
        project_frontdev + "/partials/**/*.html",
        project_frontdev + "/pages/**/*.html",
        project_frontdev + "/layout/*.html"
      ]
    image:
      dev:    project_frontdev + '/assets__img/*'
    data:
      src:    project_frontdev + '/contents/'
      app:    project_frontdev + '/contents/app.json'
      json:   project_frontdev + '/contents/**/*.json'
      yaml:   project_frontdev + '/contents/**/*.yml'
    vendors:  project_frontdev + '/vendors/**'
  out:
    *****
```