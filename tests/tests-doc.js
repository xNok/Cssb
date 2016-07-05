/*
* @Author: Alexandre-COUEDELO
* @Date:   2016-07-04 19:11:00
* @Last Modified by:   Alexandre-COUEDELO
* @Last Modified time: 2016-07-05 17:50:29
*/

'use strict';

'use strict';

var chai    = require('chai');
var assert  = chai.assert;
var expect  = chai.expect;
var del     = require('del');

var exec    = require('child-process-promise').exec;
var fs      = require('fs');
var dirTree = require('directory-tree');

describe('documentation', function () {

  before(function(done) {
    del(['../docs/**','../docsBook/**'],{
      force: true
    }).then(paths => {
      done();
    });
  });

  describe('init:gitbook', function () {
    before(function(done) {

        this.timeout(15000);

        exec("gulp init:gitbook")
          .then(function (result) {
              done();
          })
          .catch(function (err) {
              console.log(err);
              done();
          });
    });

    it('it Should provide a valid docs directory-tree', function () {
      let frontdevDirTree =  JSON.parse(fs.readFileSync('tests/lib/dirTree/gitbook.json'));
      expect(dirTree('../docs/')).deep.to.equal(frontdevDirTree);
    });
  });

  describe('docs:gitbook:*', function () {

    describe('docs:gitbook:website', function () {
      before(function(done) {

          this.timeout(50000);

          exec("gulp docs:gitbook:website")
            .then(function (result) {
                done();
            })
            .catch(function (err) {
                console.log(err);
                done();
            });
      });

      it('it Should provide a valid docsBook directory-tree', function () {
        let frontdevDirTree = JSON.parse(fs.readFileSync('tests/lib/dirTree/gitbookWebsite.json'));
        expect(dirTree('../docsBook/web')).deep.to.equal(frontdevDirTree);
      });
    });

    describe('docs:gitbook:pdf', function () {
      before(function(done) {

          this.timeout(50000);

          exec("gulp docs:gitbook:pdf")
            .then(function (result) {
                done();
            })
            .catch(function (err) {
                console.log(err);
                done();
            });
      });

      it('it Should generate a book.pdf', function () {
        expect(fs.existsSync('../docsBook/book.pdf')).to.equal(true);
      });
    });
  });

});