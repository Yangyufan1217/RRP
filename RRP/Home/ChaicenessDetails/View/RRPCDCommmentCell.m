//
//  RRPCDCommmentCell.m
//  RRP
//
//  Created by sks on 16/2/25.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPCDCommmentCell.h"
#import "RRPImageDetailsController.h"
#import "RRPDetailsImageController.h"
#import "RRPAllCommentModel.h"
#import <SDWebImage/UIButton+WebCache.h>
@interface RRPCDCommmentCell () {
    BOOL usesClick;
    NSInteger count;
}

@end


@implementation RRPCDCommmentCell

- (void)awakeFromNib {

    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.imageURLArr = [@[] mutableCopy];
    //去掉所有控件的颜色
    self.nameLabel.backgroundColor = self.typeLabel.backgroundColor = self.timeLabel.backgroundColor = self.commentContentLabel.backgroundColor = self.contentImageView.backgroundColor = self.usesButton.backgroundColor = [UIColor clearColor];
    
    self.headImageView.image = [UIImage imageNamed:@"精选封面"];
    //切圆
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 34/2;
    
    self.nameLabel.text = @"非洲胚胎";
    self.nameLabel.adjustsFontSizeToFitWidth = YES;//改变字体大小填满label
    self.nameLabel.textColor = IWColor(91, 91, 91);
    self.typeLabel.text = @"好评";
    self.typeLabel.textColor = [UIColor redColor];
    self.typeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.text = @"2016-02-13";
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textColor = IWColor(170, 170, 170);
    
    self.usesButton.layer.borderWidth = 1;
    self.usesButton.layer.borderColor = IWColor(170, 170, 170).CGColor;
    self.usesButton.layer.masksToBounds = YES;
    self.usesButton.layer.cornerRadius = 5;
    [self.usesButton addTarget:self action:@selector(usesButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.usesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    //    imageView.backgroundColor = [UIColor redColor];
    self.usesImageView.image = [UIImage imageNamed:@"sign-list-noUse"];
    
    [self.usesButton addSubview:self.usesImageView];
    
    self.usesLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.usesImageView.frame), 5, 25, 20)];
    //    usesLabel.backgroundColor = [UIColor redColor];
    self.usesLabel.text = @"有用";
    self.usesLabel.textColor = IWColor(170, 170, 170);
    self.usesLabel.font = [UIFont systemFontOfSize:12];
    [self.usesButton addSubview:self.usesLabel];
    
    self.usesNumaberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.usesLabel.frame), 5, 20, 20)];
    //    usesNumaberLabel.backgroundColor = [UIColor redColor];
    self.usesNumaberLabel.textColor = IWColor(170, 170, 170);
    self.usesNumaberLabel.text = @"22";
    self.usesNumaberLabel.font = [UIFont systemFontOfSize:12];
    self.usesNumaberLabel.textAlignment = 1;
    [self.usesButton addSubview:self.usesNumaberLabel];
    
    self.commentString = @"盛开着永不凋零，蓝莲花啊。。心中那自由世界，如此的清澈高远，盛开着永不凋零，蓝莲花。。没有什么能够阻挡，我对自由的向往，天马行空的力量，我的心了无牵绊盛开着永不凋零，蓝莲花。。没有什么能够阻挡，我对自由的向往，天马行空的力量，我的心了无牵绊";
    self.commentContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.headImageView.frame) + 10, RRPWidth-20, 10)];
    self.commentContentLabel.text = self.commentString;
    self.commentContentLabel.textColor = IWColor(21, 21, 21);
    self.commentContentLabel.numberOfLines = 0;
    self.commentContentLabel.font = [UIFont systemFontOfSize:14];
    //内容高度自适应
    CGSize size = CGSizeMake(self.commentContentLabel.frame.size.width, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rect = [self.commentString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.commentContentLabel.frame;
    frame.size.height = rect.size.height;
    self.commentContentLabel.frame = frame;
    [self addSubview:self.commentContentLabel];
    
}
//有用按钮点击方法
- (void)usesButton:(UIButton *)sender {
    //判断是否登录了
    NSString *Register = [[NSUserDefaults standardUserDefaults]objectForKey:@"register"];
    if ([Register isEqualToString:@"YES"])  {
        //点赞
        if (usesClick == YES) {
            [[MyAlertView sharedInstance]showFrom:@"你已经点过了哦"];
        }else {
            self.usesImageView.image = [UIImage imageNamed:@"sign-list-use"];
            self.usesButton.layer.borderColor = IWColor(255, 88, 11).CGColor;
            self.usesLabel.textColor = IWColor(255, 88, 11);
            self.usesNumaberLabel.textColor = IWColor(255, 88, 11);
            self.usesNumaberLabel.text = [NSString stringWithFormat:@"%ld",[self.usesNumaberLabel.text integerValue]+1];
            [[MyAlertView sharedInstance]showFrom:@"你果然是个有态度的人"];
            [self requestClickGoodData];
            usesClick = YES;
        }
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"user" object:nil];
    }
}
- (void)requestClickGoodData
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"scenery_comment" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.model.pc_id forKey:@"pc_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [manager POST:MyClickComment parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取数据
        NSDictionary *dict = responseObject;
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            NSString *msg = dict[@"ResponseBody"][@"msg"];
            NSInteger code = [dict[@"ResponseBody"][@"code"] integerValue];
            if (code == 4001) {
                [[MyAlertView sharedInstance]showFrom:@"你已经点过了哦"];
            }else if (code == 2000)
            {
                self.usesImageView.image = [UIImage imageNamed:@"sign-list-use"];
                self.usesButton.layer.borderColor = IWColor(255, 88, 11).CGColor;
                self.usesLabel.textColor = IWColor(255, 88, 11);
                self.usesNumaberLabel.textColor = IWColor(255, 88, 11);
                self.usesNumaberLabel.text = [NSString stringWithFormat:@"%ld",    [self.usesNumaberLabel.text integerValue]+1];
                
                [[MyAlertView sharedInstance]showFrom:msg];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
 }

