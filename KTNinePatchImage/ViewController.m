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
        make.top.equalTo(self.view).offset(100);
        make.right.equalTo(self.view).offset(-40);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    [self.imageView1 addConstraintsWithPaddingView:self.label1];
    self.imageView1.ninePatchImage = [SNKNinePatchImage ninePatchImageWithName:@"test1"];
    self.label1.text = @"这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！这是测试！";
    
//    [self.view addSubview:self.imageView2];
//    [self.view addSubview:self.label2];
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

@end
