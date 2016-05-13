# Cssb

Base Frontend tools 

## Configuration

1. The project uses Gulp to run tasks. Thus start by intall gulp with [node.js](https://nodejs.org/en/)

> npm install -g gulp

2. then install dependencies

> npm install

3. Define our project dist folder (default: www)

In gulpfile.coffee

``` JS
#- Project definition

project_name = "www"
```

finally run the gulp application

> gulp

## Tools

### Tasks

* default: Watch assets and templates for build on change
* dist: Build production files
* gh-pages','Publish gh-pages

* sass: Build the css assets
* swig: Built pages with swig template engine
* uglify: Build minified JS files

### Node_modules

* [coffee-script](http://coffeescript.org/) - .coffee interpretation
* [gulp-sass](http://sass-lang.com/) - .scss compilation
* [browser-sync](http://www.browsersync.io/) - Navigator autorelaod
* [autoprefixer](https://css-tricks.com/autoprefixer/) - Simple navigator compatibiity
* [swig](https://www.npmjs.com/package/gulp-swig) - html templating engine
* [gulp-uglify](https://www.npmjs.com/package/gulp-uglify) - Minify JS files

### Template engine uses

Thanks to the template engine __swig__ you can use json data. So complete the json file located in __./data/app.json__

You can personalise this ine the Data section of __gulpfile.coffee__

```
#Data
JsonData = (file) ->
  require('./data/app.json')
```

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
