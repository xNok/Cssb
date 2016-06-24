###
@plugin : plumber, mergeJson
@input  : pathIN, pathOUT, options
@options:
###
exports.jsons = (gulp, $, inputs, options) ->
  return () -> 
    folders = options.getFolders inputs.pathIN
    folders.map( (folder) ->
        return gulp.src options.path.join(inputs.pathIN, folder, '/**/*.json')
        .pipe $.plumber()
        .pipe $.mergeJson(folder + '.json')
        .pipe gulp.dest(inputs.pathOUT)
    )
      