//
//  MyAlertView.h
//  KMovie
//
//  Created by TuHaiSheng on 15/9/2.
//  Copyright (c) 2015年 PP－mac001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyAlertView;
@interface MyAlertView : UIView

/**
 *  显示
 */
- (void)showFrom:(NSString *)labelString;

- (void)showFrom:(NSString *)labelString andTextColor:(UIColor *)textColor andFrame:(CGRect)frame;

- (void)showTransform3DFrom:(NSString *)labelString;

/**
 *  销毁
 */
- (void)dismiss;

//@property(nonatomic, strong)UIColor* textColor;

/**
 @method
 @brief 获取MyAlertView单例对象
 */

+ (MyAlertView*)sharedInstance;
@end
