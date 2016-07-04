//
//  RRPInviteFriendController.m
//  RRP
//
//  Created by sks on 16/3/21.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPInviteFriendController.h"
#import "RRPMyInviteFriendCell.h"
#import <AddressBook/AddressBook.h>
#import "MHContactModel.h"

@interface RRPInviteFriendController ()<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate> {
    BOOL weiboClick;
    BOOL phoneClick;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *weiboMoreImageView;
@property (nonatomic,strong) UIImageView *phoneMoreImageView;
@property (nonatomic, strong) UITapGestureRecognizer *weixinTap;
@property (nonatomic, strong) UITapGestureRecognizer *QQTap;
@property (nonatomic, strong) UITapGestureRecognizer *WeiboTap;
//分享所需参数
@property (nonatomic, strong) NSString *shareContent;
@property (nonatomic, strong) NSString *download_link_ios;
@property (nonatomic, strong) NSString *imgurl;
@property (nonatomic, strong) NSString *shareTitle;


/** 所有联系人 */
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation RRPInviteFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.title= @"邀请好友";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPMyInviteFriendCell" bundle:nil] forCellReuseIdentifier:@"RRPMyInviteFriendCell"];
    [self.view addSubview:self.tableView];
    
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    //判断授权状态
    
    if (status == kABAuthorizationStatusNotDetermined) {
        
        ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
        
        ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error) {
            
            if (granted) {
                //查找所有联系人
                [self address];
                
            }else
            {
                NSLog(@"授权失败");
            }
        });
    }else if (status == kABAuthorizationStatusAuthorized)
    {
        //已授权
        [self address];
    }
    
}
//懒加载
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

//懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,RRPWidth, RRPHeight)];
        self.tableView.dk_backgroundColorPicker = DKColorWithColors( IWColor(246, 246, 246), IWColor(200, 200, 200));
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
//cell数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0;
    }else if (section == 2) {
        if (weiboClick == NO) {
            return 0;
        }else {
            return 3;
        }
    }else {
        if (phoneClick == NO) {
            return 0;
        }else {
            return self.dataSource.count;
        }
    }
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    
    if (indexPath.section == 3) {
        RRPMyInviteFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyInviteFriendCell" forIndexPath:indexPath];
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        MHContactModel *model = self.dataSource[indexPath.row];
        [cell showDate:model];
        cell.backgroundColor = IWColor(241, 241, 241);
        return cell;
    }
    RRPMyInviteFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyInviteFriendCell" forIndexPath:indexPath];
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    cell.backgroundColor = IWColor(241, 241, 241);
    return cell;
 
}

#pragma mark - UITableViewDelegate
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64;
}

//区头
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 17.5, 29, 29)];
    [view addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 25, 100, 15)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = IWColor(83, 83, 83);
    [view addSubview:nameLabel];
    
    UIView *wireView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, RRPWidth, 1)];
    wireView.backgroundColor = IWColor(237, 237, 237);
    [view addSubview:wireView];
    
    UIButton *moreButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    moreButton.frame = CGRectMake(RRPWidth - 64, 0, 64, 64);
    [moreButton addTarget:self action:@selector(moreButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:moreButton];
    
    if (section == 0) {
        imageView.image = [UIImage imageNamed:@"qq好友"];
        nameLabel.text = @"QQ好友";
        moreButton.hidden = YES;
        //创建手势
        self.QQTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QQTap:)];
        //向视图添加手势
        [view addGestureRecognizer:self.QQTap];
    }else if (section == 1) {
        imageView.image = [UIImage imageNamed:@"微信好友"];
        nameLabel.text = @"微信好友";
        moreButton.hidden = YES;
        //创建手势
        self.weixinTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weixinTap:)];
        //向视图添加手势
        [view addGestureRecognizer:self.weixinTap];
    }else if(section == 2) {
        imageView.image = [UIImage imageNamed:@"微博好友"];
        nameLabel.text = @"微博";
        moreButton.hidden = YES;
        //创建手势
        self.WeiboTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Weibo:)];
        //向视图添加手势
        [view addGestureRecognizer:self.WeiboTap];
    }else {
        imageView.image = [UIImage imageNamed:@"scanWindow-phoneCall"];
        nameLabel.text = @"通讯录好友";
        self.phoneMoreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(RRPWidth - 35, 25, 14, 14)];
        if (phoneClick == NO) {
            self.phoneMoreImageView.image = [UIImage imageNamed:@"合并"];
        }else {
            self.phoneMoreImageView.image = [UIImage imageNamed:@"展开"];
        }

        [view addSubview:self.phoneMoreImageView];

    }
    return view;
}

