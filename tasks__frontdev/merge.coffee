###
@plugin : plumber, mergeJson
@input  : pathIN, pathOUT, options
@options:
###
exports.jsons = (pathIN, pathOUT) ->
  return () -> 
      folders = getFolders pathIN
      folders.map( (folder) ->
          return gulp.src path.join(pathIN, folder, '/**/*.json')
          .pipe plumber()
          .pipe mergeJson(folder + '.json')
          .pipe gulp.dest pathOUT
      )