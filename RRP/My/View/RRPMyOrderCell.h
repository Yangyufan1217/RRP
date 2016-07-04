//
//  RRPMyOrderCell.h
//  RRP
//
//  Created by sks on 16/3/9.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPMyOrderCell : UITableViewCell
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIButton *nonPaymentButton;//未付款
@property (nonatomic, strong) UIButton *tripNotButton;//未出行
@property (nonatomic, strong) UIButton *commentNotButton;//未评论


@end
