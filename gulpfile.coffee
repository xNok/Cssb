#--------------------------------
#------ Imports -----------------
#--------------------------------
#%%%%% Primary Tools %%%%%
_               = require('lodash')
argv            = require('yargs').argv
fs              = require('fs')
path            = require('path')
log             = require('./logger')()
dirTree         = require('directory-tree')

#%%%%% Config Information %%%%%
# Path
configPath      = require('./_config/paths.coffee')
# module config
configTasks     = require('./_config/tasks.coffee')
browser_support = configTasks.browser_support
images_config   = configTasks.images_config

#%%%%% Plugins %%%%%
gulp = require('gulp-help')(require('gulp'),{
  aliases: ['h']
  hideEmpty: true
  hideDepsMessage: true
})

$ = require('gulp-load-plugins')({
    DEBUG: false, # when set to true, the plugin will log info to console. Useful for bug reporting and issue debugging 
    pattern: ['gulp-*', 'gulp.*',
    'browser-sync',
    'babel-preset-es2015',
    'vinyl-paths',
    'del',
    'gitbook',
    'delete-empty',
    'run-sequence'], # the glob(s) to search for 
    #config: 'package.json', # where to find the plugins, by default searched up from process.cwd() 
    scope: ['dependencies', 'devDependencies', 'peerDependencies'], # which keys in the config to look within 
    replaceString: /^gulp(-|\.)/, # what to remove from the name of the module when adding it to the context 
    camelize: true, # if true, transforms hyphenated plugins names to camel case 
    lazy: true, # whether the plugins should be lazy loaded on demand 
    rename: {
      'babel-preset-es2015': 'es2015'
    }, # a mapping of plugins to rename 
})

#--------------------------------
#------ Functions definition ----
#--------------------------------
getFolders  = require('./tasks/helpers/helper-files.js').getFolders
getFiles    = require('./tasks/helpers/helper-files.js').getFiles
getJsons    = require('./tasks/helpers/helper-files.js').getJsons
#--------------------------------
#------ 0.dev -------------------
#--------------------------------

# Patch gulp to add new function inside a task
_gulpStart = gulp.Gulp.prototype.start
_runTask = gulp.Gulp.prototype._runTask

gulp.Gulp.prototype.start = (taskName) ->
    this.currentStartTaskName = taskName
    _gulpStart.apply(this, arguments)

gulp.Gulp.prototype._runTask = (task) ->
    this.currentRunTaskName = task.name;
    _runTask.apply(this, arguments);

# create a report about this gulp file
gulp.task 'dirTree','Display gulp.tasks and create a resport tasks.json', ->
  taskReport = {}
  stream = fs.createWriteStream("dirTree.json")
  stream.once('open', (fd) ->
      stream.write JSON.stringify(dirTree('../docsBook/web'))
      stream.end
  );

# create a report about the directory structure
gulp.task 'tasks','Display gulp.tasks and create a resport tasks.json', ->
  taskReport = {}
  log.info.ln(gulp.tasks)
  stream = fs.createWriteStream("tasks.json")
  stream.once('open', (fd) ->
      stream.write JSON.stringify(gulp.tasks)
      stream.end
  );

# require a task based on the pattern
getTask = (task, input, options) ->
  name = task.currentRunTaskName
  log.debug.ln('getTask >> ' + name)
  nameArray = name.split(':') # expected mainCat:subCat:name
  reqStrg = './tasks/' + nameArray[0] + '/' + nameArray[1] + '.coffee' #expected ./task__mainCat/subCat
  return require(reqStrg)[nameArray[2]](gulp, $, input, options)()

#--------------------------------
#------ 1. Init task   ----------
#--------------------------------
#%%%%% Init var %%%%%
copy_directories_out = "./"
copy_directories_in = "../"

gulp.task 'copy-directories', 'copy directories to another loaction' ,->
  return gulp.src copy_directories_in
  .pipe gulp.dest(copy_directories_out)

gulp.task 'delete-empty-directories', 'cleanup empty directories',->
  return $.deleteEmpty.sync(copy_directories_out, {force: true})

#--------------------------------
#------ 2.frontdev --------------
#--------------------------------
# 2.0 Init tasks
# 2.1 frontend watch
# 2.2 main tasks
# 2.3 compilation tasks
# 2.4 linting Tasks
# 2.5 minify tasks
# 2.6 linting Tasks
#--------------------------------

frontdev_OUT  = configPath.path_frontdev.out
frontdev_IN   = configPath.path_frontdev.in
frontdev_init = configPath.path_init.website

#%%%%% 2.0 Init tasks %%%%%
gulp.task 'init:frontdev', 'Copy paste the app folder into the project_dev folder', ->
  copy_directories_out = frontdev_IN.src
  copy_directories_in  = frontdev_init
  $.runSequence('copy-directories','delete-empty-directories')

#%%%%% 2.1 frontend watch %%%%%

