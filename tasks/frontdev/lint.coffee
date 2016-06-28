###
@plugin : jsonlint, mergeJson
@input  : pathIN
@options:
###
exports.jsons = (pathIN) ->
  return () -> 
    gulp.src pathIN
    .pipe jsonlint()
    .pipe jsonlint.reporter()