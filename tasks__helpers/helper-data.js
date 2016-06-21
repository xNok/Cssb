/*
* @Author: Alexandre-COUEDELO
* @Date:   2016-06-17 10:12:13
* @Last Modified by:   Alexandre-COUEDELO
* @Last Modified time: 2016-06-21 10:07:22
*/

'use strict';

exports.getJsons = (pathJSON) => {
    return () => {
        var jsons = {};

        var files = getFiles(pathJSON, '.json');
        files.map( (file) => {
          var json = JSON.parse(fs.readFileSync(path.join(pathJSON, file)));
          jsons[file.replace(".json","")] = json;
        });

        return JSON.parse(JSON.stringify(jsons));
    }
}