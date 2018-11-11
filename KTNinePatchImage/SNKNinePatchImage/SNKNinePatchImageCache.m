//
//  SNKNinePatchImageCache.m
//  TestImageResible
//
//  Created by tu jinqiu on 2018/11/7.
//  Copyright © 2018年 tu jinqiu. All rights reserved.
//

#import "SNKNinePatchImageCache.h"

@interface SNKNinePatchImageCache ()

@property(nonatomic, strong) NSCache *imagesCache;

@end

@implementation SNKNinePatchImageCache

+ (instancetype)sharedCache
{
    static SNKNinePatchImageCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SNKNinePatchImageCache new];
        instance.imagesCache = [NSCache new];
    });
    
    return instance;
}

+ (void)setNinePatchImage:(SNKNinePatchImage *)ninePatchImage forName:(NSString *)name
{
    [[SNKNinePatchImageCache sharedCache] setNinePatchImage:ninePatchImage forName:name];
}

+ (SNKNinePatchImage *)ninePatchImageNamed:(NSString *)name
{
    return [[SNKNinePatchImageCache sharedCache] ninePatchImageNamed:name];
}

- (void)setNinePatchImage:(SNKNinePatchImage *)ninePatchImage forName:(NSString *)name
{
    if (ninePatchImage == nil) {
        return;
    }
    [self.imagesCache setObject:ninePatchImage forKey:name];
}

- (SNKNinePatchImage *)ninePatchImageNamed:(NSString *)name
{
    return [self.imagesCache objectForKey:name];
}

@end
