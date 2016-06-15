# Cssb

Frontend tools automating your workflow with [gulp](http://gulpjs.com/).

The project provide a set of pre-programmed command. These commandes will help you to simplify and impove your developement process. Use it or [learn how to build your own automated workflow](https://github.com/xNok/Cssb/blob/master/docs/part1-automated-workflow/gulp_automated_workflow.md).

The main enhancements that bring this project are :

1. Never start a project from scratch
2. Letting you write modular code
    * css -> [sass|scss](http://sass-lang.com/)
    * js  -> [ES6](https://babeljs.io/)
    * html-> [swig](http://paularmstrong.github.io/swig/)
3. Compiling your modular files whenever it is changed
4. Refreshing your browsers (cross browser and responsive programming) automatically
5. Warning you whenerer you made errors in your code
6. Publish your work and your documentation

## Documentation

* [Automated work-flows](https://github.com/xNok/Cssb/blob/master/docs/part1-automated-workflow/README.md)
    * [Programming with __Cssb__ automated work-flow ](https://github.com/xNok/Cssb/blob/master/docs/part1-automated-workflow/cssb_automated_workflow.md)
    * [Automate work-flow with __gulp__](https://github.com/xNok/Cssb/blob/master/docs/part1-automated-workflow/gulp_automated_workflow.md)
    * [Automated work-flow with __npm__](https://github.com/xNok/Cssb/blob/master/docs/part1-automated-workflow/npm_automated_workflow.md)
* [Technology tutorials](https://github.com/xNok/Cssb/blob/master/docs/part2-technologies-tutorials/README.md)
    * [__Git__ and project management work-flows](https://github.com/xNok/Cssb/blob/master/docs/part2-technologies-tutorials/git_workflow.md)
    * [Programming an __Apache Cordova__ hybrid mobile application](https://github.com/xNok/Cssb/blob/master/docs/part2-technologies-tutorials/apache_cordova.md)

----

* [Development strategy](#developement-strategy)
* [Installation](#installation)
* [Tasks List](#tasks-list)
* [Node modules List](#node-modules-list)
* [Recommendations](#recommendations)

## Developement strategy

I recommend that you use the Cssb project as a submodule :

```
+-- Cssb
 `+-- app               // Sample code
  +-- documentation     // Tricks to develop faster your application
  +-- node_modules      // All modules you needed - see Node_modules section
  +-- config.coffee     // configuration file
  +-- gulpfile.coffee   // tasks definition
  +-- package.json      // dependencies
  +-- README.md         // the documentation entry point
+-- app                 // your dev folder
+-- www                 // your production folder
```

Thus you can update the cssb project easly and you can create your own git on the __./__ directory et __./app__ and save only the interesting files.

## Installation

1. The project uses Gulp to run tasks. Thus start by intall gulp with [node.js](https://nodejs.org/en/) (I use v5.6.0)

> npm install -g gulp

2. then install dependencies

> npm install

3 Copy the sample app to your project_dev directory

> gulp init

4. finally run the gulp application

> gulp

## Tasks List

### Main tasks

1. Starting a project
* **init**:          Copy paste the app folder into the project_dev folder
* **gitbook-init**:  Copy paste gitbook folder into your doc folder

2. Developing
* **default**:       Run devs tasks
* **lint**:          Run linters
* **dist**:          Build production files

3. Publishing
* **gh-pages**:      Publish gh-pages
* **gitbook**:       

### Sub tasks

#### frontend dev
* **compile:sass**:       Build css assets
* **compile:swig**:       Build pages with swig template engine
* **compile:babel**:      Build JS files from ES6
* **minify:image**:       Optimize images

#### frontend post-dev
* **minify:js**:          Build minified ES6/JS files
* **minify:css**:         Build minified CSS files and compiled from SCSS
* **copy:vendors**:       Copy your project_scr/vendors folder to the project_dist/vendors

#### watch
* **watch:browserSync**:  Watch assets and templates for build on change
* **watch:sass**:         Watch scss files
* **watch:swig**:         Watch html/swig files
* **watch:js**:           Watch js/babel files
* **watch:json**:         Watch data/content files
* **watch:image**:        Watch imagesS

#### Data & Content management
* **merge:json**:         merge Json files under a folder to one json file with the folder name

#### linting
* **lint:Json**:          lint JSON files

## Node_modules List

### Frontdev

* Javascript
  * [coffee-script](http://coffeescript.org/) - .coffee interpretation
  * [gulp-babel](https://www.npmjs.com/package/gulp-babel) - Use next generation JavaScript
  * [gulp-uglify](https://www.npmjs.com/package/gulp-uglify) - Minify JS files
* CSS
  * [gulp-sass](http://sass-lang.com/) - .scss compilation
  * [autoprefixer](https://css-tricks.com/autoprefixer/) - Simple navigator compatibility
  * [gulp-clean-css](https://github.com/scniro/gulp-clean-css) - minify css files
* HTML
  * [swig](https://www.npmjs.com/package/gulp-swig) - html template engine
  * [gulp-image](https://www.npmjs.com/package/gulp-image) - Optimize PNG, JPG, GIF, SVG images
* Development & Linting
  * [browser-sync](http://www.browsersync.io/) - Navigator auto-reload
  * [gulp-jsonlint](https://www.npmjs.com/package/gulp-jsonlint) - linting JSON files
  * [gulp-yaml](https://www.npmjs.com/package/gulp-yaml) - Convert YAML to JSON

### Publishing tools
* [gulp-gh-pages](https://www.npmjs.com/package/gulp-gh-pages) - gulp plugin to publish contents to Github pages
* [gitbook](http://toolchain.gitbook.com/) - Creating Books from markdown

### Tools
* [gulp-changed](https://www.npmjs.com/package/gulp-changed) - reload only changed files
* [gulp-if](https://www.npmjs.com/package/gulp-if) - Allow condition into tasks
* [gulp-merge-json](https://www.npmjs.com/package/gulp-merge-json) - A gulp plugin to merge JSON files into one file
* [deleteEmpty](https://www.npmjs.com/package/delete-empty) - Delete recursively empty folders
* [path](https://www.npmjs.com/package/path) - Manipulate file path
* [yards](https://www.npmjs.com/package/yargs) - Allow to add arguments to gulp task
* [runSequence](https://www.npmjs.com/package/run-sequence) - Run a series of dependent gulp tasks in order
* [q](https://www.npmjs.com/package/q) - A library for promises
* [require-dir](https://www.npmjs.com/package/require-dir)

## Recommendations

### Recommended Sass modules 

* [cssReset](http://html5doctor.com/html-5-reset-stylesheet/) - Basic boilerplates for HTML 5
* [susy](http://susy.oddbird.net/) - Pretty grid system
* [breakpoint-sass](http://breakpoint-sass.com/) - Writing simple media queries in Sass
* [Foundation 6](http://foundation.zurb.com/sites/docs/) - Complete Html/Css framework

### Recommended code Rules

You will find those advices into the demo *.scss files

* [BEM-Block, Element, Modifier](https://en.bem.info/tutorials/quick-start-static/)
* [SMACSS-Scalable and modular architecture for CSS](https://smacss.com/)