//
//  WebPWrapper.h
//  WebPWrapper
//


#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface WebPDecoder : NSObject

-(NSImage*)imageWithWebP:(NSString*)filePath error:(NSError **)error;

-(NSImage*)imageWithWebPData:(NSData*)imgData error:(NSError **)error;

-(int)getVersion;

@end
