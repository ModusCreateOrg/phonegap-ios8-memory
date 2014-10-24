
var argscheck = require('cordova/argscheck'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec');


var ModPlyr = {
    test : function() {
        console.log('JAVA SCRIPT TEST');
        

        var fileCallback = function(data) {
            console.log('dir success')
            console.log(data = JSON.parse(data));

            cordova.exec(function() { 
                // cordova.exec(null,null,'ModPlyr','cdvPlayMod');
            }, null, 'ModPlyr', 'cdvLoadMod', [data[0].path]);
        }



        var dirCallback = function(data) {
            console.log('dir success')
            console.log(data = JSON.parse(data));

            cordova.exec(fileCallback, null, 'ModPlyr', 'cdvGetModFiles', [data[0].path]);
        }

        cordova.exec(dirCallback, null, 'ModPlyr', 'cdvGetModPaths', []);
    }
};


module.exports = ModPlyr;
