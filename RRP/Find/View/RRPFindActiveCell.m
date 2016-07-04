//
//  RRPFindActiveCell.m
//  RRP
//
//  Created by WangZhaZha on 16/3/25.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPFindActiveCell.h"
#import "RRPDailySelectViewController.h"
#import "RRPFindActivityController.h"
#import "RRPFindSeasonController.h"
#import "RRPFindTopModel.h"


@interface RRPFindActiveCell ()
//轻拍手势
@property (nonatomic,strong)UITapGestureRecognizer *leftTap;
@property (nonatomic,strong)UITapGestureRecognizer *rightTap;
@property (nonatomic,strong)UITapGestureRecognizer *centerTap;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
@implementation RRPFindActiveCell
- (void)awakeFromNib {
     self.contentView.backgroundColor = IWColor(241, 240, 246);
//    self.contentView.backgroundColor = [UIColor lightGrayColor];
    self.dataArray = [@[] mutableCopy];
    //布局左侧View
    [self layoutLeftView];
    //布局中间View
    [self layoutCenterView];
    //布局右侧View
    [self layoutRightView];
}
//布局左侧View
- (void)layoutLeftView
{
    //backView
    self.leftBackView = [[UIView alloc] initWithFrame:CGRectMake(0,0,(RRPWidth-10)/3, 165)];
    self.leftBackView.backgroundColor = [UIColor whiteColor];
    //创建轻拍手势
    self.leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTapAction:)];
    self.leftTap.numberOfTapsRequired = 1;
    self.leftTap.numberOfTouchesRequired = 1;
    //添加轻拍手势
    [self.leftBackView addGestureRecognizer:self.leftTap];

    [self addSubview:self.leftBackView];
    //图片
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 12, self.leftBackView.frame.size.width-50, self.leftBackView.frame.size.width-50)];
    self.leftImageView.image = [UIImage imageNamed:@"下一站旅行"];
    self.leftImageView.layer.masksToBounds = YES;
    self.leftImageView.layer.cornerRadius = self.leftImageView.frame.size.width/2;
    [self.leftBackView addSubview:self.leftImageView];
    //title
    self.leftTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(13, CGRectGetMaxY(self.leftImageView.frame)+12, self.leftBackView.frame.size.width-26, 16)];
    self.leftTitleLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    self.leftTitleLable.textColor = IWColor(234, 61, 58);
//    self.leftTitleLable.adjustsFontSizeToFitWidth = YES;
    self.leftTitleLable.textAlignment = NSTextAlignmentCenter;
    self.leftTitleLable.text = @"下一站旅行";
    [self.leftBackView addSubview:self.leftTitleLable];
    //detailLabel
    self.leftDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(self.leftTitleLable.frame)+ 8,self.leftBackView.frame.size.width-44, 22)];
    self.leftDetailLabel.font = [UIFont systemFontOfSize:10];
    self.leftDetailLabel.adjustsFontSizeToFitWidth = YES;
    self.leftDetailLabel.textAlignment = NSTextAlignmentLeft;
    self.leftDetailLabel.numberOfLines = 0;
    self.leftDetailLabel.textColor = IWColor(80, 80, 80);
    self.leftDetailLabel.text = @"那里风景独好,遇见更美自己";
    [self.leftBackView addSubview:self.leftDetailLabel];
}
//布局中间View
- (void)layoutCenterView
{
    //backView
    self.centerBackView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftBackView.frame)+5,0,(RRPWidth-10)/3, 165)];
    self.centerBackView.backgroundColor = [UIColor whiteColor];
    //创建轻拍手势
    self.centerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerTapAction:)];
    self.centerTap.numberOfTapsRequired = 1;
    self.centerTap.numberOfTouchesRequired = 1;
    //添加轻拍手势
    [self.centerBackView addGestureRecognizer:self.centerTap];

    [self addSubview:self.centerBackView];
    //图片
    self.centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 12, self.centerBackView.frame.size.width-50, self.centerBackView.frame.size.width-50)];
    self.centerImageView.image = [UIImage imageNamed:@"当季热玩"];
    self.centerImageView.layer.masksToBounds = YES;
    self.centerImageView.layer.cornerRadius = self.centerImageView.frame.size.width/2;
    [self.centerBackView addSubview:self.centerImageView];
    //title
    self.centerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, CGRectGetMaxY(self.centerImageView.frame)+12, self.centerBackView.frame.size.width-26, 16)];
    self.centerTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    self.centerTitleLabel.textColor = IWColor(115   , 170, 88);