gulp.task 'watch:frontdev','run browserSync server', ->
  $.browserSync server: {baseDir: frontdev_OUT.src}
  gulp.watch frontdev_IN.css.watch, ['frontdev:compile:sass2css']
  gulp.watch frontdev_IN.html.watch, ['frontdev:compile:swig2html', $.browserSync.reload]
  gulp.watch frontdev_IN.js.watch, ['frontdev:compile:babel2js']
  gulp.watch frontdev_IN.contents.json, (event) ->
    console.log('File ' + event.path + ' was ' + event.type + ', running tasks...')
    runSequence('frontdev:merge:jsons' ,'frontdev:compile:swig2html', $.browserSync.reload)
  gulp.watch frontdev_IN.img.dev, ['frontdev:minify:images']  

#%%%%% 2.2 main tasks %%%%%

gulp.task 'default', 'Run dev tasks', [
  'frontdev:compile:swig2html'
  'frontdev:compile:sass2css'
  'frontdev:compile:babel2js'
  'frontdev:copy:vendors'
  'frontdev:minify:images'
  'watch:frontdev'
]

# gulp.task 'dist','Build production files', taskBundle.dist

#%%%%% 2.3 compilation tasks %%%%%

###
@plugin : changed, sass, autoprfixer, browsersync, sourcemaps
@input  : pathIN, pathOUT,pathMAPS
@options: autoprfixer, sass
###
gulp.task 'frontdev:compile:sass2css','Build the css assets', ->
  getTask(this,
    {
      pathIN:   frontdev_IN.css.dev
      pathOUT:  frontdev_OUT.css
      pathMAPS: frontdev_OUT.maps
      sass: {outputStyle: 'compressed'}
      argv: argv
    },{
      autoprfixer: {browsers: browser_support}
    }
  )
,{
  aliases: ['sass'],
  options: {
    'env=prod': 'Compile and minify'
    'env=dev' : 'Compile & sourceMap & browserSync'
  }
}

###
@plugin : plumber, data, swig, getJsons
@input  : pathIN, pathOUT, pathDATA
@options: swig
###
gulp.task 'frontdev:compile:swig2html','Built pages with swig template engine', ->
  getTask this,
    {
      pathIN:   frontdev_IN.html.pages.dev
      pathOUT:  frontdev_OUT.html
      pathDATA: frontdev_IN.contents.src
      argv: argv
    },{
      swig: {defaults: { cache: false }}
      getJsons: getJsons
    }
,{
  aliases: ['swig'],
  options: {
    'env=prod': ''
    'env=dev' : ''
  }
}

###
@plugin : changed, plumber, babel
@input  : pathIN, pathOUT, options
@options: babel
###
gulp.task 'frontdev:compile:babel2js', 'Build JS files from ES6', ->
  getTask this,
    {
      pathIN:   frontdev_IN.js.dev
      pathOUT:  frontdev_OUT.js
      pathMAPS: frontdev_OUT.maps
      argv: argv
    },{
      babel: {"presets": [$.es2015]}
    }
,{
  aliases: ['js'],
  options: {
    'env=prod': ''
    'env=dev' : ''
  }
}

#%%%%% 2.4 linting Tasks %%%%%

###
@plugin : jsonlint
@input  : pathIN
@options:
###
gulp.task 'frontdev:lint:json','Optimise images', ->
  getTask this,
    {
      pathIN:   frontdev_IN.contents.json
      argv: argv
    },{

    }
,{
  aliases: ['lint:jsons'],
  options: {
    'env=prod': ''
    'env=dev' : ''
  }
}

###
@plugin : jshint
@input  : pathIN
@options:
###
gulp.task 'frontdev:lint:js','Optimise images', ->
  getTask this,
    {
      pathIN:   frontdev_IN.js.src + '/app.js'
      argv: argv
    },{

    }
,{
  aliases: ['lint:js'],
  options: {
    'env=prod': ''
    'env=dev' : ''
  }
}

#%%%%% 2.5 minify tasks %%%%%

###
@plugin : changed, image
@input  : pathIN, pathOUT, options
@options: image
###
gulp.task 'frontdev:minify:images','Optimise images', ->
  getTask this,
    {
      pathIN:   frontdev_IN.img.dev
      pathOUT:  frontdev_OUT.img
      argv: argv
    },{
      image: images_config
    }
,{
  aliases: ['img'],
  options: {
    'env=prod': ''
    'env=dev' : ''
  }
}

###
@plugin : changed, babel, uglify
@input  : pathIN, pathOUT
@options
###
gulp.task 'frontdev:minify:js','Minify js files', ->
  getTask this,
    {
      pathIN:   [frontdev_OUT.js + '/*.js', '!' + frontdev_OUT.js + '/*.min.js']
      pathOUT:  frontdev_OUT.js
      argv: argv
    },{

    }
,{
  aliases: ['minify:js'],
  options: {
    'env=prod': ''
    'env=dev' : ''
  }
}

###
@plugin : changed, babel, uglify
@input  : pathIN, pathOUT, options
@options
###
gulp.task 'frontdev:minify:css','Minify css files', ->
  getTask this,
    {
      pathIN:   [frontdev_OUT.css + '/*.css', '!' + frontdev_OUT.css + '/*.min.css']
      pathOUT:  frontdev_OUT.css
      argv: argv
    },{

    }
