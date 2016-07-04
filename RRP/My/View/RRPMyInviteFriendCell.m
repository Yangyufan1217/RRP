//
//  RRPMyInviteFriendCell.m
//  RRP
//
//  Created by sks on 16/3/21.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMyInviteFriendCell.h"
#import "MHContactModel.h"
@implementation RRPMyInviteFriendCell

- (void)awakeFromNib {
//    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.headNameLabel.backgroundColor = self.nameLabel.backgroundColor = self.inviteButton.backgroundColor = [UIColor clearColor];
    self.headNameLabel.font = self.nameLabel.font = [UIFont systemFontOfSize:10];
    self.headNameLabel.text = @"请";
    self.headNameLabel.textColor = IWColor(140, 140, 140);
    self.headNameLabel.layer.cornerRadius = 15;
    self.headNameLabel.layer.masksToBounds = YES;
    self.headNameLabel.layer.borderColor = IWColor(140, 140, 140).CGColor;
    self.headNameLabel.layer.borderWidth = 1;
    
    self.nameLabel.textColor = IWColor(40, 40, 40);
    self.nameLabel.text = @"请叫我杨超而不是黑人";
    
    
    self.inviteButton.layer.cornerRadius = 10;
    self.inviteButton.layer.masksToBounds = YES;
    [self.inviteButton setTitle:@"邀请" forState:(UIControlStateNormal)];
    [self.inviteButton setTitleColor:IWColor(140, 140, 140) forState:(UIControlStateNormal)];
    self.inviteButton.layer.borderColor = IWColor(140, 140, 140).CGColor;
    self.inviteButton.layer.borderWidth = 1;
//    [self.inviteButton addTarget:self action:@selector(inviteButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.inviteButton.userInteractionEnabled = NO;
    
}

//控件赋值
- (void)showDate:(MHContactModel *)model
{
    
    NSString *headStr = [model.name substringWithRange:NSMakeRange(0, 1)];
    self.headNameLabel.text = headStr;
    self.nameLabel.text = model.name;

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
