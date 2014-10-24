//
//
//  ModPlyr
//
//  Created by Jesus Garcia on 6/28/13.
//
//

#import "ModPlyr.h"

@implementation ModPlyr  {
}

- (void) test:(CDVInvokedUrlCommand*)command {
    
    CDVPluginResult *pluginResult = [CDVPluginResult
                                    resultWithStatus:CDVCommandStatus_OK,
                                    messageAsString: @"TEST"
                                ];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}@end

