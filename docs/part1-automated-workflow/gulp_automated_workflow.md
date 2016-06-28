# Create a Gulp Automated work-flow

An automated workflow helps you to save many hour of your time by using pre-programmed commands lines. Moreover, Creating such tools is a bit like writing a recipes book, containing all the boring task you used to do. From now, we called this recipes book the __gulpfile__.

However creating such a work-flow required you to spend some time first to develop it. It's still bit difficult to get a complete and an reliable engine, because  you have to together a lot of technology and make them work together in the proper way.

The purpose of this documentation is to let you discover few technologies that I picked and integrated to my work-flow
Every time I will also quotes alternative choices to each of those technology to gives the maximum information to make your choices. So with the documentation you can understand my project and maybe start to build your own work-flow.

## Get Ready

Before you can start with your automated work-flow you need to install some softwares.

Start by install [node.js](https://nodejs.org/en/). Node.js is a javaScript server, that's simply means it is a server reading/executing javaScript language. 

Node.js comes with a very interesting tool witch is __npm__ a package manager. You will use npm to install, share, distribute code and manage dependencies. Npm it is also an [online platform](https://www.npmjs.com/) where you can find more than 250 000 package to create your work-flow.

Lets install your first package with __npm__. You may have already find the name of this package.

> npm init
> npm install gulp --save-dev

The flag `--save-dev` will register _gulp_ as a `devDependencies` into your [package.json]() file, the file in charged of collecting all the information about your project. For the dependencies essential for the production mode of your project use the flag `--save`.

The npm different dependences levels are

| Nom | Usage | Description |
|-----|-------|-------------|
|dependences         | production  | . |
|devdependencies     | development | . |
|peerdependences     |             | . |
|optianaldependencies|             | . |
|bundledependencies  |             | . |

Note that you can also install gulp globally.

> npm install -g gulp

## Gulpfile

### Define a tasks

Now that you have install gulp and all the dependencies, you can start your gulp file with the first task.

```javascript
var gulp = require('gulp');

gulp.task('task:name', function() {
   //do something 
});
```

This task is very useless but you can test it :
> gulp task:name

Now that your task is working we can make something useful such as compiling you sass files into css.

first add __gulp-sass__ :
> npm i gulp-sass -D

```javascript
var gulp = require('gulp');
var sass = require('gulp-sass');            //the sass module

gulp.task('task:name', function() {
  gulp.src(pathIN)                          //select our files
  .pipe(sass().on('error', sass.logError))  //go thought the sass function
  .pipe(gulp.dest(pathOUT))                 //go out
});
```

A task is always construct as following :
    1. you get the files you need with `gulp.scr` - it is the sources
    2. you files go thought function with the function `pipe`
    3. the you write the computed files where you when with `gulp.src`

See this task like a flow of water, our files go thought pipes, are modified by the current en then or pushing out.

Now let's create an even more complicated task :
    1. compile sass
    2. add cross-browser tags

first add __autoprefixer__ :
> npm i autoprefixer -D

```javascript
var gulp = require('gulp');
var sass = require('gulp-sass');            //the sass module
var autoprefixer = require('autoprefixer'); //the autoprefixer module

gulp.task('task:name', function() {
  gulp.src(pathIN)                          //select our files
  .pipe(sass().on('error', sass.logError))  //go thought the sass function
  .pipe(autoprefixer(options.autoprefixer)) //go thought the sass function
  .pipe(gulp.dest(pathOUT))                 //go out
});
```

### Divide your gulpfile

'Divide and rule'. A good process could be to divide your gulpfile into smaller part. So you can share your woks and some part of your automated work-flow

#### First methode

The first thing to do is installing `require-dir` and reference it into your gulpfile. Then require the directories where are stored your task.

``` javascript
var requireDir = require('require-dir');
requireDir('./gulptasks', { recurse: true });
```

This is a very widespread method, but I disagree on that point because most off the tasks are 3~4 lines or a list of task with [runSequence](). That why I prefer import that way only the tasks that I called [helpers](). The other task can stay in your gulpfile as a cookBook with all the recipes and for each the list of the ingredient.

#### Second methode

This method keep the definition of your task in your gulpfile, but `require` a function that you stored in an other file. This is very useful to keep this idea or cookbook but also for running unit tests.

I have files containing the structure of the task for example :

```coffeescript
###
@plugin : test
@input  : pathIN, pathOUT, options
@options: test
###
exports.myFunction = (pathIN, pathOUT, options) ->
  return () -> 
      gulp.src pathIN
      .pipe test(options.test)
      .pipe gulp.dest(pathOUT)
```

Now, you can use it in your gulpfile as following :

``` coffeescript
frontdevCompile = require('./tasks__frontdev/compile.coffee')

###
@plugin : test
@input  : pathIN, pathOUT, options
@options: test
###
gulp.task 'compile:sass','Build the css assets', ->
  frontdevCompile.test pathIN, pathOUT, options

```

## testing your task

## Bibliography

### Gulp.js
* [Introduction to Gulp.js](http://stefanimhoff.de/2014/gulp-tutorial-1-intro-setup/)
* [Recipes of the gulpjs repository](http://gulpjs.org/recipes/automate-release-workflow.html)
* [How to Modularize HTML Using Template Engines and Gulp](http://zellwk.com/blog/nunjucks-with-gulp/)
* [A delicious blend of gulp tasks combined into a configurable asset pipeline and static site builder](https://github.com/vigetlabs/gulp-starter)
* [Simple functional tests for gulp task](https://duske.me/simple-functional-tests-for-gulp-tasks)
* [Small Sips of Gulp.js: 4 Steps to Reduce Complexity](https://teamgaslight.com/blog/small-sips-of-gulp-dot-js-4-steps-to-reduce-complexity)
* [Splitting a gulpfile into multiple files](http://macr.ae/article/splitting-gulpfile-multiple-files.html)
* [Automatically Load Gulp Plugins with gulp-load-plugins](http://andy-carter.com/blog/automatically-load-gulp-plugins-with-gulp-load-plugins)