//点击cell发送邀请短信
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MHContactModel *model = self.dataSource[indexPath.row];
    if (model.telArray.count != 0) {
        [self sendMessage:model.telArray[0]];
    }
    //统计:邀请好友通讯录好友点击
    [MobClick event:@"92"];
}

#pragma mark -sendMessage
#pragma mark -发送短信邀请
- (void)sendMessage:(NSString*)mobile
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        self.shareContent = [RRPFindTopModel shareRRPFindTopModel].content;
        self.download_link_ios = [RRPFindTopModel shareRRPFindTopModel].download_link_ios;
        self.shareTitle = [RRPFindTopModel shareRRPFindTopModel].title;
        NSString *descriptionStr = [NSString stringWithFormat:@"%@,%@APP下载地址:%@",self.shareTitle,self.shareContent,self.download_link_ios];
        controller.body = descriptionStr;
        controller.messageComposeDelegate = self;
        controller.recipients = [NSArray arrayWithObject:mobile];
        [self presentViewController:controller animated:YES completion:^(void) {}];
    }
}

//调用sendSMS函数
//内容，收件人列表
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^(void) {}];
    }
}

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^(void) {}];
}


- (void)moreButton:(UIButton *)sender {
        if (phoneClick == NO) {
            self.phoneMoreImageView.image = [UIImage imageNamed:@"展开"];
            phoneClick = YES;
        }else {
            self.phoneMoreImageView.image = [UIImage imageNamed:@"合并"];
            phoneClick = NO;
        }
        [self.tableView reloadData];
}

#pragma mark - 手势方法的实现
//QQ邀请
- (void)QQTap:(UITapGestureRecognizer *)tap {
    NSMutableDictionary *shareParams = [self shareParameter];
    [ShareSDK showShareEditor:SSDKPlatformSubTypeQQFriend otherPlatformTypes:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
    }];
    //统计:邀请QQ好友点击
    [MobClick event:@"89"];
    
}
//微信邀请
- (void)weixinTap:(UITapGestureRecognizer *)tap {
    NSMutableDictionary *shareParams = [self shareParameter];
    [ShareSDK showShareEditor:SSDKPlatformSubTypeWechatSession otherPlatformTypes:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
    }];
    //统计:邀请好友微信好友点击
    [MobClick event:@"90"];
}
//微博邀请
- (void)Weibo:(UITapGestureRecognizer *)tap {
    NSMutableDictionary *shareParams = [self shareParameter];
    [ShareSDK showShareEditor:SSDKPlatformTypeSinaWeibo otherPlatformTypes:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
    }];
    //统计:邀请好友未必好友点击
    [MobClick event:@"91"];
}

//创建分享参数
- (NSMutableDictionary *)shareParameter {
    
    self.shareContent = [RRPFindTopModel shareRRPFindTopModel].content;
    self.download_link_ios = [RRPFindTopModel shareRRPFindTopModel].download_link_ios;
    self.imgurl = [RRPFindTopModel shareRRPFindTopModel].imgurl;
    self.shareTitle = [RRPFindTopModel shareRRPFindTopModel].title;
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.shareContent
                                     images:@[self.imgurl]
                                        url:[NSURL URLWithString:self.download_link_ios]
                                      title:self.shareTitle
                                       type:SSDKContentTypeAuto];
    
    return shareParams;
}


#pragma mark - 获取通讯录里联系人姓名和手机号
- (void)address
{
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
    //获取通讯录权限
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        return;
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++) {
        
        //新建一个addressBook model类
        MHContactModel *addressBook = [[MHContactModel alloc] init];
        addressBook.telArray = [NSMutableArray new];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        }
        else {
            if ((__bridge id)abLastName != nil) {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        NSString *tel = (__bridge NSString*)value;
                        
                        //以下5行请勿删除,请勿修改,隐形代码,删改后果自负
                        tel = [tel stringByReplacingOccurrencesOfString:@"(" withString:@""];
                        tel = [tel stringByReplacingOccurrencesOfString:@")" withString:@""];
                        tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        tel = [tel stringByReplacingOccurrencesOfString:@" " withString:@""];
                        tel = [tel stringByReplacingOccurrencesOfString:@" " withString:@""];
                        
                        [addressBook.telArray addObject:tel];
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [self.dataSource addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    
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
