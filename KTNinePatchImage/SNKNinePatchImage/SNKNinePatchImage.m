//
//  SNKNinePatchImage.m
//  TestImageResible
//
//  Created by tu jinqiu on 2018/11/6.
//  Copyright © 2018年 tu jinqiu. All rights reserved.
//

#import "SNKNinePatchImage.h"
#import "SNKNinePatchImageCache.h"

static NSString *const kSNKNinePatchImageErrorDomain = @"kSNKNinePatchImageErrorDomain";

static int s_checkCPUendian()
{
    union
    {
        unsigned int a;
        unsigned char b;
    }c;
    c.a = 1;
    return 1 == c.b;
}

static uint32_t s_getBigEndian(uint32_t origin)
{
    uint32_t newSize = origin;
    if (s_checkCPUendian() == 1) {
        newSize = ntohl(origin);
    }
    
    return newSize;
}

static BOOL s_checkDivCount(uint32_t length) {
    if (length == 0 || (length & 0x01) != 0) {
        return NO;
    }
    
    return YES;
}

static void s_scalePaddingCap(SNKNinePatchPaddingCap *paddingCap, CGFloat scale)
{
    UIEdgeInsets padding = paddingCap->padding;
    padding.top = padding.top * scale;
    padding.left = padding.left * scale;
    padding.bottom = padding.bottom * scale;
    padding.right = padding.right * scale;
    paddingCap->padding = padding;
    
    UIEdgeInsets cap = paddingCap->cap;
    cap.top = cap.top * scale;
    cap.left = cap.left * scale;
    cap.bottom = cap.bottom * scale;
    cap.right = cap.right * scale;
    paddingCap->cap = cap;
}

@implementation SNKNinePatchImage

+ (instancetype)ninePatchImageWithName:(NSString *)name
{
    SNKNinePatchImage *image = [[SNKNinePatchImageCache sharedCache] ninePatchImageNamed:name];
    if (image) {
        return image;
    }
    
    NSData *data = nil;
    if ([name hasSuffix:@".png"] || [name hasSuffix:@".PNG"]) {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        data = [NSData dataWithContentsOfFile:fileName];
    } else {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        data = [NSData dataWithContentsOfFile:fileName];
    }
    if (data) {
        image = [self ninePatchImageWithImageData:data];
        if (image) {
            [[SNKNinePatchImageCache sharedCache] setNinePatchImage:image forName:name];
        }
        return image;
    }
    
    return nil;
}

+ (instancetype)ninePatchImageWithImageData:(NSData *)data
{
    return [self ninePatchImageWithImageData:data scale:1];
}

+ (instancetype)ninePatchImageWithImageData:(NSData *)data scale:(NSInteger)scale
{
    SNKNinePatchImage *ninePatch = [SNKNinePatchImage new];
    
    NSError *error = nil;
    SNKNinePatchPaddingCap paddingCap = [self p_paddingCapForPngImageData:data error:&error];
    if (error) {
        return nil;
    }
    
    UIImage *oldImage = [UIImage imageWithData:data];
    UIEdgeInsets newCap = UIEdgeInsetsMake(paddingCap.cap.top - 1, paddingCap.cap.left - 1, oldImage.size.height - paddingCap.cap.bottom, oldImage.size.width - paddingCap.cap.right);
    paddingCap.cap = newCap;
    s_scalePaddingCap(&paddingCap, 1.0 / scale);
    
    UIImage *newImage = [[UIImage alloc] initWithCGImage:oldImage.CGImage scale:scale orientation:UIImageOrientationUp];
    newImage = [newImage resizableImageWithCapInsets:paddingCap.cap];
    
    ninePatch.paddingCap = paddingCap;
    ninePatch.image = newImage;
    
    return ninePatch;
}

#pragma mark - private

+ (SNKNinePatchPaddingCap)p_paddingCapForPngImageData:(NSData *)data error:(NSError **)error
{
    NSData *chunkData = [self p_chunkDataWithImageData:data];
    if (chunkData) {
        return [self p_paddingCapFromChunkData:chunkData error:error];
    } else {
        *error = [NSError errorWithDomain:kSNKNinePatchImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"解析ChunkData失败"}];
        SNKNinePatchPaddingCap ret = {};
        return ret;
    }
}

