//
//  RRPMyCompileController.m
//  RRP
//
//  Created by sks on 16/3/17.
//  Copyright © 2016年 sks. All rights reserved.
#import "RRPMyCompileController.h"
#import "RRPMyHeadPortraitCell.h"
#import "RRPMyCompileCell.h"
#import "RRPMyCompileTwoCell.h"
#import "FindPassWordViewController.h"

@interface RRPMyCompileController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BoPhotoPickerProtocol,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CameraViewDelegate> {
    BOOL manState;
    BOOL wamanState;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitButton;//提交按钮
@property (nonatomic, strong) UIButton *manButton;//男
@property (nonatomic, strong) UIButton *wamanButton;//女
@property (nonatomic, assign) NSInteger tag;//识别男女
@property (nonatomic, strong) UIDatePicker *datePicker;//时间选择
@property (nonatomic, strong) NSString *dateString;//时间数据
@property (nonatomic, strong) UILabel *birthdayLabel;//生日时间Label
@property (nonatomic, strong) UIView *birthdayView;
@property (nonatomic, strong) UIButton *confirmButton;//确定按钮
@property (nonatomic, strong) UIButton *cancelButton;//取消按钮
@property (nonatomic, assign) NSInteger keyboardheight;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) UIImage *image;//头像图片
@property (nonatomic, strong) UITapGestureRecognizer *tap;

/**
 *  展示数据用的模型属性
 */
@property (nonatomic, strong) NSString *head_img;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *per_note;
@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *site;
@property (nonatomic, strong) NSString *se;


@property (nonatomic, strong) UITextField *nicknameTextField;
@property (nonatomic, strong) UITextField *per_noteTextField;
@property (nonatomic, strong) UITextField *realnameTextField;
@property (nonatomic, strong) UITextField *mobileTextField;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *siteTextField;

@end

@implementation RRPMyCompileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.title = @"资料修改";
    [self downLoadDataLook];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPMyCompileTwoCell" bundle:nil] forCellReuseIdentifier:@"RRPMyCompileTwoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPMyHeadPortraitCell" bundle:nil] forCellReuseIdentifier:@"RRPMyHeadPortraitCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPMyCompileCell" bundle:nil] forCellReuseIdentifier:@"RRPMyCompileCell"];
    
    //键盘弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [self.view addSubview:self.tableView];

}

#pragma mark - 数据请求
- (void)downLoadDataLook {
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"seepersonal" forKey:@"method"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:Regist parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dico = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dict = [RRPPrintObject nullDic:dico];
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            self.head_img = dict[@"ResponseBody"][@"head_img"];//头像
            self.nickname = dict[@"ResponseBody"][@"nickname"];//昵称
            self.per_note = dict[@"ResponseBody"][@"per_note"];//签名
            self.realname = dict[@"ResponseBody"][@"realname"];//名字
            self.mobile = dict[@"ResponseBody"][@"mobile"];//电话
            self.birthday = dict[@"ResponseBody"][@"birthday"];//生日
            self.sex = [NSString stringWithFormat:@"%@",dict[@"ResponseBody"][@"sex"]];//性别
            self.email = dict[@"ResponseBody"][@"email"];//邮箱
            self.site = dict[@"ResponseBody"][@"site"];//住址
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}

