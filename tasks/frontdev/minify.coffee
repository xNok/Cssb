###
@plugin : changed, image
@input  : pathIN, pathOUT, options
@options: image
###
exports.images = (gulp, $, inputs, options) ->
  return () -> 
    gulp.src inputs.pathIN
    .pipe $.changed(inputs.pathOUT)
    .pipe $.image(options.image)
    .pipe gulp.dest(inputs.pathOUT)
    .pipe $.browserSync.stream()

###
@plugin : changed, babel, uglify
@input  : pathIN, pathOUT, options
@options: babel
###
exports.js = (gulp, $, inputs, options) ->
  return () -> 
    gulp.src inputs.pathIN
    .pipe $.plumber()
    .pipe $.babel(options.babel)
    .pipe $.uglify().on('error', gutil.log)
    .pipe gulp.dest(inputs.pathOUT)

###
@plugin : sass, autoprefixer, cleanCss
@input  : pathIN, pathOUT, options
@options: autoprefixer, cleanCSS
###
exports.css = (gulp, $, inputs, options) ->
  return () -> 
    gulp.src inputs.pathIN
    .pipe $.sass()
    .pipe $.autoprefixer(options.autoprefixer)
    .pipe $.cleanCSS(options.cleanCSS, (details) ->
          console.log("[INFO] minify-css-> " + details.name + ': ' + details.stats.originalSize)
          console.log("[INFO] minify-css-> " + details.name + ': ' + details.stats.minifiedSize)
        )
    .pipe gulp.dest(inputs.pathOUT)