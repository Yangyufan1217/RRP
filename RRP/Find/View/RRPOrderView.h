//
//  RRPOrderView.h
//  RRP
//
//  Created by WangZhaZha on 16/3/11.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RRPOrderView : UIView
@property (nonatomic, strong) UITableView *moneyTableView;
@property (nonatomic, strong) UIView *backView;//预定view
@property (nonatomic, strong)UILabel *moneyNumberLabel;
@property (nonatomic, strong)RRPOrderModel *orderModel;

- (instancetype)initWithFrame:(CGRect)frame;



@end
