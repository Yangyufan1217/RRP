//
//  RRPAllCityHandle.h
//  RRP
//
//  Created by WangZhaZha on 16/3/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRPOrderModel.h"
#import "RRPAllCityModel.h"
#import "RRPHomeSelectedCommentModel.h"
#import "RRPAllCommentModel.h"
@interface RRPAllCityHandle : NSObject
@property (nonatomic,strong)NSMutableArray *allCityCode;
@property (nonatomic,strong)NSMutableDictionary *allCityDic;
@property (nonatomic,assign)NSInteger hotCityNumber;
@property (nonatomic,strong)RRPOrderModel *orderModel;
@property (nonatomic, strong)NSMutableArray *dateArray;
@property (nonatomic,assign)NSInteger starCount;
@property (nonatomic,strong)NSMutableArray *contactShowArray;
@property (nonatomic,strong)NSString *topPrice;
@property (nonatomic,strong)RRPAllCityModel *passCityModel;
@property (nonatomic,assign)NSInteger likeitStatus;//点赞状态 1:已点赞 0:未点赞
@property (nonatomic,strong)NSString *commentResult;//评论结果
@property (nonatomic,strong)NSString *ticketid;//票ID
@property (nonatomic,strong)NSString *sceneryID;//景区ID
@property (nonatomic, strong) RRPHomeSelectedCommentModel *selectedCommentModel;//精选评论model

//单例
+ (RRPAllCityHandle *)shareAllCityHandle;
//类方法
+ (NSData *)image_TransForm_Data:(UIImage *)image;



@end
