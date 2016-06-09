Programming with the automated __CSSB__ work-flow
===

# Introduction

  Using a automated work-flow start by running some command lines by definition. I asume that you have install [git](https://git-scm.com/) en [node.js](https://nodejs.org/)

Download the project
> git clone https://github.com/xNok/Cssb

Install dependencies
> npm install

Prepare your workspace
> gulp init

# Directory structure

I recommend that you use the Cssb project as a [submodule](https://git-scm.com/docs/git-submodule), and structure your working directory as following :

```
+-- Cssb                // CSSB folder
+-- app                 // your dev folder
+-- www                 // your production folder
```

I recommend that you use following structure inside the __www__ folder, but you can easily changed that configuration with the config.coffee file. To simplifies organizing large websites CSSB support by default a single level subdirectory.

I recommend keeping a simple lvl of subdirectory, because it is much simple to navigate into your project. This is one reason why I choose to prefix assets with **assets__** rather than using a directory.

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

First,Open the file *config.coffee* and define your project structure :

```javascript
// directory where your developing stuff
project_dev     = "../app"
// directory where you want to publish the project
project_src     = "../www"
// sample code directory
project_sample  = "./app"
```

Then you can change the output directories via the variable **path__OUT** :

```javascript
exports.path_OUT =
  dist:
    src:    project_src
    css:    project_src + '/css/'
    js:     project_src + '/js/'
    images: project_src + '/img/'
    vendors:project_src + '/vendors'
  ghpage:
    src:    project_src + '/**/*'
```

Finally you can define the structure of your dev directory. These variables are use by the gulp task with the following rules :

* __src__:      directory definition
* __dev__:      development files to compile
* __watch__:    development files to watch
* __ignore__:   development files to ignore

```
exports.path_IN =
  scss:
    dev:    project_dev + '/assets__css/*.scss'
    watch:  project_dev + '/assets__css/**/*.scss'
  js:
    watch:  project_dev + '/assets__js/**/*.js'
    ignore: project_dev + '/assets__js/vendors/**/*'
  swig:
    dev:    project_dev + '/pages/**/*.html'
    watch: [
      project_dev + "/partials/**/*.html",  
      project_dev + "/pages/**/*.html"
    ]
  image:
    dev:    project_dev + '/assets__img/*'
  data:
    src:    project_dev + '/content/'
    app:    project_dev + '/content/app.json'
    json:   project_dev + '/content/**/*.json'
    yaml:   project_dev + '/content/**/*.yml'
  vendors:  project_dev + '/vendors/**'
```