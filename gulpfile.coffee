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
path_OUT        = configPath.path_frontdev.out
path_IN         = configPath.path_frontdev.in
path_docs       = configPath.path_docs
path_init       = configPath.path_init
path_ghpage     = configPath.path_ghpage
# module config
configTasks     = require('./_config/tasks.coffee')
browser_support = configTasks.browser_support
images_config   = configTasks.images_config

#%%%%% Plugins %%%%%
gulp            = require('gulp-help')(require('gulp'))
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

gulp.task 'tasks','Display gulp.tasks and create a resport tasks.json', ->
  log.info.ln(gulp.tasks)
  stream = fs.createWriteStream("tasks.json")
  stream.once('open', (fd) ->
      stream.write JSON.stringify(gulp.tasks)
      stream.end
  );

getTask = (name, input, options) ->
  log.debug.ln('getTask >> ' + name)
  nameArray = name.split(':'); # expected mainCat:subCat:name
  reqStrg = './tasks__' + nameArray[0] + '/' + nameArray[1] + '.coffee'; #expected ./task__mainCat/subCat
  return require(reqStrg)[nameArray[2]](gulp, $, input, options)();

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

# directory where you want to publish the project
project_src       = "../www"
# your frontend developement directory
project_frontdev  = "../frontdev"

#%%%%% 1.1 frontend dev %%%%%

###
@plugin : changed, sass, autoprfixer, browsersync
@input  : pathIN, pathOUT
@options: autoprfixer
###
gulp.task 'frontdev:compile:sass2css','Build the css assets', ->
  getTask 'frontdev:compile:sass2css',
    {
      pathIN:  project_frontdev + '/assets__css/*.scss'
      pathOUT: project_src + '/css/'
      argv: argv
    },{
      autoprfixer: {browsers: browser_support}
    }
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
  getTask 'frontdev:compile:swig2html',
    {
      pathIN:   project_frontdev + '/pages/**/*.html'
      pathOUT:  project_src + '/'
      pathDATA: project_frontdev + '/contents/'
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
  getTask 'frontdev:compile:babel2js',
    {
      pathIN:   project_frontdev + '/assets__js/**/*.js'
      pathOUT:  project_src + '/js/'
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
  getTask 'frontdev:minify:images',
    {
      pathIN:   project_frontdev + '/assets__img/*'
      pathOUT:  project_src + '/img/'
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

# #%%%%% 1.2 frontend post-dev %%%%%
 
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
  gulp.src path_IN.vendors
  .pipe $.changed(path_OUT.vendors)
  .pipe gulp.dest(path_OUT.vendors)

# #%%%%% 1.3 frontend Content/Data Management %%%%%

###
@plugin : plumber, mergeJson
@input  : pathIN, pathOUT, options
@options:
###
gulp.task 'frontdev:merge:jsons', 'merge Json files under a folder to one json file with the folder name', ->
  getTask 'frontdev:merge:jsons',
    {
      pathIN:   project_frontdev + '/contents/'
      pathOUT:  project_frontdev + '/contents/'
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

# #%%%%% 1.4 linting Tasks %%%%%

# ###
# @plugin : jsonlint, mergeJson
# @input  : pathIN
# @options:
# ###
# gulp.task 'lint:json', 'lint JSON files', ->
#   frontdevLint.jsons path_IN.data.json

# #%%%%% 1.5 frontend watch %%%%%

gulp.task 'watch:frontdev','run browserSync server', ->
  $.browserSync server: {baseDir: path_OUT.src}
  gulp.watch path_IN.scss.watch, ['frontdev:compile:sass2css']
  gulp.watch path_IN.swig.watch, ['frontdev:compile:swig2html', $.browserSync.reload]
  gulp.watch path_IN.js.watch, ['frontdev:compile:babel2js']
  gulp.watch path_IN.data.json, (event) ->
    console.log('File ' + event.path + ' was ' + event.type + ', running tasks...')
    runSequence('frontdev:merge:jsons' ,'frontdev:compile:swig2html', $.browserSync.reload)
  gulp.watch path_IN.image.dev, ['frontdev:minify:images']  

# #%%%%% 1.6 main tasks %%%%%

gulp.task 'default', 'Run dev tasks', [
  'frontdev:compile:swig2html'
  'frontdev:compile:sass2css'
  'frontdev:compile:babel2js'
  'frontdev:copy:vendors'
  'frontdev:minify:images'
  'watch:frontdev'
]

# gulp.task 'dist','Build production files', taskBundle.dist

# #--------------------------------
# #------ Publication tools -------
# #--------------------------------

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

# #--------------------------------
# #------ Starter Config ----------
# #--------------------------------
# #%%%%% Init var %%%%%
# copy_directories_out = "./"
# copy_directories_in = "../"
# #%%%%% Init tasks %%%%%
# gulp.task 'init:frontdev', 'Copy paste the app folder into the project_dev folder', ->
#   copy_directories_out = path_IN.src
#   copy_directories_in  = path_init.website
#   runSequence('copy-directories','delete-empty-directories')

# gulp.task 'init:gitbook', 'Copy paste gitbook template in the project_doc directory' , ->
#   copy_directories_out = path_docs.in.src
#   copy_directories_in  = path_init.gitbook
#   runSequence('copy-directories','delete-empty-directories')

# gulp.task 'copy-directories', 'copy directories to another loaction' ,->
#   return gulp.src copy_directories_in
#   .pipe gulp.dest(copy_directories_out)

# gulp.task 'delete-empty-directories', 'cleanup empty directories',->
#   return deleteEmpty.sync(copy_directories_out, {force: true})