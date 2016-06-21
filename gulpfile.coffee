#--------------------------------
#------ Imports -----------------
#--------------------------------
#%%%%% Primary Tools %%%%%
_               = require('lodash')
argv            = require('yargs').argv
fs              = require('fs')
path            = require('path')
requireDir      = require('require-dir')

#%%%%% Config Information %%%%%
# Path
configPath      = require('./_config/paths.coffee')
path_OUT        = configPath.path_frontdev.out
path_IN         = configPath.path_frontdev.in
path_docs       = configPath.path_docs
path_init       = configPath.path_init
# module config
configTasks     = require('./_config/tasks.coffee')
browser_support = configTasks.browser_support
images_config   = configTasks.images_config
# task config
taskBundle      = require('./_config/taskBundles.coffee')

#%%%%% Project tools %%%%%
gulp            = require('gulp-help')(require('gulp'))
plumber         = require('gulp-plumber')
gutil           = require('gulp-util')
changed         = require('gulp-changed')
runSequence     = require('run-sequence')
deleteEmpty     = require('delete-empty')
gulpif          = require('gulp-if')

#%%%%% frontend dev %%%%%
sass            = require('gulp-sass')
autoprefixer    = require('gulp-autoprefixer')
swig            = require('gulp-swig')
data            = require('gulp-data')
babel           = require('gulp-babel')
es2015          = require('babel-preset-es2015')
mergeJson       = require("gulp-merge-json")
browserSync     = require('browser-sync')
reload          = browserSync.reload
stream          = browserSync.stream

#%%%%% linters %%%%%
jsonlint        = require("gulp-jsonlint")

#%%%%% Post dev %%%%%
image           = require('gulp-image')
uglify          = require('gulp-uglify')
cleanCSS        = require('gulp-clean-css')

#%%%%% Publishing tools %%%%%
ghPages         = require('gulp-gh-pages')
gitbook         = require('gitbook')

#%%%%% helpers %%%%%
helpers         = requireDir('./helpers__tasks', { recurse: true })

#--------------------------------
#------ Functions definition ----
#--------------------------------
getFolders  = require('./tasks__helpers/helper-files.js').getFolders
getFiles    = require('./tasks__helpers/helper-files.js').getFiles
getJsons    = require('./tasks__helpers/helper-data.js').getJsons

#--------------------------------
#------ Tasks definition --------
#--------------------------------

#%%%%% 1.frontdev %%%%%
frontdevCompile = require('./tasks__frontdev/compile.coffee')
frontdevMinify  = require('./tasks__frontdev/minify.coffee')
frontdevMerge   = require('./tasks__frontdev/merge.coffee')
frontdevLint    = require('./tasks__frontdev/lint.coffee')
#%%%%% 2.documentation %%%%%
docsGitbook     = require('./tasks__docs/gitbook.coffee')
#%%%%% 3.publish %%%%%
publishGhPage   = require('./tasks__publish/ghPage.coffee')
#%%%%% 4.helpers %%%%%
helperGitbook   = require('./tasks__helpers/helper-gitbook.coffee')

#--------------------------------
#------ 1.frontdev --------------
#--------------------------------
# 1.1 frontend dev
# 1.2 frontend post-dev
# 1.3 frontend Content/Data Management
# 1.4 linting Tasks
# 1.5 frontend watch
# 1.6 main tasks
#--------------------------------

#%%%%% 1.1 frontend dev %%%%%

###
@plugin : changed, sass, autoprfixer, browsersync
@input  : pathIN, pathOUT, options
@options: autoprfixer
###
gulp.task 'compile:sass','Build the css assets', ->
  frontdevCompile.sass2Css path_IN.scss.dev, path_OUT.src, {autoprefixer:
    {browsers: browser_support}
  }

###
@plugin : plumber, data, swig, getJsons
@input  : pathIN, pathOUT, pathDATA, options
@options: swig
###
gulp.task 'compile:swig','Built pages with swig template engine', ->
  frontdevCompile.swig2html path_IN.swig.dev, path_IN.data.src, path_OUT.src, {
    swig: {defaults: { cache: false }}
  }

###
@plugin : changed, plumber, babel
@input  : pathIN, pathOUT, options
@options: babel
###
gulp.task 'compile:js', 'Build JS files from ES6', ->
  frontdevCompile.babel2js [path_IN.js.watch, "!"+path_IN.js.ignore], path_OUT.js, {
    babel: {"presets": [es2015]}
  }

###
@plugin : changed, image
@input  : pathIN, pathOUT, options
@options: image
###
gulp.task 'minify:image','Optimise images', ->
  frontdevMinify.images path_IN.image.dev,path_OUT.images, {image: images_config}

