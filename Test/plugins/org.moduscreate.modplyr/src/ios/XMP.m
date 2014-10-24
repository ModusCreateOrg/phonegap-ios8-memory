//
//  XMP.m
//  XMP
//
//  Created by Jesus Garcia (jay@moduscreate.com) 9/25/2014.
//
//


#import "XMP.h"

@implementation XMP {}



- (NSString *) getDirectoriesAsJson {

    NSString *appUrl    = [[NSBundle mainBundle] bundlePath];
    NSString *modsUrl   = [appUrl stringByAppendingString:@"/mods"];
    
    NSURL *directoryUrl = [[NSURL alloc] initFileURLWithPath:modsUrl];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    
    NSArray *directories = [fileManager
                             contentsOfDirectoryAtURL: directoryUrl
                             includingPropertiesForKeys : keys
                             options : 0
                             error:nil
                            ];

    NSMutableArray *pathDictionaries = [[NSMutableArray alloc] init];
    
    for (NSURL *url in directories) {
         NSDictionary *jsonObj = [[NSDictionary alloc]
                                    initWithObjectsAndKeys:
                                        [url lastPathComponent], @"dirName",
                                        [url path], @"path",
                                        nil
                                    ];
        
        
        [pathDictionaries addObject:jsonObj];
    }
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:pathDictionaries
                        options:NSJSONWritingPrettyPrinted
                        error:&jsonError
                       ];
    
    NSString *jsonDataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return jsonDataString;
}


- (NSString *) getModFilesAsJson: (NSString*)path {
   
    
    NSURL *directoryUrl = [[NSURL alloc] initFileURLWithPath:path];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    
    NSDirectoryEnumerator *enumerator = [fileManager
                                         enumeratorAtURL : directoryUrl
                                         includingPropertiesForKeys : keys
                                         options : 0
                                         errorHandler : ^(NSURL *url, NSError *error) {
                                             //Handle the error.
                                             // Return YES if the enumeration should continue after the error.
                                             NSLog(@"Error :: %@", error);
                                             return YES;
                                         }];
    
    NSMutableArray *pathDictionaries = [[NSMutableArray alloc] init];

    for (NSURL *url in enumerator) {
        NSError *error;
        NSNumber *isDirectory = nil;
        if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            //handle error
        }
        else if (! [isDirectory boolValue]) {
            NSDictionary *jsonObj = [[NSDictionary alloc]
                initWithObjectsAndKeys:
                    [url lastPathComponent], @"fileName",
                    [url path], @"path",
                    nil
                ];
            
            [pathDictionaries addObject:jsonObj];
        }
    }
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:pathDictionaries
                        options:NSJSONWritingPrettyPrinted
                        error:&jsonError
                    ];
    
    NSString *jsonDataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return jsonDataString;
}



#pragma mark - CDV
- (void) cdvGetModPaths:(CDVInvokedUrlCommand*)command {
    
    NSString* modPaths = [self getDirectoriesAsJson];
    
    CDVPluginResult *pluginResult = [CDVPluginResult
                                    resultWithStatus:CDVCommandStatus_OK
                                    messageAsString:modPaths
                                ];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];    
}




- (void) cdvGetModFiles:(CDVInvokedUrlCommand*)command {
    
    NSString* path = [command.arguments objectAtIndex:0];

    NSString* modFiles = [self getModFilesAsJson:path];
    
    CDVPluginResult *pluginResult = [CDVPluginResult
                                    resultWithStatus : CDVCommandStatus_OK
                                    messageAsString  : modFiles
                                ];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];    
}


- (void) cdvPlayMod:(CDVInvokedUrlCommand*)command {
    
    NSDictionary *jsonObj  = [[NSDictionary alloc]
                initWithObjectsAndKeys:
                    @"true", @"success",
                    nil
                ];

//    [self playSong]; // play the stream

        
    CDVPluginResult *pluginResult = [CDVPluginResult
                                        resultWithStatus:CDVCommandStatus_OK
                                        messageAsDictionary:jsonObj
                                    ];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



- (void) cdvLoadMod:(CDVInvokedUrlCommand*) command {
    // Todo : Clear existing song
    // Todo : Initialize sound
    
    NSString *file = [command.arguments objectAtIndex:0];
    
    
    static xmp_context ctx;
    static struct xmp_module_info mi;
    int i;
    
    ctx = xmp_create_context();
    
    const char* fil = [file cStringUsingEncoding:NSASCIIStringEncoding];
    int returnCode = xmp_load_module(ctx, fil);
    
    printf("returnCode %i\n", returnCode);
    
    
    
  
    NSDictionary *jsonObj;
        
//    if (! currentModFile) {
//        NSString *message = [[NSString alloc] initWithFormat: @"Could not load file: %@", file];
//        NSLog(@"%@", message);
//        
//        
//        jsonObj = [[NSDictionary alloc]
//                initWithObjectsAndKeys:
//                    false,   @"success",
//                    message, @"message",
//                    nil
//                ];
//        
//    }
//    else {
//        NSString *songName = [[NSString alloc] initWithCString: modName];
//    
//        NSLog(@"PLAYING : %s", modName);
//        NSNumber *nsNumChannels = [[NSNumber alloc] initWithInt:numChannels];
//        
//        // This needs to be moved to a separate method;
//        jsonObj = [[NSDictionary alloc]
//                initWithObjectsAndKeys:
//                    @"true",       @"success",
//                    nsNumChannels, @"numChannels",
//                    songName,      @"songName",
//                    nil
//                ];
//    }


     
    CDVPluginResult *pluginResult = [CDVPluginResult
                                        resultWithStatus:CDVCommandStatus_OK
                                        messageAsDictionary:jsonObj
                                    ];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}




@end

