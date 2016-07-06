//
//  RRPSaleDetailController.h
//  RRP
//
//  Created by WangZhaZha on 16/3/9.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPSaleDetailController : UIViewController
/**
 *  只要跳转这个页面必须传以下参数
 */
@property (nonatomic,strong)NSString *sceneryID;//景点id
@property (nonatomic,strong)NSString *sceneryName;//景点名称
@property (nonatomic,strong)NSString *imageURL;//顶部图片
@property (nonatomic, strong) NSString *sceneryIntroduce;//景区介绍
@end
