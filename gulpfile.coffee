# Configuration

#- Project definition

project_name = "www"

#- Path configuration
path =
  dist: '../' + project_name
  css: '../' + project_name + '/css/'
  js: '../' + project_name + '/js/'
  refresh: ["*.html",  "js/*.js"]
  scssWatch: 'css/**/*.scss'
  scss: 'css/*.scss'
  jsWatch: 'js/**/*.js'
  ghpage: './gh-pages/**/*'
  swigWatch: ["partials/*.html",  "pages/*.html"]
  swig: 'pages/*.html'
  data: './data/app.json'


#- Support definition
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

#- Imports
#-- Project tools
gulp = require('gulp-help')(require('gulp'))
plumber = require('gulp-plumber')
gutil = require('gulp-util')

#-- frontend dev
sass = require('gulp-sass')
autoprefixer = require('gulp-autoprefixer')
swig = require('gulp-swig')
data = require('gulp-data')
uglify = require('gulp-uglify')
browserSync = require('browser-sync')
reload = browserSync.reload

#-- Post dev
ghPages = require('gulp-gh-pages')

#- Data definition
JsonData = (file) ->
  require(path.data)

#- Task definition
#-- frontend dev
gulp.task 'sass', 'Build the css assets', ->
  gulp.src path.scss
  .pipe sass().on('error', sass.logError)
  .pipe autoprefixer(browsers: browser_support)
  .pipe gulp.dest(path.css)
  .pipe reload(stream: true)

gulp.task 'swig','Built pages with swig template engine', ->
  gulp.src(path.swig)
  .pipe plumber()
  .pipe data(JsonData)
  .pipe swig({defaults: { cache: false }})
  .pipe gulp.dest(path.dist)

gulp.task 'uglify', 'Build minified JS files', ->
  gulp.src path.jsWatch
  .pipe plumber()
  .pipe uglify().on('error', gutil.log)
  .pipe gulp.dest(path.js)
  .pipe reload(stream: true)

gulp.task 'default','Watch assets and templates for build on change', ->
  browserSync
    server: {baseDir: path.dist}
  gulp.watch path.scssWatch, ['sass']
  gulp.watch path.swigWatch, ['swig', reload]
  gulp.watch path.refresh, reload
  gulp.watch path.jsWatch, ['uglify']

#- Compile project
gulp.task 'dist','Build production files', ['swig','sass','uglify']

#- Publication tools
gulp.task 'gh-pages','Publish gh-pages', ->
  return gulp.src path.ghpage
  .pipe ghPages()