###
@plugin : changed, image
@input  : pathIN, pathOUT, options
@options: image
###
exports.images = (pathIN, pathOUT, options) ->
  return () -> 
      gulp.src pathIN
      .pipe changed(pathOUT)
      .pipe image(options.image)
      .pipe gulp.dest(pathOUT)
      .pipe stream()

###
@plugin : changed, babel, uglify
@input  : pathIN, pathOUT, options
@options: babel
###
exports.js = (pathIN, pathOUT, options) ->
  return () -> 
      gulp.src pathIN
      .pipe plumber()
      .pipe babel(options.babel)
      .pipe uglify().on('error', gutil.log)
      .pipe gulp.dest(pathOUT)

###
@plugin : sass, autoprefixer, cleanCss
@input  : pathIN, pathOUT, options
@options: autoprefixer, cleanCSS
###
exports.css = (pathIN, pathOUT, options) ->
  return () -> 
      gulp.src pathIN
      .pipe sass()
      .pipe autoprefixer(options.autoprefixer)
      .pipe cleanCSS(options.cleanCSS, (details) ->
            console.log("[INFO] minify-css-> " + details.name + ': ' + details.stats.originalSize)
            console.log("[INFO] minify-css-> " + details.name + ': ' + details.stats.minifiedSize)
          )
      .pipe gulp.dest(pathOUT)