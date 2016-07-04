//
//  RRPMyOrderCell.m
//  RRP
//
//  Created by sks on 16/3/9.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMyOrderCell.h"
#import "RRPAllOrderController.h"
#import "RRPNonPaymentController.h"
#import "RRPNotTripController.h"
#import "RRPNotCommentController.h"


@implementation RRPMyOrderCell

- (void)awakeFromNib {
    
    self.allButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.allButton.frame = CGRectMake(0, 0, RRPWidth/4, 77.5);
    [self.allButton addTarget:self action:@selector(allButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.allButton];
    UIImageView *allImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.allButton.frame.size.width - 25)/2, 15, 25, 25)];
    allImageView.image = [UIImage imageNamed:@"全部订单"];
    [self.allButton addSubview:allImageView];
    UILabel *allLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.allButton.frame.size.width - 55)/2, CGRectGetMaxY(allImageView.frame)+10, 55, 13)];
    allLabel.text = @"全部订单";
    allLabel.textAlignment = 1;
    allLabel.textColor = IWColor(15, 15, 15);
    allLabel.font = [UIFont systemFontOfSize:13];
    UIView *allView = [[UIView alloc] initWithFrame:CGRectMake(RRPWidth/4, 17.5, 1, 45)];
    allView.backgroundColor = IWColor(228, 231, 232);
    [self.allButton addSubview:allView];
    [self.allButton addSubview:allLabel];
    
    self.nonPaymentButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.nonPaymentButton.frame = CGRectMake(CGRectGetMaxX(self.allButton.frame), 0, RRPWidth/4, 77.5);
    [self.nonPaymentButton addTarget:self action:@selector(nonPaymentButton:) forControlEvents:(UIControlEventTouchUpInside)];
    UIImageView *nonPaymentImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.nonPaymentButton.frame.size.width - 25)/2, 15, 25, 25)];
    nonPaymentImageView.image = [UIImage imageNamed:@"待付款"];
    [self.nonPaymentButton addSubview:nonPaymentImageView];
    UILabel *nonPaymentLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.nonPaymentButton.frame.size.width - 55)/2, CGRectGetMaxY(allImageView.frame)+10, 55, 13)];
    nonPaymentLabel.text = @"待付款";
    nonPaymentLabel.textAlignment = 1;
    nonPaymentLabel.textColor = IWColor(15, 15, 15);
    nonPaymentLabel.font = [UIFont systemFontOfSize:13];
    [self.nonPaymentButton addSubview:nonPaymentLabel];
    UIView *nonPaymentView = [[UIView alloc] initWithFrame:CGRectMake(RRPWidth/4, 17.5, 1, 45)];
    nonPaymentView.backgroundColor = IWColor(228, 231, 232);
    [self.nonPaymentButton addSubview:nonPaymentView];
    [self addSubview:self.nonPaymentButton];

    self.tripNotButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.tripNotButton.frame = CGRectMake(CGRectGetMaxX(self.nonPaymentButton.frame), 0, RRPWidth/4, 77.5);
    [self.tripNotButton addTarget:self action:@selector(tripNotButton:) forControlEvents:(UIControlEventTouchUpInside)];
    UIImageView *tripNotImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.nonPaymentButton.frame.size.width - 25)/2, 15, 25, 25)];
    tripNotImageView.image = [UIImage imageNamed:@"未出行"];
    [self.tripNotButton addSubview:tripNotImageView];
    UILabel *tripNotLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.tripNotButton.frame.size.width - 55)/2, CGRectGetMaxY(allImageView.frame)+10, 55, 13)];
    tripNotLabel.text = @"未出行";
    tripNotLabel.textAlignment = 1;
    tripNotLabel.textColor = IWColor(15, 15, 15);
    tripNotLabel.font = [UIFont systemFontOfSize:13];
    [self.tripNotButton addSubview:tripNotLabel];
    UIView *tripNotView = [[UIView alloc] initWithFrame:CGRectMake(RRPWidth/4, 17.5, 1, 45)];
    tripNotView.backgroundColor = IWColor(228, 231, 232);
    [self.tripNotButton addSubview:tripNotView];
    [self addSubview:self.tripNotButton];
    
    self.commentNotButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.commentNotButton.frame = CGRectMake(CGRectGetMaxX(self.tripNotButton.frame), 0, RRPWidth/4, 77.5);
    [self.commentNotButton addTarget:self action:@selector(commentNotButton:) forControlEvents:(UIControlEventTouchUpInside)];
    UIImageView *commentNotImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.nonPaymentButton.frame.size.width - 25)/2, 15, 25, 25)];
    commentNotImageView.image = [UIImage imageNamed:@"待评价"];
    [self.commentNotButton addSubview:commentNotImageView];
    UILabel *commentNotLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.tripNotButton.frame.size.width - 55)/2, CGRectGetMaxY(commentNotImageView.frame)+10, 55, 13)];
    commentNotLabel.text = @"待评价";
    commentNotLabel.textAlignment = 1;
    commentNotLabel.textColor = IWColor(15, 15, 15);
    commentNotLabel.font = [UIFont systemFontOfSize:13];
    [self.commentNotButton addSubview:commentNotLabel];
    UIView *commentNotView = [[UIView alloc] initWithFrame:CGRectMake(RRPWidth/4, 17.5, 1, 45)];
    commentNotView.backgroundColor = IWColor(228, 231, 232);
    [self.commentNotButton addSubview:commentNotView];
    
    //图片自适应控件大小，等比例缩放
    allImageView.clipsToBounds = nonPaymentImageView.clipsToBounds = tripNotImageView.clipsToBounds = commentNotImageView.clipsToBounds = YES;
    allImageView.contentMode = nonPaymentImageView.contentMode = tripNotImageView.contentMode = commentNotImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    
    [self addSubview:self.commentNotButton];
    
}

//全部订单
- (void) allButton:(UIButton *)sender {
    //发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"全部订单" object:self userInfo:@{@"value":sender}];
}

//未付款
- (void) nonPaymentButton:(UIButton *) sender {
    //发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"待付款" object:self userInfo:@{@"value":sender}];
}

//未出行
- (void) tripNotButton:(UIButton *)sender {
    //发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"未出行" object:self userInfo:@{@"value":sender}];
}

//评论
- (void) commentNotButton:(UIButton *)sender {
    //发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"待评价" object:self userInfo:@{@"value":sender}];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
