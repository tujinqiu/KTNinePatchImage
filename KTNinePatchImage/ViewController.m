//
//  ViewController.m
//  KTNinePatchImage
//
//  Created by tu on 2018/11/11.
//  Copyright © 2018年 tu. All rights reserved.
//

#import "ViewController.h"
#import "SNKNinePatchImageView.h"
#import <Masonry.h>

@interface ViewController ()

@property(nonatomic, strong) SNKNinePatchImageView *imageView1;
@property(nonatomic, strong) UILabel *label1;
@property(nonatomic, strong) SNKNinePatchImageView *imageView2;
@property(nonatomic, strong) UILabel *label2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.imageView1];
    [self.view addSubview:self.label1];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(200);
        make.right.equalTo(self.view).offset(-60);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    [self.imageView1 addConstraintsWithPaddingView:self.label1];
    self.imageView1.ninePatchImage = [SNKNinePatchImage ninePatchImageWithName:@"test1"];
    self.label1.text = @"这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！";
    
    [self.view addSubview:self.imageView2];
    [self.view addSubview:self.label2];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(400);
        make.right.equalTo(self.view).offset(-60);
        make.width.mas_lessThanOrEqualTo(300);
    }];
    [self.imageView2 addConstraintsWithPaddingView:self.label2];
    self.imageView2.ninePatchImage = [SNKNinePatchImage ninePatchImageWithName:@"test1"];
    self.label2.text = @"这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！";
}

- (SNKNinePatchImageView *)imageView1
{
    if (!_imageView1) {
        _imageView1 = [SNKNinePatchImageView new];
    }
    
    return _imageView1;
}

- (UILabel *)label1
{
    if (!_label1) {
        _label1 = [UILabel new];
        _label1.textColor = [UIColor blackColor];
        _label1.font = [UIFont systemFontOfSize:16];
        _label1.textAlignment = NSTextAlignmentLeft;
        _label1.numberOfLines = 0;
    }
    
    return _label1;
}

- (SNKNinePatchImageView *)imageView2
{
    if (!_imageView2) {
        _imageView2 = [SNKNinePatchImageView new];
    }
    
    return _imageView2;
}

- (UILabel *)label2
{
    if (!_label2) {
        _label2 = [UILabel new];
        _label2.textColor = [UIColor blackColor];
        _label2.font = [UIFont systemFontOfSize:16];
        _label2.textAlignment = NSTextAlignmentLeft;
        _label2.numberOfLines = 0;
    }
    
    return _label2;
}

@end
