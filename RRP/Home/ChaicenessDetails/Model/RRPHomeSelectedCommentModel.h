//
//  RRPHomeSelectedCommentModel.h
//  RRP
//
//  Created by WangZhaZha on 16/4/13.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRPHomeSelectedCommentModel : NSObject
@property (nonatomic,strong)NSString *comment;//评论
@property (nonatomic,strong)NSString *comment_count;//评论条数
@property (nonatomic,strong)NSString *createdtime;//创建时间
@property (nonatomic,strong)NSString *forward;
@property (nonatomic,strong)NSURL *head_img;//用户头像
@property (nonatomic,strong)NSString *ID;
@property (nonatomic,strong)NSString *likeit;//有用
@property (nonatomic,strong)NSString *likeit_id;
@property (nonatomic,strong)NSString *likeit_status;//点赞状态 0:未点赞 1:已点赞
@property (nonatomic,strong)NSString *memberid;
@property (nonatomic,strong)NSString *orderid;
@property (nonatomic,strong)NSString *pc_id;//评论ID
@property (nonatomic,strong)NSString *percent_count;//百分数 0%
@property (nonatomic,strong)NSString *sceneryid;//景点ID
@property (nonatomic,strong)NSString *score;//5.00评星
@property (nonatomic,strong)NSString *ticketid;
@property (nonatomic,strong)NSString *updatetime;//更新时间
@property (nonatomic,strong)NSString *username;//用户昵称


@end