- (void)submitButton:(UIButton *)sender {
    //性别（1男 2女 0未知）
    if (self.tag == 1) {
        self.se = @"1";
    }else if (self.tag == 2) {
        self.se = @"2";
    }else if (self.tag == 0) {
        self.se = @"0";
    }
    //性别
    if (self.se.length != 0) {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.se forKey:@"sex"];
    }else {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic removeObjectForKey:@"sex"];
    }
    /**
     *  手机号判断，邮箱判断，三方登录不能修改名称、性别  地址 生日取消逻辑
     */
    if (self.mobileTextField.text.length != 0) {
        BOOL mobileStr = [Utility checkUserTelNumber:self.mobileTextField.text];
        BOOL emile = [RRPMyCompileController validateEmail:self.emailTextField.text];
        if (mobileStr == YES) {
            if (self.emailTextField.text.length != 0) {
                if (emile == YES) {
                    [self downLoadDataupLoading];
                    //统计:资料修改提交按钮点击
                    [MobClick event:@"83"];
                    
                }else {
                    [[MyAlertView sharedInstance]showFrom:@"输入的邮箱有误"];
                }
            }else {
                [self downLoadDataupLoading];
                //统计:资料修改提交按钮点击
                [MobClick event:@"83"];
            }
        }else {
            [[MyAlertView sharedInstance]showFrom:@"输入的手机号有误"];
        }
    }else {
        BOOL emile = [RRPMyCompileController validateEmail:self.emailTextField.text];
        if (self.emailTextField.text.length != 0) {
            if (emile == YES) {
                [self downLoadDataupLoading];
                //统计:资料修改提交按钮点击
                [MobClick event:@"83"];
                
            }else {
                [[MyAlertView sharedInstance]showFrom:@"输入的邮箱有误"];
            }
        }else {
            [self downLoadDataupLoading];
            //统计:资料修改提交按钮点击
            [MobClick event:@"83"];
        }
    }
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//上传数据
- (void)downLoadDataupLoading {
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.head_img forKey:@"head_img"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.nicknameTextField.text forKey:@"nickname"];
    //签名
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.per_noteTextField.text forKey:@"per_note"];
    NSInteger realname = 1;
    if (realname == 1) {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.realnameTextField.text forKey:@"realname"];
        //统计:资料修改姓名点击
        [MobClick event:@"76"];
    }
    NSInteger mobile = 2;
    if (mobile == 2) {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.mobileTextField.text forKey:@"mobile"];
        //统计:资料修改手机号点击
        [MobClick event:@"77"];
    }
    NSInteger birthday = 3;
    if (birthday == 3) {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.birthdayLabel.text forKey:@"birthday"];
        //统计:资料修改生日点击
        NSDictionary *dict = @{@"birthday":self.birthdayLabel.text};
        [MobClick event:@"79" attributes:dict];
    }
    NSInteger email = 4;
    if (email == 4) {
        //邮箱
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.emailTextField.text forKey:@"email"];
        //统计:资料修改邮箱点击
        [MobClick event:@"81"];
    }
    NSInteger site = 5;
    if (site == 5) {
        //住址
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.siteTextField.text forKey:@"site"];
        //统计:资料修改常住地址点击
        [MobClick event:@"82"];
    }
    
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"editpersonal" forKey:@"method"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:Regist parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dico = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dict = [RRPPrintObject nullDic:dico];
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            NSInteger nickname = 1;
            if (nickname == 1) {
                [[NSUserDefaults standardUserDefaults] setObject:self.nicknameTextField.text forKey:@"nickname"];
                //统计:资料修改昵称点击
                [MobClick event:@"74"];
            }
            NSInteger head_img = 3;
            if (head_img == 3) {
                [[NSUserDefaults standardUserDefaults] setObject:self.head_img forKey:@"head_img"];
                //统计:资料修改头像点击
                [MobClick event:@"73"];
            }
            NSInteger per_note = 2;
            if (per_note == 2) {
                [[NSUserDefaults standardUserDefaults] setObject:self.nicknameTextField.text forKey:@"nickname"];
                //统计:资料修改签名点击
                [MobClick event:@"75"];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
//上传头像
- (void)UpLoadHeadImage
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSData *imageData = [RRPAllCityHandle image_TransForm_Data:self.image];
    NSString *encodedString = [imageData base64Encoding];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"image_upload" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:encodedString forKey:@"image"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:MyUpLoadHeadImage parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSInteger code = [dict[@"ResponseHead"][@"code"] integerValue];
        if (code == 1000) {
            [self downLoadDataLook];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}
//懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,RRPWidth, RRPHeight) style:(UITableViewStyleGrouped)];
        self.tableView.dk_backgroundColorPicker= DKColorWithColors(IWColor(246, 246, 246), IWColor(200, 200, 200));
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
//cell数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1) {
        return 3;
    }else {
        return 4;
    }
}
//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            RRPMyHeadPortraitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyHeadPortraitCell" forIndexPath:indexPath];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            cell.headPortaitButton.userInteractionEnabled = YES;
            //创建手势
            self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            //向视图添加手势
            [cell.headPortaitButton addGestureRecognizer:self.tap];
            [cell.moreButton addTarget:self action:@selector(tap:) forControlEvents:(UIControlEventTouchUpInside)];
            //判断头像图片是否为空
            if (self.image == nil) {
                [cell.headPortaitButton sd_setImageWithURL:[NSURL URLWithString:self.head_img]];
            }else {
                cell.headPortaitButton.image = self.image;
            }
            return cell;
        }else if (indexPath.row == 1) {
            RRPMyCompileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyCompileCell" forIndexPath:indexPath];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            cell.titleNameLabel.text = @"昵称";
            if (self.nickname.length != 0) {
                cell.contentTextField.placeholder = self.nickname;
            }else {
                cell.contentTextField.placeholder = @"还没昵称快来设置吧";
            }
            
            NSString *three = [[NSUserDefaults standardUserDefaults] valueForKey:@"three"];
            if ([three isEqualToString:@"NO"]) {
                self.nicknameTextField = cell.contentTextField;
            }else {
                self.nicknameTextField = cell.contentTextField;
            }
            return cell;
        }else {
            RRPMyCompileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyCompileCell" forIndexPath:indexPath];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            cell.titleNameLabel.text = @"个性签名";
            if (self.per_note.length != 0) {
                cell.contentTextField.placeholder = self.per_note;
            }else {
                cell.contentTextField.placeholder = @"写下你最中意的句子（20字）";
            }
            self.per_noteTextField = cell.contentTextField;
            return cell;
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            RRPMyCompileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyCompileCell" forIndexPath:indexPath];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            cell.titleNameLabel.text = @"姓名";
            if (self.realname.length != 0) {
                cell.contentTextField.placeholder = self.realname;
            }else {
                cell.contentTextField.placeholder = @"还没填写真实名字";
            }
            self.realnameTextField = cell.contentTextField;
            return cell;
        }else if (indexPath.row == 1) {
            RRPMyCompileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyCompileCell" forIndexPath:indexPath];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            cell.titleNameLabel.text = @"手机号";
            
            if (self.mobile.length != 0) {
                cell.contentTextField.placeholder = self.mobile;
            }else {
                cell.contentTextField.placeholder = @"18510588770";
            }
            self.mobileTextField = cell.contentTextField;

            return cell;
        }else {
            RRPMyCompileTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyCompileTwoCell" forIndexPath:indexPath];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            cell.titleNameLabel.text = @"修改密码";
            //添加跟多图片
            UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(RRPWidth - 110 - 20, 11, 20, 20)];
            moreImageView.image = [UIImage imageNamed:@"home-middleList-more"];
            [cell.backView addSubview:moreImageView];
            return cell;
        }
    }else {
        if (indexPath.row == 0) {
            RRPMyCompileTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyCompileTwoCell" forIndexPath:indexPath];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            
            cell.titleNameLabel.text = @"生日";
            if (self.dateString.length == 0) {
                self.birthdayLabel.text = self.birthday;
            }else {
                self.birthdayLabel.text = self.dateString;
            }
            [cell.backView addSubview:self.birthdayLabel];
            return cell;
        }else if (indexPath.row == 1) {
            RRPMyCompileTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyCompileTwoCell" forIndexPath:indexPath];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            cell.titleNameLabel.text = @"性别";
            
            self.manButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
            self.manButton.backgroundColor = [UIColor clearColor];
            self.manButton.frame = CGRectMake(RRPWidth - 110 - 120, 10, 55, 24);
            self.manButton.layer.cornerRadius  = 12;
            self.manButton.layer.masksToBounds = YES;
            [self.manButton addTarget:self action:@selector(manButton:) forControlEvents:(UIControlEventTouchUpInside)];
            if ([self.sex integerValue] == 1) {
                //男选中
                manState = YES;
            }else if ([self.sex integerValue] == 2) {
                //女选中
                wamanState = YES;
            }
            
            if (manState == YES) {
                [self.manButton setBackgroundImage:[UIImage imageNamed:@"男-选中"] forState:(UIControlStateNormal)];
            }else {
                [self.manButton setBackgroundImage:[UIImage imageNamed:@"男-未选中"] forState:(UIControlStateNormal)];
            }
            [cell.backView addSubview:self.manButton];
            
            self.wamanButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
            self.wamanButton.backgroundColor = [UIColor clearColor];
            self.wamanButton.frame = CGRectMake(CGRectGetMaxX(self.manButton.frame)+10, 10, 55, 24);
            self.wamanButton.layer.cornerRadius  = 12;
            self.wamanButton.layer.masksToBounds = YES;
            [self.wamanButton addTarget:self action:@selector(wamanButton:) forControlEvents:(UIControlEventTouchUpInside)];
            if (wamanState == YES) {
                [self.wamanButton setBackgroundImage:[UIImage imageNamed:@"女-选中"] forState:(UIControlStateNormal)];
            }else {
                [self.wamanButton setBackgroundImage:[UIImage imageNamed:@"女-未选中"] forState:(UIControlStateNormal)];
            }
            [cell.backView addSubview:self.wamanButton];
            
            return cell;
        }else if (indexPath.row == 2) {
            RRPMyCompileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyCompileCell" forIndexPath:indexPath];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            cell.titleNameLabel.text = @"邮箱";
            if (self.email.length != 0) {
                cell.contentTextField.placeholder = self.email;
            }else {
                cell.contentTextField.placeholder = @"接收订单信息";
            }
            self.emailTextField = cell.contentTextField;

            cell.contentTextField.delegate = self;
            return cell;
        }else {
            RRPMyCompileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyCompileCell" forIndexPath:indexPath];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            cell.titleNameLabel.text = @"常住地";
            if (self.site.length != 0) {
                cell.contentTextField.placeholder = self.site;
            }else {
                cell.contentTextField.placeholder = @"为你推荐身边的旅游咨询";
            }
            self.siteTextField = cell.contentTextField;

            cell.contentTextField.delegate = self;
            return cell;
        }
    }
}

