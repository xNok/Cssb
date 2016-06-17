/*
* @Author: Alexandre-COUEDELO
* @Date:   2016-06-17 10:12:13
* @Last Modified by:   Alexandre-COUEDELO
* @Last Modified time: 2016-06-17 10:56:48
*/

var fs       = require('fs');
var path     = require('path');

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