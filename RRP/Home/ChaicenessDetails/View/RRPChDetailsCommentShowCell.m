//
//  RRPChDetailsCommentShowCell.m
//  RRP
//
//  Created by sks on 16/2/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPChDetailsCommentShowCell.h"
#import "RRPImageDetailsController.h"
#import "RRPDetailsImageController.h"
#import "RRPHomeSelectedCommentModel.h"
#import <SDWebImage/UIButton+WebCache.h>
@interface RRPChDetailsCommentShowCell (){
    BOOL usesClick;
    NSInteger count;
}
@property (nonatomic, strong) NSMutableArray *imageURLArr;
@end


@implementation RRPChDetailsCommentShowCell

- (void)awakeFromNib {

    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.imageURLArr = [@[] mutableCopy];
    //去掉所有控件的颜色
    self.commentNumberLabel.backgroundColor = self.commentLabel.backgroundColor = self.nameLabel.backgroundColor = self.typeLabel.backgroundColor = self.timeLabel.backgroundColor = self.commentContentLabel.backgroundColor = self.contentImageView.backgroundColor = self.usesButton.backgroundColor = [UIColor clearColor];
    
    self.commentImageImageView.image = [UIImage imageNamed:@"sign-list-evaluate"];
    
    self.commentNumberLabel.text = @"共342条99%满意";
    self.commentNumberLabel.textColor = IWColor(170, 170, 170);
    self.commentNumberLabel.font = [UIFont systemFontOfSize:14];
    self.commentLabel.textColor = IWColor(170, 170, 170);
    self.commentLabel.text = @"点评";
    self.commentLabel.font = [UIFont systemFontOfSize:14];
    
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
    self.commentContentLabel.text = @"盛开着永不凋零，蓝莲花啊。。心中那自由世界，如此的清澈高远，盛开着永不凋零，蓝莲花。。没有什么能够阻挡，我对自由的向往，天马行空的力量，我的心了无牵绊盛开着永不凋零，蓝莲花。。没有什么能够阻挡，我对自由的向往，天马行空的力量，我的心了无牵绊";
    self.commentContentLabel.font = [UIFont systemFontOfSize:14];
    self.commentContentLabel.textColor = IWColor(20, 20, 20);
    
    
    self.usesButton.layer.borderWidth = 1;
    self.usesButton.layer.masksToBounds = YES;
    self.usesButton.layer.cornerRadius = 5;
    [self.usesButton addTarget:self action:@selector(usesButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.usesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
//    imageView.backgroundColor = [UIColor redColor];

    [self.usesButton addSubview:self.usesImageView];
    
    self.usesLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.usesImageView.frame), 5, 25, 20)];
//    usesLabel.backgroundColor = [UIColor redColor];
    self.usesLabel.text = @"有用";
    self.usesLabel.font = [UIFont systemFontOfSize:12];
    [self.usesButton addSubview:self.usesLabel];
    
    self.usesNumaberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.usesLabel.frame), 5, 20, 20)];
//    usesNumaberLabel.backgroundColor = [UIColor redColor];
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
//赋值
- (void)shoeDataWithModel:(RRPHomeSelectedCommentModel *)model CommentStatus:(NSInteger)commentStatus imageArr:(NSMutableArray *)imageArr
{
    [self.imageURLArr removeAllObjects];
    for (NSURL *imageUrl in imageArr) {
        NSString *imageStr = [imageUrl absoluteString];
        [self.imageURLArr addObject:imageStr];
    }
    count = imageArr.count;
    //有评论
    if (commentStatus == 1) {
        self.commentImageImageView.hidden = NO;
        self.commentLabel.hidden = NO;
        self.commentNumberLabel.hidden = NO;
        self.headImageView.hidden = NO;
        self.nameLabel.hidden = NO;
        self.timeLabel.hidden = NO;
        self.typeLabel.hidden = NO;
        self.commentContentLabel.hidden = NO;
        self.contentImageView.hidden = NO;
        self.usesButton.hidden = NO;
        self.usesImageView.hidden = NO;
        self.usesNumaberLabel.hidden = NO;
        self.usesLabel.hidden = NO;

        NSString *commentNumber = [NSString stringWithFormat:@"共%@条%@满意",model.comment_count,model.percent_count];
        self.commentNumberLabel.text = commentNumber;
        //    self.typeLabel.text = @"好评";
        [self.headImageView sd_setImageWithURL:model.head_img placeholderImage:[UIImage imageNamed:@"上传图片228-228"]];
        self.nameLabel.text = model.username;
        self.timeLabel.text = model.createdtime;
        self.commentContentLabel.text = model.comment;
        self.usesNumaberLabel.text = model.likeit;
        
        for (int i = 0; i <= count; i++) {
            UIButton *contentImageButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
            contentImageButton.frame = CGRectMake((10+(RRPWidth-50)/4)*i+10, 5, (RRPWidth-50)/4, (RRPWidth-50)/4-5);
            //        contentImageButton.backgroundColor = [UIColor redColor];
            [contentImageButton addTarget:self action:@selector(contentImageButton:) forControlEvents:(UIControlEventTouchUpInside)];
            contentImageButton.tag  = 100 +i;
            [self.contentImageView addSubview:contentImageButton];
            
            if (i == 0 && i<count) {
                NSURL *imageURL = imageArr[i];
                [contentImageButton setBackgroundImageWithURL:imageURL forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"点评124-124"]];
            }else if (i == 1 && i<count) {
                NSURL *imageURL = imageArr[i];
                [contentImageButton setBackgroundImageWithURL:imageURL forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"点评124-124"]];
            }else if (i == 2 && i<count){
                NSURL *imageURL = imageArr[i];
                [contentImageButton setBackgroundImageWithURL:imageURL forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"点评124-124"]];            }else if (i >=3) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (RRPWidth-50)/4, (RRPWidth-50)/4-5)];
                label.text = [NSString stringWithFormat:@"共%ld张",count];
                label.backgroundColor = IWColor(230, 230, 230);
                label.font = [UIFont systemFontOfSize:14];
                label.textAlignment = 1;
                [contentImageButton addSubview:label];
            }
        }

    }else
    {
        //无评论
        self.commentImageImageView.hidden = YES;
        self.commentLabel.hidden = YES;
        self.commentNumberLabel.hidden = YES;
        self.headImageView.hidden = YES;
        self.nameLabel.hidden = YES;
        self.timeLabel.hidden = YES;
        self.typeLabel.hidden = YES;
        self.commentContentLabel.hidden = YES;
        self.contentImageView.hidden = YES;
        self.usesButton.hidden = YES;
        self.usesImageView.hidden = YES;
        self.usesNumaberLabel.hidden = YES;
        self.usesLabel.hidden = YES;
    
    }
}

//cell高度
+ (CGFloat)cellHeight:(NSInteger)imagecount
{
    if (imagecount > 0) {
        return 310;
    }else
    {
        return 215;
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
