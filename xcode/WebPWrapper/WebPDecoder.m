//
//  WebPWrapper.m
//  WebPWrapper
//

#import "WebPDecoder.h"
#import <WebP/decode.h>

// This gets called when the UIImage gets collected and frees the underlying image.
static void free_image_data(void *info, const void *data, size_t size)
{
    if(info != NULL) {
        WebPFreeDecBuffer(&(((WebPDecoderConfig *) info)->output));
        free(info);
    } else {
        free((void *) data);
    }
}


@implementation WebPDecoder


-(UIImage*)imageWithWebP:(NSString*)filePath
{
    // If passed `filepath` is invalid, return nil to caller and log error in console
    NSError *dataError = nil;
    NSData *imgData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&dataError];
    if (dataError != nil) {
        //*error = dataError;
        
        NSLog(@"had some error over here: %@", [dataError localizedDescription]);
        
        
        return nil;
    }
    
    return [self imageWithWebPData:imgData];
}


-(UIImage*)imageWithWebPData:(NSData*)imgData
{
    // `WebPGetInfo` weill return image width and height
    int width = 0, height = 0;
    if(!WebPGetInfo([imgData bytes], [imgData length], &width, &height)) {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Header formatting error." forKey:NSLocalizedDescriptionKey];
        //if(error != NULL)
        //    *error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@.errorDomain",  [[NSBundle mainBundle] bundleIdentifier]] code:-101 userInfo:errorDetail];
        
        NSLog(@"Got an error: Header formatting error");
        return nil;
    }
    
    WebPDecoderConfig * config = malloc(sizeof(WebPDecoderConfig));
    if(!WebPInitDecoderConfig(config)) {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Failed to initialize structure. Version mismatch." forKey:NSLocalizedDescriptionKey];
        /*if(error != NULL)
         *error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@.errorDomain",  [[NSBundle mainBundle] bundleIdentifier]] code:-101 userInfo:errorDetail];*/
        
        NSLog(@"Got an error: Failed to initialize structure. Version mismatch.");
        
        return nil;
    }
    
    config->options.no_fancy_upsampling = 1;
    config->options.bypass_filtering = 1;
    config->options.use_threads = 1;
    config->output.colorspace = MODE_RGBA;
    
    // Decode the WebP image data into a RGBA value array
    VP8StatusCode decodeStatus = WebPDecode([imgData bytes], [imgData length], config);
    if (decodeStatus != VP8_STATUS_OK) {
        /*NSString *errorString = [self statusForVP8Code:decodeStatus];
        
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:errorString forKey:NSLocalizedDescriptionKey];
        if(error != NULL)
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@.errorDomain",  [[NSBundle mainBundle] bundleIdentifier]] code:-101 userInfo:errorDetail];*/
        
        NSLog(@"had some error over here: vp8 status error");
        
        
        return nil;
    }
    
    // Construct UIImage from the decoded RGBA value array
    uint8_t *data = WebPDecodeRGBA([imgData bytes], [imgData length], &width, &height);
    CGDataProviderRef provider = CGDataProviderCreateWithData(config, data, (config->options.scaled_width || width) * (config->options.scaled_height || height) * 4, free_image_data);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault |kCGImageAlphaLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef imageRef = CGImageCreate(width, height, 8, 32, 4 * width, colorSpaceRef, bitmapInfo, provider, NULL, YES, renderingIntent);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    
    // Free resources to avoid memory leaks
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    return result;
}
@end
