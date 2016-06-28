###
@plugin : _ , getFolders, getFiles, path
@input  : pathIN
@options:
###
exports.generateSummary = (pathIN) ->
  return () -> 
  folders = getFolders(pathIN)
  filesString = "\n"

  _(folders).forEach((folder) ->
    folderREADME = false

    files = getFiles path.join(pathIN, folder), '.md'

    _.remove(files, (n) ->
      folderREADME = true;
      return n == 'README.md'
    )

    filesString += if folderREADME then "[](" + folder + "/README.md)" + "\n"  else "### " + folder + "\n"  

    _(files).forEach( (file) ->
      filesString += '  * []('+ folder + '/' + file + ')' + "\n"
    )
  )

  fs.appendFile(pathIN + "/SUMMARY.md", filesString,  (err) ->
    console.log(err)
  )