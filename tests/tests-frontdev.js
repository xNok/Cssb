/*
* @Author: Alexandre-COUEDELO
* @Date:   2016-06-26 18:23:34
* @Last Modified by:   Alexandre-COUEDELO
* @Last Modified time: 2016-07-03 21:32:17
*/

'use strict';

var chai    = require('chai');
var assert  = chai.assert;
var expect  = chai.expect;
var del     = require('del');

var exec    = require('child-process-promise').exec;
var fs      = require('fs');
var dirTree = require('directory-tree');

describe('frontdev', function () {

  before(function(done) {
    del(['../www/**', '../frontdev/**'],{
      force: true
    }).then(paths => {
      done();
    });
  });

  describe('init:frontdev', function () {
    before(function(done) {

        this.timeout(15000);

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

  describe('frontdev:compile:*', function () {

    describe('frontdev:compile:sass2css', function () {
      before(function(done) {

          this.timeout(15000);

          exec("gulp frontdev:compile:sass2css")
            .then(function (result) {
                done();
            })
            .catch(function (err) {
                console.log(err);
                done();
            });
      });

      it('it Should provide a valid css/app.css file', function () {
        expect(fs.existsSync('../www/css/app.css')).to.equal(true);
      });

      it('it Should provide a .map file', function () {
        expect(fs.existsSync('../www/maps/app.css.map')).to.equal(true);
      });
    });

    describe('frontdev:compile:swig2html', function () {
      before(function(done) {

          this.timeout(15000);

          exec("gulp frontdev:compile:swig2html")
            .then(function (result) {
                done();
            })
            .catch(function (err) {
                console.log(err);
                done();
            });
      });

      it('it Should create the default index.html', function () {
        expect(fs.existsSync('../www/index.html')).to.equal(true);
      });
    });

    describe('frontdev:compile:babel2js', function () {
      before(function(done) {

          this.timeout(15000);

          exec("gulp frontdev:compile:babel2js")
            .then(function (result) {
                done();
            })
            .catch(function (err) {
                console.log(err);
                done();
            });
      });

      it('it Should create the default app.js', function () {
        expect(fs.existsSync('../www/js/app.js')).to.equal(true);
      });

      it('it Should provide a .map file', function () {
        expect(fs.existsSync('../www/maps/app.js.map')).to.equal(true);
      });
    });
  });

  describe('frontdev:lint:*', function () {

    describe('frontdev:lint:json', function () {
      before(function(done) {

          this.timeout(15000);

          exec("gulp frontdev:lint:json")
            .then(function (result) {
                done();
            })
            .catch(function (err) {
                console.log(err);
                done();
            });
      });

      xit('cli should pass without error', function () {
        
      });
    }); 

    describe('frontdev:lint:js', function () {
      before(function(done) {

          this.timeout(15000);

          exec("gulp frontdev:lint:js")
            .then(function (result) {
                done();
            })
            .catch(function (err) {
                console.log(err);
                done();
            });
      });

      xit('cli should pass without error', function () {
        
      });
    }); 
  });

  describe('frontdev:minify:*', function () {

    describe('frontdev:minify:images', function () {
      before(function(done) {

          this.timeout(15000);

          exec("gulp frontdev:minify:images")
            .then(function (result) {
                done();
            })
            .catch(function (err) {
                console.log(err);
                done();
            });
      });

      it('it Should create a compiled longrange.png', function () {
        expect(fs.existsSync('../www/img/longrange.png')).to.equal(true);
      });
    });

    describe('frontdev:minify:js', function () {
      before(function(done) {

          this.timeout(15000);

          exec("gulp frontdev:minify:js")
            .then(function (result) {
                done();
            })
            .catch(function (err) {
                console.log(err);
                done();
            });
      });

      it('it Should create a minified app.min.js', function () {
        expect(fs.existsSync('../www/js/app.min.js')).to.equal(true);
      });
    });

    describe('frontdev:minify:css', function () {
      before(function(done) {

          this.timeout(15000);

          exec("gulp frontdev:minify:css")
            .then(function (result) {
                done();
            })
            .catch(function (err) {
                console.log(err);
                done();
            });
      });

      it('it Should create a minified app.min.css', function () {
        expect(fs.existsSync('../www/css/app.min.css')).to.equal(true);
      });
    });

    describe('frontdev:minify:useref', function () {
      before(function(done) {

          this.timeout(15000);

          exec("gulp frontdev:minify:useref")
            .then(function (result) {
                done();
            })
            .catch(function (err) {
                console.log(err);
                done();
            });
      });

      it('it Should create a styles.min.css file', function () {
        expect(fs.existsSync('../www/css/styles.min.css')).to.equal(true);
      });

      it('it Should create a scripts.min.js file', function () {
        expect(fs.existsSync('../www/js/scripts.min.js')).to.equal(true);
      });
    });

    describe('frontdev:minify:cleanUp', function () {
      before(function(done) {

          this.timeout(15000);

          exec("gulp frontdev:minify:cleanUp")
            .then(function (result) {
                done();
            })
            .catch(function (err) {
                console.log(err);
                done();
            });
      });

      it('it Should delete a app.css file', function () {
        expect(fs.existsSync('../www/css/app.css')).to.equal(false);
      });

      it('it Should delete a app.js file', function () {
        expect(fs.existsSync('../www/js/app.js')).to.equal(false);
      });
    }); 
  });

});
