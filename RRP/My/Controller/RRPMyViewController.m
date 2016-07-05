//
//  RRPMyViewController.m
//  RRP
//
//  Created by sks on 16/2/16.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMyViewController.h"
#import "RRPMyOrderCell.h"
#import "RRPMyCell.h"
#import "RRPMySwitchCell.h"
#import "RRPAllOrderController.h"
#import "RRPMyCollectListController.h"
#import "RRPMyCompileController.h"
#import "RRPCommonLinkmanController.h"
#import "AFHTTPRequestOperation.h"
#import "RRPInviteFriendController.h"
#import "RRPMyAboutController.h"
#import "RRPMessageViewController.h"
#import "RRPDataRequestModel.h"
#import "RRPNonPaymentController.h"
#import "RRPNotTripController.h"
#import "RRPNotCommentController.h"
@interface RRPMyViewController ()<UITableViewDataSource, UITableViewDelegate,BoPhotoPickerProtocol,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CameraViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) NSString *eliminateString;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong)UIImageView *headImageView;
@property (assign, nonatomic) BOOL isBackImage;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, assign) NSUInteger size;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *signatureLabel;

@end

@implementation RRPMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    self.view.dk_backgroundColorPicker = DKColorWithColors(IWColor(242, 245, 247), IWColor(200, 200, 200));
    //登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"login" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllOrderValue:) name:@"全部订单" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNoPaymentValue:) name:@"待付款" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNoTravelValue:) name:@"未出行" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNoCommentValue:) name:@"待评价" object:nil];
    //取消滚动视图的自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPMyOrderCell" bundle:nil] forCellReuseIdentifier:@"RRPMyOrderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPMyCell" bundle:nil] forCellReuseIdentifier:@"RRPMyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPMySwitchCell" bundle:nil] forCellReuseIdentifier:@"RRPMySwitchCell"];
    [self.view addSubview:self.tableView];//加点测试的

}
//全部订单
- (void)getAllOrderValue:(NSNotification *)notification
{
     NSString *Register = [[NSUserDefaults standardUserDefaults]objectForKey:@"register"];
    //判断是否登录了
    if ([Register isEqualToString:@"YES"])  {
        RRPAllOrderController *allOrder = [[RRPAllOrderController alloc] init];
        //统计:全部订单
        [MobClick event:@"56"];

        [self.navigationController pushViewController:allOrder animated:YES];
    }else {
        [[MyAlertView sharedInstance]showFrom:@"登录即可查看常用信息"];
        RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
//代付款
- (void)getNoPaymentValue:(NSNotification *)notification
{

    NSString *Register = [[NSUserDefaults standardUserDefaults]objectForKey:@"register"];
    //判断是否登录了
    if ([Register isEqualToString:@"YES"])  {
        RRPNonPaymentController *noCommentVC = [[RRPNonPaymentController alloc] init];
        //统计:待付款
        [MobClick event:@"57"];
        [self.navigationController pushViewController:noCommentVC animated:YES];
    }else {
        [[MyAlertView sharedInstance]showFrom:@"登录即可查看常用信息"];
        RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
       
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
//未出行
- (void)getNoTravelValue:(NSNotification *)notification
{
    NSString *Register = [[NSUserDefaults standardUserDefaults]objectForKey:@"register"];
    //判断是否登录了
    if ([Register isEqualToString:@"YES"])  {
        RRPNotTripController *noTrip = [[RRPNotTripController alloc] init];
        //统计:未出行
        [MobClick event:@"59"];
        [self.navigationController pushViewController:noTrip animated:YES];
    }else {
        [[MyAlertView sharedInstance]showFrom:@"登录即可查看常用信息"];
        RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
//待评价
- (void)getNoCommentValue:(NSNotification *)notification
{
    NSString *Register = [[NSUserDefaults standardUserDefaults]objectForKey:@"register"];
    //判断是否登录了
    if ([Register isEqualToString:@"YES"])  {
        RRPNotCommentController *noComment = [[RRPNotCommentController alloc] init];
        //统计:待评价
        [MobClick event:@"62"];
        [self.navigationController pushViewController:noComment animated:YES];
    }else {
        [[MyAlertView sharedInstance]showFrom:@"登录即可查看常用信息"];
        RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,20,RRPWidth, RRPHeight-20-49)];
        self.tableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(242, 245, 247), IWColor(200, 200, 200));
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
        return 4;
    }else if (section == 4) {
        return 0;
    }else {
        return 3;
    }
}

- (UILabel *)numberLabel {
    if (_numberLabel == nil) {
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(RRPWidth - 60, 15, 45, 20)];
        self.numberLabel.font = [UIFont systemFontOfSize:12];
        self.numberLabel.textColor = IWColor(225, 225, 225);
    }
    return _numberLabel;
}

//展示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        RRPMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyOrderCell" forIndexPath:indexPath];
        //取消点击样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.dk_backgroundColorPicker = DKColorWithColors(IWColor(250, 250, 250), IWColor(150, 150, 150));
        return cell;
    }else if (indexPath.section == 2) {
        RRPMyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyCell" forIndexPath:indexPath];
        //取消点击样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 0) {
            cell.titleImageView.image = [UIImage imageNamed:@"我的收藏"];
            cell.RRPTitleLabel.text = @"我的收藏";
        }else if (indexPath.row == 1) {
            cell.titleImageView.image = [UIImage imageNamed:@"编辑资料"];
            cell.RRPTitleLabel.text = @"编辑资料";
        }else if(indexPath.row == 2) {
            cell.titleImageView.image = [UIImage imageNamed:@"常用信息"];
            cell.RRPTitleLabel.text = @"常用信息";
        }else {
            cell.titleImageView.image = [UIImage imageNamed:@"邀请好友"];
            cell.RRPTitleLabel.text = @"邀请好友";
        }
        cell.dk_backgroundColorPicker = DKColorWithColors(IWColor(250, 250, 250), IWColor(150, 150, 150));
        return cell;
    }else {
        if (indexPath.section == 3 && indexPath.row == 2) {
            RRPMyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyCell" forIndexPath:indexPath];
            //取消点击样式
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.titleImageView.image = [UIImage imageNamed:@"关于我们"];
            cell.RRPTitleLabel.text = @"关于我们";
            cell.dk_backgroundColorPicker = DKColorWithColors(IWColor(250, 250, 250), IWColor(150, 150, 150));
            return cell;
        }else {
            RRPMySwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMySwitchCell" forIndexPath:indexPath];
            //取消点击样式
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if (indexPath.row == 0) {
                cell.titleImageView.image = [UIImage imageNamed:@"清除缓存"];
                cell.RRPTitleLabel.text = @"清除缓存";
                [cell.RRPSwitch removeFromSuperview];
                //清楚缓存的弹框
                self.size = [[SDImageCache sharedImageCache] getSize];
                NSString *sizeString = [NSString stringWithFormat:@"%.1fM ", self.size / 1024 / 1024.];
                self.numberLabel.text = sizeString;
                [cell addSubview:self.numberLabel];
            }else if (indexPath.row == 1) {
                cell.titleImageView.image = [UIImage imageNamed:@"夜间模式"];
                cell.RRPTitleLabel.text = @"夜间模式";
            }
            cell.dk_backgroundColorPicker = DKColorWithColors(IWColor(250, 250, 250), IWColor(150, 150, 150));
            return cell;
        }
    }
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 77.5;
    }else {
        return 50;
    }
}
//区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 175;
    }else if(section == 1) {
        return 0;
    }else if(section == 4) {
        return 0;
    }else {
        return 10;
    }
}
//区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return 80;
    }else {
        return 0;
    }
}
//区头
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 175)];
        self.imageView.image = [UIImage imageNamed:@"用户背景"];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;//等比例放大
        UIView *view = [[UIView alloc] initWithFrame:self.imageView.bounds];
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self.imageView addSubview:view];
        
        
        
        //标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 15, RRPWidth - 46, 15)];
        NSString *nickname = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
        if ([nickname isEqualToString:@""]) {
            self.titleLabel.text = @"登录/注册";
        }else {
            self.titleLabel.text = [NSString stringWithFormat:@"%@",nickname];
        }
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = 1;
        [view addSubview:self.titleLabel];
        //消息按钮
        UIButton *newsButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        newsButton.frame = CGRectMake(RRPWidth - 45, 15, 22.5, 22.5);
        [newsButton setBackgroundImage:[UIImage imageNamed:@"系统消息"] forState:(UIControlStateNormal)];
        [newsButton addTarget:self action:@selector(newsButton:) forControlEvents:(UIControlEventTouchUpInside)];
        UILabel *newMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, -5, 10, 10)];
        newMessageLabel.backgroundColor = [UIColor clearColor];
        newMessageLabel.layer.cornerRadius = 5;
        newMessageLabel.layer.masksToBounds = YES;
        [newsButton addSubview:newMessageLabel];
        [view addSubview:newsButton];
        
        //头像
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((RRPWidth-90)/2, 42.5, 90, 90)];
        self.headImageView.userInteractionEnabled = YES;
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.cornerRadius = self.headImageView.frame.size.height/2;
        NSString *headimgurl = [[NSUserDefaults standardUserDefaults]objectForKey:@"head_img"];
        if ([headimgurl isEqualToString:@""]) {
            self.headImageView.image = [UIImage imageNamed:@"会员默认头像"];
        }else {
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",headimgurl]] placeholderImage:[UIImage imageNamed:@"会员默认头像"]];
        }
        [view addSubview:self.headImageView];
        self.view.userInteractionEnabled = YES;
        //创建手势
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        //向视图添加手势
        [self.headImageView addGestureRecognizer:self.tap];
        //签名
        self.signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.headImageView.frame)+15, RRPWidth - 20, 15)];
        self.signatureLabel.textColor = [UIColor whiteColor];
        self.signatureLabel.font = [UIFont systemFontOfSize:15];
        self.signatureLabel.textAlignment = 1;
        
       NSString *per_note = [[NSUserDefaults standardUserDefaults]objectForKey:@"per_note"];
        if ([per_note isEqualToString:@""]) {
            self.signatureLabel.text = @"世界那么大,我想去看看";
        }else {
            self.signatureLabel.text = per_note;
        }
        
        [view addSubview:self.signatureLabel];
        
        return self.imageView;
    }else {
        UIView *view = [[UIView alloc] init];
        view.dk_backgroundColorPicker = DKColorWithColors(IWColor(242, 245, 247), IWColor(200, 200, 200));
        return view;
    }
}
//区尾
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 80)];
    view.dk_backgroundColorPicker = DKColorWithColors(IWColor(250, 250, 250), IWColor(200, 200, 200));
    self.quitButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.quitButton.frame = CGRectMake(40, 15, RRPWidth - 80, 50);
    self.quitButton.layer.cornerRadius = 5;
    self.quitButton.layer.masksToBounds = YES;
    self.quitButton.backgroundColor = IWColor(56, 135, 191);
    
    /**
     *  标记用户是否登
     *  register  key
     *  YES登录了  NO未登录
     */
    NSString *Register = [[NSUserDefaults standardUserDefaults]objectForKey:@"register"];
    if ([Register isEqualToString:@"YES"]) {
      [self.quitButton setTitle:@"退出登录" forState:(UIControlStateNormal)];
    }else {
       [self.quitButton setTitle:@"登录/注册" forState:(UIControlStateNormal)];
    }
    [self.quitButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.quitButton.titleLabel.font =[UIFont systemFontOfSize:20];
    [self.quitButton addTarget:self action:@selector(quitButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:self.quitButton];
    return view;
}
//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *Register = [[NSUserDefaults standardUserDefaults]objectForKey:@"register"];
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //判断是否登录了
            if ([Register isEqualToString:@"YES"])  {
                RRPMyCollectListController *collect = [[RRPMyCollectListController alloc] init];
                //统计:我的收藏按钮点击
                [MobClick event:@"69"];
                [self.navigationController pushViewController:collect animated:YES];
            }else {
                [[MyAlertView sharedInstance]showFrom:@"登录即可查看收藏"];
                RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
        }else if (indexPath.row == 1) {
            //判断是否登录了
            if ([Register isEqualToString:@"YES"])  {
                RRPMyCompileController *compile = [[RRPMyCompileController alloc] init];
                //统计:编辑资料按钮点击
                [MobClick event:@"72"];
                [self.navigationController pushViewController:compile animated:YES];
            }else {
                [[MyAlertView sharedInstance]showFrom:@"登录即可编辑资料"];
                RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
                //统计:编辑资料点击
                [MobClick event:@"55"];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
        }else if (indexPath.row == 2) {
            //判断是否登录了
            if ([Register isEqualToString:@"YES"])  {
                RRPCommonLinkmanController *commonLinkman = [[RRPCommonLinkmanController alloc] init];
                //统计:常用联系人点击
                [MobClick event:@"84"];
                
                [self.navigationController pushViewController:commonLinkman animated:YES];
            }else {
                [[MyAlertView sharedInstance]showFrom:@"登录即可查看常用信息"];
                RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
        }else {
            RRPInviteFriendController *inviteFriend = [[RRPInviteFriendController alloc] init];
            //统计:邀请好友按钮点击
            [MobClick event:@"88"];
            [self.navigationController pushViewController:inviteFriend animated:YES];
        }
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            //清楚缓存的弹框
            NSString *sizeString = [NSString stringWithFormat:@"缓存文件大小总计%.1fM,确认清除? ", self.size / 1024 / 1024.];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:sizeString preferredStyle:(UIAlertControllerStyleAlert)];
            // 创建按钮
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                //确定清除缓存
                [[SDImageCache sharedImageCache] clearDisk];
                [[SDImageCache sharedImageCache] clearMemory];
                NSString * cache = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
                NSString *clearMune = [NSString stringWithFormat:@"%@/Caches", cache];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager removeItemAtPath:clearMune error:nil];
                NSString *sizeString = [NSString stringWithFormat:@"已清除%.1fM缓存文件", self.size / 1024 / 1024.];
                //清除后的成功提示
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:sizeString preferredStyle:(UIAlertControllerStyleAlert)];
                [self.navigationController presentViewController:alertController animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                    //统计:清除缓存按钮点击
                    [MobClick event:@"93"];
                    [self.tableView reloadData];
                });
            }];
            
            // 注意取消按钮只能添加一个
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
                // 点击按钮后的方法直接在这里面写
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            
            //添加按钮 将按钮添加到UIAlertController对象上
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            //将UIAlertController模态出来 相当于UIAlertView show 的方法
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
            
        }else if (indexPath.row == 2) {
            RRPMyAboutController *about = [[RRPMyAboutController alloc] init];
            //统计:关于我们点击
            [MobClick event:@"95"];
            [self.navigationController pushViewController:about animated:YES];
        }
    }
}

