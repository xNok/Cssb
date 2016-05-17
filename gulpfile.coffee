# Configuration

#--------------------------------
#----- Project definition -------
#--------------------------------

project_src = "www"

#--------------------------------
#------ Path configuration ------
#--------------------------------
path =
  dist:
    src: '../' + project_src
    css: '../' + project_src + '/css/'
    js:  '../' + project_src + '/js/'
    images: '../' + project_src + '/img/'
  ghpage:
    src: './gh-pages/**/*'
  browser:
    refresh: ["app/*.html",  "app/js/*.js"]
  scss:
    dev: 'app/css/*.scss'
    watch: 'app/css/**/*.scss'
  js:
    watch: 'app/js/**/*.js'
  swig:
    dev: 'app/pages/*.html'
    watch: ["app/partials/*.html",  "app/pages/*.html"]
  image:
    dev: 'app/img/*'
  data:
    src: './app/data/app.json'

#--------------------------------
#------ Support definition ------
#--------------------------------
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

#--------------------------------
#------ Imports -----------------
#--------------------------------
#%%%%% Project tools %%%%%
gulp = require('gulp-help')(require('gulp'))
plumber = require('gulp-plumber')
gutil = require('gulp-util')

#%%%%% frontend dev %%%%%
sass = require('gulp-sass')
autoprefixer = require('gulp-autoprefixer')
swig = require('gulp-swig')
data = require('gulp-data')
uglify = require('gulp-uglify')
babel = require('gulp-babel')
browserSync = require('browser-sync')
reload = browserSync.reload

#%%%%% Post dev %%%%%
image = require('gulp-image')
ghPages = require('gulp-gh-pages')

#--------------------------------
#------ Data definition ---------
#--------------------------------
JsonData = (file) ->
  require(path.data.src)

#--------------------------------
#------ Task definition ---------
#--------------------------------
#%%%%% frontend dev %%%%%
gulp.task 'sass','Build the css assets', ->
  gulp.src path.scss.dev
  .pipe sass().on('error', sass.logError)
  .pipe autoprefixer(browsers: browser_support)
  .pipe gulp.dest(path.dist.src)
  .pipe reload(stream: true)

gulp.task 'swig','Built pages with swig template engine', ->
  gulp.src path.swig.dev
  .pipe plumber()
  .pipe data(JsonData)
  .pipe swig({defaults: { cache: false }})
  .pipe gulp.dest(path.dist.src)

gulp.task 'uglify','Build minified JS files and addapte ES6', ->
  gulp.src path.js.watch
  .pipe plumber()
  .pipe babel({
    presets: ['es2015']
  })
  .pipe uglify().on('error', gutil.log)
  .pipe gulp.dest(path.dist.js)
  .pipe reload(stream: true)

#%%%%% frontend post-dev %%%%%
gulp.task 'image','Optimise images', ->
  gulp.src path.image.dev
  .pipe image({
          pngquant: true,
          optipng: false,
          zopflipng: true,
          advpng: true,
          jpegRecompress: false,
          jpegoptim: true,
          mozjpeg: true,
          gifsicle: true,
          svgo: true
        })
  .pipe gulp.dest(path.dist.images)

gulp.task 'default','Watch assets and templates for build on change', ->
  browserSync
    server: {baseDir: path.dist.src}
  gulp.watch path.scss.watch, ['sass']
  gulp.watch path.swig.watch, ['swig', reload]
  gulp.watch path.js.watch, ['uglify']
  gulp.watch path.browser.refresh, reload

#--------------------------------
#------ Compile project ---------
#--------------------------------
gulp.task 'dist','Build production files', ['swig','sass','uglify', 'image']

#--------------------------------
#------ Publication tools -------
#--------------------------------
gulp.task 'gh-pages','Publish gh-pages', ->
  return gulp.src path.ghpage.src
  .pipe ghPages()