//
//  MyAlertView.m
//  KMovie
//
//  Created by TuHaiSheng on 15/9/2.
//  Copyright (c) 2015年 PP－mac001. All rights reserved.
//

#import "MyAlertView.h"


@interface MyAlertView()

/**
 * 将来用来显示具体内容的容器
 */
@property(nonatomic, weak)UIView * containerView;
@property(nonatomic, weak)UILabel * containLaber;
@property(nonatomic, strong)NSTimer * timer;
@end

@implementation MyAlertView


- (UIView *)containerView
{
    if (_containerView == nil)
    {
        //添加
        UIView * containView = [[UIView alloc]init];
        containView.layer.masksToBounds = YES;
        [containView.layer setCornerRadius:5.0];
        //加阴影
        containView.layer.masksToBounds = YES;
        [containView.layer setBorderWidth:1];
        containView.layer.cornerRadius = 5;
        [self addSubview:containView];
        self.containerView = containView;
    }
    return _containerView;
}



- (UILabel *)containLaber
{
    if (_containLaber == nil)
    {
        UILabel * label = [[UILabel alloc]init];
        CGFloat h = 50;
        CGFloat y = (self.containerView.frame.size.height - h)*0.5;
        label.frame = CGRectMake(0, y, self.containerView.frame.size.width, h);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
       
        label.font = [UIFont boldSystemFontOfSize:14];
        [self.containerView addSubview:label];
        self.containLaber = label;
    }
    return _containLaber;
}

- (NSTimer *)timer
{
    if (_timer == nil)
    {
        _timer = [[NSTimer alloc]init];
    }
    return _timer;
}


- (void)showFrom:(NSString *)labelString andTextColor:(UIColor *)textColor andFrame:(CGRect)frame
{
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    // 2.添加自己到窗口上
    [window addSubview:self];
    self.containerView.frame = frame;
    self.containerView.backgroundColor = [UIColor blackColor];
    self.containerView.alpha = 0.7;
    
    self.containLaber.textColor = textColor;
    self.containLaber.text = labelString;
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(alertShow:) userInfo:nil repeats:NO];
}

- (void)showFrom:(NSString *)labelString
{
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    // 2.添加自己到窗口上
    [window addSubview:self];
    
    
    CGFloat x = (RRPWidth - 200)*0.5;
    CGFloat y = (RRPHeight - 60) * 0.5;
    self.containerView.frame = CGRectMake(x, y, 200, 60);

    self.containerView.backgroundColor = IWColor(255, 255, 255);
     self.containLaber.textColor = IWColor(115, 115, 115);
    self.containLaber.text = labelString;
    [self.containerView.layer setBorderColor:[IWColor(225, 225, 225) CGColor]];
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(alertShow:) userInfo:nil repeats:NO];
    
}

- (void)alertShow:(NSTimer *)time
{
    
    [self.timer invalidate];
    [self dismiss];
}

- (void)dismiss
{
    [self removeFromSuperview];
    
}

+ (MyAlertView *)sharedInstance
{
    static MyAlertView *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}


- (void)showTransform3DFrom:(NSString *)labelString
{
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    // 2.添加自己到窗口上
    [window addSubview:self];
    
    
    CGFloat x = (RRPWidth - 200)*0.5;
    CGFloat y = (RRPHeight - 60) * 0.5;
    self.containerView.frame = CGRectMake(x, y, 200, 60);
    self.containerView.backgroundColor = IWColor(255, 255, 255);
    self.containLaber.textColor = IWColor(115, 115, 115);
    self.containLaber.text = labelString;
//    self.containLaber.font = [UIFont systemFontOfSize:1];
    self.containerView.layer.transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1);
    self.containLaber.layer.transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1);

    self.timer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(alertShow:) userInfo:nil repeats:NO];
}
@end
