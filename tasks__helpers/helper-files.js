/*
* @Author: Alexandre-COUEDELO
* @Date:   2016-06-17 10:12:13
* @Last Modified by:   Alexandre-COUEDELO
* @Last Modified time: 2016-06-21 10:06:38
*/

/**
 * get Files from a folder, matching with the regex filter
 * @param  {[type]} dir    directory path
 * @param  {[type]} filter regex expression
 * @return {[type]}        array of string
 */
exports.getFiles = (dir, filter) => {
  return () => {
        fs.readdirSync(dir)
        .filter( (file) => {
            return file.match(filter)
        })
    }
}

/**
 * get folders name only
 * @param  {[type]} dir directory path
 * @return {[type]}     array of string
 */
exports.getFolders = (dir) => {
  return () => {
        fs.readdirSync(dir)
        .filter( (file) => {
          return fs.statSync(path.join(dir, file)).isDirectory()
        })
    }
}