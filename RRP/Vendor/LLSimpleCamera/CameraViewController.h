//
//  CameraViewController.h
//  HXyoga
//
//  Created by YangJiLei on 16/1/7.
//  Copyright © 2016年 WakeYoga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSimpleCamera.h"

@class RRPMyCommentController;


@protocol CameraViewDelegate <NSObject>
//给评论页面传值协议
- (void)RRPMyCommentPassByValue:(RRPMyCommentController *)control andImage:(UIImage *)image;

@end


@interface CameraViewController : UIViewController<LLSimpleCameraDelegate>

@property (nonatomic, assign)id<CameraViewDelegate> delegate;


@end
