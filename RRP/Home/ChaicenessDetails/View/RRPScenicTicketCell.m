//
//  RRPScenicTicketCell.m
//  RRP
//
//  Created by WangZhaZha on 16/4/8.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPScenicTicketCell.h"
#import "RRPSelectedTicketModel.h"
@implementation RRPScenicTicketCell

- (void)awakeFromNib {
    // Initialization code
    self.dk_backgroundColorPicker = DKColorWithColors(IWColor(246, 246, 246), IWColor(200, 200, 200));
    self.backFrameView.userInteractionEnabled = YES;
    //布局
    [self layoutTicketView];
    
    //预定跳转
    NSInteger status = [RRPFindTopModel shareRRPFindTopModel].status;
    if (status == 2) {
        self.orderImageView.hidden = YES;
    }else if (status == 1) {
        self.orderImageView.hidden = NO;
    }
    
    

}
- (void)layoutTicketView
{
    self.ticketName = @"北京密云黑龙潭景区+成人票";
    //票名
    self.ticketNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, RRPWidth-40, 17)];
    self.ticketNameLabel.font = [UIFont systemFontOfSize:15];
    self.ticketNameLabel.textColor = IWColor(69, 69, 69);
    self.ticketNameLabel.numberOfLines = 0;
    self.ticketNameLabel.textAlignment = NSTextAlignmentLeft;
    self.ticketNameLabel.text = self.ticketName;
    [self.backFrameView addSubview:self.ticketNameLabel];

    //设置颜色
    self.noticeLabel.textColor = IWColor(164, 164, 164);
    self.currentPriceLogo.textColor = IWColor(252, 79, 31);
    self.currentPriceLabel.textColor = IWColor(252, 79, 31);
    self.originalPriceLabel.textColor = IWColor(152, 152, 152);
    
    self.noticeLabel.font = [UIFont systemFontOfSize:10];
    self.logoImageView.image = [UIImage imageNamed:@"人人票"];
    self.lineImageView.image = [UIImage imageNamed:@"通用虚线"];
    //原价横线
    
    self.currentPriceLabel.adjustsFontSizeToFitWidth = YES;
    self.originalPriceLabel.adjustsFontSizeToFitWidth = YES;
    
    
    

}
//订购
- (IBAction)orderAction:(id)sender {

    //判断是否登录了
    NSString *Register = [[NSUserDefaults standardUserDefaults]objectForKey:@"register"];
    if ([Register isEqualToString:@"YES"])  {
        //发布通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"弹出订购页面" object:self userInfo:@{@"value":sender}];
    }else {
        //发布通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"登录" object:self userInfo:@{@"value":sender}];
    }
}

//赋值
- (void)showDataWithModel:(RRPSelectedTicketModel *)model
{
    
    self.noticeLabel.text = model.advance_time;
    self.currentPriceLabel.text = model.sellerprice;
    NSString *originalPriceStr = [NSString stringWithFormat:@"￥%@",model.marketprice];
    self.originalPriceLabel.text = originalPriceStr;
    //原价横线
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(1.5, self.originalPriceLabel.frame.size.height/2, [originalPriceStr length]*7.5, 1)];
    label.backgroundColor = IWColor(152, 152, 152);
    [self.originalPriceLabel addSubview:label];
    self.ticketNameLabel.text = model.ticketname;
    //内容高度自适应
    CGSize size = CGSizeMake(self.ticketNameLabel.frame.size.width, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [model.ticketname boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.ticketNameLabel.frame;
    frame.size.height = rect.size.height;
    self.ticketNameLabel.frame = frame;
    
}

//自适应高度
+(CGFloat)cellHeight:(RRPSelectedTicketModel *)model{
    //计算文字的高度
    CGSize size = CGSizeMake(RRPWidth-40, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [model.ticketname boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return  105 + rect.size.height;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