//    self.centerTitleLabel.adjustsFontSizeToFitWidth = YES;
    self.centerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.centerTitleLabel.text = @"当季热玩";
    [self.centerBackView addSubview:self.centerTitleLabel];
    //detailLabel
    self.centerDeatilLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(self.centerTitleLabel.frame)+ 8,self.centerBackView.frame.size.width-44, 22)];
    self.centerDeatilLabel.font = [UIFont systemFontOfSize:10];
    self.centerDeatilLabel.textAlignment = NSTextAlignmentLeft;
    self.centerDeatilLabel.adjustsFontSizeToFitWidth = YES;
    self.centerDeatilLabel.numberOfLines = 0;
    self.centerDeatilLabel.textColor = IWColor(80, 80, 80);
    self.centerDeatilLabel.text = @"这个季节优点热,相约一起各种趴";
    [self.centerBackView addSubview:self.centerDeatilLabel];




}
//布局右侧View
- (void)layoutRightView
{
    //backView
    self.rightBackView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.centerBackView.frame)+5,0,(RRPWidth-10)/3, 165)];
    self.rightBackView.backgroundColor = [UIColor whiteColor];
    //创建轻拍手势
    self.rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTapAction:)];
    self.rightTap.numberOfTapsRequired = 1;
    self.rightTap.numberOfTouchesRequired = 1;
    //添加轻拍手势
    [self.rightBackView addGestureRecognizer:self.rightTap];

    [self addSubview:self.rightBackView];
    //图片
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 12, self.rightBackView.frame.size.width-50, self.rightBackView.frame.size.width-50)];
    self.rightImageView.image = [UIImage imageNamed:@"每日精选"];
    self.rightImageView.layer.masksToBounds = YES;
    self.rightImageView.layer.cornerRadius = self.rightImageView.frame.size.width/2;
    [self.rightBackView addSubview:self.rightImageView];
    //title
    self.rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, CGRectGetMaxY(self.rightImageView.frame)+12, self.rightBackView.frame.size.width-26, 16)];
    self.rightTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    self.rightTitleLabel.textColor = IWColor(201, 69, 83);
//    self.rightTitleLabel.adjustsFontSizeToFitWidth = YES;
    self.rightTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.rightTitleLabel.text = @"每日精选";
    [self.rightBackView addSubview:self.rightTitleLabel];
    //detailLabel
    self.rightDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(self.rightTitleLabel.frame)+ 8,self.rightBackView.frame.size.width-44, 22)];
    self.rightDetailLabel.font = [UIFont systemFontOfSize:10];
    self.rightDetailLabel.textAlignment = NSTextAlignmentLeft;
    self.rightDetailLabel.numberOfLines = 0;
    self.rightDetailLabel.textColor = IWColor(80, 80, 80);
    self.rightDetailLabel.adjustsFontSizeToFitWidth = YES;
    self.rightDetailLabel.text = @"一座城市,一种态度,一种人生";
    [self.rightBackView addSubview:self.rightDetailLabel];
}
#pragma mark - 轻拍事件
- (void)leftTapAction:(UITapGestureRecognizer *)tap
{
    //下一站
    RRPFindActivityController *activity = [[RRPFindActivityController alloc] init];
    UINavigationController *viewController = [self findViewController:self];
    //统计:下一站点击
    [MobClick event:@"45"];
    [viewController pushViewController:activity animated:YES];
}
- (void)centerTapAction:(UITapGestureRecognizer *)tap
{
    self.dataArray = [RRPFindTopModel shareRRPFindTopModel].dataArray;
    //当季热玩  
    RRPFindSeasonController *season = [[RRPFindSeasonController alloc] init];
    season.classcode = self.dataArray[0][@"classcode"];
    season.city_code = @"110100";
    //统计:当季热玩点击
    [MobClick event:@"47"];
    UINavigationController *viewController = [self findViewController:self];
    [viewController pushViewController:season animated:YES];
    
}

//跳转到每日精选界面
- (void)rightTapAction:(UITapGestureRecognizer *)tap
{
    self.dataArray = [RRPFindTopModel shareRRPFindTopModel].dataArray;
    RRPDailySelectViewController *dailySelectionVC = [[RRPDailySelectViewController alloc] init];
    dailySelectionVC.classcode = self.dataArray[0][@"classcode"];
    dailySelectionVC.city_code = @"110100";
    //统计:每日精选点击
    [MobClick event:@"49"];
    UINavigationController *viewController = [self findViewController:self];
    [viewController pushViewController:dailySelectionVC animated:YES];
}


//通过View找viewController
- (UINavigationController *)findViewController:(UIView *)sourceView
{
    id target= sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UINavigationController class]]) {
            break;
        }
    }
    return target;
    
}

@end
