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

## Gulpfile

### Devide your gulpfile

'Divide and rule'. A good process could be to divide your gulpfile into smaller part. So you can share your woks and some part of your automated work-flow

The first thing to do is installing `require-dir` and reference it into your gulpfile. Then require the directories where are stored your task.

``` javascript
var requireDir = require('require-dir');
requireDir('./gulptasks', { recurse: true });
```

This is a very widespread method, but I desagree on that point because most off the tasks are 3~4 lines or a list of task with [runSequence](). That why I prefer import that way only the tasks that I called [helpers](). The other task can stay in your gulpfile as a cookBook with all the recipes and for each the list of the ingredient.

## Bibliography

### Gulp.js
* [Introduction to Gulp.js](http://stefanimhoff.de/2014/gulp-tutorial-1-intro-setup/)
* [Recipes of the gulpjs repository](http://gulpjs.org/recipes/automate-release-workflow.html)
* [How to Modularize HTML Using Template Engines and Gulp](http://zellwk.com/blog/nunjucks-with-gulp/)
* [A delicious blend of gulp tasks combined into a configurable asset pipeline and static site builder](https://github.com/vigetlabs/gulp-starter)

### npm

* [npm automated workflow](https://github.com/xNok/Cssb/tree/master/documentation/npm_automated_workflow.md) - ME
* [npm-script](https://docs.npmjs.com/misc/scripts) - official documentation
* [How to Use npm as a Build Tool](http://blog.keithcirkel.co.uk/how-to-use-npm-as-a-build-tool/) - Andrew Burgess
* [Why I Left Gulp and Grunt for npm Scripts](https://medium.freecodecamp.com/why-i-left-gulp-and-grunt-for-npm-scripts-3d6853dd22b8#.tym949kgf) - Cory House