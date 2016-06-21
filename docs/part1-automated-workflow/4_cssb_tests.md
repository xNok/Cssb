# Improve your workflow with test

Have you ever heard about test driven programming ?

## CLI test

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

## bibliography

* [child-process]()
* [child-process-promise]()