gulp            = require('gulp-help')(require('gulp'))
_               = require('lodash')
config          = require('../_config/paths.coffee')
path_docs       = config.path_docs
getFolders      = require('../helpers__functions/helper-files.js').getFolders
getFiles        = require('../helpers__functions/helper-files.js').getFiles
path            = require('path')

gulp.task 'helper:gitbook', 'helper for gitbook' , ->
  folders = getFolders(path_docs.in.src)
  filesString = "\n"

  _(folders).forEach((folder) ->
    folderREADME = false

    files = getFiles path.join(path_docs.in.src, folder), '.md'

    _.remove(files, (n) ->
      folderREADME = true;
      return n == 'README.md'
    )

    filesString += if folderREADME then "[](" + folder + "/README.md)" + "\n"  else "### " + folder + "\n"  

    _(files).forEach( (file) ->
      filesString += '  * []('+ folder + '/' + file + ')' + "\n"
    )
  )

  fs.appendFile(path_docs.in.src + "/SUMMARY.md", filesString,  (err) ->
    console.log(err)
  )