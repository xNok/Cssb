/*
* @Author: Alexandre-COUEDELO
* @Date:   2016-06-17 10:12:13
* @Last Modified by:   Alexandre-COUEDELO
* @Last Modified time: 2016-06-26 19:58:40
*/

var fs   = require('fs');
var log  = require('../../logger')();
var path = require('path')

/**
 * get Files from a folder, matching with the regex filter
 * @param  {[type]} dir    directory path
 * @param  {[type]} filter regex expression
 * @return {[type]}        array of string
 */
getFiles = (dir, filter) => {
    log.debug.ln('getFiles >> ' + dir + ' ' + filter)
    return fs.readdirSync(dir).filter( (file) => {
        return file.match(filter)
    })
}

/**
 * get folders name only
 * @param  {[type]} dir directory path
 * @return {[type]}     array of string
 */
getFolders = (dir) => {
    log.debug.ln('getFolders >> ' + dir)
    return fs.readdirSync(dir).filter( (file) => {
      return fs.statSync(path.join(dir, file)).isDirectory()
    })
}

/**
 * get jsons files and merged it into one json Object
 * @param  {[type]} pathJSON [description]
 * @return {[type]}          [description]
 */
getJsons = (pathJSON) => {
    var jsons = {};

    var files = getFiles(pathJSON, '.json');
    files.map( (file) => {
      var json = JSON.parse(fs.readFileSync(path.join(pathJSON, file)));
      jsons[file.replace(".json","")] = json;
    });

    return JSON.parse(JSON.stringify(jsons));
}

exports.getJsons   = getJsons;
exports.getFiles   = getFiles;
exports.getFolders = getFolders;