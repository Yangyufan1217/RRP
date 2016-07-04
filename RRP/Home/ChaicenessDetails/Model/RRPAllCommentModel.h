//
//  RRPAllCommentModel.h
//  RRP
//
//  Created by WangZhaZha on 16/4/13.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPAllCommentModel : NSObject
@property (nonatomic,strong)NSString *comment;//评论
@property (nonatomic,strong)NSString *createdtime;//创建时间
@property (nonatomic,strong)NSString *forward;
@property (nonatomic,strong)NSURL *head_img;//用户头像
@property (nonatomic,strong)NSString *likeit;//有用
@property (nonatomic,strong)NSString *likeit_id;
@property (nonatomic,strong)NSString *likeit_status;//评论状态
@property (nonatomic,strong)NSString *memberid;
@property (nonatomic,strong)NSString *mid;
@property (nonatomic,strong)NSString *orderid;
@property (nonatomic,strong)NSString *pc_id;//评论ID
@property (nonatomic,strong)NSString *sceneryid;//景点ID
@property (nonatomic,strong)NSString *score;//5.00评星
@property (nonatomic,strong)NSString *ticketid;
@property (nonatomic,strong)NSString *updatetime;
@property (nonatomic,strong)NSString *username;//用户昵称
@property (nonatomic,strong)NSString *comment_score;//评星
@property (nonatomic,assign)NSInteger comment_img_status;//评论图片是否存在
@property (nonatomic,strong)NSMutableDictionary *commentImageDic;//评论图片

@end
