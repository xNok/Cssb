/*
* @Author: Alexandre-COUEDELO
* @Date:   2016-06-21 11:31:36
* @Last Modified by:   Alexandre-COUEDELO
* @Last Modified time: 2016-06-22 00:28:29
*/

var fs     = require('fs');
var exec   = require('child-process-promise').exec;
var Logger = require('./logger');
var log    = Logger();

//Run gulp task
//gulp task generate a task.json file with the information of the task in the gulp file
log.info.ln('Run "gulp tasks"');

exec("gulp tasks")
.then(function (result) {
    var json = JSON.parse(fs.readFileSync('tasks.json'));
    var i = 0;
    var gulpTasks = [];

    for(var task in json){
        i++;
        gulpTasks.push(task)
    }

    gulpTasks = [
        'compile:sass',
        'compile:swig'
    ];

    log.info.ln( i + ' Tasks detected');
    log.debug.ln(gulpTasks);

    runGulpTests(gulpTasks);
})
.catch(function (err) {
    log.info.fail('task "' + task + '" failed');
    log.debug.ln(err);
});

/**
 * Run cli one by one and catch errors
 * @param  {[type]} gulpTasks array of cli string
 */
runGulpTests = function (gulpTasks) {
    log.info.ln('Start CLI tests');

    syncLoop(gulpTasks.length, function(loop){  
        var i = loop.iteration();
        var task = "gulp " + gulpTasks[i];
        log.info.ln('Test task "' + task + '"');
        
        return exec(task)
        .then(function (result) {
            log.info.ok('task "' + task + '" passed with success');
            loop.next();
        })
        .catch(function (err) {
            log.info.fail('task "' + task + '" failed');
            log.debug.ln(err);
            loop.next();
        });
    }, function(){
        log.info.ok('task CLI test finished');
    });
}

function syncLoop(iterations, process, exit){  
    var index = 0,
        done = false,
        shouldExit = false;
    var loop = {
        next:function(){
            if(done){
                if(shouldExit && exit){
                    return exit(); // Exit if we're done
                }
            }
            // If we're not finished
            if(index < iterations){
                index++; // Increment our index
                process(loop); // Run our process, pass in the loop
            // Otherwise we're done
            } else {
                done = true; // Make sure we say we're done
                if(exit) exit(); // Call the callback on exit
            }
        },
        iteration:function(){
            return index - 1; // Return the loop number we're on
        },
        break:function(end){
            done = true; // End the loop
            shouldExit = end; // Passing end as true means we still call the exit callback
        }
    };
    loop.next();
    return loop;
}