+ (NSData *)p_chunkDataWithImageData:(NSData *)data
{
    if (data == nil) {
        return nil;
    }
    
#define SNKNinePatchTestDataByte(a) if (a <= 0) { return nil; }
    
    uint32_t startPos = 0;
    uint32_t ahead1 = [self p_getByte4FromData:data startPos:&startPos];
    SNKNinePatchTestDataByte(ahead1)
    uint32_t ahead2 = [self p_getByte4FromData:data startPos:&startPos];
    SNKNinePatchTestDataByte(ahead1)
    if (ahead1 != 0x89504e47 || ahead2 != 0x0D0A1A0A) {
        return nil;
    }
    
    while (YES) {
        uint32_t length = [self p_getByte4FromData:data startPos:&startPos];
        SNKNinePatchTestDataByte(length)
        uint32_t type = [self p_getByte4FromData:data startPos:&startPos];
        SNKNinePatchTestDataByte(type)
        if (type != 0x6E705463) {
            startPos += (length + 4);
            continue;
        }
        return [data subdataWithRange:NSMakeRange(startPos, length)];
    }
    
    return nil;
    
#undef SNKNinePatchTestDataByte
}

+ (SNKNinePatchPaddingCap)p_paddingCapFromChunkData:(NSData *)data error:(NSError **)error
{
    uint32_t startPos = 0;
    
    startPos += 1;
    
    uint32_t xLength = [self p_getByteFromData:data startPos:&startPos];
    uint32_t yLength = [self p_getByteFromData:data startPos:&startPos];
    startPos += 1;
    
    BOOL xCheck = s_checkDivCount(xLength);
    BOOL yCheck = s_checkDivCount(yLength);
    NSAssert(xCheck && yCheck, @"checkDivCount failure");
    
    // skip 8 bytes
    startPos += 8;
    
    uint32_t left = [self p_getByte4FromData:data startPos:&startPos];
    uint32_t right = [self p_getByte4FromData:data startPos:&startPos];
    uint32_t top = [self p_getByte4FromData:data startPos:&startPos];
    uint32_t bottom = [self p_getByte4FromData:data startPos:&startPos];
    UIEdgeInsets padding = UIEdgeInsetsMake(top, left, bottom, right);
    
    // skip 4 bytes
    startPos += 4;
    
    uint32_t xCapArr[256];
    [self p_getBytesArr:xCapArr fromData:data startPos:&startPos count:xLength];
    uint32_t yCapArr[256];
    [self p_getBytesArr:yCapArr fromData:data startPos:&startPos count:yLength];
    
    uint32_t xCapStart = xCapArr[0];
    uint32_t xCapEnd = xCapArr[xLength - 1];
    uint32_t yCapStart = yCapArr[0];
    uint32_t yCapEnd = yCapArr[yLength - 1];
    UIEdgeInsets cap = UIEdgeInsetsMake(yCapStart, xCapStart, yCapEnd, xCapEnd);
    
    SNKNinePatchPaddingCap paddingCap = {padding, cap};
    
    return paddingCap;
}

+ (uint32_t)p_getByte4FromData:(NSData *)data
                      startPos:(uint32_t *)startPos
{
    return [self p_getBytesFromData:data startPos:startPos length:4];
}

+ (uint32_t)p_getByteFromData:(NSData *)data
                     startPos:(uint32_t *)startPos
{
    return [self p_getBytesFromData:data startPos:startPos length:1];
}

+ (uint32_t)p_getBytesFromData:(NSData *)data
                      startPos:(uint32_t *)startPos
                        length:(uint32_t)length
{
    uint32_t bytes = 0;
    uint32_t start = *startPos;
    if (start + length > data.length) {
        return 0;
    }
    [data getBytes:&bytes range:NSMakeRange(start, length)];
    if (length > 1) {
        bytes = s_getBigEndian(bytes);
    }
    *startPos = start + length;
    
    return bytes;
}

+ (void)p_getBytesArr:(uint32_t *)bytesArr
             fromData:(NSData *)data
             startPos:(uint32_t *)startPos
                count:(uint32_t)count
{
    for (int32_t ii = 0; ii < count; ++ii) {
        uint32_t bytes = [self p_getBytesFromData:data startPos:startPos length:4];
        bytesArr[ii] = bytes;
    }
}

@end

