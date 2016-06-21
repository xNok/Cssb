###
@plugin : changed, sass, autoprfixer, browsersync
@input  : pathIN, pathOUT, options
@options: autoprfixer
###
exports.sass2Css = (pathIN, pathOUT, options) ->
  return () -> 
      gulp.src pathIN
      .pipe changed(pathOUT)
      .pipe sass().on('error', sass.logError)
      .pipe autoprefixer(options.autoprefixer)
      .pipe gulp.dest(pathOUT)
      .pipe stream()

###
@plugin : plumber, data, swig, getJsons
@input  : pathIN, pathOUT, pathDATA, options
@options: swig
###
exports.swig2html = (pathIN, pathOUT, pathDATA, options) ->
  return () -> 
    gulp.src pathIN
    .pipe changed(pathOUT)
    .pipe plumber()
    .pipe data( getJsons pathDATA )
    .pipe swig(options.swig)
    .pipe gulp.dest(pathOUT)

###
@plugin : changed, plumber, babel
@input  : pathIN, pathOUT, options
@options: babel
###
exports.babel2js = (pathIN, pathOUT, options) ->
  return () -> 
    gulp.src pathIN
    .pipe changed(pathOUT)
    .pipe plumber()
    .pipe babel(options.babel)
    .pipe gulp.dest(pathOUT)
    .pipe stream()

###
@plugin : yaml
@input  : pathIN, pathOUT, options
@options: yaml
###
exports.yaml2json = (pathIN, pathOUT, options) ->
  return () -> 
    gulp.src pathIN
    .pipe yaml(options.yaml)
    .pipe gulp.dest(pathOUT)