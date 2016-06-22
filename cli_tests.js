/*
* @Author: Alexandre-COUEDELO
* @Date:   2016-06-21 11:31:36
* @Last Modified by:   Alexandre-COUEDELO
* @Last Modified time: 2016-06-22 14:29:17
*/

var fs     = require('fs');
var exec   = require('child-process-promise').exec;
var Logger = require('./logger');
var log    = Logger();

var ignore = [
    'gulp default',
    'gulp watch:frontdev',
    'gulp watch'
]

var timeout = 30000;

//Run gulp task
//gulp task generate a task.json file with the information of the task in the gulp file
log.info.ln('Run "gulp tasks"');

exec("gulp tasks")
.then(function (result) {
    //read tasks.json
    var json = JSON.parse(fs.readFileSync('tasks.json'));

    // re-shape data
    var i = 0; var gulpTasks = [];
    for(var task in json){
        i++;
        gulpTasks.push(task)
    }

    log.info.ln( i + ' Tasks detected');
    log.debug.ln(gulpTasks);

    //run test
    log.warn.ln(ignore + ' Tasks ignored')
    runGulpTests(gulpTasks);
})
.catch(function (err) {
    log.info.fail('task "' + task + '" failed');
    log.debug.ln(err);
});

/**
 * Run cli one by one and catch errors
 * @param  {[type]}  gulpTasks array of cli string
 * @parem  {integer} timeout mils
 */
runGulpTests = function (gulpTasks) {
    log.info.ln('Start CLI tests');

    var errors = [];

    syncLoop(gulpTasks.length, function(loop){  
        var i = loop.iteration();
        var task = "gulp " + gulpTasks[i];

        if(ignore.indexOf(task) === -1){ // test ignore files
            log.info.ln( (i+1) + '/' + gulpTasks.length + ' Test task "' + task + '"');

            // execute the command line
            var child = exec(task, { timeout: timeout, killSignal: 'SIGTERM'})
            .then(function (result) {
                //reporting
                log.info.ok('task "' + task + '" passed with success');
                loop.next(); //next command line
            })
            .catch(function (err) {
                errors.push(task);
                // reporting 
                log.info.fail('task "' + task + '" failed');
                log.debug.ln(err);
                loop.next(); //next command line
            });

            // reporting 
            log.debug.ln("---")
            log.debug.ln('PID :' + child.childProcess.pid);
        }else{
            // reporting 
            log.warn.ln( (i+1) + '/' + gulpTasks.length + ' Ignore task "' + task + '"');
            loop.next(); //next command line
        }

    }, function(){
        log.info.ln('task CLI test finished');
        if(errors.length == 0){
            log.info.ok('SUCCESS');
        }else{
            log.info.fail(errors.length + ' tasks fails');
            log.info.fail(errors.toString());
        }
    });
}

/**
 * A loop which can loop X amount of times,
 *  which carries out asynchronous code,
 *  but waits for that code to complete before looping
 * @param  {[type]} iterations the number of iterations to carry out
 * @param  {[type]} process    the code/function we're running for every iteration 
 * @param  {[type]} exit       an optional callback to carry out once the loop has completed  
 */
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