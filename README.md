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

1. The project uses Gulp to run tasks. Thus start by intall gulp with [node.js](https://nodejs.org/en/)

> npm install -g gulp

2. then install dependencies

> npm install

3. Define our project dist folder (default: ../www) & project dev folder (default ../app)

In gulpfile.coffee

``` JS
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

Thus you can update the cssb project easly. For example to update you Cssb folder
```
git fetch origin
git rebase origin
```

You can create easely your own git on the __./__ directory et __./app__ and save only the interesting files

## Tools

### Tasks

#### Main tasks
* default: Run devs tasks
* dist: Build production files
* gh-pages: Publish gh-pages

#### Sub tasks
* watch: Watch assets and templates for build on change
* sass: Build the css assets
* minify-css: Build minified CSS files and addapte SCSS
* swig: Built pages with swig template engine
* uglify: Build minified JS files
* babel: Build JS files frome ES6
* JSvendors: Copy past your vendors without treatment

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

#### Developement
* [browser-sync](http://www.browsersync.io/) - Navigator autorelaod
* vendors - Copy your project_scr/vendors folder to the project_dist/vendors

#### Tools
* [gulp-changed](https://www.npmjs.com/package/gulp-changed) - relaod only changed files
* [yards](https://www.npmjs.com/package/yargs) - Allow to add arguments to gulp task
. [gulp-if](https://www.npmjs.com/package/gulp-if) - Allow condition into tasks

### Template engine uses

Thanks to the template engine __swig__ you can use json data. So complete the json file located in __./data/app.json__

You can personalise this ine the Data section of __gulpfile.coffee__

```
#Data
JsonData = (file) ->
  require('./data/app.json')
```

### Known issues

### Recommended Sass modules 

* [cssReset](http://html5doctor.com/html-5-reset-stylesheet/) - Basic boilerplates for HTML 5
* [susy](http://susy.oddbird.net/) - Pretty grid system
* [breackpoint-sass](http://breakpoint-sass.com/) - Writing simple media queries in Sass
* [Foundation 6](http://foundation.zurb.com/sites/docs/)

### Recommended code Rules

* [BEM-Block, Element, Modifier](https://en.bem.info/tutorials/quick-start-static/)
* [SMACSS-Scalable and modular architecture for CSS](https://smacss.com/)

## Basics layouts solution

### Created with susy

* [three Boxes](http://xnok.github.io/Cssb/threeBoxes)
* [three Images](http://xnok.github.io/Cssb/threeImages)
