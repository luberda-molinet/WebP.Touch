//
//  WebPWrapper.h
//  WebPWrapper
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#ifndef WebPWrapper_WebPDecoder_h
#define WebPWrapper_WebPDecoder_h

@interface WebPDecoder : NSObject

-(UIImage*)imageWithWebP:(NSString*)filePath;

-(UIImage*)imageWithWebPData:(NSData*)imgData;

@end

#endif