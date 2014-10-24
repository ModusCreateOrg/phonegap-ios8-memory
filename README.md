A simple app to test memory accretion with iOS8.

This application simply uses a pretty vanilla PhoneGap application that demonstrates that either PhoneGap for iOS8 or the iOS8 JavaScript VM has problems with the JavaScript to ObjectiveC communication.  *NOTE*:This is not a problem with iOS5,6 or 7.

Image: http://bit.ly/1DIM944
To see for yourself:
- Clone this project (in a mac, obviously).
- Open <your project dir>/Test/Platforms/ios/Test.xcodeproj in xcode
- Select an IOS 8 sim
- Run the project
- Click the "device is ready" element
- Watch the device profiler in XCode 

The test:
Below is the ObjectiveC code that contains a methoed named `testFn`. `testFn` is called by a modified copy of Cordova's index.js and generates 1000 random integers and stuffs them to an array to be returned by the calling plugin method execution request inside of index.js.

Here's the testFn method:

```
@implementation ModPlyr

- (void) testFn:(CDVInvokedUrlCommand*)command {

    NSMutableArray *array = [[NSMutableArray alloc] init];

    int randomNum;
    NSNumber *num;
    
    for (int i=0; i < 1000; i++) {
        randomNum = arc4random_uniform(74);;
        num       = [[NSNumber alloc] initWithInt:randomNum];
        
        [array addObject:num];
    }
    
     
    NSDictionary * dict = [[NSDictionary alloc]
                initWithObjectsAndKeys:
                    array,   @"data",
                    nil
                ];

    
    CDVPluginResult *pluginResult = [CDVPluginResult
                                    resultWithStatus : CDVCommandStatus_OK
                                    messageAsDictionary  : dict
                                ];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
@end
```

index.js is modified to register a click handler of the "device is ready" div found in the hello world phonegap application.  The click handler is going to initiate a 10ms `setInterval()` loop to execute `this.getData()`. `this.getData()`, is what is responsible for executing `testFn` in the above vanilla plugin and will simply update the "device is ready" div, displaying the execution number.

```
    // Update DOM on a Received Event
    receivedEvent: function(id) {

        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');
        
        this.receivedElement = receivedElement;
        
        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        this.runNumber = 0;
        
        var me = this;
        receivedElement.onclick = function() {
            console.log('starting loop');
            setInterval(function() {
                me.getData();
            }, 10);
        }
    },

    getData : function() {
        console.log('getData')
        var me = this;
        cordova.exec(
            function callback(data) {
//                console.log(data);
                me.receivedElement.innerHTML = ++me.runNumber;
            },
            function errorHandler(err) {
                console.log('testFn error');
            },
            'ModPlyr',
            'testFn',
            []
        );
    }
```
