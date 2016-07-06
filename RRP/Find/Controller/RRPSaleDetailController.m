//
//  RRPSaleDetailController.m
//  RRP
//
//  Created by WangZhaZha on 16/3/9.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPSaleDetailController.h"
#import "RRPSaleDetailPicCell.h"
#import "RRPChDetilsCommentCell.h"
#import "RRPChDetilsFeatureCell.h"
#import "RRPTicketTypeCell.h"
#import "RRPCommentCell.h"
#import "RRPChDetailsAllCommentCell.h"
#import "RRPCDCommmentController.h"
#import "RRPChDetilsInformCell.h"
#import "RRPChDetilsCommendCell.h"
#import "RRPChDetilsServiceCell.h"
#import "RRPNoticeController.h"
#import "RRPCoverView.h"
#import "RRPDetailsImageController.h"
#import "RRPOrderView.h"
#import "RRPDetailsImageController.h"
#import "RRPScenicTicketCell.h"
#import "RRPTicketPopMoreCell.h"
#import "RRPHomeSelectedDetailModel.h"
#import "RRPHomeSelectedCommentModel.h"
#import "RRPSelectedTicketModel.h"
#import "RRPCollectionModel.h"
#import "RRPChDetailsCommentShowCell.h"

typedef NS_ENUM(NSInteger, refState){
    refStateHeader = 0,
    refStateFooter = 1,
};
@interface RRPSaleDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL click;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)RRPCoverView *coverView;
@property (nonatomic,copy)NSString *moreStr;
@property (nonatomic,strong)NSMutableArray *imageUrlArray;
@property (nonatomic,strong)NSMutableArray *ticketArray;
@property (nonatomic,strong)RRPHomeSelectedDetailModel *homeSelectedDetailModel;
@property (nonatomic,strong)RRPHomeSelectedCommentModel *selectedCommentModel;
@property (nonatomic,strong)RRPSelectedTicketModel *selectedTicketModel;
@property (nonatomic, strong)UIBarButtonItem *saveButton;
@property (nonatomic, strong)NSMutableArray *saveListArr;
@property (nonatomic, strong)NSDictionary *orderDic;
@property (nonatomic, strong)NSString *ticketid;//票ID
@property (nonatomic, strong)RRPOrderModel *orderModel;
@property (nonatomic, strong)NSString *sellerprice;//票价
@property (nonatomic, strong)NSMutableArray *commentImageArr;//评论图片
@property (nonatomic, assign)NSInteger commentStatus;//评论有无
@property (nonatomic, assign)NSInteger commentPicStatus;//评论照片有无


@end

