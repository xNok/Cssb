###
get the gitbook commande line
###
gitbookGetCMD = (cmdString) ->
  return _.find(gitbook.commands, (_cmd) ->
      return _.first(_cmd.name.split(" ")) == cmdString;
  )

###
@plugin : gitbook
@input  : pathIN, pathOUT, options
@options: log: info/debug , format: website, timing: false
###
exports.website = (pathIN, pathOUT, options) ->
  return () -> 
      cmd = gitbookGetCMD("build")
      args = [pathIN, pathOUT]
      kwargs = options
      cmd.exec(args, kwargs)

###
@plugin : gitbook
@input  : pathIN, pathOUT, options
@options: log: info/debug , format: website, timing: false
###
exports.pdf = (pathIN, pathOUT, options) ->
  return () -> 
      cmd = gitbookGetCMD("pdf")
      args = [pathIN, pathOUT]
      kwargs = options
      cmd.exec(args, kwargs)