//
//
//  ModPlyr
//
//  Created by Jesus Garcia on 6/28/13.
//
//

#import "ModPlyr.h"

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

