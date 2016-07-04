//
//  RRPCateListRightCell.m
//  RRP
//
//  Created by WangZhaZha on 16/3/18.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPCateListRightCell.h"
#import "FindRecreationModel.h"

@interface RRPCateListRightCell ()
@property (nonatomic,strong)NSString *string;
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSString *centerStr;

@end
@implementation RRPCateListRightCell

- (void)awakeFromNib {
    // Initialization code
    
    //设置蒙层
    [self layoutCoverView];
    //设置喷枪打字
    [self layoutPrintLabel];
    
}

- (void)showData:(FindRecreationModel *)model {
    self.titleStr = model.sceneryname;
    self.centerStr = [self getNameWithChineseName:model.sceneryname];
    self.string = model.summary;
    //图片异步加载
    [self.backView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"发现750-285"]];
    //开辟线程 喷枪打字
    NSThread *thred1 = [[NSThread alloc]initWithTarget:self selector:@selector(animationForShowtitleLableBigLabelText1) object:nil];
    [thred1 start];
    //开辟线程 喷枪打字
    NSThread *thred2 = [[NSThread alloc]initWithTarget:self selector:@selector(animationForShowtitleLableBigLabelText2) object:nil];
    [thred2 start];
    NSThread *thred3 = [[NSThread alloc]initWithTarget:self selector:@selector(animationForShowtitleLableBigLabelText3) object:nil];
    [thred3 start];
}
-(NSString *)getNameWithChineseName:(NSString *)name
{
    //转化为可变字符串
    NSMutableString *muName = [NSMutableString stringWithFormat:@"%@",name];
    //转化为带音调的拼音
    CFStringTransform((CFMutableStringRef)muName , NULL, kCFStringTransformMandarinLatin, NO);
    //转化为不带音调的拼音
    CFStringTransform((CFMutableStringRef)muName, NULL, kCFStringTransformStripDiacritics, NO);
    
    return muName;
    
}
//设置蒙层
- (void)layoutCoverView
{
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(RRPWidth/2, 0, RRPWidth/2,RRPWidth/750*370)];
    self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.backView addSubview:_coverView];
    
}
//设置喷枪打字
- (void)layoutPrintLabel
{
    //标题
    self.titleStr = @"北京新世纪日航饭店";
    self.RRPtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 50, self.coverView.frame.size.width - 50, 15)];
    self.RRPtitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    self.RRPtitleLabel.text = self.titleStr;
    //居中
    //    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.RRPtitleLabel.textColor = [UIColor whiteColor];
    self.RRPtitleLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.coverView addSubview:self.RRPtitleLabel];
    
    //英文
    self.centerStr = @"Hotel Nikko New Century Beijing";
    self.centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.RRPtitleLabel.frame)+4, self.coverView.frame.size.width - 50, 9)];
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    self.centerLabel.font = [UIFont systemFontOfSize:8];
    self.centerLabel.text = self.centerStr;
    self.centerLabel.adjustsFontSizeToFitWidth = YES;
    //    self.centerLabel.textAlignment= NSTextAlignmentCenter;
    self.centerLabel.textColor = [UIColor whiteColor];
    
    [self.coverView addSubview:_centerLabel];
    
    //简介
    //在这里label行间距，实现原理是通过字符串长度和label宽度来计算可以显示在多少行，然后设置行与行间的间距
    self.string = @"北京新世纪日航饭店毗邻西外大街,地理位置优越,是商旅客人理想的下榻之地";
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.centerLabel.frame)+10, self.coverView.frame.size.width - 50, 100)];
    self.detailLabel.textColor = [UIColor whiteColor];
    self.detailLabel.font = [UIFont systemFontOfSize:10];
    self.detailLabel.textAlignment = 0;
    self.detailLabel.text = self.string;
    //自动折行设置
    self.detailLabel.lineBreakMode = 0;
    self.detailLabel.numberOfLines = 0;//0 代表自动换行，1234...... 数字是几代表几行
    self.detailLabel.text = self.string;
    
    
    
    [self.coverView addSubview:self.detailLabel];
    
    
    
    
}
#pragma mark - 喷枪打字方法
//tileLabel
- (void)animationForShowtitleLableBigLabelText1
{
    //这是子线程里处理动画的方式 str1是我要处理的文本 , self.titleLableBig 是我用于显示这个文本的label  下面是执行动画的循环 一共执行 [_str1 length] 是字符串的长度 每执行一次,在主线程之中刷新ui 子线程休眠0.1秒中用于显示 每次文本的不同 就显示出 上一次笔者一次 少一个文本的效果了
    for (NSInteger i = 0 ; i < [self.titleStr length] ;i++)
    {
        [self performSelectorOnMainThread:@selector(refreUIFortitleLableBigLabelText1:) withObject:[self.titleStr substringWithRange:NSMakeRange(0,i+1)]waitUntilDone:YES];
        [NSThread sleepForTimeInterval:0.1f];
    }
    
    
}
- (void)refreUIFortitleLableBigLabelText1:(NSString *)str
{
    self.RRPtitleLabel.text = str;
    self.RRPtitleLabel.textAlignment = NSTextAlignmentCenter;
}
//centerLabel
- (void)animationForShowtitleLableBigLabelText2
{
    //这是子线程里处理动画的方式 str1是我要处理的文本 , self.titleLableBig 是我用于显示这个文本的label  下面是执行动画的循环 一共执行 [_str1 length] 是字符串的长度 每执行一次,在主线程之中刷新ui 子线程休眠0.1秒中用于显示 每次文本的不同 就显示出 上一次笔者一次 少一个文本的效果了
    for (NSInteger i = 0 ; i < [self.centerStr length] ;i++)
    {
        [self performSelectorOnMainThread:@selector(refreUIFortitleLableBigLabelText2:) withObject:[self.centerStr substringWithRange:NSMakeRange(0,i+1)]waitUntilDone:YES];
        [NSThread sleepForTimeInterval:0.05f];
    }
    
    
}
- (void)refreUIFortitleLableBigLabelText2:(NSString *)str
{
    self.centerLabel.text = str;
    self.centerLabel.textAlignment= NSTextAlignmentCenter;
}
//detaiLabel
- (void)animationForShowtitleLableBigLabelText3
{
    //这是子线程里处理动画的方式 str1是我要处理的文本 , self.titleLableBig 是我用于显示这个文本的label  下面是执行动画的循环 一共执行 [_str1 length] 是字符串的长度 每执行一次,在主线程之中刷新ui 子线程休眠0.1秒中用于显示 每次文本的不同 就显示出 上一次笔者一次 少一个文本的效果了
    for (NSInteger i = 0 ; i < [self.string length] ;i++)
    {
        [self performSelectorOnMainThread:@selector(refreUIFortitleLableBigLabelText3:) withObject:[self.string substringWithRange:NSMakeRange(0,i+1)]waitUntilDone:YES];
        [NSThread sleepForTimeInterval:0.1f];
    }
    
    
}
- (void)refreUIFortitleLableBigLabelText3:(NSString *)str
{
    self.detailLabel.text = str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
