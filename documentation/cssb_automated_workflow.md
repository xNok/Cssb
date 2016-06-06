Programming with the automated __Cssb__ workflow
===

# Introduction

# Directory structure

I recommend that you use following structure, but you can easily changed that conffiguration with the config.coffee file. To simplifies organizing large websites Cssb support by default a single level subdirectory.

I recommend keeping a simple lvl of subdirectory, because it is much simple to navigate into your project. This is one reason which made me chose to to the prefix **assets__** rather than using a directory.

```
+-- assets__css     // CSS, SCSS, SASS resources
+-- assets__img     // images
+-- assets__js      // JS resources
+-- content         // JSON, text, HTML, Markdown blocks that can be edited separately from the page or layout
+-- layout          // All page scaffolds
+-- pages           // Webpage
+-- partials        // contain reusable HTML that an be include or used as a macro
+-- vendors         // external librairies
```

## Personalised the directory structure

First,Open the file *confi.coffee* and define your project structure :

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

Finaly you can define the structure of your dev directory. These variables are use by the gulp task with the following rules :

* __src__:      directory definition
* __dev__:      developement files to compile
* __watch__:    developement files to watch
* __ignore__:   developement files to ignore

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