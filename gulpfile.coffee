# Configuration

#--------------------------------
#----- Project definition -------
#--------------------------------

# directory where your developing stuff
project_dev = "../app"
# directory where you want to publish the project
project_src = "../www"


#--------------------------------
#------ Path configuration ------
#--------------------------------
path =
  dist:
    src:    project_src
    css:    project_src + '/css/'
    js:     project_src + '/js/'
    images: project_src + '/img/'
  ghpage:
    src: '../gh-pages/**/*'
  browser:
    refresh: [project_dev + "/*.html",  project_dev + "/js/*.js"]
  scss:
    dev:    project_dev + '/css/*.scss'
    watch:  project_dev + '/css/**/*.scss'
  js:
    watch:  project_dev + '/js/**/*.js'
  swig:
    dev:    project_dev + '/pages/*.html'
    watch: [project_dev + "/partials/*.html",  project_dev + "/pages/*.html"]
  image:
    dev:    project_dev + '/img/*'
  data:
    src:    project_dev + '/data/app.json'

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
changed = require('gulp-changed')

#%%%%% frontend dev %%%%%
sass = require('gulp-sass')
autoprefixer = require('gulp-autoprefixer')
swig = require('gulp-swig')
data = require('gulp-data')
uglify = require('gulp-uglify')
babel = require('gulp-babel')
es2015 = require('babel-preset-es2015')
browserSync = require('browser-sync')
reload = browserSync.reload
stream = browserSync.stream

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
  .pipe changed(path.dist.src)
  .pipe sass().on('error', sass.logError)
  .pipe autoprefixer(browsers: browser_support)
  .pipe gulp.dest(path.dist.src)
  .pipe stream()

gulp.task 'swig','Built pages with swig template engine', ->
  gulp.src path.swig.dev
  .pipe plumber()
  .pipe data(JsonData)
  .pipe swig({defaults: { cache: false }})
  .pipe gulp.dest(path.dist.src)

gulp.task 'uglify','Build minified JS files and addapte ES6', ->
  gulp.src path.js.watch
  .pipe changed(path.dist.js)
  .pipe plumber()
  .pipe babel({"presets": [es2015]})
  .pipe uglify().on('error', gutil.log)
  .pipe gulp.dest(path.dist.js)
  .pipe stream()

#%%%%% frontend post-dev %%%%%
gulp.task 'image','Optimise images', ->
  gulp.src path.image.dev
  .pipe changed(path.dist.images)
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

#%%%%% frontend watch %%%%%
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