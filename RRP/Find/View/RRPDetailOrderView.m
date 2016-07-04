//
//  RRPDetailOrderView.m
//  RRP
//
//  Created by 王渣渣 on 16/3/13.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPDetailOrderView.h"
#import "RRPOrderController.h"
@interface RRPDetailOrderView ()
@property (nonatomic, strong) UIView *backView;//预定view

@end
@implementation RRPDetailOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //布局预定界面
        [self layoutOrderTicketView];

    }
    return self;
}
//布局预定界面
- (void)layoutOrderTicketView
{
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 49)];
    self.backView.backgroundColor =[UIColor whiteColor];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, RRPWidth / 3, 49)];
    moneyLabel.backgroundColor = [UIColor whiteColor];
    moneyLabel.text = @"在线支付:";
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.textAlignment = 2;
    moneyLabel.textColor = IWColor(73, 73, 73);
    [self.backView addSubview:moneyLabel];
    
    UILabel *moneyNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(RRPWidth / 3, 0, RRPWidth / 3, 49)];
    moneyNumberLabel.backgroundColor = [UIColor whiteColor];
    moneyNumberLabel.text = @"￥43";
    moneyNumberLabel.textAlignment = 0;
    moneyNumberLabel.font = [UIFont systemFontOfSize:15];
    moneyNumberLabel.textColor = IWColor(225, 65, 34);
    [self.backView addSubview:moneyNumberLabel];
    
    UIButton *moneyButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    moneyButton.frame = CGRectMake(RRPWidth / 3 *2, 0, RRPWidth / 3, 49);
    moneyButton.backgroundColor =IWColor(255, 104, 23);
    [moneyButton addTarget:self action:@selector(moneyButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [moneyButton setTitle:@"立即预定" forState:(UIControlStateNormal)];
    moneyButton.titleLabel.textAlignment = 1;
    moneyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [moneyButton setTitleColor:IWColor(255, 255, 255) forState:(UIControlStateNormal)];
    [self.backView addSubview:moneyButton];
    [self addSubview:self.backView];
    
}
- (void) moneyButton:(UIButton *) sender {
    RRPOrderController *order = [[RRPOrderController alloc] init];
    UINavigationController *viewController = [self findViewController:self];
    [viewController pushViewController:order animated:YES];
}

//通过View找viewController
- (UINavigationController *)findViewController:(UIView *)sourceView
{
    id target= sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UINavigationController class]]) {
            break;
        }
    }
    return target;
    
}

@end
