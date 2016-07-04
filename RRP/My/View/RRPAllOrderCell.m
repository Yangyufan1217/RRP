//
//  RRPAllOrderCell.m
//  RRP
//
//  Created by sks on 16/3/10.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPAllOrderCell.h"
#import "RRPPaymentController.h"
#import "RRPApplyForRefundController.h"
#import "RRPMyCommentController.h"
#import "RRPAllOrderModel.h"
@interface RRPAllOrderCell ()

@end

@implementation RRPAllOrderCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.backImageView.layer.cornerRadius = 5;
    self.backImageView.layer.masksToBounds = YES;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, RRPWidth-160, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = IWColor(73, 73, 73);
    self.titleLabel.text = @"北京清凉谷景区反对他要是不放假还是多大的工业和部分";
    self.titleLabel.numberOfLines = 0;
    //内容高度自适应
    CGSize size = CGSizeMake(RRPWidth-160, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [self.titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.titleLabel.frame;
    frame.size.height = rect.size.height;
    self.titleLabel.frame = frame;
    [self.backImageView addSubview:self.titleLabel];
    
    self.backImageView.image = [UIImage imageNamed:@"消息提醒背景"];
    self.scenicHeadImageView.image = [UIImage imageNamed:@"景点图标"];
    self.timeLabel.backgroundColor = self.timeContentLabel.backgroundColor = self.numberLabel.backgroundColor = self.numberContentLabel.backgroundColor = self.paymentButton.backgroundColor = self.moneyLabel.backgroundColor = [UIColor clearColor];
    self.moneyLabel.text = @"￥9999";
    self.moneyLabel.textColor =  IWColor(255, 137, 41);
    self.timeLabel.text = @"游玩日期:";
    self.timeLabel.textColor = self.timeContentLabel.textColor = self.numberLabel.textColor = self.numberContentLabel.textColor = IWColor(164, 164, 164);
    self.timeLabel.font = self.timeContentLabel.font = self.numberLabel.font = self.numberContentLabel.font = [UIFont systemFontOfSize:13];
    self.timeContentLabel.text = @"9999-99-99";
    self.numberLabel.text = @"门票数量:";
    self.numberContentLabel.text = @"9999张";
    
    self.newsTimeLabel.backgroundColor = [UIColor clearColor];
    self.newsTimeLabel.textColor = IWColor(112, 112, 112);
    self.newsTimeLabel.text = @"2016-06-24";
    self.newsTimeLabel.font = [UIFont systemFontOfSize:13];
    
}

//赋值
- (void)showDataWithModel:(RRPAllOrderModel *)model
{
    self.timeContentLabel.text = model.traveldate;
    self.numberContentLabel.text = [NSString stringWithFormat:@"%@张",model.quantity];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.origin];
    //下单日期 时间戳转标准时间
   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
   [formatter setDateStyle:NSDateFormatterMediumStyle];
   [formatter setDateFormat:@"YYYY-MM-dd"];
   NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.createdtime intValue]];
   NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    self.newsTimeLabel.text = confromTimespStr;
    
    self.titleLabel.text = model.ticketname;
    //内容高度自适应
    CGSize size = CGSizeMake(self.titleLabel.frame.size.width, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [model.ticketname boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.titleLabel.frame;
    frame.size.height = rect.size.height;
    self.titleLabel.frame = frame;
}
//cell高度
+ (CGFloat)cellHeight:(RRPAllOrderModel *)model
{
    //计算文字的高度
    CGSize size = CGSizeMake(RRPWidth-160, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [model.ticketname boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return  160 + rect.size.height;

}
- (void)paymentButton:(UIButton *)sender {
//        NSLog(@"删除");
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