#%%%%% 1.2 frontend post-dev %%%%%
###
@plugin : changed, babel, uglify
@input  : pathIN, pathOUT, options
@options: babel
###
gulp.task 'minify:js','Build minified JS files and addapte ES6', ->
  frontdevMinify.js [path_IN.js.watch, '!'+path_IN.js.ignore], path_OUT.js, {
    babel: {"presets": [es2015]}
  }

###
@plugin : sass, autoprefixer, cleanCss
@input  : pathIN, pathOUT, options
@options: autoprefixer, cleanCSS
###
gulp.task 'minify:css','Build minified CSS files and addapte SCSS', ->
  frontdevMerge.jsons path_IN.scss.dev, path_OUT.css , {
    autoprfixer: {browsers: browser_support},
    cleanCSS: {debug: true}
  }

###
@plugin : changed
@input  : pathIN, pathOUT
@options:
###
gulp.task 'copy:vendors','Copy past your vendors without treatment', ->
  gulp.src path_IN.vendors
  .pipe changed(path_OUT.vendors)
  .pipe gulp.dest(path_OUT.vendors)

#%%%%% 1.3 frontend Content/Data Management %%%%%

###
@plugin : yaml
@input  : pathIN, pathOUT, options
@options: yaml
###
gulp.task 'compile:yaml2json', 'Convert YAML to JSON', ->
  frontdev.yaml2json path_IN.data.yaml, path_IN.data.src, {
    yaml: { schema: 'DEFAULT_SAFE_SCHEMA' }
  }

###
@plugin : plumber, mergeJson
@input  : pathIN, pathOUT, options
@options:
###
gulp.task 'merge:json', 'merge Json files under a folder to one json file with the folder name', ->
path_IN.data.src, path_IN.data.src

#%%%%% 1.4 linting Tasks %%%%%

###
@plugin : jsonlint, mergeJson
@input  : pathIN
@options:
###
gulp.task 'lint:json', 'lint JSON files', ->
  frontdevLint.jsons path_IN.data.json

#%%%%% 1.5 frontend watch %%%%%

gulp.task 'watch:frontdev','run browserSync server', ->
  browserSync server: {baseDir: path_OUT.src}
  gulp.watch path_IN.scss.watch, ['compile:sass']
  gulp.watch path_IN.swig.watch, ['compile:swig', reload]
  gulp.watch path_IN.data.json, (event) ->
    runSequence('lint:json','merge:json' ,'compile:swig', reload)
  gulp.watch path_IN.image.dev, ['minify:image']  

#%%%%% 1.6 main tasks %%%%%

gulp.task 'watch', "Watch assets and templates for build on change", taskBundle.watch
gulp.task 'default', 'Run dev tasks', taskBundle.run
gulp.task 'lint', 'Run linters', taskBundle.lint
gulp.task 'dist','Build production files', taskBundle.dist

#--------------------------------
#------ Publication tools -------
#--------------------------------

###
@plugin : ghPages
@input  : pathIN
@options:
###
gulp.task 'gh-pages','Publish gh-pages', ->
  publishGhPage.publish path_OUT.ghpage.src

###
@plugin : gitbook
@input  : pathIN, pathOUT, options
@options: log: info/debug , format: website, timing: false
###
gulp.task 'gitbook', 'Publish pdf gitbook' , ->
  docsGitbook.website path_docs.in.src, path_docs.out.website, { log: 'info', format: 'website', timing: false }

###
@plugin : gitbook
@input  : pathIN, pathOUT, options
@options: log: info/debug , format: website, timing: false
###
gulp.task 'gitbook-pdf', 'Publish pdf gitbook' , ->
  docsGitbook.pdf path_docs.in.src, path_docs.out.pdf, { log: 'info', format: 'ebook', timing: false 

###
@plugin : _, getFolders, getFiles, path
@input  : pathIN
@options:
###
gulp.task 'helper:gitbook', 'helper for gitbook' , ->
  helperGitbook.generateSummary path_docs.in.src

#--------------------------------
#------ Starter Config ----------
#--------------------------------
#%%%%% Init var %%%%%
copy_directories_out = "/"
copy_directories_in = "/"
#%%%%% Init tasks %%%%%
gulp.task 'init:front', 'Copy paste the app folder into the project_dev folder', ->
  copy_directories_out = path_IN.src
  copy_directories_in  = path_init.website
  runSequence('copy-directories','delete-empty-directories')

gulp.task 'init:gitbook', 'Copy paste gitbook template in the project_doc directory' , ->
  copy_directories_out = path_docs.in.src
  copy_directories_in  = path_init.gitbook
  runSequence('copy-directories','delete-empty-directories')

gulp.task 'copy-directories', ->
  return gulp.src copy_directories_in
  .pipe gulp.dest(copy_directories_out)

gulp.task 'delete-empty-directories', ->
  return deleteEmpty.sync(copy_directories_out, {force: true})