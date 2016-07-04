//
//  RRPHomeLocationView.m
//  RRP
//
//  Created by WangZhaZha on 16/3/23.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPHomeLocationView.h"
#import "RRPAllCityHandle.h"
#import "RRPAllCityModel.h"
@implementation RRPHomeLocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

      //布局界面
        [self layoutLocationView];
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getValue:) name:@"AllCityName" object:nil];
    }
    return self;
}
//获取值
-(void)getValue:(NSNotification *)notification
{
    
    RRPAllCityModel *value = [notification valueForKey:@"userInfo"][@"value"];
    self.locationCityLabel.text = value.city_name;
    [RRPAllCityHandle shareAllCityHandle].passCityModel = value;
}
- (void)layoutLocationView
{
    //定位城市
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 23)];
    topView.dk_backgroundColorPicker = DKColorWithColors(IWColor(235, 235, 235), IWColor(200, 200, 200));
    [self addSubview:topView];
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (topView.frame.size.height-15)/2, RRPWidth-20, 15)];
    topLabel.textAlignment = NSTextAlignmentLeft;
    topLabel.font = [UIFont systemFontOfSize:13];
    topLabel.textColor = IWColor(109, 109, 114);
    topLabel.text = @"定位城市";
    [topView addSubview:topLabel];
    //城市View
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 23, RRPWidth, 46)];
    backView.dk_backgroundColorPicker = DKColorWithColors(IWColor(244, 244, 244), IWColor(150, 150, 150));
    [self addSubview:backView];
    
    self.locationCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8,RRPWidth-20, backView.frame.size.height-16)];
    self.locationCityLabel.text = @"北京";
    self.locationCityLabel.textColor = [UIColor blueColor];
    self.locationCityLabel.font = [UIFont systemFontOfSize:14];
    self.locationCityLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:self.locationCityLabel];

}
@end
