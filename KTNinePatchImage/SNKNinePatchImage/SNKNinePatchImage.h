//
//  SNKNinePatchImage.h
//  TestImageResible
//
//  Created by tu jinqiu on 2018/11/6.
//  Copyright © 2018年 tu jinqiu. All rights reserved.
//

#import <UIKit/UIKit.h>


// 参照这篇文章 https://blog.csdn.net/u013365670/article/details/25415393 实现从png图片中读取padding和cap信息

typedef struct SNKNinePatchPaddingCap {
    UIEdgeInsets padding;
    UIEdgeInsets cap;
} SNKNinePatchPaddingCap;

@interface SNKNinePatchImage : NSObject

@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) SNKNinePatchPaddingCap paddingCap;

+ (instancetype)ninePatchImageWithName:(NSString *)name;
+ (instancetype)ninePatchImageWithImageData:(NSData *)data;
+ (instancetype)ninePatchImageWithImageData:(NSData *)data scale:(NSInteger)scale;

@end
