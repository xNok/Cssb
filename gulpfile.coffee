#--------------------------------
#------ Imports -----------------
#--------------------------------
#%%%%% Primary Tools %%%%%
_               = require('lodash')
argv            = require('yargs').argv
fs              = require('fs')
path            = require('path')
log             = require('./logger')()

#%%%%% Config Information %%%%%
# Path
configPath      = require('./_config/paths.coffee')
path_docs       = configPath.path_docs
path_init       = configPath.path_init
path_ghpage     = configPath.path_ghpage
# module config
configTasks     = require('./_config/tasks.coffee')
browser_support = configTasks.browser_support
images_config   = configTasks.images_config

#%%%%% Plugins %%%%%
gulp            = require('gulp-help')(require('gulp'),{
  aliases: ['h']
  hideEmpty: true
  hideDepsMessage: true
})

$               = require('gulp-load-plugins')({
    DEBUG: false, # when set to true, the plugin will log info to console. Useful for bug reporting and issue debugging 
    pattern: ['gulp-*', 'gulp.*', 'browser-sync', 'babel-preset-es2015'], # the glob(s) to search for 
    #config: 'package.json', # where to find the plugins, by default searched up from process.cwd() 
    scope: ['dependencies', 'devDependencies', 'peerDependencies'], # which keys in the config to look within 
    replaceString: /^gulp(-|\.)/, # what to remove from the name of the module when adding it to the context 
    camelize: true, # if true, transforms hyphenated plugins names to camel case 
    lazy: true, # whether the plugins should be lazy loaded on demand 
    rename: {
      'babel-preset-es2015': 'es2015'
    }, # a mapping of plugins to rename 
})

runSequence     = require('run-sequence')
deleteEmpty     = require('delete-empty')
gitbook         = require('gitbook')

#--------------------------------
#------ Functions definition ----
#--------------------------------
getFolders  = require('./tasks__helpers/helper-files.js').getFolders
getFiles    = require('./tasks__helpers/helper-files.js').getFiles
getJsons    = require('./tasks__helpers/helper-files.js').getJsons
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
  reqStrg = './tasks__' + nameArray[0] + '/' + nameArray[1] + '.coffee' #expected ./task__mainCat/subCat
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
  return deleteEmpty.sync(copy_directories_out, {force: true})

#--------------------------------
#------ 2.frontdev --------------
#--------------------------------
# 2.0 Init tasks
# 2.1 frontend watch
# 2.2 main tasks
# 2.3 frontend dev
# 2.4 frontend post-dev
# 2.5 frontend Content/Data Management
# 2.6 linting Tasks
#--------------------------------

frontdev_OUT = configPath.path_frontdev.out
frontdev_IN  = configPath.path_frontdev.in

#%%%%% 2.0 Init tasks %%%%%
gulp.task 'init:frontdev', 'Copy paste the app folder into the project_dev folder', ->
  copy_directories_out = frontdev_IN.src
  copy_directories_in  = path_init.website
  runSequence('copy-directories','delete-empty-directories')

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

#%%%%% 2.3 frontend dev %%%%%

###
@plugin : changed, sass, autoprfixer, browsersync
@input  : pathIN, pathOUT
@options: autoprfixer
###
gulp.task 'frontdev:compile:sass2css','Build the css assets', ->
  getTask(this,
    {
      pathIN:  frontdev_IN.css.dev
      pathOUT: frontdev_OUT.css
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

# #%%%%% 2.4 frontend post-dev %%%%%
 
# TODO complite refactoring 

# ###
# @plugin : changed, babel, uglify
# @input  : pathIN, pathOUT, options
# @options: babel
# ###
# gulp.task 'minify:js','Build minified JS files and addapte ES6', ->
#   frontdevMinify.js [path_IN.js.watch, '!'+path_IN.js.ignore], path_OUT.js, {
#     babel: {"presets": [es2015]}
#   }

# ###
# @plugin : sass, autoprefixer, cleanCss
# @input  : pathIN, pathOUT, options
# @options: autoprefixer, cleanCSS
# ###
# gulp.task 'minify:css','Build minified CSS files and addapte SCSS', ->
#   frontdevMerge.jsons path_IN.scss.dev, path_OUT.css , {
#     autoprfixer: {browsers: browser_support},
#     cleanCSS: {debug: true}
#   }

###
@plugin : changed
@input  : pathIN, pathOUT
@options:
###
gulp.task 'frontdev:copy:vendors','Copy past your vendors without treatment', ->
  gulp.src frontdev_IN.vendors.src
  .pipe $.changed(frontdev_IN.vendors.src)
  .pipe gulp.dest(frontdev_OUT.vendors)

# #%%%%% 2.4 frontend Content/Data Management %%%%%

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

# #%%%%% 2.5 linting Tasks %%%%%

# ###
# @plugin : jsonlint, mergeJson
# @input  : pathIN
# @options:
# ###
# gulp.task 'lint:json', 'lint JSON files', ->
#   frontdevLint.jsons path_IN.data.json


#--------------------------------
#------ 3.Documentation ---------
#--------------------------------
# 3.0 Init tasks
# -------------------------------

#%%%%% 2.0 Init tasks %%%%%
gulp.task 'init:gitbook', 'Copy paste gitbook template in the project_doc directory' , ->
  copy_directories_out = path_docs.in.src
  copy_directories_in  = path_init.gitbook
  runSequence('copy-directories','delete-empty-directories')

# ###
# @plugin : ghPages
# @input  : pathIN
# @options:
# ###
# gulp.task 'gh-pages','Publish gh-pages', ->
#   publishGhPage.publish path_ghpage.in

# ###
# @plugin : gitbook
# @input  : pathIN, pathOUT, options
# @options: log: info/debug , format: website, timing: false
# ###
# gulp.task 'gitbook', 'Publish pdf gitbook' , ->
#   docsGitbook.website path_docs.in.src, path_docs.out.website, { log: 'info', format: 'website', timing: false }

# ###
# @plugin : gitbook
# @input  : pathIN, pathOUT, options
# @options: log: info/debug , format: website, timing: false
# ###
# gulp.task 'gitbook-pdf', 'Publish pdf gitbook' , ->
#   docsGitbook.pdf path_docs.in.src, path_docs.out.pdf, { log: 'info', format: 'ebook', timing: false }

# ###
# @plugin : _, getFolders, getFiles, path
# @input  : pathIN
# @options:
# ###
# gulp.task 'helper:gitbook', 'helper for gitbook' , ->
#   helperGitbook.generateSummary path_docs.in.src