,{
  aliases: ['minify:css'],
  options: {
    'env=prod': ''
    'env=dev' : ''
  }
}

###
@plugin : useref, gulpif, uglify, cleanCss
@input  : pathIN, pathOUT
@options: cleanCss
###
gulp.task 'frontdev:minify:useref','Concat assets dedicated to a single html page', ->
  getTask this,
    {
      pathIN:   frontdev_OUT.html + 'index.html'
      pathOUT:  frontdev_OUT.html
      argv: argv
    },{

    }
,{
  aliases: ['minify:useref', 'useref'],
  options: {
    'env=prod': ''
    'env=dev' : ''
  }
}

###
@plugin : del
@input  : pathIN
@options: 
###
gulp.task 'frontdev:minify:cleanUp','Remove non minify files', ->
  getTask this,
    {
      pathIN:   [frontdev_OUT.css + '/*.css', '!' + frontdev_OUT.css + '/*.min.css',
                 frontdev_OUT.js + '/*.js', '!' + frontdev_OUT.js + '/*.min.js']
      pathOUT:  frontdev_OUT.html
      argv: argv
    },{

    }
,{
  aliases: ['minify:cleanup'],
  options: {
    'env=prod': ''
    'env=dev' : ''
  }
}

#%%%%% 2.4 frontend Content/Data Management %%%%%

###
@plugin : changed
@input  : pathIN, pathOUT
@options:
###
gulp.task 'frontdev:copy:vendors','Copy past your vendors without treatment', ->
  gulp.src frontdev_IN.vendors.src
  .pipe $.changed(frontdev_IN.vendors.src)
  .pipe gulp.dest(frontdev_OUT.vendors)



###
@plugin : plumber, mergeJson
@input  : pathIN, pathOUT, options
@options:
###
gulp.task 'frontdev:merge:jsons', 'merge Json files under a folder to one json file with the folder name', ->
  getTask this,
    {
      pathIN:   frontdev_IN.contents.src
      pathOUT:  frontdev_IN.contents.src
      argv: argv
    },{
      getFolders: getFolders
      path: path
    }
,{
  aliases: ['jsons'],
  options: {
    'env=prod': ''
    'env=dev' : ''
  }
}

# ###
# @plugin : yaml
# @input  : pathIN, pathOUT, options
# @options: yaml
# ###
# gulp.task 'compile:yaml2json', 'Convert YAML to JSON', ->
#   frontdevCompile.yaml2json path_IN.data.yaml, path_IN.data.src, {
#     yaml: { schema: 'DEFAULT_SAFE_SCHEMA' }
#   }

#--------------------------------
#------ 3.Documentation ---------
#--------------------------------
# 3.0 Init tasks
# -------------------------------

docs_OUT  = configPath.path_docs.out
docs_IN   = configPath.path_docs.in
docs_init = configPath.path_init.gitbook

#%%%%% 2.0 Init tasks %%%%%
gulp.task 'init:gitbook', 'Copy paste gitbook template in the project_doc directory' , ->
  copy_directories_out = docs_IN.src
  copy_directories_in  = docs_init
  $.runSequence('copy-directories','delete-empty-directories')

# ###
# @plugin : gitbook
# @input  : pathIN, pathOUT, options
# @options: log: info/debug , format: website, timing: false
# ###
# gulp.task 'gitbook', 'Publish pdf gitbook' , ->
#   docsGitbook.website path_docs.in.src, path_docs.out.website, 
gulp.task 'docs:gitbook:website', 'Publish website gitbook', ->
  getTask this,
    {
      pathIN:   docs_IN.src
      pathOUT:  docs_OUT.website
      argv: argv
    },{
      log: 'info', format: 'website', timing: false
    }
,{
  aliases: ['gitbook'],
  options: {
    'env=prod': ''
    'env=dev' : ''
  }
}

###
@plugin : gitbook
@input  : pathIN, pathOUT, options
@options: log: info/debug , format: website, timing: false
###
gulp.task 'docs:gitbook:pdf', 'Publish website gitbook', ->
  getTask this,
    {
      pathIN:   docs_IN.src
      pathOUT:  docs_OUT.pdf
      argv: argv
    },{
      log: 'info', format: 'ebook', timing: false
    }
,{
  aliases: ['gitbook:pdf', 'doc:pdf', 'pdf'],
  options: {
    'env=prod': ''
    'env=dev' : ''
  }
}

# ###
# @plugin : _, getFolders, getFiles, path
# @input  : pathIN
# @options:
# ###
# gulp.task 'helper:gitbook', 'helper for gitbook' , ->
#   helperGitbook.generateSummary path_docs.in.src

# ###
# @plugin : ghPages
# @input  : pathIN
# @options:
# ###
# gulp.task 'gh-pages','Publish gh-pages', ->
#   publishGhPage.publish path_ghpage.in