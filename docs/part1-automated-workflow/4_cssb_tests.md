# Improve your workflow with test

Have you ever heard about test driven programming ?

## CLI test

The purpose of this test is to know if the command line works. Then you add integration tests to check of everything append as expected.

__Child process__ let you execute command line via node.js. I recommend to use the [promise]() version fare more easy to use.

```javascript
var exec   = require('child-process-promise').exec;

exec("cmd")
  .then(function (result) {
      var stdout = result.stdout;
      var stderr = result.stderr;

      console.log(stdout);
      console.log(stderr);
  })
  .catch(function (err) {
      console.log(err);
  });
```

If you don't know yet what [stdin, stdout, stderr]() are, you should probably have look, because it is a very standard protocol in command line processing.

Now you are have a simple way to test your `gulp task` for example.

## Integration test

> npm install -g mocha

## bibliography

* [child-process]()
* [child-process-promise]()
* [mocha](https://mochajs.org/)