//
//  RRPNonPaymentCell.m
//  RRP
//
//  Created by sks on 16/3/10.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPNonPaymentCell.h"
#import "RRPNotCommentController.h"
#import "RRPPaymentController.h"
#import "RRPApplyForRefundController.h"
#import "RRPMyCommentController.h"
#import "RRPNoPayModel.h"
#import "RRPNoTravelModel.h"
#import "RRPNoCommentModel.h"
@interface RRPNonPaymentCell ()

@end

@implementation RRPNonPaymentCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.number = 4;
    self.backImageView.layer.cornerRadius = 5;
    self.backImageView.layer.masksToBounds = YES;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, RRPWidth- 95, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = IWColor(73, 73, 73);
    self.titleLabel.text = @"北京清凉谷景区反对他要是不放假还是多大的工业和部分";
    self.titleLabel.numberOfLines = 0;
    //内容高度自适应
    CGSize size = CGSizeMake(self.titleLabel.frame.size.width, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [self.titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.titleLabel.frame;
    frame.size.height = rect.size.height;
    self.titleLabel.frame = frame;
    [self.backImageView addSubview:self.titleLabel];
    
    
    self.backImageView.image = [UIImage imageNamed:@"消息提醒背景"];
    self.scenicHeadImageView.image = [UIImage imageNamed:@"景点图标"];
    self.timeLabel.backgroundColor = self.timeContentLabel.backgroundColor = self.numberLabel.backgroundColor = self.numberContentLabel.backgroundColor = self.paymentButton.backgroundColor = self.cancelButton.backgroundColor = self.moneyLabel.backgroundColor = [UIColor clearColor];
    self.moneyLabel.font =  [UIFont systemFontOfSize:15];
    self.moneyLabel.textColor =  IWColor(255, 137, 41);
    self.moneyLabel.text = @"￥9999";
    
    self.timeLabel.text = @"游玩日期:";
    self.timeLabel.textColor = self.timeContentLabel.textColor = self.numberLabel.textColor = self.numberContentLabel.textColor = IWColor(164, 164, 164);
    self.timeLabel.font = self.timeContentLabel.font = self.numberLabel.font = self.numberContentLabel.font = [UIFont systemFontOfSize:13];
    self.timeContentLabel.text = @"9999-99-99";
    self.numberLabel.text = @"门票数量:";
    self.numberContentLabel.text = @"9999张";
    
    self.paymentButton.layer.cornerRadius = 2;
    self.paymentButton.layer.masksToBounds = YES;
    self.paymentButton.titleLabel.font = self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.paymentButton addTarget:self action:@selector(paymentButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.cancelButton.backgroundColor = [UIColor whiteColor];
    self.cancelButton.layer.cornerRadius = 2;
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = IWColor(221, 221, 221).CGColor;
    [self.cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.cancelButton setTitle:@"取消订单" forState:(UIControlStateNormal)];
    [self.cancelButton setTitleColor:IWColor(112, 112, 112) forState:(UIControlStateNormal)];
  
}
//赋值
- (void)showDataWithNoPayModel:(RRPNoPayModel *)model
{
    //判断显示按钮
    //可以删除：0   待付款：1   未出行：2  评价：3
    if ([model.type isEqualToString:@"0"]) {
        self.cancelButton.hidden = YES;
        [self.paymentButton setTitle:@"删除" forState:(UIControlStateNormal)];
        [self.paymentButton setTitleColor:IWColor(112, 112, 112) forState:(UIControlStateNormal)];
        self.paymentButton.layer.borderWidth = 1;
        self.paymentButton.layer.borderColor = IWColor(221, 221, 221).CGColor;
        self.paymentButton.tag = 1;
        
    }else if ([model.type isEqualToString:@"1"]) {
        self.cancelButton.hidden = YES;
        self.paymentButton.backgroundColor = IWColor(247, 102, 51);
        [self.paymentButton setTitle:@"立即支付" forState:(UIControlStateNormal)];
        [self.paymentButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.paymentButton.tag = 2;
    }else if ([model.type isEqualToString:@"2"]) {
        self.cancelButton.hidden = YES;
        [self.paymentButton setTitle:@"退票" forState:(UIControlStateNormal)];
        [self.paymentButton setTitleColor:IWColor(112, 112, 112) forState:(UIControlStateNormal)];
        self.paymentButton.layer.borderWidth = 1;
        self.paymentButton.layer.borderColor = IWColor(221, 221, 221).CGColor;
        self.paymentButton.tag = 3;
    }else if ([model.type isEqualToString:@"3"]) {
        
        self.cancelButton.hidden = YES;
        self.paymentButton.backgroundColor = IWColor(247, 102, 51);
        [self.paymentButton setTitle:@"评论" forState:(UIControlStateNormal)];
        [self.paymentButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.paymentButton.tag = 4;
    }

    
    self.timeContentLabel.text = model.traveldate;
    self.numberContentLabel.text = [NSString stringWithFormat:@"%@张",model.quantity];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.origin];
    
    self.titleLabel.text = model.ticketname;
    //内容高度自适应
    CGSize size = CGSizeMake(self.titleLabel.frame.size.width, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [model.ticketname boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.titleLabel.frame;
    frame.size.height = rect.size.height;
    self.titleLabel.frame = frame;


}
//未出行赋值
- (void)showDataWithNoTravelModel:(RRPNoTravelModel *)model
{
    self.timeContentLabel.text = model.traveldate;
    self.numberContentLabel.text = [NSString stringWithFormat:@"%@张",model.quantity];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.origin];
    
    self.titleLabel.text = model.ticketname;
    //内容高度自适应
    CGSize size = CGSizeMake(self.titleLabel.frame.size.width, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [model.ticketname boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.titleLabel.frame;
    frame.size.height = rect.size.height;
    self.titleLabel.frame = frame;


}
//待评价赋值
- (void)showDataWithNoCommentModel:(RRPNoCommentModel *)model
{
    self.timeContentLabel.text = model.traveldate;
    self.numberContentLabel.text = [NSString stringWithFormat:@"%@张",model.quantity];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.origin];
    
    self.titleLabel.text = model.ticketname;
    //内容高度自适应
    CGSize size = CGSizeMake(self.titleLabel.frame.size.width, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [model.ticketname boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.titleLabel.frame;
    frame.size.height = rect.size.height;
    self.titleLabel.frame = frame;


}

+ (CGFloat)cellHeight:(RRPNoPayModel *)model
{
    //计算文字的高度
    CGSize size = CGSizeMake(RRPWidth - 95, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [model.ticketname boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return  160 + rect.size.height;

}
- (void)paymentButton:(UIButton *)sender {
    if (sender.tag == 1) {
//        NSLog(@"删除");
    }else if (sender.tag == 2) {
        //发布通知 支付
        [[NSNotificationCenter defaultCenter] postNotificationName:@"支付" object:self userInfo:@{@"value":sender}];

    }else if (sender.tag == 3) {
        //退款
        //发布通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"退款" object:self userInfo:@{@"value":sender}];

    }else if (sender.tag == 4) {
        //发布通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"评论" object:self userInfo:@{@"value":sender}];

    }
}
- (void)cancelButton:(UIButton *) sender {
    // 初始化一个一个UIAlertController
    // 参数preferredStyle:是IAlertController的样式
    // UIAlertControllerStyleAlert 创建出来相当于UIAlertView
    // UIAlertControllerStyleActionSheet 创建出来相当于 UIActionSheet
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消订单？" preferredStyle:(UIAlertControllerStyleAlert)];
    
    // 创建按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
//        NSLog(@"确定");
    }];
    // 注意取消按钮只能添加一个
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        // 点击按钮后的方法直接在这里面写
//        NSLog(@"取消");
    }];
    
    //创建警告按钮
//    UIAlertAction *structlAction = [UIAlertAction actionWithTitle:@"警告" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction *action) {
//        NSLog(@"警告");
//    }];
    //添加按钮 将按钮添加到UIAlertController对象上
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
//    [alertController addAction:structlAction];
    //将UIAlertController模态出来 相当于UIAlertView show 的方法
    UINavigationController *viewController = [self findViewController:self];
    [viewController presentViewController:alertController animated:YES completion:nil];
    
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
