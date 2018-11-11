//
//  SNKNinePatchImageCache.h
//  TestImageResible
//
//  Created by tu jinqiu on 2018/11/7.
//  Copyright © 2018年 tu jinqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNKNinePatchImage.h"

@interface SNKNinePatchImageCache : NSObject

+ (instancetype)sharedCache;

+ (void)setNinePatchImage:(SNKNinePatchImage *)ninePatchImage forName:(NSString *)name;
+ (SNKNinePatchImage *)ninePatchImageNamed:(NSString *)name;

- (void)setNinePatchImage:(SNKNinePatchImage *)ninePatchImage forName:(NSString *)name;
- (SNKNinePatchImage *)ninePatchImageNamed:(NSString *)name;

@end
