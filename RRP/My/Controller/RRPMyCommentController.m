//
//  RRPMyCommentController.m
//  RRP
//
//  Created by sks on 16/3/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "RRPMyCommentController.h"
#import "RRPAllCityHandle.h"

@interface RRPMyCommentController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,BoPhotoPickerProtocol,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CameraViewDelegate>
{
    BOOL goodclick;
    BOOL centerclick;
    BOOL badclick;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headImageView;//景点图片
@property (nonatomic, strong) UILabel *nameLabel;//门票名字
@property (nonatomic, strong) UILabel *moneyLanel;//门票价格
@property (nonatomic, strong) UILabel *titleLabel;//选择标题
@property (nonatomic, strong) UIButton *goodButton;//好评按钮
@property (nonatomic, strong) UIImageView *goodImageView;//好评笑脸
@property (nonatomic, strong) UILabel *goodLabel;//好评
@property (nonatomic, strong) UIButton *centreButton;//中评按钮
@property (nonatomic, strong) UIImageView *centreImageView;//中评笑脸
@property (nonatomic, strong) UILabel *centreLabel;//中评
@property (nonatomic, strong) UIButton *diffButton;//差评按钮
@property (nonatomic, strong) UIImageView *diffImageView;//差评笑脸
@property (nonatomic, strong) UILabel *diffLabel;//差评
@property (nonatomic, strong) HWTextView *textView;//输入框
@property (nonatomic, strong) UIView *wireView;//分割线
@property (nonatomic, strong) UIView *wireTwoView;//分割线2
@property (nonatomic, strong) UILabel *lbNums;//显示字数
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;//轻拍手势
@property (nonatomic, assign) NSInteger keyboardheight;//键盘弹出的高度
@property (nonatomic, strong) UIButton *cameraButton;//相机
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *removeButton;//删除按钮
@property (nonatomic, strong) UIImageView *removeImageView;//删除图片
@property (nonatomic, strong) NSMutableArray *imageArray;//图片数组
@property (nonatomic, strong) NSString *commentResult;//评论结果



@end

@implementation RRPMyCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = IWColor(241, 241, 241);
    self.title = @"发表评论";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    self.imageArray = [@[] mutableCopy];//初始化数组
    //键盘弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = IWColor(0, 122, 255);
    
