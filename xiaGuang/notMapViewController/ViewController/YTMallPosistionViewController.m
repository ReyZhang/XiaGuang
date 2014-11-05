//
//  YTMallPosistionViewController.m
//  xiaGuang
//
//  Created by YunTop on 14/11/5.
//  Copyright (c) 2014年 YunTop. All rights reserved.
//

#import "YTMallPosistionViewController.h"

@implementation YTMallPosistionViewController
-(instancetype)initWithImage:(UIImage *)image address:(NSString *)address phoneNumber:(NSString *)phoneNumber{
    self = [super init];
    if (self) {
        UIImageView *mapImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        mapImageView.image = image;
        [self.view addSubview:mapImageView];
        
        self.navigationItem.title = @"商圈位置";
        
        UILabel *phoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.view.frame), 50)];
        [self.view addSubview:phoneNumberLabel];
        
    }
    return self;
}
@end
