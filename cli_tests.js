/*
* @Author: Alexandre-COUEDELO
* @Date:   2016-06-21 11:31:36
* @Last Modified by:   Alexandre-COUEDELO
* @Last Modified time: 2016-06-25 16:16:06
*/

var fs     = require('fs');
var exec   = require('child-process-promise').exec;
var log    = require('./logger')();

var ignore = [
    'gulp default',
    'gulp watch:frontdev',
]

var tasks = {
    main: {
        init: [],
        watch: [],
        dist: [],
    },
    sub: {},
    aliases: [],
    others: []
}

var timeout = 60000;

//Run gulp task
//gulp task generate a task.json file with the information of the task in the gulp file
log.info.ln('Testing process starting');


/* Testing process
 * 1. run gulp Task
 * 2. read task.json report
 * 3. analyse task pattern
 * 3.1 sort aliasses (don't test aliases)
 * 3.2 filter design pattern
 * 4. rungulpTasks
 */

// 1. ---
log.info.ln('T >> 1. run gulp Task');
exec("gulp tasks")
    .then(function (result) {
        // 2. ---
        log.info.ln('T >> 2. read task.json report');
        var json = JSON.parse(fs.readFileSync('tasks.json'));

        // 3. ---
        log.info.ln('T >> 3. analyse task pattern');
        getTaskPattern(json);

        log.info.ln(tasks);
        log.info.ln( Object.keys(json).length + ' Tasks detected');
        // log.debug.ln(gulpTasks);
        // log.info.ln( aliasescounter + ' Aliases detected');
        // log.debug.ln(gulpAliases);
        log.warn.ln(ignore.length + ' Tasks ignored')
        log.warn.ln(ignore + ' Tasks ignored')

        // 4.---
        syncLoop(Object.keys(tasks).length, function(loop){
            var i = loop.iteration();
            var key = Object.keys(tasks)[i];
            log.info.ln('T >> 4.'+ i + ' ' + key +' test');

            //subtask by category
            if(Array.isArray(tasks[key])){
                runGulpTests(tasks[key], ignore, function(){
                    loop.next();
                });
            }else{
                var subtasks = tasks[key];
                syncLoop(Object.keys(subtasks).length, function(subloop){
                    var j = subloop.iteration();
                    var subkey = Object.keys(subtasks)[j];
                    log.info.ln('T >> 4.'+ i + '.' + j + ' ' + subkey +' test');

                    runGulpTests(subtasks[subkey], ignore, function(){
                        loop.next();
                    });
                })                
            }
        })
    })
    .catch(function (err) {
        log.info.fail('task "' + task + '" failed');
        log.debug.ln(err);
    });

/*
 * Task pattern :
 *   - main task
 *        init:category  --initialisation task
 *        watch:category --watch changes
 *        dist:category  --publishing task
 *    - subtask
 *        category:action:function
 *    - aliases
 *    - other
 */
function getTaskPattern(json){
    // sort aliasses
    for(var task in json){
        if(json[task].help){
            var sArray = task.split(':');
            log.debug.ln(sArray);
            // sort patterns
            switch(sArray.length){
                case 2:
                    tasks.main[sArray[0]].push(task);
                    break;
                case 3:
                    if(!tasks.sub[sArray[0]]) tasks.sub[sArray[0]] = [];
                    tasks.sub[sArray[0]].push(task);
                    break;
                default:
                    tasks.others.push(task);
            }
        }else{
            tasks['aliases'].push(task);
        }
    }
}

/**
 * Run cli one by one and catch errors
 * Provide a list of gulp task to be tested
 * 1. loop over task
 * 2. test if ignored
 * 3. execute task
 * 4. prompt report
 * @param  {[type]}  gulpTasks array of cli string
 * @parem  {integer} timeout mils
 * @parem  {integer} callback
 */
function runGulpTests(gulpTasks, ignore, exit) {
    log.info.ln('--- Start CLI tests ---');
    log.info.ln(gulpTasks);

    var errors = [];
    // 1. ---
    syncLoop(gulpTasks.length, function(loop){  
        var i = loop.iteration();
        var task = "gulp " + gulpTasks[i];
        // 2. ---
        if(ignore.indexOf(task) === -1){ // test ignore files
            log.info.ln( (i+1) + '/' + gulpTasks.length + ' Test task "' + task + '"');

            // 3. ---
            var child = exec(task, { timeout: timeout, killSignal: 'SIGTERM'}) // execute the command line
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

            // 4. --- reporting 
            log.debug.ln("---")
            log.debug.ln('PID :' + child.childProcess.pid);
        }else{
            // 4. --- reporting  
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

        if(exit) exit();
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