//赋值
- (void)shoeDataWithModel:(RRPAllCommentModel *)model
{
    self.model = model;
     //0:未点赞 1:已点赞
    if ([self.model.likeit_status isEqualToString:@"0"]) {
        usesClick = NO;
    }else {
        usesClick = YES;
    }
    if (usesClick == YES) {
        self.usesImageView.image = [UIImage imageNamed:@"sign-list-use"];
        self.usesButton.layer.borderColor = IWColor(255, 88, 11).CGColor;
        self.usesLabel.textColor = IWColor(255, 88, 11);
        self.usesNumaberLabel.textColor = IWColor(255, 88, 11);
    }else {
        self.usesImageView.image = [UIImage imageNamed:@"sign-list-noUse"];
        self.usesButton.layer.borderColor = IWColor(170, 170, 170).CGColor;
        self.usesLabel.textColor = IWColor(170, 170, 170);
        self.usesNumaberLabel.textColor = IWColor(170, 170, 170);
    }
  
    //用户头像
    [self.headImageView sd_setImageWithURL:model.head_img placeholderImage:[UIImage imageNamed:@"上传图片228-228"]];
    self.nameLabel.text = model.username;
    self.typeLabel.text = model.comment_score;
    self.timeLabel.text = model.createdtime;
    self.commentContentLabel.text = model.comment;
    self.usesNumaberLabel.text = model.likeit;
    //内容高度自适应
    CGSize size = CGSizeMake(self.commentContentLabel.frame.size.width, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rect = [model.comment boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.commentContentLabel.frame;
    frame.size.height = rect.size.height;
    self.commentContentLabel.frame = frame;
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSString *imageKey in model.commentImageDic) {
        [imageArray addObject:[model.commentImageDic valueForKey:imageKey]];
    }
    self.imageURLArr = imageArray;
    count = imageArray.count;

    for (int i = 0; i <= count; i++) {
        UIButton *contentImageButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        contentImageButton.frame = CGRectMake(((RRPWidth-50)/4+10)*i, 5, (RRPWidth-50)/4, (RRPWidth-50)/4);
        [contentImageButton addTarget:self action:@selector(contentImageButton:) forControlEvents:(UIControlEventTouchUpInside)];
        contentImageButton.tag  = 100 +i;
        [self.contentImageView addSubview:contentImageButton];
      if (i == 0 && i<count) {
            NSURL *imageURL = imageArray[i];
            [contentImageButton setBackgroundImageWithURL:imageURL forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"点评124-124"]];
        }else if (i == 1 && i<count) {
            NSURL *imageURL = imageArray[i];
            [contentImageButton setBackgroundImageWithURL:imageURL forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"点评124-124"]];
        }else if (i == 2 && i<count){
            NSURL *imageURL = imageArray[i];
            [contentImageButton setBackgroundImageWithURL:imageURL forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"点评124-124"]];
        }else if (i >=3) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (RRPWidth-50)/4, (RRPWidth-50)/4)];
            label.text = [NSString stringWithFormat:@"共%ld张",count];
            label.backgroundColor = IWColor(230, 230, 230);
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = 1;
            [contentImageButton addSubview:label];
        }
    }
    
}

+ (CGFloat)cellHeight:(RRPAllCommentModel *)model {
    //计算文字的高度
    CGSize size = CGSizeMake(RRPWidth - 20, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rect = [model.comment boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    //0没有图片 1有
    if (model.comment_img_status == 0) {
        return  215 - 85 + rect.size.height;
    }else {
        return  215 + rect.size.height;
    }
    
}
//展示的内容图片点击方法
- (void)contentImageButton:(UIButton *)sender {
    if (sender.tag == 100) {
        RRPImageDetailsController *imageDetails = [[RRPImageDetailsController alloc] init];
        imageDetails.imageURLArray = self.imageURLArr;
        imageDetails.index = 0;
        UINavigationController *viewController = [self findViewController:self];
        [viewController pushViewController:imageDetails animated:YES];
    }else if (sender.tag == 101) {
        RRPImageDetailsController *imageDetails = [[RRPImageDetailsController alloc] init];
        imageDetails.imageURLArray = self.imageURLArr;
        imageDetails.index = 1;
        UINavigationController *viewController = [self findViewController:self];
        [viewController pushViewController:imageDetails animated:YES];
    }else if (sender.tag == 102) {
        RRPImageDetailsController *imageDetails = [[RRPImageDetailsController alloc] init];
        imageDetails.imageURLArray = self.imageURLArr;
        imageDetails.index = 2;
        UINavigationController *viewController = [self findViewController:self];
        [viewController pushViewController:imageDetails animated:YES];
    }else if (sender.tag == 103) {
        RRPDetailsImageController *detailsImage = [RRPDetailsImageController alloc];
        detailsImage.imageURLArray = self.imageURLArr;
        UINavigationController *viewController = [self findViewController:self];
        [viewController pushViewController:detailsImage animated:YES];
    }
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
