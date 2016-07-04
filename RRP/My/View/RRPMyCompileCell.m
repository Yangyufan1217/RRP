//
//  RRPMyCompileCell.m
//  RRP
//
//  Created by sks on 16/3/17.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMyCompileCell.h"

@interface RRPMyCompileCell ()<UITextFieldDelegate>

@end

@implementation RRPMyCompileCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150,150, 150));
    self.titleNameLabel.backgroundColor = [UIColor clearColor];
    self.titleNameLabel.textColor = IWColor(73, 73, 73);
    self.titleNameLabel.font = [UIFont systemFontOfSize:16];
    //注册通知 接收消息 实现方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeUserInteractionEnabled) name:@"关闭textView的用户交互" object:nil];
    
}

- (void) closeUserInteractionEnabled {
    [self.contentTextField resignFirstResponder];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
