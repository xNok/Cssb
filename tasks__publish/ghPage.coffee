###
@plugin : ghPages
@input  : pathIN
@options:
###
exports.publish = (pathIN) ->
  return () -> 
    return gulp.src pathIN
    .pipe ghPages()