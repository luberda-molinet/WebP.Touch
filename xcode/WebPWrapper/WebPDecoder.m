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
    }
    
    free((void *) data);
}


@implementation WebPDecoder


-(UIImage*)imageWithWebP:(NSString*)filePath error:(NSError **)error
{
    // If passed `filepath` is invalid, return nil to caller and log error in console
    NSError *dataError = nil;
    NSData *imgData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&dataError];
    if (dataError != nil) {
        *error = dataError;
        return nil;
    }
    
    return [self imageWithWebPData:imgData error:error];
}


-(UIImage*)imageWithWebPData:(NSData*)imgData error:(NSError **)error
{
    // `WebPGetInfo` weill return image width and height
    int width = 0, height = 0;
    if(!WebPGetInfo([imgData bytes], [imgData length], &width, &height)) {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Header formatting error." forKey:NSLocalizedDescriptionKey];
        if(error != NULL)
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@.errorDomain",  [[NSBundle mainBundle] bundleIdentifier]] code:-101 userInfo:errorDetail];
        return nil;
    }
    
    WebPDecoderConfig * config = malloc(sizeof(WebPDecoderConfig));
    if(!WebPInitDecoderConfig(config)) {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Failed to initialize structure. Version mismatch." forKey:NSLocalizedDescriptionKey];
        if(error != NULL)
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@.errorDomain",  [[NSBundle mainBundle] bundleIdentifier]] code:-101 userInfo:errorDetail];
        return nil;
    }
    
    config->options.no_fancy_upsampling = 1;
    config->options.bypass_filtering = 1;
    config->options.use_threads = 1;
    config->output.colorspace = MODE_RGBA;
    
    // Decode the WebP image data into a RGBA value array
    VP8StatusCode decodeStatus = WebPDecode([imgData bytes], [imgData length], config);
    if (decodeStatus != VP8_STATUS_OK) {
        NSString *errorString = [self statusForVP8Code:decodeStatus];
        
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:errorString forKey:NSLocalizedDescriptionKey];
        if(error != NULL)
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@.errorDomain",  [[NSBundle mainBundle] bundleIdentifier]] code:-101 userInfo:errorDetail];
        return nil;
    }
    
    // Construct UIImage from the decoded RGBA value array
    uint8_t *data = WebPDecodeRGBA([imgData bytes], [imgData length], &width, &height);
    CGDataProviderRef provider = CGDataProviderCreateWithData(config, data, width  * height * 4, free_image_data);
    
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

-(int)getVersion
{
    return WebPGetDecoderVersion();
}

- (NSString *)statusForVP8Code:(VP8StatusCode)code
{
    NSString *errorString;
    switch (code) {
        case VP8_STATUS_OUT_OF_MEMORY:
            errorString = @"OUT_OF_MEMORY";
            break;
        case VP8_STATUS_INVALID_PARAM:
            errorString = @"INVALID_PARAM";
            break;
        case VP8_STATUS_BITSTREAM_ERROR:
            errorString = @"BITSTREAM_ERROR";
            break;
        case VP8_STATUS_UNSUPPORTED_FEATURE:
            errorString = @"UNSUPPORTED_FEATURE";
            break;
        case VP8_STATUS_SUSPENDED:
            errorString = @"SUSPENDED";
            break;
        case VP8_STATUS_USER_ABORT:
            errorString = @"USER_ABORT";
            break;
        case VP8_STATUS_NOT_ENOUGH_DATA:
            errorString = @"NOT_ENOUGH_DATA";
            break;
        default:
            errorString = @"UNEXPECTED_ERROR";
            break;
    }
    return errorString;
}

@end
