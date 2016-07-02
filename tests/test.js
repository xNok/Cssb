/*
* @Author: Alexandre-COUEDELO
* @Date:   2016-06-26 18:23:34
* @Last Modified by:   Alexandre-COUEDELO
* @Last Modified time: 2016-07-02 17:21:27
*/

'use strict';

var chai    = require('chai');
var assert  = chai.assert;
var expect  = chai.expect;

var exec    = require('child-process-promise').exec;
var fs      = require('fs');
var dirTree = require('directory-tree');

describe('frontdev', function () {

  //cli

  describe('init:frontdev', function () {
    before(function(done) {

        this.timeout(50000);

        exec("gulp init:frontdev")
          .then(function (result) {
              done();
          })
          .catch(function (err) {
              console.log(err);
              done();
          });
    });

    it('it Should provide a valid frontdev directory-tree', function () {
        let frontdevDirTree =  JSON.stringify(JSON.parse(fs.readFileSync('tests/lib/dirTree/frontdev.json')));
        expect(JSON.stringify(dirTree('../frontdev/'))).to.equal(frontdevDirTree);
    });
  });
});
