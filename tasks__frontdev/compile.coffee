###
@plugin : changed, sass, autoprfixer, browsersync
@input  : pathIN, pathOUT, options
@options: autoprfixer
###
exports.sass2css = (gulp, $, inputs, options) ->
  return () -> 
      gulp.src inputs.pathIN
      .pipe $.changed(inputs.pathOUT)
      .pipe $.sass().on('error', $.sass.logError)
      .pipe $.autoprefixer(options.autoprefixer)
      .pipe gulp.dest(inputs.pathOUT)
      .pipe $.browserSync.stream()

###
@plugin : plumber, data, swig, getJsons
@input  : pathIN, pathOUT, pathDATA, options
@options: swig
###
exports.swig2html = (gulp, $, inputs, options) ->
  return () -> 
    gulp.src inputs.pathIN
    #.pipe $.changed(inputs.pathOUT)
    .pipe $.plumber()
    .pipe $.data( options.getJsons inputs.pathDATA )
    .pipe $.swig(options.swig)
    .pipe gulp.dest(inputs.pathOUT)

###
@plugin : changed, plumber, babel
@input  : pathIN, pathOUT, options
@options: babel
###
exports.babel2js = (gulp, $, inputs, options) ->
  return () -> 
    gulp.src inputs.pathIN
    .pipe $.changed(inputs.pathOUT)
    .pipe $.plumber()
    .pipe $.babel(options.babel)
    .pipe gulp.dest(inputs.pathOUT)
    .pipe $.browserSync.stream()

###
@plugin : yaml
@input  : pathIN, pathOUT, options
@options: yaml
###
exports.yaml2json = (gulp, $, inputs, options) ->
  return () -> 
    gulp.src inputs.pathIN
    .pipe yaml(options.yaml)
    .pipe gulp.dest(inputs.pathOUT)