- (UILabel *)birthdayLabel {
    if (_birthdayLabel == nil) {
        self.birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, RRPWidth - 110, 15)];
        self.birthdayLabel.backgroundColor = [UIColor clearColor];
        self.birthdayLabel.textColor = IWColor(199, 199, 205)
        ;
        self.birthdayLabel.font = [UIFont systemFontOfSize:15];
        self.birthdayLabel.textAlignment = 2;
    }
    return _birthdayLabel;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 100;
    }else {
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 80;
    }else {
        return 13;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

//区尾
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 80)];
        view.dk_backgroundColorPicker = DKColorWithColors(IWColor(246, 246, 246), IWColor(200, 200, 200));
        self.submitButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.submitButton.frame = CGRectMake(40, 15, RRPWidth - 80, 50);
        self.submitButton.layer.cornerRadius = 5;
        self.submitButton.layer.masksToBounds = YES;
        self.submitButton.backgroundColor = IWColor(56, 135, 191);
        [self.submitButton setTitle:@"提交" forState:(UIControlStateNormal)];
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.submitButton.titleLabel.font =[UIFont systemFontOfSize:20];
        [self.submitButton addTarget:self action:@selector(submitButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:self.submitButton];
        return view;

    }else {
        return nil;
    }
}

//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 2) {
        NSString *three = [[NSUserDefaults standardUserDefaults] valueForKey:@"three"];
        if ([three isEqualToString:@"NO"]) {
            FindPassWordViewController *findPassWordVC = [[FindPassWordViewController alloc] init];
            //统计:资料修改修改密码点击
            [MobClick event:@"78"];
            [self presentViewController:findPassWordVC animated:YES completion:^{
            }];
        }else {
            [[MyAlertView sharedInstance]showFrom:@"第三方登录不能改修密码"];
        }
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        [self.view addSubview:self.birthdayView];
    }else if (indexPath.section == 2 && indexPath.row == 2) {
        self.tableView.frame = CGRectMake(0, - self.keyboardheight/2,RRPWidth, RRPHeight);
    }
}