@implementation RRPSaleDetailController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.saveListArr = [@[] mutableCopy];
    self.commentImageArr = [@[] mutableCopy];
    //判断收藏
    //请求数据
    [self requestCollectionData];

}
//请求数据
- (void)requestCollectionData
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"collection_scenery" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:MySave parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //检查字典中是否含有：“<NULL>”这样的字符串，有就改为“”
        NSDictionary * nullDict = [RRPPrintObject nullDic:dict];
        NSInteger code = [[nullDict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000)  {
            for (NSDictionary *dic in nullDict[@"ResponseBody"]) {
                RRPCollectionModel *collectionModel = [RRPCollectionModel mj_objectWithKeyValues:dic];
                NSString *sceneryID =  collectionModel.sid;
                [self.saveListArr addObject:sceneryID];
            }
        }
        
        if ([self.saveListArr containsObject:self.sceneryID]) {
            self.saveButton.image = [UIImage imageNamed:@"已收藏"];
            click = NO;
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.sceneryName;
    self.moreStr = @"普通";
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.imageUrlArray = [@[] mutableCopy];
    self.ticketArray = [@[] mutableCopy];
    //取消滚动视图的自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    //注册cell 图片
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPSaleDetailPicCell" bundle:nil] forCellReuseIdentifier:@"RRPSaleDetailPicCell"];
    //点评
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPChDetilsCommentCell" bundle:nil] forCellReuseIdentifier:@"RRPChDetilsCommentCell"];
    //景区特色
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPChDetilsFeatureCell" bundle:nil] forCellReuseIdentifier:@"RRPChDetilsFeatureCell"];
    //门票类型
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPTicketTypeCell" bundle:nil] forCellReuseIdentifier:@"RRPTicketTypeCell"];
    //点评
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPCommentCell" bundle:nil] forCellReuseIdentifier:@"RRPCommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPChDetailsCommentShowCell" bundle:nil] forCellReuseIdentifier:@"RRPChDetailsCommentShowCell"];
    //查看全部评论
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPChDetailsAllCommentCell" bundle:nil] forCellReuseIdentifier:@"RRPChDetailsAllCommentCell"];
    //在线客服
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPChDetilsServiceCell" bundle:nil] forCellReuseIdentifier:@"RRPChDetilsServiceCell"];
   
       //门票
//    [self.tableView registerNib:[UINib nibWithNibName:@"RRPSaleDetailTicketCell" bundle:nil] forCellReuseIdentifier:@"RRPSaleDetailTicketCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPScenicTicketCell" bundle:nil] forCellReuseIdentifier:@"RRPScenicTicketCell"];
    //弹出更多门票按钮
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPTicketPopMoreCell" bundle:nil] forCellReuseIdentifier:@"RRPTicketPopMoreCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    //添加tableView
    [self.view addSubview:_tableView];
    //右侧收藏分享按钮
    [self layoutRightButton];

    //数据请求
    [self requestData];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popTickrtOrderView:) name:@"弹出订购页面" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"登录" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Login:) name:@"user" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNavigationBar:) name:@"显示导航栏" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popMoreTicketAction:) name:@"弹出更多门票" object:nil];
    [RRPAllCityHandle shareAllCityHandle].sceneryID = self.sceneryID;
}
//右侧收藏分享按钮
- (void)layoutRightButton
{
    self.saveButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"收藏"] style:(UIBarButtonItemStyleDone) target:self action:@selector(saveAction:)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:(UIBarButtonItemStyleDone) target:self action:@selector(shareAction:)];
    NSArray *rightButtonArray = [[NSArray alloc] initWithObjects:shareButton,self.saveButton, nil];
    self.navigationItem.rightBarButtonItems = rightButtonArray;
    
}
//收藏
- (void)saveAction:(UIBarButtonItem *)item
{
    //判断是否登录了
    NSString *Register = [[NSUserDefaults standardUserDefaults]objectForKey:@"register"];
    if ([Register isEqualToString:@"YES"])  {
        
        if (click == NO) {
            self.saveButton.image = [UIImage imageNamed:@"已收藏"];
            [self requestCollection];
            click = YES;
        }else {
            self.saveButton.image = [UIImage imageNamed:@"收藏"];
            [self deleteCollection];
            click = NO;
        }
        
    }else {
        [[MyAlertView sharedInstance]showFrom:@"登录即可收藏"];
        RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
}
#pragma mark - 收藏和取消收藏
//收藏
- (void)requestCollection
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"add_collection" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.sceneryID forKey:@"sceneryid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    //统计:收藏
    NSDictionary *statistacsDic = @{@"sceneryname":self.sceneryName,@"sceneryid":self.sceneryID};
    [MobClick event:@"14" attributes:statistacsDic];
    
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [manager POST:MyCollection parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取数据
        NSDictionary *dict = responseObject;
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            NSString *msg = dict[@"ResponseBody"][@"msg"];
            [[MyAlertView sharedInstance]showFrom:msg];
            NSInteger code = [[dict[@"ResponseBody"] valueForKey:@"code"] integerValue];
            if (code == 2000) {
                click = NO;
                self.saveButton.image = [UIImage imageNamed:@"已收藏"];
            }else if (code == 4002)
            {
                [self deleteCollection];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
//删除收藏
- (void)deleteCollection
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"delete_collection" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.sceneryID forKey:@"sceneryid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [manager POST:MyCollection parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取数据
        NSDictionary *dict = responseObject;
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        NSString *msg = dict[@"ResponseBody"][@"msg"];
        [[MyAlertView sharedInstance]showFrom:msg];
        if (code == 1000) {
            NSString *msg = dict[@"ResponseBody"][@"msg"];
            [[MyAlertView sharedInstance]showFrom:msg];
            NSInteger code = [dict[@"ResponseBody"][@"code"] integerValue];
            if (code == 2000) {
                click = NO;
                self.saveButton.image = [UIImage imageNamed:@"收藏"];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
    
}
//分享
- (void)shareAction:(UIBarButtonItem *)item
{
    //判断是否登录了
    NSString *Register = [[NSUserDefaults standardUserDefaults]objectForKey:@"register"];
    if ([Register isEqualToString:@"YES"])  {
        NSString *titleStr = [NSString stringWithFormat:@"【人人票推荐】%@",self.sceneryName];
        NSString *urlStr = [RRPFindTopModel shareRRPFindTopModel].download_share;
        //1、创建分享参数
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.homeSelectedDetailModel.summary
                                         images:@[[self.imageUrlArray firstObject]]
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlStr,self.sceneryID]]
                                          title:titleStr
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   }];
        //统计:分享
        NSDictionary *dict = @{@"sceneryname":self.sceneryName,@"sceneryID":self.sceneryID};
        [MobClick event:@"15" attributes:dict];

    }else {
        [[MyAlertView sharedInstance]showFrom:@"登录即可分享"];
        RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
//数据请求
- (void)requestData
{
    
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"scenery_detail" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.sceneryID forKey:@"sceneryid"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:HomeSelectedDetails parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //获取数据
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dict = [RRPPrintObject nullDic:dic];        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            [self.imageUrlArray removeAllObjects];
            [self.ticketArray removeAllObjects];
            //遍历ResponseBody
            self.homeSelectedDetailModel = [[RRPHomeSelectedDetailModel alloc] init];
            self.homeSelectedDetailModel.comment_count = [dict[@"ResponseBody"] valueForKey:@"comment_count"];
            self.homeSelectedDetailModel.address =[dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"address"];
            self.homeSelectedDetailModel.businesshours = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"businesshours"];
            self.homeSelectedDetailModel.favouredpolicy = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"favouredpolicy"];
            self.homeSelectedDetailModel.latitude = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"latitude"];
            self.homeSelectedDetailModel.longitude = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"longitude"];
            self.homeSelectedDetailModel.reminder = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"reminder"];
            self.homeSelectedDetailModel.avg_score = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"avg_score"];
            self.homeSelectedDetailModel.summary = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"summary"];
            self.homeSelectedDetailModel.collection_status = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"collection_status"];
            //            //判断评论是否为空
            NSInteger commentStatus = [dict[@"ResponseBody"][@"comment_one"][@"list"][@"status"] integerValue];
            self.commentStatus = commentStatus;
            if (commentStatus == 1) {
                self.selectedCommentModel = [RRPHomeSelectedCommentModel mj_objectWithKeyValues:dict[@"ResponseBody"][@"comment_one"][@"list"]];
                [RRPAllCityHandle shareAllCityHandle].selectedCommentModel = self.selectedCommentModel;
                //判断评论图片是否为空
                NSInteger commentPicStatus = [dict[@"ResponseBody"][@"comment_one"][@"comment_img_status"] integerValue];
                self.commentPicStatus = commentPicStatus;
                if (self.commentPicStatus == 1) {
                    //图片数组
                    for (NSString *key in dict[@"ResponseBody"][@"comment_one"][@"personal_comment_img"]) {
                        NSString *image_url =[dict[@"ResponseBody"][@"comment_one"][@"personal_comment_img"] valueForKey:key];
                        NSURL *url = [NSURL URLWithString:image_url];
                        [self.commentImageArr addObject:url];
                    }
                }
            }            //顶部图片
            for (NSString *key in dict[@"ResponseBody"][@"imgurl"]) {
                NSString *imageStr = [dict[@"ResponseBody"][@"imgurl"]       valueForKey:key];
                [self.imageUrlArray addObject:imageStr];
            }
            //遍历字典门票
            for (NSDictionary *ticketDic in dict[@"ResponseBody"][@"ticket"]) {
                self.selectedTicketModel = [RRPSelectedTicketModel mj_objectWithKeyValues:ticketDic];
                [self.ticketArray addObject:self.selectedTicketModel];
            }
        }
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
    
}
- (void)login:(NSNotification *)notification {
    [[MyAlertView sharedInstance]showFrom:@"登录即可订购"];
    RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}
