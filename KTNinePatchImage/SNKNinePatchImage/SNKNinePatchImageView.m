//
//  SNKNinePatchImageView.m
//  TestImageResible
//
//  Created by tu jinqiu on 2018/11/7.
//  Copyright © 2018年 tu jinqiu. All rights reserved.
//

#import "SNKNinePatchImageView.h"
#import "SNKNinePatchImageCache.h"
#import <UIImageView+YYWebImage.h>
#import <YYDiskCache.h>

@interface SNKNinePatchImageView ()

@property(nonatomic, weak) NSLayoutConstraint *topConstraint;
@property(nonatomic, weak) NSLayoutConstraint *leftConstraint;
@property(nonatomic, weak) NSLayoutConstraint *bottomConstraint;
@property(nonatomic, weak) NSLayoutConstraint *rightConstraint;

@end

@implementation SNKNinePatchImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageScale = 1;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _imageScale = 1;
    }
    
    return self;
}

- (void)addConstraintsWithPaddingView:(UIView *)paddingView
{
    NSAssert(self.superview && paddingView.superview && self.superview == paddingView.superview, @"paddingView 和 SNKNinePatchImageView 应该公有一个父 view");
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    [self setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:paddingView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    self.topConstraint = topConstraint;
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:paddingView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    self.leftConstraint = leftConstraint;
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:paddingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    self.bottomConstraint = bottomConstraint;
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:paddingView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    self.rightConstraint = rightConstraint;
    
    [self.superview addConstraints:@[topConstraint, leftConstraint, bottomConstraint, rightConstraint]];
    
    if (self.ninePatchImage) {
        [self p_updateConstraints];
    }
}

- (void)setImageWithUrlStr:(NSString *)urlStr
{
    SNKNinePatchImage *ninePatchImage = [SNKNinePatchImageCache ninePatchImageNamed:urlStr];
    if (ninePatchImage) {
        self.ninePatchImage = ninePatchImage;
        return;
    }
    
    __weak SNKNinePatchImageView *weakSelf = self;
    [self yy_setImageWithURL:[NSURL URLWithString:urlStr]
                 placeholder:nil
                     options:kNilOptions
                    progress:nil
                   transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                       [weakSelf p_checkSetImageForUrl:url urlStr:urlStr];
                       return image;
                   }
                  completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                      [weakSelf p_checkSetImageForUrl:url urlStr:urlStr];
                   }];
}

- (void)setNinePatchImage:(SNKNinePatchImage *)ninePatchImage
{
    _ninePatchImage = ninePatchImage;
    
    self.image = ninePatchImage.image;
    if (ninePatchImage) {
        [self p_updateConstraints];
    }
}

#pragma mark - private

- (void)p_updateConstraints
{
    UIEdgeInsets padding = self.ninePatchImage.paddingCap.padding;
    self.topConstraint.constant = padding.top;
    self.leftConstraint.constant = padding.left;
    self.bottomConstraint.constant = -padding.bottom;
    self.rightConstraint.constant = -padding.right;
}

- (void)p_checkSetImageForUrl:(NSURL *)url urlStr:(NSString *)urlStr
{
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:url];
    NSData *data = (NSData *)[[YYWebImageManager sharedManager].cache getImageDataForKey:key];
    if (data) {
        [self p_checkSetImageWithData:data urlStr:urlStr];
    } else {
        __weak SNKNinePatchImageView *weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSData *data = (NSData *)[[YYWebImageManager sharedManager].cache getImageDataForKey:key];
            [weakSelf p_checkSetImageWithData:data urlStr:urlStr];
        });
    }
}

- (void)p_checkSetImageWithData:(NSData *)data urlStr:(NSString *)urlStr
{
    SNKNinePatchImage *ninePatchImage = [SNKNinePatchImage ninePatchImageWithImageData:data scale:self.imageScale];
    [SNKNinePatchImageCache setNinePatchImage:ninePatchImage forName:urlStr];
    self.ninePatchImage = ninePatchImage;
}

@end
