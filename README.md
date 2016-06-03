# Cssb

Frontend tools, automating your workflow with [gulp](http://gulpjs.com/).

The project provide a set of pre-programmed command. These commandes will help you to simplify and impove your developement process. Use it or [learn how to build your own automated workflow](https://github.com/xNok/Cssb/blob/master/documentation/gulp_automated_workflow.md).

The main enhancements that bring this project are :

1. Never start a project from scratch
2. Letting you write modular code
    * css -> [sass|scss](http://sass-lang.com/)
    * js  -> [ES6](https://babeljs.io/)
    * html-> [swig](http://paularmstrong.github.io/swig/)
3. Compiling your modular files whenever it is changed
4. Refreshing your browser automatically
5. Warning you whenerer you made errors in your code

## Configuration

1. The project uses Gulp to run tasks. Thus start by intall gulp with [node.js](https://nodejs.org/en/) (I use v5.6.0)

> npm install -g gulp

2. then install dependencies

> npm install

3. Configure your ptoject

 Define our project dist folder (default: ../www) & project dev folder (default ../app)

In config.coffee

```javascript
#- Project definition

project_dev = "../app"
project_name = "../www"
```

4. Copy the sample app to your project_dev directory

> gulp init

5. finally run the gulp application

> gulp

## Dev strategy

I recommend that you use the Cssb project as a submodule :

```
+-- Cssb
 `+-- app               // Sample code
  +-- documentation     // Tricks to develop faster your application
  +-- node_modules      // All modules you needed - see Node_modules section
  +-- gulpifile.coffee  // configuration file
  +-- package.json      // dependencies
  +-- README.md         // the documentation entry point
+-- app                 // your dev folder
+-- www                 // your production folder
```

Thus you can update the cssb project easly and you can create your own git on the __./__ directory et __./app__ and save only the interesting files.

## Tools

### Tasks

#### Main tasks
* **init**:      Copy paste the app folder into the project_dev folder
* **default**:   Run devs tasks
* **lint**:      Run linters
* **dist**:      Build production files
* **gh-pages**:  Publish gh-pages

#### Sub tasks

##### frontend dev
* **compile:sass**:         Build css assets
* **compile:swig**:         Build pages with swig template engine
* **compile:babel**:        Build JS files frome ES6
* **minify:image**:        Optimise images

##### frontend post-dev
* **minify:js**:    Build minified ES6/JS files
* **minify:css**:   Build minified CSS files and addapte SCSS
* **copy:vendors**:      Copy your project_scr/vendors folder to the project_dist/vendors

##### watch
* **watch:browserSync**:  Watch assets and templates for build on change
* **watch:swig**:         Watch html/swig files
* **watch:babel**:        Watch js/babel files
* **watch:swig**:         Watch data/content files
* **watch:image**:        Watch images

##### linting
* **lint:Json**:    lint JSON files

### Node_modules

#### Javascript
* [coffee-script](http://coffeescript.org/) - .coffee interpretation
* [gulp-babel](https://www.npmjs.com/package/gulp-babel) - Use next generation JavaScript
* [gulp-uglify](https://www.npmjs.com/package/gulp-uglify) - Minify JS files

#### CSS
* [gulp-sass](http://sass-lang.com/) - .scss compilation
* [autoprefixer](https://css-tricks.com/autoprefixer/) - Simple navigator compatibiity
* [gulp-clean-css](https://github.com/scniro/gulp-clean-css) - minify css files

#### HTML
* [swig](https://www.npmjs.com/package/gulp-swig) - html templating engine
* [gulp-image](https://www.npmjs.com/package/gulp-image) - Optimize PNG, JPG, GIF, SVG images

#### Developement & Linting
* [browser-sync](http://www.browsersync.io/) - Navigator autorelaod
* [gulp-jsonlint](https://www.npmjs.com/package/gulp-jsonlint) - linting JSON files

#### Tools
* [gulp-changed](https://www.npmjs.com/package/gulp-changed) - relaod only changed files
* [gulp-yaml](https://www.npmjs.com/package/gulp-yaml) - Convert YAML to JSON
* [yards](https://www.npmjs.com/package/yargs) - Allow to add arguments to gulp task
* [gulp-if](https://www.npmjs.com/package/gulp-if) - Allow condition into tasks
* [runSequence](https://www.npmjs.com/package/run-sequence) - Run a series of dependent gulp tasks in order
* [deleteEmpty](https://www.npmjs.com/package/delete-empty) - Delete recursivly empty folders

### Recommended Sass modules 

* [cssReset](http://html5doctor.com/html-5-reset-stylesheet/) - Basic boilerplates for HTML 5
* [susy](http://susy.oddbird.net/) - Pretty grid system
* [breackpoint-sass](http://breakpoint-sass.com/) - Writing simple media queries in Sass
* [Foundation 6](http://foundation.zurb.com/sites/docs/) - Complete Html/Css framework

### Recommended code Rules

You will find those advices into the demo *.scss files

* [BEM-Block, Element, Modifier](https://en.bem.info/tutorials/quick-start-static/)
* [SMACSS-Scalable and modular architecture for CSS](https://smacss.com/)