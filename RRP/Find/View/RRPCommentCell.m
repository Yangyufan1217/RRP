//
//  RRPCommentCell.m
//  RRP
//
//  Created by WangZhaZha on 16/3/10.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPCommentCell.h"
#import "RRPImageDetailsController.h"
#import "RRPDetailsImageController.h"
#import "RRPHomeSelectedCommentModel.h"
@interface RRPCommentCell (){
    
    BOOL usesClick;
    int count;
}


@end
@implementation RRPCommentCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    count = 6;
    //去掉控件的颜色
    self.picContentView.backgroundColor = self.usesButton.backgroundColor = [UIColor clearColor];
    //设置用户头像和评论照片
    [self setUserHeadPicAndCommentPic];
    //设置有用按钮
    [self setUseButton];
    self.backgroundView.layer.masksToBounds = YES;
    self.tabClassifyLabel.textColor = [UIColor redColor];
}

//设置控件详情
- (void)setUserHeadPicAndCommentPic
{
    //用户头像切圆
    self.userHeadPic.layer.masksToBounds = YES;
    self.userHeadPic.layer.cornerRadius = self.userHeadPic.frame.size.width/2;
    self.userHeadPic.image = [UIImage imageNamed:@"bottomPic"];
    //设置评论照片
    for (int i = 0; i <= count; i++) {
        UIButton *contentImageButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        contentImageButton.frame = CGRectMake((10+(RRPWidth-50)/4)*i+10, 5, (RRPWidth-50)/4, (RRPWidth-50)/4-5);
        //        contentImageButton.backgroundColor = [UIColor redColor];
        [contentImageButton addTarget:self action:@selector(contentImageButton:) forControlEvents:(UIControlEventTouchUpInside)];
        contentImageButton.tag  = 100 +i;
        [self.picContentView addSubview:contentImageButton];
        
        if (i == 0 && i<count) {
            [contentImageButton setBackgroundImage:[UIImage imageNamed:@"精选封面"] forState:(UIControlStateNormal)];
        }else if (i == 1 && i<count) {
            [contentImageButton setBackgroundImage:[UIImage imageNamed:@"精选内容图"] forState:(UIControlStateNormal)];
        }else if (i == 2 && i<count){
            [contentImageButton setBackgroundImage:[UIImage imageNamed:@"故宫"] forState:(UIControlStateNormal)];
        }else if (i >=3) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (RRPWidth-50)/4, (RRPWidth-50)/4-5)];
            label.text = [NSString stringWithFormat:@"共%d张",count];
            label.backgroundColor = IWColor(230, 230, 230);
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = 1;
            [contentImageButton addSubview:label];
        }
    }
}

//赋值
- (void)shoeDataWithModel:(RRPHomeSelectedCommentModel *)model
{
    
    NSString *commentNumber = [NSString stringWithFormat:@"共%@条%@满意",model.comment_count,model.percent_count];
    self.commentNumberLabel.text = commentNumber;
    //    self.typeLabel.text = @"好评";
    [self.userHeadPic sd_setImageWithURL:model.head_img placeholderImage:[UIImage imageNamed:@"上传图片228-228"]];
    self.userNameLabel.text = model.username;
    self.dateLabel.text = model.createdtime;
    self.commentDetailLabel.text = model.comment;
    self.usesNumaberLabel.text = model.likeit;
    
}
- (void)requestClickGoodData
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"scenery_comment" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[RRPAllCityHandle shareAllCityHandle].selectedCommentModel.pc_id forKey:@"pc_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [manager POST:MyClickComment parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取数据
        NSDictionary *dict = responseObject;
//        NSLog(@"点赞%@",dict);
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
        NSLog(@"%@",error);
        
    }];
    
    
}
//设置有用按钮
- (void)setUseButton
{
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

    RRPHomeSelectedCommentModel *selectedCommentModel= [RRPAllCityHandle shareAllCityHandle].selectedCommentModel;
    //0:未点赞 1:已点赞
    if ([selectedCommentModel.likeit_status isEqualToString:@"0"]) {
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

//展示的内容图片点击方法
- (void)contentImageButton:(UIButton *)sender {
    if (sender.tag == 100) {
        RRPImageDetailsController *imageDetails = [[RRPImageDetailsController alloc] init];
        UINavigationController *viewController = [self findViewController:self];
        [viewController pushViewController:imageDetails animated:YES];
    }else if (sender.tag == 101) {
        RRPImageDetailsController *imageDetails = [[RRPImageDetailsController alloc] init];
        UINavigationController *viewController = [self findViewController:self];
        [viewController pushViewController:imageDetails animated:YES];
    }else if (sender.tag == 102) {
        RRPImageDetailsController *imageDetails = [[RRPImageDetailsController alloc] init];
        UINavigationController *viewController = [self findViewController:self];
        [viewController pushViewController:imageDetails animated:YES];
    }else if (sender.tag == 103) {
        RRPDetailsImageController *detailsImage = [RRPDetailsImageController alloc];
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
