//
//  RRPAddCTPersonClickCell.m
//  RRP
//
//  Created by sks on 16/3/4.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPAddCTPersonClickCell.h"
#import "RRPAddContactPersonController.h"

@implementation RRPAddCTPersonClickCell

- (void)awakeFromNib {
    self.addImageView.image = [UIImage imageNamed:@"添加取票人"];
    self.moreButton.backgroundColor = [UIColor clearColor];
    [self.moreButton addTarget:self action:@selector(moreButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.moreImageView.image = [UIImage imageNamed:@"home-middleList-more"];
    self.addNameLabel.backgroundColor =[UIColor clearColor];
    self.addNameLabel.text = @"添加取票人";
    self.addNameLabel.textColor = IWColor(68, 218, 255);
    self.addNameLabel.font = [UIFont systemFontOfSize:16];
    self.addNameLabel.textAlignment = 0;
}

- (void) moreButton:(UIButton *)sender {
    RRPAddContactPersonController *addContactPerson = [[RRPAddContactPersonController alloc] init];
    UINavigationController *viewController = [self findViewController:self];
    //统计:添加取票人点击
    [MobClick event:@"27"];
    [viewController pushViewController:addContactPerson animated:YES];
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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
