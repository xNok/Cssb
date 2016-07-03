###
@plugin : jsonlint
@input  : pathIN
@options:
###
exports.json = (gulp, $, inputs, options) ->
  return () -> 
    gulp.src inputs.pathIN
    .pipe $.jsonlint()
    .pipe $.jsonlint.reporter()

###
@plugin : jshint
@input  : pathIN
@options:
###
exports.js = (gulp, $, inputs, options) ->
  return () -> 
    gulp.src inputs.pathIN
    .pipe $.jshint()
    .pipe $.jshint.reporter('jshint-stylish')