- (UIView *)birthdayView {
    if (_birthdayView == nil) {
        self.birthdayView = [[UIView alloc] initWithFrame:CGRectMake(0, RRPHeight - 250, RRPWidth, 250)];
        self.birthdayView.backgroundColor = [UIColor whiteColor];
        
        //取消
        self.cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.cancelButton.frame = CGRectMake(0, 0, RRPWidth/2, 50);
        self.cancelButton.backgroundColor = IWColor(246, 246, 246);
        [self.cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
        [self.cancelButton setTitleColor:IWColor(100, 100, 100) forState:(UIControlStateNormal)];
        [self.cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.birthdayView addSubview:self.cancelButton];
        
        //分割线
        UIView *wireView = [[UIView alloc] initWithFrame:CGRectMake(RRPWidth/2-1, 10, 1, 30)];
        wireView.backgroundColor = IWColor(200, 200, 200);
        [self.cancelButton addSubview:wireView];
        
        //确定
        self.confirmButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.confirmButton.frame = CGRectMake(RRPWidth/2, 0, RRPWidth/2, 50);
        self.confirmButton.backgroundColor = IWColor(246, 246, 246);
        [self.confirmButton setTitle:@"确定" forState:(UIControlStateNormal)];
        [self.confirmButton setTitleColor:IWColor(100, 100, 100) forState:(UIControlStateNormal)];
        [self.confirmButton addTarget:self action:@selector(confirmButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.birthdayView addSubview:self.confirmButton];
        
        [self.birthdayView addSubview:self.datePicker];
        
    }
    return _birthdayView;
}
- (UIDatePicker *)datePicker {
    if (_datePicker == nil) {
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, RRPWidth, 200)];
        self.datePicker.backgroundColor = IWColor(255, 255, 255);
        // 设置picker的显示模式：只显示日期
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        // 设置区域为中国简体中文
        self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        }
    return _datePicker;
}

