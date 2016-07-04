//
//  RRPMyCommentController.h
//  RRP
//
//  Created by sks on 16/3/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRPMyCommentController : UIViewController

@property(nonatomic, assign)BOOL punch;
@property(nonatomic, strong)UIImage *contentImage;
@property (nonatomic,strong)NSURL *imageUrl;
@property (nonatomic,strong)NSString *sceneryName;//景区名
@property (nonatomic,strong)NSString *ticketPrice;//票价
@property (nonatomic, strong)NSString *ticketID;//订单ID


@end