- (void)Login:(NSNotification *)notification {
    [[MyAlertView sharedInstance]showFrom:@"登录即可点赞"];
    RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - 弹出订购页面
- (void)popTickrtOrderView:(NSNotification *)notification
{
    
    UIButton *sender = [notification valueForKey:@"userInfo"][@"value"];
    RRPScenicTicketCell * cell = (RRPScenicTicketCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    RRPSelectedTicketModel *model =  self.ticketArray[path.row-1];
    self.ticketid = model.ID;
    self.sellerprice = model.sellerprice;
    //统计:订购点击
    NSDictionary *dict = @{@"ticketname":model.ticketname,@"ticketID":model.ID};
    [MobClick event:@"20" attributes:dict];
    //请求订票数据
    [self requestOrderView];
    self.navigationController.navigationBar.hidden = YES;
    
}
//请求订票数据
- (void)requestOrderView
{
     NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"order_data" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.ticketid forKey:@"ticketid"];
    [RRPAllCityHandle shareAllCityHandle].ticketid = self.ticketid;
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"user_id"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:HomeOrderWrite parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //检查字典中是否含有：“<NULL>”这样的字符串，有就改为“”
        NSDictionary * nullDict = [RRPPrintObject nullDic:dict];
        self.orderDic = [[NSDictionary alloc] init];
        self.orderDic = nullDict;
        NSInteger code = [[nullDict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000)  {
            RRPOrderModel *orderModel =  [RRPOrderModel mj_objectWithKeyValues:self.orderDic[@"ResponseBody"][@"ticket_data"]];
            self.orderModel = orderModel;
            RRPOrderView *orderView = [[RRPOrderView alloc] initWithFrame:CGRectMake(0,0, RRPWidth, RRPHeight)];
            [orderView removeFromSuperview];
            [self.view addSubview:orderView];
            [RRPAllCityHandle shareAllCityHandle].orderModel = orderModel;
            orderView.orderModel = orderModel;
            orderView.moneyNumberLabel.text = self.sellerprice;
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}
//显示导航栏
- (void)showNavigationBar:(NSNotification *)notification
{
    self.navigationController.navigationBar.hidden = NO;
    //之前移除导航栏 响应者链被破坏 重新显示导航栏的时候需要重新加载页面 才能恢复响应者链
    [self.view addSubview:self.tableView];
}
//懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64-35,RRPWidth, RRPHeight-64+35) style:(UITableViewStyleGrouped)];
        self.tableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(246, 246, 246), IWColor(200, 200, 200));
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}


//下拉刷新
- (void)loadNewData
{
    
    [self requestData];
    [self.tableView.header endRefreshing];
}

#pragma mark - UITableViewDataSource
//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else if (section == 1){
        return 2;
    }else{
        if ([self.moreStr isEqualToString:@"更多"]) {
            
            return self.ticketArray.count+1;
        }else
        {
            //门票类型
            if (self.ticketArray.count <= 3) {
                return  self.ticketArray.count+1;
            }else
            {
                return 5;
            }
            
        }
    }
}
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //景点图片
            RRPSaleDetailPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPSaleDetailPicCell" forIndexPath:indexPath];
            //取消点击样式
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell showDataWithArray:self.imageUrlArray topImage:self.imageURL];
            return cell;
        }else if (indexPath.row == 1) {
            //景点名
            RRPChDetilsFeatureCell *cell =[tableView dequeueReusableCellWithIdentifier:@"RRPChDetilsFeatureCell" forIndexPath:indexPath];
            cell.scenicImageView.image = [UIImage imageNamed:@"sign-list-gps"];
            cell.moreImageView.hidden = YES;
            cell.scenicNameLabel.text = self.homeSelectedDetailModel.address;
            //取消点击样式
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;

        }else if (indexPath.row == 2 ) {
            //评论 星级
            RRPChDetilsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPChDetilsCommentCell" forIndexPath:indexPath];
            //取消点击样式
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell showDataWithStar:self.homeSelectedDetailModel.avg_score CommentCount:self.homeSelectedDetailModel.comment_count];
            return cell;

        }else if (indexPath.row == 3) {
            //查看须知
            RRPChDetilsFeatureCell *cell =[tableView dequeueReusableCellWithIdentifier:@"RRPChDetilsFeatureCell" forIndexPath:indexPath];
            cell.scenicNameLabel.text = @"查看须知";
            //取消点击样式
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }else {
            //在线客服
            RRPChDetilsServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPChDetilsServiceCell" forIndexPath:indexPath];
            //取消点击样式
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.topLine.hidden = YES;
            return cell;
        }
 
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //点评
            if (self.commentStatus == 1) {
                RRPChDetailsCommentShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPChDetailsCommentShowCell" forIndexPath:indexPath];
                [cell shoeDataWithModel:self.selectedCommentModel CommentStatus:1 imageArr:self.commentImageArr];
                if ([self.selectedCommentModel.likeit_status isEqualToString:@"1"]) {
                    cell.usesImageView.image = [UIImage imageNamed:@"sign-list-use"];
                    cell.usesButton.layer.borderColor = IWColor(255, 88, 11).CGColor;
                    cell.usesLabel.textColor = IWColor(255, 88, 11);
                    cell.usesNumaberLabel.textColor = IWColor(255, 88, 11);
                }
                //取消点击样式
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                
            }else
            {
                RRPChDetailsCommentShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPChDetailsCommentShowCell" forIndexPath:indexPath];
                [cell shoeDataWithModel:self.selectedCommentModel CommentStatus:0 imageArr:self.commentImageArr];
                //取消点击样式
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                
            }

        }else {
            //查看全部评论
            RRPChDetailsAllCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPChDetailsAllCommentCell" forIndexPath:indexPath];
            //取消点击样式
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        
    }else {
        
            if ([self.moreStr isEqualToString:@"更多"]) {
                if (indexPath.row == 0) {
                    //门票类型
                    RRPTicketTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPTicketTypeCell" forIndexPath:indexPath];
                    
                    //取消点击样式
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    return cell;
                    
                }else
                {
                    RRPScenicTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPScenicTicketCell" forIndexPath:indexPath];
                    RRPSelectedTicketModel *model = self.ticketArray[indexPath.row-1];
                    [cell showDataWithModel:model];
                    //取消点击样式
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    return cell;
                    
                    
                }
            }else
            {
                //未展开状态
                if (self.ticketArray.count <= 3) {
                    //票的张数小于等于3
                    if (indexPath.row == 0) {
                        //门票类型
                        RRPTicketTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPTicketTypeCell" forIndexPath:indexPath];
                        //取消点击样式
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        return cell;
                        
                    }else
                    {
                        RRPScenicTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPScenicTicketCell" forIndexPath:indexPath];
                        RRPSelectedTicketModel *model = self.ticketArray[indexPath.row-1];
                        [cell showDataWithModel:model];
                        //取消点击样式
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        return cell;
                        
                    }
                    
                }else
                {
                    //票的个数大于3
                    if (indexPath.row == 0) {
                        //门票类型
                        RRPTicketTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPTicketTypeCell" forIndexPath:indexPath];
                        //取消点击样式
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        return cell;
                        
                    }else if (indexPath.row == 4)
                    {
                        
                        RRPTicketPopMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPTicketPopMoreCell" forIndexPath:indexPath];
                        //取消点击样式
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        return cell;
                        
                    }else
                    {
                        RRPScenicTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPScenicTicketCell" forIndexPath:indexPath];
                        RRPSelectedTicketModel *model = self.ticketArray[indexPath.row-1];
                        [cell showDataWithModel:model];
                        //取消点击样式
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        return cell;
                        
                    }
                }
            }
            
    }
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor clearColor];
//    return cell;
}





