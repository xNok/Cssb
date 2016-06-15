fs   = require('fs')
path = require('path')

exports.getFiles = (dir, filter) => {
  return fs.readdirSync(dir)
    .filter( (file) => {
        return file.match(filter)
    })
}

exports.getFolders = (dir) => {
  return fs.readdirSync(dir)
    .filter( (file) => {
      return fs.statSync(path.join(dir, file)).isDirectory()
    })
}