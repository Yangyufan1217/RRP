//
//  RRPPaymentController.h
//  RRP
//
//  Created by sks on 16/3/6.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPPaymentController : UIViewController

@property (nonatomic, assign) CGFloat money;//价格
@property (nonatomic, strong) NSString *name;//票名
@property (nonatomic, strong) NSString *time;//时间
@property (nonatomic, assign) NSInteger ticketNumber;//票的数量
@property (nonatomic, strong) NSString *orderno;//订单
@property (nonatomic, strong) NSMutableDictionary *dataDic;//需要传给江虹

@end
