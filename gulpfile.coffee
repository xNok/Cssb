#--------------------------------
#------ Imports -----------------
#--------------------------------
#%%%%% Config Information %%%%%
config          = require('./config.coffee')
# Path
path_OUT        = config.path_frontdev.out
path_IN         = config.path_frontdev.in
path_docs       = config.path_docs
path_init       = config.path_init
# module config
browser_support = config.browser_support
images_config   = config.images_config
# task config
taskBundle      = config.taskBundle

#%%%%% Project tools %%%%%
gulp            = require('gulp-help')(require('gulp'))
plumber         = require('gulp-plumber')
gutil           = require('gulp-util')
changed         = require('gulp-changed')
runSequence     = require('run-sequence')
deleteEmpty     = require('delete-empty')
_               = require('lodash')
fs              = require('fs')
filepath        = require('path')
argv            = require('yargs').argv
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

#--------------------------------
#------ Functions definition ----
#--------------------------------
getFolders = (dir) ->
  return fs.readdirSync(dir)
    .filter( (file) ->
      return fs.statSync(filepath.join(dir, file)).isDirectory()
    )

getFiles = (dir, filter) ->
  return fs.readdirSync(dir)
    .filter( (file)->
      return file.match(filter)
    )

#--------------------------------
#------ Tasks definition --------
#--------------------------------
#%%%%% frontend dev %%%%%
gulp.task 'compile:sass','Build the css assets', ->
  gulp.src path_IN.scss.dev
  .pipe changed(path_OUT.src)
  .pipe sass().on('error', sass.logError)
  .pipe autoprefixer(browsers: browser_support)
  .pipe gulp.dest(path_OUT.css)
  .pipe stream()

gulp.task 'compile:swig','Built pages with swig template engine', ->
  gulp.src path_IN.swig.dev
  .pipe plumber()
  .pipe data( (file)->
    files = getFiles path_IN.data.src, '.json'
    jsons = {}
    files.map( (file)->
      json = JSON.parse(fs.readFileSync(filepath.join(path_IN.data.src, file)))
      jsons[file.replace(".json","")] = json
    )
    return JSON.parse(JSON.stringify(jsons))
  )
  .pipe swig({defaults: { cache: false }})
  .pipe gulp.dest(path_OUT.src)

gulp.task 'compile:js', 'Build JS files from ES6', ->
  gulp.src [path_IN.js.watch, "!"+path_IN.js.ignore]
  .pipe changed(path_OUT.js)
  .pipe plumber()
  .pipe babel({"presets": [es2015]})
  .pipe gulp.dest(path_OUT.js)
  .pipe stream()

gulp.task 'minify:image','Optimise images', ->
  gulp.src path_IN.image.dev
  .pipe changed(path_OUT.images)
  .pipe image(images_config)
  .pipe gulp.dest(path_OUT.images)
  .pipe stream()

#%%%%% frontend post-dev %%%%%
gulp.task 'minify:js','Build minified JS files and addapte ES6', ->
  gulp.src [path_IN.js.watch, '!'+path_IN.js.ignore]
  .pipe plumber()
  .pipe babel({"presets": [es2015]})
  .pipe uglify().on('error', gutil.log)
  .pipe gulp.dest(path_OUT.js)

gulp.task 'minify:css','Build minified CSS files and addapte SCSS', ->
  gulp.src path_IN.scss.dev
  .pipe sass()
  .pipe autoprefixer(browsers: browser_support)
  .pipe cleanCSS({debug: true}, (details) ->
        console.log("[INFO] minify-css-> " + details.name + ': ' + details.stats.originalSize)
        console.log("[INFO] minify-css-> " + details.name + ': ' + details.stats.minifiedSize)
      )
  .pipe gulp.dest(path_OUT.css)

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
      return gulp.src filepath.join(path_IN.data.src, folder, '/**/*.json')
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
  cmd = _.find(gitbook.commands, (_cmd) ->
      return _.first(_cmd.name.split(" ")) == "build";
  )

  args = ['../docs', '../docsBook']
  kwargs = { log: 'debug', format: 'website', timing: false }

  cmd.exec(args, kwargs)

#--------------------------------
#------ Starter Config ----------
#--------------------------------
#%%%%% Init var %%%%%
copy_directories_out = "/"
copy_directories_in = "/"
#%%%%% Init tasks %%%%%
gulp.task 'init', 'Copy paste the app folder into the project_dev folder', ->
  copy_directories_out = path_OUT.scr
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
