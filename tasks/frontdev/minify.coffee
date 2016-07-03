###
@plugin : changed, image
@input  : pathIN, pathOUT, options
@options: image
###
exports.images = (gulp, $, inputs, options) ->
  return () -> 
    gulp.src inputs.pathIN
    .pipe $.cache($.image(options.image))
    .pipe gulp.dest(inputs.pathOUT)
    .pipe $.browserSync.stream()

###
@plugin : changed, babel, uglify
@input  : pathIN, pathOUT, options
@options
###
exports.js = (gulp, $, inputs, options) ->
  return () -> 
    gulp.src inputs.pathIN
    .pipe $.plumber()
    .pipe $.uglify()
    .pipe $.rename({ extname: '.min.js' })
    .pipe gulp.dest(inputs.pathOUT)

###
@plugin : sass, autoprefixer, cleanCss
@input  : pathIN, pathOUT
@options:
###
exports.css = (gulp, $, inputs, options) ->
  return () -> 
    gulp.src inputs.pathIN
    .pipe $.cleanCss(options.cleanCSS)
    .pipe $.rename({ extname: '.min.css' })
    .pipe gulp.dest(inputs.pathOUT)


###
@plugin : useref, gulpif, uglify, cleanCss
@input  : pathIN, pathOUT
@options: cleanCss
###
exports.useref = (gulp, $, inputs, options) ->
  return () -> 
    gulp.src inputs.pathIN
      .pipe $.useref()
      .pipe $.if('*.js', $.uglify())
      .pipe $.if('*.css', $.cleanCss(options.cleanCSS))
      .pipe gulp.dest(inputs.pathOUT)

###
@plugin : del
@input  : pathIN
@options: 
###
exports.cleanUp = (gulp, $, inputs, options) ->
  return () -> 
    return  $.del(inputs.pathIN,{
      force: true
    })