    //发表按钮
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [button setTitle:@"发表" forState:(UIControlStateNormal)];
    [button setTitleColor:IWColor(200, 10, 10) forState:(UIControlStateNormal)];
    button.frame = CGRectMake(0, 0, 30, 20);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(button:) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
//返回
- (void)returnAction:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)button:(UIButton *)sender {
    if ([self.commentResult length] > 0 && [self.textView.text length] > 15) {
        //请求发表评论接口
        [self requestComment];
    }else
    {
       [[MyAlertView sharedInstance]showFrom:@"评价不能为空"];
    }
    
}
//请求发表评论接口
- (void)requestComment
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"write_comment" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    
    if ([self.commentResult isEqualToString:@"好评"]) {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"5" forKey:@"score"];
    }else if([self.commentResult isEqualToString:@"中评"])
    {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"3" forKey:@"score"];
    }else
    {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"1" forKey:@"score"];
    }
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.ticketID forKey:@"orderid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.textView.text forKey:@"comment"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%ld",self.imageArray.count] forKey:@"img_count"];
    for (int i = 0; i < self.imageArray.count; i++) {
        NSData *imageData = [RRPAllCityHandle image_TransForm_Data:self.imageArray[i]];
        NSString *encodedString = [imageData base64Encoding];
       [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:encodedString forKey:[NSString stringWithFormat:@"img%d",i+1]];
    }
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:MySubmitComment parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //检查字典中是否含有：“<NULL>”这样的字符串，有就改为“”
        NSDictionary * nullDict = [RRPPrintObject nullDic:dict];
        NSInteger code = [[nullDict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        NSString *str = nullDict[@"ResponseHead"][@"desc"];
        if (code == 1000)  {
            [[MyAlertView sharedInstance]showFrom:str];
            //统计:发表评论发表按钮点击
            NSDictionary *stasticsDic = [NSDictionary dictionaryWithDictionary:dic];
            [MobClick event:@"68" attributes:stasticsDic];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
//懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,RRPWidth, RRPHeight+49)];
        self.tableView.backgroundColor = IWColor(241, 241, 241);
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
    if (section == 0) {
        return 0;
    }else {
        return 0;
    }
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    return cell;
}

#pragma mark - UITableViewDelegate
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 345;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 95;
    }else if(section == 1) {
        return 250;
    }else {
        return 220;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }else {
        return 0;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    if (section == 0) {
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 15, 65, 65)];
        [self.headImageView sd_setImageWithURL:self.imageUrl placeholderImage:[UIImage imageNamed:@"上传图片228-228"]];
        [view addSubview:self.headImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, 17.5, RRPWidth - 100, 40)];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.text = self.sceneryName;
        [view addSubview:self.nameLabel];
        
        self.moneyLanel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, CGRectGetMaxY(self.nameLabel.frame)+5, RRPWidth - 100, 15)];
        self.moneyLanel.font = [UIFont systemFontOfSize:15];
        self.moneyLanel.text = [NSString stringWithFormat:@"￥%@",self.ticketPrice];
        [view addSubview:self.moneyLanel];

    }else if(section == 1) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 150, 18)];
        self.titleLabel.text = @"请选择评价";
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.textColor = IWColor(160, 160, 160);
        [view addSubview:self.titleLabel];
        
        //好评
        self.goodButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.goodButton addTarget:self action:@selector(goodButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"好评2"] forState:(UIControlStateNormal)];
        self.goodButton.frame = CGRectMake(25, CGRectGetMaxY(self.titleLabel.frame)+1, 60, 35);
        [view addSubview:self.goodButton];
        
        //中评
        self.centreButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.centreButton addTarget:self action:@selector(centreButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.centreButton setBackgroundImage:[UIImage imageNamed:@"中评2"] forState:(UIControlStateNormal)];
        self.centreButton.frame = CGRectMake(CGRectGetMaxX(self.goodButton.frame)+ (RRPWidth - 230)/2, CGRectGetMaxY(self.titleLabel.frame)+1, 60, 35);
        [view addSubview:self.centreButton];

        //差评
        self.diffButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.diffButton addTarget:self action:@selector(badButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.diffButton setBackgroundImage:[UIImage imageNamed:@"差评2"] forState:(UIControlStateNormal)];
        self.diffButton.frame = CGRectMake(CGRectGetMaxX(self.centreButton.frame)+ (RRPWidth - 230)/2, CGRectGetMaxY(self.titleLabel.frame)+1, 60, 35);
        [view addSubview:self.diffButton];
        
        self.wireView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.diffButton.frame)+1, RRPWidth, 0.5)];
        self.wireView.backgroundColor = [UIColor blackColor];
        [view addSubview:self.wireView];
        [view addSubview:self.textView];
        self.wireTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lbNums.frame)+1, RRPWidth, 0.5)];
        self.wireTwoView.backgroundColor = [UIColor blackColor];
        [view addSubview:self.wireTwoView];
        [view addSubview:self.lbNums];
        
    }else {
        
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j< 2; j++) {
                self.backView = [[UIView alloc] initWithFrame:CGRectMake((RRPWidth - 352)/5+((RRPWidth - 352)/5 + 88) * i, (88+(RRPWidth - 352)/5) * j, 88, 88)];
                [view addSubview:self.backView];
                self.cameraButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
                self.cameraButton.frame = CGRectMake(0, 8, 80, 80);
                [self.cameraButton addTarget:self action:@selector(cameraButton:) forControlEvents:(UIControlEventTouchUpInside)];
                [self.backView addSubview:self.cameraButton];
                self.removeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
                self.removeButton.frame = CGRectMake(self.backView.frame.size.width-20, 0, 20, 20);
                [self.removeButton addTarget:self action:@selector(removeButton:) forControlEvents:(UIControlEventTouchUpInside)];
                [self.removeButton setBackgroundImage:[UIImage imageNamed:@"发表图片-删除按钮"] forState:(UIControlStateNormal)];
                [self.backView addSubview:self.removeButton];
                //判断给tag值
                if (j == 0) {
                    if (i == 0) {
                        self.removeButton.tag = self.cameraButton.tag = 101;
                        //判断图片数组是否为空，如果为空显示：最多8张，否则显示重新选择+对图片
                        if (self.imageArray.count == 0) {
                            [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"相机_最多8张"] forState:(UIControlStateNormal)];
                            self.removeButton.hidden = YES;
                        }else {
                            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
                            imageView.image = [UIImage imageNamed:@"相机_重新选择透明"];
                            imageView.backgroundColor = [UIColor colorWithRed:0  green:0 blue:0 alpha:0.6];
                            [self.cameraButton addSubview:imageView];
                            [self.cameraButton setBackgroundImage:self.imageArray[0] forState:(UIControlStateNormal)];
                        }
                    }else if (i == 1) {
                        self.removeButton.tag = self.cameraButton.tag = 102;
                        self.cameraButton.userInteractionEnabled = NO;
                        //判断图片数组是否有两张图片，有显示图片，否则隐藏
                        if (self.imageArray.count >= 2) {
                            [self.cameraButton setBackgroundImage:self.imageArray[1] forState:(UIControlStateNormal)];
                        }else {
                            self.backView.hidden = YES;
                        }
                    }else if (i == 2) {
                        self.removeButton.tag = self.cameraButton.tag = 103;
                        self.cameraButton.userInteractionEnabled = NO;
                        if (self.imageArray.count >= 3) {
                            [self.cameraButton setBackgroundImage:self.imageArray[2] forState:(UIControlStateNormal)];
                        }else {
                            self.backView.hidden = YES;
                        }
                    }else {
                        self.removeButton.tag = self.cameraButton.tag = 104;
                        self.cameraButton.userInteractionEnabled = NO;
                        if (self.imageArray.count >= 4) {
                            [self.cameraButton setBackgroundImage:self.imageArray[3] forState:(UIControlStateNormal)];
                        }else {
                            self.backView.hidden = YES;
                        }
                    }
                }else {
                    if (i == 0) {
                    self.removeButton.tag = self.cameraButton.tag = 105;
                    self.cameraButton.userInteractionEnabled = NO;
                    if (self.imageArray.count >= 5) {
                        [self.cameraButton setBackgroundImage:self.imageArray[4] forState:(UIControlStateNormal)];
                    }else {
                        self.backView.hidden = YES;
                    }
                }else if (i == 1) {
                    self.removeButton.tag = self.cameraButton.tag = 106;
                    self.cameraButton.userInteractionEnabled = NO;
                    if (self.imageArray.count >= 6) {
                        [self.cameraButton setBackgroundImage:self.imageArray[5] forState:(UIControlStateNormal)];
                    }else {
                        self.backView.hidden = YES;
                    }
                }else if (i == 2) {
                    self.removeButton.tag = self.cameraButton.tag = 107;
                    self.cameraButton.userInteractionEnabled = NO;
                    if (self.imageArray.count >= 7) {
                        [self.cameraButton setBackgroundImage:self.imageArray[6] forState:(UIControlStateNormal)];
                    }else {
                        self.backView.hidden = YES;
                    }
                }else {
                    self.removeButton.tag = self.cameraButton.tag = 108;
                    self.cameraButton.userInteractionEnabled = NO;
                    if (self.imageArray.count >= 8) {
                        [self.cameraButton setBackgroundImage:self.imageArray[7] forState:(UIControlStateNormal)];
                    }else {
                        self.backView.hidden = YES;
                    }
                }
                }
                [self.backView addSubview:self.removeButton];
            }
        }
    }
    
    return view;
}
//添加图片点击方法
- (void)cameraButton:(UIButton *) sender {
    if (self.imageArray.count != 0) {
        [self.imageArray removeAllObjects];//重新选择之前移除数组的所有图片
    }
    if (sender.tag == 101) {
        
        BoPhotoPickerViewController *picker = [[BoPhotoPickerViewController alloc] init];
        picker.maximumNumberOfSelection = 8;
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
        //统计:发表评论相机点击
        [MobClick event:@"67"];
        [self presentViewController:navigation animated:YES completion:nil];
    }
}
//删除图片
- (void)removeButton:(UIButton *) sender {
    switch (sender.tag) {
        case 101:
            [self.imageArray removeObjectAtIndex:0];
            break;
        case 102:
            [self.imageArray removeObjectAtIndex:1];
            break;
        case 103:
            [self.imageArray removeObjectAtIndex:2];
            break;
        case 104:
            [self.imageArray removeObjectAtIndex:3];
            break;
        case 105:
            [self.imageArray removeObjectAtIndex:4];
            break;
        case 106:
            [self.imageArray removeObjectAtIndex:5];
            break;
        case 107:
            [self.imageArray removeObjectAtIndex:6];
            break;
        case 108:
            [self.imageArray removeObjectAtIndex:7];
            break;
        default:
            break;
    }
    //刷新照片分区
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    [self.tableView reloadSections:indexSet withRowAnimation:(UITableViewRowAnimationAutomatic)];

}


