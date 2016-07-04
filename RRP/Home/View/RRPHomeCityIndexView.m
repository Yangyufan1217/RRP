//
//  RRPHomeCityIndexView.m
//  RRP
//
//  Created by WangZhaZha on 16/3/23.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPHomeCityIndexView.h"

@implementation RRPHomeCityIndexView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //布局界面
        [self layoutIndexView];
    }
    return self;

}
- (void)layoutIndexView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 23)];
    backView.dk_backgroundColorPicker = DKColorWithColors(IWColor(235, 235, 235), IWColor(200, 200, 200));
    [self addSubview:backView];
    
    self.indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (backView.frame.size.height-15)/2, RRPWidth-20, 15)];
    self.indexLabel.textAlignment = NSTextAlignmentLeft;
    self.indexLabel.font = [UIFont systemFontOfSize:13];
    self.indexLabel.textColor = IWColor(109, 109, 114);
    self.indexLabel.text = @"索引";
    [backView addSubview:self.indexLabel];
}
@end