#pragma mark - UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return RRPWidth/740*350;
        }else
        {
            return 50;
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (self.commentStatus == 1) {
                return 310;
            }else{
                return 0;
            }
        }else
        {
            return 50;
        }
    }else
    {
        if ([self.moreStr isEqualToString:@"更多"]) {
            if (indexPath.row == 0) {
                return 50;
            }else
            {
                return [RRPScenicTicketCell cellHeight:self.selectedTicketModel];
            }
            
        }else
        {
            
            if (self.ticketArray.count <= 3) {
                //票的个数小于等于3
                if (indexPath.row == 0) {
                    return 50;
                }else
                {
                    //                        return [RRPSaleDetailTicketCell cellHeight:self.selectedTicketModel];
                    return [RRPScenicTicketCell cellHeight:self.selectedTicketModel];
                }
            }else
            {
                //票的个数大于3
                if (indexPath.row == 0) {
                    return 50;
                }else if (indexPath.row == 4)
                {
                    return 20;
                }else
                {
                    //                       return [RRPSaleDetailTicketCell cellHeight:self.selectedTicketModel];
                    return [RRPScenicTicketCell cellHeight:self.selectedTicketModel];
                    
                }
            }
        }

    
    }
     
//    if ([self.moreStr isEqualToString:@"更多"]) {
//        if (indexPath.row == 0) {
//            return 50;
//        }else
//        {
//            return 120;
//        }
//
//    }
//    
//    if (indexPath.row == 0) {
//        return 50;
//    }else if(indexPath.row == 4)
//    {
//        return 20;
//    
//    }else
//    {
//        return 120;
//    }

}
//区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else if (section == 1 ) {
        return 13;
    }else {
        return 13;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 13)];
    view.backgroundColor = IWColor(246, 246, 246);
    return view;
}

