/*
* @Author: Alexandre-COUEDELO
* @Date:   2016-06-21 11:31:36
* @Last Modified by:   Alexandre-COUEDELO
* @Last Modified time: 2016-06-21 11:33:51
*/

var spawn = require('child-process').spawn;

spawn('compile:sass', [])
  .progress(function(childProcess){
    console.log("process runing")
  })
  .then(function(result){
    console.log("finished")
  })
  .fail(function(err){
    console.log("error")
  });