/*
* @Author: Alexandre-COUEDELO
* @Date:   2016-06-26 18:23:34
* @Last Modified by:   Alexandre-COUEDELO
* @Last Modified time: 2016-06-26 20:06:04
*/

'use strict';

var assert = require('chai').assert;
var exec   = require('child-process-promise').exec;
var fs     = require('fs');

describe('init:frontdev', function () {
    before(function(done) {

        this.timeout(5000);

        exec("gulp init:frontdev")
          .then(function (result) {
              // var stdout = result.stdout;
              // var stderr = result.stderr;

              // console.log(stdout);
              // console.log(stderr);
              done();
          })
          .catch(function (err) {
              console.log(err);
              done();
          });
    });

    it('should return -1 when the value is not present', function () {
      assert.equal(-1, [1,2,3].indexOf(5));
      assert.equal(-1, [1,2,3].indexOf(0));
    });

});