//选择器的滚动方法
- (void)dateChanged:(UIDatePicker *)sender{
    NSDate* date = sender.date;
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    self.dateString = [formatter stringFromDate:date];
    [self.tableView reloadData];
}

//确定
- (void) confirmButton:(UIButton *)sender {
    [self.birthdayView removeFromSuperview];
}
//取消
- (void) cancelButton:(UIButton *)sender {
    [self.birthdayView removeFromSuperview];
}
- (void)manButton:(UIButton *)sender {
    if (manState == YES) {
        [self.manButton setBackgroundImage:[UIImage imageNamed:@"男-未选中"] forState:(UIControlStateNormal)];
        manState = NO;
        self.tag = 0;
    }else {
        [self.manButton setBackgroundImage:[UIImage imageNamed:@"男-选中"] forState:(UIControlStateNormal)];
        manState = YES;
        self.tag = 1;
        //统计:资料修改
        NSDictionary *dict = @{@"gender":@"男"};
        [MobClick event:@"80" attributes:dict];
    }
    [self.wamanButton setBackgroundImage:[UIImage imageNamed:@"女-未选中"] forState:(UIControlStateNormal)];
    wamanState = NO;
}
- (void)wamanButton:(UIButton *)sender {
    if (wamanState == YES) {
        [self.wamanButton setBackgroundImage:[UIImage imageNamed:@"女-未选中"] forState:(UIControlStateNormal)];
        wamanState = NO;
        self.tag = 0;
    }else {
        [self.wamanButton setBackgroundImage:[UIImage imageNamed:@"女-选中"] forState:(UIControlStateNormal)];
        self.tag = 2;
        wamanState = YES;
        //统计:资料修改
        NSDictionary *dict = @{@"gender":@"男"};
        [MobClick event:@"80" attributes:dict];
    }
    [self.manButton setBackgroundImage:[UIImage imageNamed:@"男-未选中"] forState:(UIControlStateNormal)];
    manState = NO;
}
#pragma mark 键盘即将弹出
-(void)keyboardWillShow:(NSNotification *) notification {
    [self.birthdayView removeFromSuperview];
    //键盘的frame
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardheight = keyboardRect.size.height;
    self.keyboardheight = keyboardheight;
    self.tableView.frame = CGRectMake(0, -keyboardheight/2/2,RRPWidth, RRPHeight);
    if(!self.tapGesture){
        //增加tap手势，点击使退出键盘
        self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    }
    [self.tableView addGestureRecognizer:self.tapGesture];
}

#pragma mark 键盘即将消失
-(void)keyboardWillHide:(NSNotification *) notification {
    [self.tableView removeGestureRecognizer:self.tapGesture];
    self.tableView.frame = CGRectMake(0, 0, RRPWidth, RRPHeight);
}
-(void)dismissKeyBoard{
    self.tableView.frame = CGRectMake(0, 0,RRPWidth, RRPHeight);
    
    //发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"关闭textView的用户交互" object:nil];
    
}
- (void)tap:(UITapGestureRecognizer *)tap {
    NSString *three = [[NSUserDefaults standardUserDefaults] valueForKey:@"three"];
    if ([three isEqualToString:@"NO"]) {
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
    }else {
        [[MyAlertView sharedInstance]showFrom:@"手机号登录可编辑头像"];
    }
}
#pragma mark - BoPhotoPickerProtocol
- (void)photoPickerDidCancel:(BoPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPicker:(BoPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    if (assets.count != 0) {
        ALAsset *asset=assets[0];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        self.image = tempImg;
        [self UpLoadHeadImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self.tableView reloadData];
    }
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
    self.image = image;
    [self UpLoadHeadImage];
    [self.tableView reloadData];
}


- (BOOL)checkCameraAvailability {
    BOOL status = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        status = YES;
    }
    return status;
}



- (void) viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    

}
- (void) viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
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
