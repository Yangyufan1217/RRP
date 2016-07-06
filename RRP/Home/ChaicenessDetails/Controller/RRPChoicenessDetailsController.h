//
//  RRPChoicenessDetailsController.h
//  RRP
//
//  Created by sks on 16/2/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPChoicenessDetailsController : UIViewController

/**
 *  只要跳转这个页面必须传以下参数
 */
@property (nonatomic,strong)NSString *sceneryID;//景点id
@property (nonatomic,strong)NSString *sceneryName;//景点名称
@property (nonatomic,strong)NSURL *imageURL;
@property (nonatomic, strong) NSString *sceneryIntroduce;//景区介绍

@end
