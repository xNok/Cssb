# Configuration

#- Project definition

project_src = "www"

#- Path configuration
dist:
  src: '../' + project_src
  css: '../' + project_src + '/css/'
  js:  '../' + project_src + '/js/'
ghpage: 
  src: './gh-pages/**/*'
scss:
  dev: 'app/css/*.scss'
  watch: 'app/css/**/*.scss'
js:
  watch: 'app/js/**/*.js'
swig:
  dev: 'app/pages/*.html'
  watch: ["app/partials/*.html",  "app/pages/*.html"]
data:
  src: './app/data/app.json'
browser:
  refresh: ["app/*.html",  "app/js/*.js"]

#- Support definition -
browser_support = [
  "ie >= 9"
  "ie_mob >= 10"
  "ff >= 30"
  "chrome >= 34"
  "safari >= 7"
  "opera >= 23"
  "ios >= 7"
  "android >= 4.4"
  "bb >= 10"
]

#- Imports -
#-- Project tools --
gulp = require('gulp-help')(require('gulp'))
plumber = require('gulp-plumber')
gutil = require('gulp-util')

#-- frontend dev --
sass = require('gulp-sass')
autoprefixer = require('gulp-autoprefixer')
swig = require('gulp-swig')
data = require('gulp-data')
uglify = require('gulp-uglify')
browserSync = require('browser-sync')
reload = browserSync.reload

#-- Post dev --
ghPages = require('gulp-gh-pages')

#- Data definition -
JsonData = (file) ->
  require(data.scr)

#- Task definition -
#-- frontend dev --
gulp.task 'sass', 'Build the css assets', ->
  gulp.src scss.dev
  .pipe sass().on('error', sass.logError)
  .pipe autoprefixer(browsers: browser_support)
  .pipe gulp.dest(dist.css)
  .pipe reload(stream: true)

gulp.task 'swig','Built pages with swig template engine', ->
  gulp.src(swig.dev)
  .pipe plumber()
  .pipe data(JsonData)
  .pipe swig({defaults: { cache: false }})
  .pipe gulp.dest(dist.scr)

gulp.task 'uglify', 'Build minified JS files', ->
  gulp.src js.watch
  .pipe plumber()
  .pipe uglify().on('error', gutil.log)
  .pipe gulp.dest(js.dev)
  .pipe reload(stream: true)

gulp.task 'default','Watch assets and templates for build on change', ->
  browserSync
    server: {baseDir: path.dist}
  gulp.watch scss.watch, ['sass']
  gulp.watch swig.watch, ['swig', reload]
  gulp.watch js.watch, ['uglify']
  gulp.watch browser.refresh, reload


#- Compile project -
gulp.task 'dist','Build production files', ['swig','sass','uglify']

#- Publication tools -
gulp.task 'gh-pages','Publish gh-pages', ->
  return gulp.src ghpage.src
  .pipe ghPages()