# Configuration

#--------------------------------
#----- Project definition -------
#--------------------------------

# directory where your developing stuff
project_dev = "../app"
# directory where you want to publish the project
project_src = "../www"
# sample code directory
project_sample = "./app"


#--------------------------------
#------ Path configuration ------
#--------------------------------
path =
  dist:
    src:    project_src
    css:    project_src + '/css/'
    js:     project_src + '/js/'
    images: project_src + '/img/'
    vendors:project_src + '/vendors'
  ghpage:
    src: '../gh-pages/**/*'
  browser:
    refresh: [project_dev + "/*.html",  project_dev + "/js/*.js"]
  scss:
    dev:    project_dev + '/assets__css/*.scss'
    watch:  project_dev + '/assets__css/**/*.scss'
  js:
    watch:  project_dev + '/assets__js/**/*.js'
    ignore: project_dev + '/assets__js/vendors/**/*'
  swig:
    dev:    project_dev + '/pages/**/*.html'
    watch: [project_dev + "/partials/**/*.html",  project_dev + "/pages/**/*.html"]
  image:
    dev:    project_dev + '/assets__img/*'
  data:
    src:    project_dev + '/content/app.json'
  vendors:  project_dev + '/vendors/**'

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

images_config = {
  pngquant: true,
  optipng: true,
  zopflipng: true,
  advpng: true,
  jpegRecompress: true,
  jpegoptim: true,
  mozjpeg: true,
  gifsicle: true,
  svgo: true
}

#--------------------------------
#------ Imports -----------------
#--------------------------------
#%%%%% Project tools %%%%%
gulp = require('gulp-help')(require('gulp'))
plumber = require('gulp-plumber')
gutil = require('gulp-util')
changed = require('gulp-changed')
runSequence = require('run-sequence')
deleteEmpty = require('delete-empty')
fs = require('fs')

#%%%%% frontend dev %%%%%
sass = require('gulp-sass')
autoprefixer = require('gulp-autoprefixer')
swig = require('gulp-swig')
data = require('gulp-data')
babel = require('gulp-babel')
es2015 = require('babel-preset-es2015')
browserSync = require('browser-sync')
reload = browserSync.reload
stream = browserSync.stream

#%%%%% Post dev %%%%%
image = require('gulp-image')
uglify = require('gulp-uglify')
cleanCSS = require('gulp-clean-css')
ghPages = require('gulp-gh-pages')

#--------------------------------
#------ Data definition ---------
#--------------------------------
  

#--------------------------------
#------ Tasks definition ---------
#--------------------------------
#%%%%% frontend dev %%%%%
gulp.task 'sass','Build the css assets', ->
  gulp.src path.scss.dev
  .pipe changed(path.dist.src)
  .pipe sass().on('error', sass.logError)
  .pipe autoprefixer(browsers: browser_support)
  .pipe gulp.dest(path.dist.css)
  .pipe stream()

gulp.task 'swig','Built pages with swig template engine', ->
  gulp.src path.swig.dev
  .pipe plumber()
  .pipe data((file) ->
    return JSON.parse(fs.readFileSync(path.data.src))
  )
  .pipe swig({defaults: { cache: false }})
  .pipe gulp.dest(path.dist.src)

gulp.task 'babel', 'Build JS files frome ES6', ->
  gulp.src [path.js.watch, "!"+path.js.ignore]
  .pipe changed(path.dist.js)
  .pipe plumber()
  .pipe babel({"presets": [es2015]})
  .pipe gulp.dest(path.dist.js)
  .pipe stream()

gulp.task 'vendors','Copy past your vendors without treatment', ->
  gulp.src path.vendors
  .pipe changed(path.dist.vendors)
  .pipe gulp.dest(path.dist.vendors)

#%%%%% frontend post-dev %%%%%
gulp.task 'uglify','Build minified JS files and addapte ES6', ->
  gulp.src [path.js.watch, '!'+path.js.ignore]
  .pipe plumber()
  .pipe babel({"presets": [es2015]})
  .pipe uglify().on('error', gutil.log)
  .pipe gulp.dest(path.dist.js)

gulp.task 'image','Optimise images', ->
  gulp.src path.image.dev
  .pipe changed(path.dist.images)
  .pipe image(images_config)
  .pipe gulp.dest(path.dist.images)

gulp.task 'minify-css','Build minified CSS files and addapte SCSS', ->
  gulp.src path.scss.dev
  .pipe sass()
  .pipe autoprefixer(browsers: browser_support)
  .pipe cleanCSS({debug: true}, (details) ->
        console.log("[INFO]minify-css-> " + details.name + ': ' + details.stats.originalSize)
        console.log("[INFO]minify-css-> " + details.name + ': ' + details.stats.minifiedSize)
      )
  .pipe gulp.dest(path.dist.css)

#%%%%% frontend watch %%%%%
gulp.task 'watch','Watch assets and templates for build on change', ->
  browserSync
    server: {baseDir: path.dist.src}
  gulp.watch path.scss.watch, ['sass']
  gulp.watch path.swig.watch, ['swig', reload]
  gulp.watch path.js.watch, ['babel']
  gulp.watch path.data.src, ['swig', reload]
  gulp.watch path.image.dev, ['image']
  gulp.watch path.browser.refresh, reload

#--------------------------------
#------ Main tasks --------------
#--------------------------------
gulp.task 'default', 'Run dev tasks', ['swig','sass','babel', 'vendors' ,'image', 'watch']
gulp.task 'dist','Build production files', ['swig','minify-css','vendors','uglify', 'image']

#--------------------------------
#------ Publication tools -------
#--------------------------------
gulp.task 'gh-pages','Publish gh-pages', ->
  return gulp.src path.ghpage.src
  .pipe ghPages()

#--------------------------------
#------ Starter Config ----------
#--------------------------------
#%%%%% Init configuration %%%%%
configPath=
  init: [
    project_sample + "/**",
    "!" + project_sample + "/js/*/**",
    "!" + project_sample + "/pages/*/**",
    "!" + project_sample + "/partials/*/**",
  ]

#%%%%% Init tasks %%%%%
gulp.task 'init', 'Copy paste the app folder into the project_dev folder', ->
  runSequence('copy-app-directories','delete-empty-directories')

gulp.task 'copy-app-directories', ->
  return gulp.src configPath.init
  .pipe gulp.dest(project_dev + "/")

gulp.task 'delete-empty-directories', ->
  return deleteEmpty.sync(project_dev + "/", {force: true})