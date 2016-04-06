#Configuration
path =
  dist: './dist'
  css: 'dist/css/'
  refresh: ["*.html",  "js/*.js"]
  js: 'dist/js/'
  scssWatch: 'css/**/*.scss'
  scss: 'css/*.scss'
  jsWatch: 'js/**/*.js'
  ghpage: './gh-pages/**/*'
  swigWatch: ["partials/*.html",  "pages/*.html"]
  swig: 'pages/*.html'


# Support
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

# Project tools
gulp = require('gulp-help')(require('gulp'));

# Require frontend dev
sass = require('gulp-sass')
autoprefixer = require('gulp-autoprefixer')
swig = require('gulp-swig')
uglify = require('gulp-uglify')
browserSync = require('browser-sync')
reload = browserSync.reload

# Require gh-pages
ghPages = require('gulp-gh-pages');

# frontend dev
gulp.task 'sass', 'Build the css assets', ->
  gulp.src path.scss
  .pipe sass().on('error', sass.logError)
  .pipe autoprefixer(browsers: browser_support)
  .pipe gulp.dest(path.css)
  .pipe reload(stream: true)

gulp.task 'swig','Built pages with swig template engine', ->
  gulp.src(path.swig)
  .pipe(swig({defaults: { cache: false }}))
  .pipe(gulp.dest(path.dist))

gulp.task 'uglify', 'Build minified JS files', ->
  gulp.src path.jsWatch
  .pipe uglify()
  .pipe gulp.dest(path.js)
  .pipe reload(stream: true)

gulp.task 'default','Watch assets and templates for build on change', ->
  browserSync
    server: {baseDir: path.dist}
  gulp.watch path.scssWatch, ['sass']
  gulp.watch path.swigWatch, ['swig', reload]
  gulp.watch path.refresh, reload
  gulp.watch path.jsWatch, ['uglify']

# compile project
gulp.task 'dist','Build production files', ['swig','sass','uglify']

gulp.task 'gh-pages','Publish gh-pages', ->
  return gulp.src path.ghpage
  .pipe ghPages()