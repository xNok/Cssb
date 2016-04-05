#Configuration
path =
  dist: './dist'
  css: 'dist/css/'
  refresh: ["*.html",  "js/*.js"]
  scssWatch: 'css/**/*.scss'
  scss: 'css/*.scss'
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

# Require frontend dev
gulp = require('gulp')
sass = require('gulp-sass')
autoprefixer = require('gulp-autoprefixer')
swig = require('gulp-swig')
browserSync = require('browser-sync')
reload = browserSync.reload

# Require gh-pages
ghPages = require('gulp-gh-pages');

gulp.task 'sass', ->
  gulp.src path.scss
  .pipe sass().on('error', sass.logError)
  .pipe autoprefixer(browsers: browser_support)
  .pipe gulp.dest(path.css)
  .pipe reload(stream: true)

gulp.task 'swig', ->
  gulp.src(path.swig)
  .pipe(swig({defaults: { cache: false }}))
  .pipe(gulp.dest(path.dist))

gulp.task 'default', ->
  browserSync
    server: {baseDir: path.dist}
  gulp.watch path.scssWatch, ['sass']
  gulp.watch path.swigWatch, ['swig', reload]
  gulp.watch path.refresh, reload

gulp.task 'gh-pages', ->
  return gulp.src path.ghpage
  .pipe ghPages()