//消息点击方法
- (void)newsButton:(UIButton *) sender {
    NSString *Register = [[NSUserDefaults standardUserDefaults]objectForKey:@"register"];
    //判断是否登录了
    if ([Register isEqualToString:@"YES"])  {
        RRPMessageViewController *message = [[RRPMessageViewController alloc] init];
        //统计:消息按钮点击
        [MobClick event:@"53"];
        [self.navigationController pushViewController:message animated:YES];
    }else {
        [[MyAlertView sharedInstance]showFrom:@"登录即可查看消息"];
        RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
//设置头像
- (void)headButton:(UIButton *)sender {
    RRPMyCompileController *MyCompile = [[RRPMyCompileController alloc] init];
    //统计:头像点击
    [MobClick event:@"54"];
    [self.navigationController pushViewController:MyCompile animated:YES];
}

- (void)quitButton:(UIButton *)sender {
    /**
     *  标记用户是否登
     *  register  key
     *  YES登录了  NO未登录
     */
    NSString *Register = [[NSUserDefaults standardUserDefaults]objectForKey:@"register"];
    if ([Register isEqualToString:@"YES"]) {
        [[[UIAlertView alloc] initWithTitle:@"退出登录后可能会有部分功能无法使用"
                                    message:nil
                                   delegate:self
                          cancelButtonTitle:@"确认"//0
                          otherButtonTitles:@"取消",nil] show];//1
    }else {
        RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        /**
         *  标记用户是否登
         *  register  key
         *  YES登录了  NO未登录
         */
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"head_img"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"per_note"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"nickname"];
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"register"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
        [self.tableView reloadData];
    }
}


#pragma mark - 手势方法的实现
//轻拍
- (void)tap:(UITapGestureRecognizer *)tap {
    NSString *Register = [[NSUserDefaults standardUserDefaults]objectForKey:@"register"];
    //判断是否登录了
    if ([Register isEqualToString:@"YES"])  {
       NSString *three = [[NSUserDefaults standardUserDefaults] valueForKey:@"three"];
        if ([three isEqualToString:@"NO"]) {
            RRPMyCompileController *MyCompile = [[RRPMyCompileController alloc] init];
            //统计:头像点击
            [MobClick event:@"54"];
            [self.navigationController pushViewController:MyCompile animated:YES];
        }else {
            [[MyAlertView sharedInstance]showFrom:@"手机号登录可编辑头像"];
        }
    }else {
        [[MyAlertView sharedInstance]showFrom:@"登录即可编辑头像"];
        RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
- (void)photoSelect {
    BoPhotoPickerViewController *picker = [[BoPhotoPickerViewController alloc] init];
    picker.maximumNumberOfSelection = 1;
    picker.multipleSelection = YES;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:picker];
    [navigation.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg1_image.png"]]];
    navigation.navigationBarHidden = YES;
    [navigation.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:IWColor(90, 113, 131)}];
    [self presentViewController:navigation animated:YES completion:nil];

}

#pragma mark - BoPhotoPickerProtocol
- (void)photoPickerDidCancel:(BoPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPicker:(BoPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    ALAsset *asset=assets[0];
    UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//    self.imageView.image = tempImg;
    if (self.isBackImage) {
        self.imageView.image = tempImg;
        self.isBackImage = NO;
    } else {
        self.headImageView.image = tempImg;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(NSString *)gb2312toutf8:(NSData *) data
{
    
    NSStringEncoding enc =             CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    
    return retStr;
    
}


- (void)photoPickerTapAction:(BoPhotoPickerViewController *)picker {
    if(![self checkCameraAvailability]){
//        NSLog(@"没有访问相机权限");
        return;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    CameraViewController *cameraUI = [CameraViewController new];
    cameraUI.delegate = self;
    [self.navigationController pushViewController:cameraUI animated:YES];
}

//代理传值的方法实现
- (void)RRPMyCommentPassByValue:(RRPMyCommentController *)control andImage:(UIImage *)image {
    self.imageView.image = image;
    
}


- (BOOL)checkCameraAvailability {
    BOOL status = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        status = YES;
    }
    return status;
}

- (void)login:(NSNotification *)notification {
    [[MyAlertView sharedInstance]showFrom:@"登录即可查看订单"];
    RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
