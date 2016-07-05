_ = require('lodash')

###
get the gitbook commande line
###
gitbookGetCMD = (cmdString, $) ->
  return _.find($.gitbook.commands, (_cmd) ->
      return _.first(_cmd.name.split(" ")) == cmdString;
  )

###
@plugin : gitbook
@input  : pathIN, pathOUT, options
@options: log: info/debug , format: website, timing: false
###
exports.website = (gulp, $, inputs, options) ->
  return () -> 
      cmd = gitbookGetCMD("build", $)
      args = [inputs.pathIN, inputs.pathOUT]
      kwargs = options
      cmd.exec(args, kwargs)

###
@plugin : gitbook
@input  : pathIN, pathOUT, options
@options: log: info/debug , format: website, timing: false
###
exports.pdf = (gulp, $, inputs, options) ->
  return () -> 
      cmd = gitbookGetCMD("pdf", $)
      args = [inputs.pathIN, inputs.pathOUT]
      kwargs = options
      cmd.exec(args, kwargs)

###
@plugin : _ , getFolders, getFiles, path
@input  : pathIN
@options:
###
exports.generateSummary = (gulp, $, inputs, options) ->
  return () -> 
  folders = options.getFolders(inputs.pathIN)
  filesString = "\n"

  _(folders).forEach((folder) ->
    folderREADME = false

    files = getFiles options.path.join(pathIN, folder), '.md'

    _.remove(files, (n) ->
      folderREADME = true;
      return n == 'README.md'
    )

    filesString += if folderREADME then "[](" + folder + "/README.md)" + "\n"  else "### " + folder + "\n"  

    _(files).forEach( (file) ->
      filesString += '  * []('+ folder + '/' + file + ')' + "\n"
    )
  )

  fs.appendFile(inputs.pathIN + "/SUMMARY.md", filesString,  (err) ->
    console.log(err)
  )