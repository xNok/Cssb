#Configuration
path =
	css: 'css/'
	scss: 'css/'
	refresh: ["*.html",  "js/*.js"]

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
browserSync = require('browser-sync')
reload = browserSync.reload

# Require gh-pages
ghPages = require('gulp-gh-pages');

gulp.task 'sass', ->
  gulp.src "#{path.scss}*.scss"
  .pipe sass().on('error', sass.logError)
  .pipe autoprefixer(browsers: browser_support)
  .pipe gulp.dest(path.css)
  .pipe reload(stream: true)

gulp.task 'default', ->
	browserSync
		server: {basedir: './'}
	gulp.watch path.refresh, reload
	gulp.watch "#{path.scss}/**/*.scss", ['sass']

gulp.task 'gh-pages', ->
  return gulp.src "./templates/**/*"
    .pipe ghPages()