#pragma mark - BoPhotoPickerProtocol
- (void)photoPickerDidCancel:(BoPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPicker:(BoPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    for (int i =0 ; i< assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [self.imageArray addObject:tempImg];
        }
    //刷新照片分区
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    [self.tableView reloadSections:indexSet withRowAnimation:(UITableViewRowAnimationAutomatic)];
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    if (self.imageArray.count != 0) {
        [self.imageArray removeAllObjects];
    }
    [self.imageArray addObject:image];
    //刷新照片分区
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    [self.tableView reloadSections:indexSet withRowAnimation:(UITableViewRowAnimationAutomatic)];
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




- (UITextView *)textView {
    if (_textView == nil) {
        self.textView = [[HWTextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.wireView.frame), RRPWidth, 135)];
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.placeholder = @"此次行程感受如何，服务是否满意？快来告诉大家吧!";
        self.textView.placeholderColor = IWColor(216, 216, 216);
        self.textView.delegate = self;
        self.textView.font = [UIFont systemFontOfSize:12];
    }
    return _textView;
}
- (UILabel *)lbNums {
    if (_lbNums == nil) {
        //字数限制
        self.lbNums = [[UILabel alloc] initWithFrame:CGRectMake(self.textView.frame.size.width - 80, CGRectGetMaxY(self.textView.frame)+3, 75, 12)];
        self.lbNums.backgroundColor = [UIColor clearColor];
        self.lbNums.font = [UIFont systemFontOfSize:12];
        self.lbNums.textColor = IWColor(115, 115, 115);
        self.lbNums.textAlignment = 2;
        self.lbNums.text = @"至少15个字哦";
        [self.view addSubview:self.lbNums];
    }
    return _lbNums;
}
#pragma mark - UITextViewDelegate
//改变return功能
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark 键盘即将弹出
-(void)keyboardWillShow:(NSNotification *) notification {
    //键盘的frame
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardheight = keyboardRect.size.height;
    self.keyboardheight = keyboardheight;
    
    self.tableView.frame = CGRectMake(0, -keyboardheight/2, RRPWidth, RRPHeight);
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
    [self.textView resignFirstResponder];
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = IWColor(241, 241, 241);
    return view;
}

//评论类型按钮
- (void)goodButton:(UIButton *)sender {
    if (goodclick == NO) {
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"好评1"] forState:(UIControlStateNormal)];
        [self.centreButton setBackgroundImage:[UIImage imageNamed:@"中评2"] forState:(UIControlStateNormal)];
        [self.diffButton setBackgroundImage:[UIImage imageNamed:@"差评2"] forState:(UIControlStateNormal)];
        self.commentResult = @"好评";
        //统计:发表评论好评点击
        [MobClick event:@"64"];
        goodclick = YES;
        centerclick = NO;
        badclick = NO;
    }else
    {
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"好评2"] forState:(UIControlStateNormal)];
        self.commentResult = @"";
        goodclick = NO;
    }

}
- (void)centreButton:(UIButton *)sender {
    if (centerclick == NO) {
        [self.centreButton setBackgroundImage:[UIImage imageNamed:@"中评1"] forState:(UIControlStateNormal)];
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"好评2"] forState:(UIControlStateNormal)];
        [self.diffButton setBackgroundImage:[UIImage imageNamed:@"差评2"] forState:(UIControlStateNormal)];
        self.commentResult = @"中评";
        //统计:发表评论中评点击
        [MobClick event:@"65"];
        centerclick = YES;
        goodclick = NO;
        badclick = NO;
    }else
    {
        [self.centreButton setBackgroundImage:[UIImage imageNamed:@"中评2"] forState:(UIControlStateNormal)];
        self.commentResult = @"";
        centerclick = NO;
    }
}
- (void)badButton:(UIButton *)sender
{
    if (badclick == NO) {
       [self.diffButton setBackgroundImage:[UIImage imageNamed:@"差评1"] forState:(UIControlStateNormal)];
       [self.goodButton setBackgroundImage:[UIImage imageNamed:@"好评2"] forState:(UIControlStateNormal)];
       [self.centreButton setBackgroundImage:[UIImage imageNamed:@"中评2"] forState:(UIControlStateNormal)];
        self.commentResult = @"差评";
        //统计:发表评论差评点击
        [MobClick event:@"66"];
        badclick = YES;
        goodclick = NO;
        centerclick = NO;
    }else
    {
        [self.diffButton setBackgroundImage:[UIImage imageNamed:@"差评2"] forState:(UIControlStateNormal)];
        self.commentResult = @"";
        badclick = NO;
    }
}
- (void) viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
- (void) viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    
    if ([self.commentResult isEqualToString:@"好评"]) {
       [RRPAllCityHandle shareAllCityHandle].commentResult = @"好评";
    } 
    
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