//区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

//区尾
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 13)];
    view.backgroundColor = [UIColor clearColor];
    return view;

}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
        {
            //跳到图片详情展示页面
            RRPDetailsImageController *image = [[RRPDetailsImageController alloc] init];
            image.imageURLArray = self.imageUrlArray;
            [self.navigationController pushViewController:image animated:YES];

        
        }else if (indexPath.row == 2)
        {
            //查看全部评论
            RRPCDCommmentController *commentVC = [[RRPCDCommmentController alloc] init];
            commentVC.sceneryid = self.sceneryID;
            commentVC.type = @"全部";
            //统计:评论点击
            NSDictionary *dict = @{@"sceneryname":self.sceneryName,@"sceneryID":self.sceneryID};
            [MobClick event:@"17" attributes:dict];
            [self.navigationController pushViewController:commentVC animated:YES];

        }else if (indexPath.row == 3) {
            //查看须知
            RRPNoticeController *noticeVC = [[RRPNoticeController alloc] init];
            noticeVC.homeSelectedModel = self.homeSelectedDetailModel;
            //统计:须知点击
            NSDictionary *dict = @{@"sceneryname":self.sceneryName,@"sceneryID":self.sceneryID};
            [MobClick event:@"18" attributes:dict];
            [self.navigationController pushViewController:noticeVC animated:YES];
        }else if(indexPath.row == 4)
        {
            //在线客服
            self.coverView = [[RRPCoverView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, RRPHeight)];
            self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptoController:)];
            tap.numberOfTapsRequired = 1;
            //统计:在线客服点击
            NSDictionary *dict = @{@"sceneryname":self.sceneryName,@"sceneryID":self.sceneryID};
            [MobClick event:@"19" attributes:dict];
            //向视图添加手势
            [self.coverView addGestureRecognizer:tap];
            [self.view addSubview:self.coverView];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            //查看全部评论
            RRPCDCommmentController *commentVC = [[RRPCDCommmentController alloc] init];
            commentVC.sceneryid = self.sceneryID;
            commentVC.type = @"全部";
            //统计:评论点击
            NSDictionary *dict = @{@"sceneryname":self.sceneryName,@"sceneryID":self.sceneryID};
            [MobClick event:@"17" attributes:dict];
            [self.navigationController pushViewController:commentVC animated:YES];

        }
    }
}
#pragma mark - 手势方法的实现
//轻拍
- (void)tap:(UITapGestureRecognizer *)tap {
    RRPDetailsImageController *image = [[RRPDetailsImageController alloc] init];
    [self.navigationController pushViewController:image animated:YES];
}
- (void)taptoController:(UITapGestureRecognizer *)tap
{
    [self.coverView removeFromSuperview];
        
}

//弹出更多
- (void)popMoreTicketAction:(NSNotification *)notification
{
    
  self.moreStr = @"更多";
  [self.tableView reloadData];
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
