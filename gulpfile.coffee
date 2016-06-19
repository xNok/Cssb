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
getFolders  = require('./helpers__functions/helper-files.js').getFolders
getFiles    = require('./helpers__functions/helper-files.js').getFiles
getJsons    = require('./helpers__functions/helper-data.js').getJsons

gitbookGetCMD = (cmdString) ->
  return _.find(gitbook.commands, (_cmd) ->
      return _.first(_cmd.name.split(" ")) == cmdString;
  )

#--------------------------------
#------ Tasks definition --------
#--------------------------------
frontdevCompile = require('./tasks__frontdev/compile.coffee')
frontdevMinify  = require('./tasks__frontdev/minify.coffee')

#%%%%% frontend dev %%%%%

###
@plugin : changed, sass, autoprfixer, browsersync
@input  : pathIN, pathOUT, options
@options: autoprfixer
###
gulp.task 'compile:sass','Build the css assets', ->
  frontdevCompile.sass2Css path_IN.scss.dev, path_OUT.src, {autoprefixer:{browsers: browser_support}}

###
@plugin : plumber, data, swig, getJsons
@input  : pathIN, pathOUT, pathDATA, options
@options: swig
###
gulp.task 'compile:swig','Built pages with swig template engine', ->
  frontdevCompile.swig2html path_IN.swig.dev, path_IN.data.src, path_OUT.src, {swig: {defaults: { cache: false }}}

###
@plugin : changed, plumber, babel
@input  : pathIN, pathOUT, options
@options: babel
###
gulp.task 'compile:js', 'Build JS files from ES6', ->
  frontdevCompile.babel2js [path_IN.js.watch, "!"+path_IN.js.ignore], path_OUT.js, {babel: {"presets": [es2015]}}

###
@plugin : changed, image
@input  : pathIN, pathOUT, options
@options: image
###
gulp.task 'minify:image','Optimise images', ->
  frontdevMinify.images path_IN.image.dev,path_OUT.images, {image: images_config}

#%%%%% frontend post-dev %%%%%
###
@plugin : changed, babel, uglify
@input  : pathIN, pathOUT, options
@options: babel
###
gulp.task 'minify:js','Build minified JS files and addapte ES6', ->
  frontdevMinify.js [path_IN.js.watch, '!'+path_IN.js.ignore], path_OUT.js, {babel: {"presets": [es2015]}}

###
@plugin : sass, autoprefixer, cleanCss
@input  : pathIN, pathOUT, options
@options: autoprefixer, cleanCSS
###
gulp.task 'minify:css','Build minified CSS files and addapte SCSS', ->
path_IN.scss.dev, path_OUT.css , {autoprfixer: {browsers: browser_support}, cleanCSS: {debug: true}}

gulp.task 'copy:vendors','Copy past your vendors without treatment', ->
  gulp.src path_IN.vendors
  .pipe changed(path_OUT.vendors)
  .pipe gulp.dest(path_OUT.vendors)

#%%%%% Content/Data Management %%%%%
gulp.task 'compile:yaml2json', 'Convert YAML to JSON', ->
  gulp.src path_IN.data.yaml
  .pipe yaml({ schema: 'DEFAULT_SAFE_SCHEMA' })
  .pipe gulp.dest( path_IN.data.src )

gulp.task 'merge:json', 'merge Json files under a folder to one json file with the folder name', ->
  folders = getFolders path_IN.data.src
  folders.map( (folder) ->
      return gulp.src path.join(path_IN.data.src, folder, '/**/*.json')
      .pipe plumber()
      .pipe mergeJson(folder + '.json')
      .pipe gulp.dest path_IN.data.src
  )

#%%%%% frontend watch %%%%%
gulp.task 'watch:browserSync','run browserSync server', ->
  browserSync server: {baseDir: path_OUT.src}

gulp.task 'watch:sass', 'Watch scss files', ->
  gulp.watch path_IN.scss.watch, ['compile:sass']

gulp.task 'watch:swig', 'Watch html/swig files', ->
  gulp.watch path_IN.swig.watch, ['compile:swig', reload]

gulp.task 'watch:js', 'Watch js/babel files', ->
  gulp.watch path_IN.js.watch, ['compile:js']

gulp.task 'watch:json', 'Watch data/content files', ->
  gulp.watch path_IN.data.json, (event) ->
    runSequence('lint:json','merge:json' ,'compile:swig', reload)

gulp.task 'watch:image', 'Watch images', ->
  gulp.watch path_IN.image.dev, ['minify:image']

#%%%%% Linting Tasks %%%%%
gulp.task 'lint:json', 'lint JSON files', ->
  gulp.src path_IN.data.json
  .pipe jsonlint()
  .pipe jsonlint.reporter()
#--------------------------------
#------ Main tasks --------------
#--------------------------------
gulp.task 'watch', "Watch assets and templates for build on change", taskBundle.watch
gulp.task 'default', 'Run dev tasks', taskBundle.run
gulp.task 'lint', 'Run linters', taskBundle.lint
gulp.task 'dist','Build production files', taskBundle.dist
#--------------------------------
#------ Publication tools -------
#--------------------------------
gulp.task 'gh-pages','Publish gh-pages', ->
  return gulp.src path_OUT.ghpage.src
  .pipe ghPages()

gulp.task 'gitbook', 'Publish pdf gitbook' , ->
  cmd = gitbookGetCMD("build")
  args = [path_docs.in.src, path_docs.out.website]
  kwargs = { log: 'info', format: 'website', timing: false }
  cmd.exec(args, kwargs)

gulp.task 'gitbook-pdf', 'Publish pdf gitbook' , ->
  cmd = gitbookGetCMD("pdf")
  args = [path_docs.in.src, path_docs.out.pdf]
  kwargs = { log: 'info', format: 'website', timing: false }
  cmd.exec(args, kwargs)

#--------------------------------
#------ Starter Config ----------
#--------------------------------
#%%%%% Init var %%%%%
copy_directories_out = "/"
copy_directories_in = "/"
#%%%%% Init tasks %%%%%
gulp.task 'init', 'Copy paste the app folder into the project_dev folder', ->
  copy_directories_out = path_IN.src
  copy_directories_in  = path_init.website
  runSequence('copy-directories','delete-empty-directories')

gulp.task 'gitbook-init', 'Copy paste gitbook template in the project_doc directory' , ->
  copy_directories_out = path_docs.in.src
  copy_directories_in  = path_init.gitbook
  runSequence('copy-directories','delete-empty-directories')

gulp.task 'copy-directories', ->
  return gulp.src copy_directories_in
  .pipe gulp.dest(copy_directories_out)

gulp.task 'delete-empty-directories', ->
  return deleteEmpty.sync(copy_directories_out, {force: true})
