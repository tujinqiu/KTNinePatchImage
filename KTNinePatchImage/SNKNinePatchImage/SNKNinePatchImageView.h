//
//  SNKNinePatchImageView.h
//  TestImageResible
//
//  Created by tu jinqiu on 2018/11/7.
//  Copyright © 2018年 tu jinqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNKNinePatchImage.h"

@interface SNKNinePatchImageView : UIImageView

@property(nonatomic, strong) SNKNinePatchImage *ninePatchImage;
@property(nonatomic, assign) NSInteger imageScale;

// 应当使用如下的方法给 SNKNinePatchImageView 添加约束
// paddingView 和 SNKNinePatchImageView 应该公有一个父 view
// 不要在外部添加约束
- (void)addConstraintsWithPaddingView:(UIView *)paddingView;

- (void)setImageWithUrlStr:(NSString *)urlStr;

@end
