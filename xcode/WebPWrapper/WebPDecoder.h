//
//  WebPWrapper.h
//  WebPWrapper
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WebPDecoder : NSObject

-(UIImage*)imageWithWebP:(NSString*)filePath error:(NSError **)error;

-(UIImage*)imageWithWebPData:(NSData*)imgData error:(NSError **)error;

-(int)getVersion;

@end
