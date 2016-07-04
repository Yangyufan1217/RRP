//
//  RRPChoicenessDetailsController.m
//  RRP
//
//  Created by sks on 16/2/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPChoicenessDetailsController.h"
#import "RRPChDetailsMapCell.h"
#import "RRPChDetilsCommentCell.h"
#import "RRPChDetilsFeatureCell.h"
#import "RRPChDetailsCommentShowCell.h"
#import "RRPChDetailsAllCommentCell.h"
#import "RRPChDetilsInformCell.h"
#import "RRPChDetilsServiceCell.h"
#import "RRPChDetilsCommendCell.h"
#import "RRPChDetilsCommendContentCell.h"
#import "RRPDetailsImageController.h"
#import "RRPCDCommmentController.h"
#import "RRPCoverView.h"
#import "RRPChoicenessViewController.h"
#import "RRPNoticeController.h"
#import "RRPOrderController.h"
#import "RRPCoverViewCell.h"
#import "RRPmoneyCell.h"
#import "RRPTicketTypeCell.h"
#import "RRPTicketPopMoreCell.h"
#import "RRPOrderView.h"
#import "RRPHomeSelectedDetailModel.h"
#import "RRPSelectedTicketModel.h"
#import "RRPScenicTicketCell.h"
#import "RRPHomeSelectedCommentModel.h"
#import "RRPPeripheryModel.h"
#import "RRPOrderModel.h"
#import "RRPAllCityHandle.h"
#import "RRPCollectionModel.h"
#import "RRPHomeAmbitusController.h"
@interface RRPChoicenessDetailsController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,RRPCoverViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
{
    BOOL click;
}
enum refreshState
{
    refreshHeader,
    refreshFooter
};
typedef enum refreshState refreshState;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *moneyTableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) RRPCoverView *coverView;//点击须知出现的蒙层
@property (nonatomic,copy)NSString *moreStr;//标记门票状态
@property (nonatomic,strong)RRPHomeSelectedDetailModel *homeSelectedDetailModel;
@property (nonatomic,strong)RRPSelectedTicketModel *selectedTicketModel;
@property (nonatomic, strong)RRPHomeSelectedCommentModel *selectedCommentModel;
@property (nonatomic, strong)RRPPeripheryModel *peripheryModel;//周边推荐
@property (nonatomic, strong)NSMutableArray *peripheryAllArray;//周边推荐全部数据
@property (nonatomic, strong)NSMutableArray *peripheryArray;//周边推荐前四个
//详情顶部图片数组
@property (nonatomic,strong)NSMutableArray *imageUrlArray;//顶部图片数组
@property (nonatomic,strong)NSMutableArray *ticketArray;//票数组
@property (nonatomic,strong)NSMutableArray *commentImageArr;//评论图片
@property (nonatomic, assign) CLLocationDegrees selfLatitude;//纬度
@property (nonatomic, assign) CLLocationDegrees selfLongitude;//经度
@property (nonatomic, strong)UIBarButtonItem *saveButton;
@property (nonatomic, strong)NSMutableArray *saveListArr;
@property (nonatomic, strong)NSString *ticketid;//票ID
@property (nonatomic, strong)NSDictionary *orderDic;
@property (nonatomic, strong)RRPOrderModel *orderModel;
@property (nonatomic, strong)NSString *sellerprice;//票
@property (nonatomic, assign)NSInteger commentStatus;//评论有无
@property (nonatomic, assign)NSInteger commentPicStatus;//评论照片有无

@end

@implementation RRPChoicenessDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.sceneryName;
    self.moreStr = @"普通";
    self.ticketArray = [@[] mutableCopy];
    self.imageUrlArray = [@[] mutableCopy];
    self.peripheryAllArray = [@[] mutableCopy];
    self.peripheryArray = [@[] mutableCopy];
    self.commentImageArr = [@[] mutableCopy];
    self.navigationItem.title = self.sceneryName;
    //取消滚动视图的自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout = flowLayout;
    //cell在X轴上的间距,默认10
    self.flowLayout.minimumInteritemSpacing = 10;
    //cell在Y轴上的间距,默认10
    self.flowLayout.minimumLineSpacing = 10;
    //滚动方向,默认垂直滚动
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    [self.view addSubview:self.tableView];
    [self registerTableControl];
    //右侧收藏分享按钮
    [self layoutRightButton];
    //左侧返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popMoreTicketAction:) name:@"弹出更多门票" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popTickrtOrderView:) name:@"弹出订购页面" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"登录" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Login:) name:@"user" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNavigationBar:) name:@"显示导航栏" object:nil];
    //注册通知 加星 实现方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AllCommentAction:) name:@"全部评论" object:nil];
    
    //数据请求
    [self requestDataWithPage:1 ID:self.sceneryID];
    [self requestAmbitusDataWithPage:1];
    [RRPAllCityHandle shareAllCityHandle].sceneryID = self.sceneryID;
    
}
//左侧返回按钮
- (void)returnAction:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}
//右侧收藏分享按钮
- (void)layoutRightButton
{
    self.saveButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"收藏"] style:(UIBarButtonItemStyleDone) target:self action:@selector(saveAction:)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:(UIBarButtonItemStyleDone) target:self action:@selector(shareAction:)];
    NSArray *rightButtonArray = [[NSArray alloc] initWithObjects:shareButton,self.saveButton,nil];
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
    //统计:收藏
    NSDictionary *statistacsDic = @{@"sceneryname":self.sceneryName,@"sceneryid":self.sceneryID};
    [MobClick event:@"14" attributes:statistacsDic];
    
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [manager POST:MyCollection parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取数据
        NSDictionary *dict = responseObject;
//        NSLog(@"收藏%@",dict);
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
//        NSLog(@"收藏%@",dict);
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
- (void)requestDataWithPage:(NSInteger)page ID:(NSString *)sceneryID
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"scenery_detail" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.sceneryID forKey:@"sceneryid"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:HomeSelectedDetails parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {    
        //获取数据
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dict = [RRPPrintObject nullDic:dic];
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            [self.imageUrlArray removeAllObjects];
            [self.ticketArray removeAllObjects];
            [self.commentImageArr removeAllObjects];
            //遍历ResponseBody
            self.homeSelectedDetailModel = [[RRPHomeSelectedDetailModel alloc] init];
            self.homeSelectedDetailModel.comment_count = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"comment_count"];
            self.homeSelectedDetailModel.address =[dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"address"];
            self.homeSelectedDetailModel.businesshours = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"businesshours"];
            self.homeSelectedDetailModel.favouredpolicy = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"favouredpolicy"];
            self.homeSelectedDetailModel.latitude = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"latitude"];
            self.homeSelectedDetailModel.longitude = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"longitude"];
            self.homeSelectedDetailModel.reminder = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"reminder"];
            self.homeSelectedDetailModel.avg_score = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"avg_score"];
            self.homeSelectedDetailModel.summary = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"summary"];
            self.homeSelectedDetailModel.collection_status = [dict[@"ResponseBody"][@"scenery_about"] valueForKey:@"collection_status"];
            //判断评论是否为空
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
            }
            
            //顶部图片
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
//请求周边推荐数据
- (void)requestAmbitusDataWithPage:(NSInteger)page
{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"peripheral_ticket" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.sceneryID forKey:@"sceneryid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic removeObjectForKey:@"location"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic removeObjectForKey:@"selected"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"1" forKey:@"limit"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:HomePeripheral parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //获取数据
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //获取数据
        NSDictionary *dict = dic;
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            [self.peripheryAllArray removeAllObjects];
            [self.peripheryArray removeAllObjects];
            //遍历ResponseBody
            for (NSDictionary *dic in dict[@"ResponseBody"]) {
                self.peripheryModel = [RRPPeripheryModel mj_objectWithKeyValues:dic];
                [self.peripheryAllArray addObject:self.peripheryModel];
            }
            //详情页展示
            for (int i = 0; i <= 3; i++) {
                [self.peripheryArray addObject:self.peripheryAllArray[i]];
            }
        }
      [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}
//注册cell
- (void)registerTableControl {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.moneyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.moneyTableView registerNib:[UINib nibWithNibName:@"RRPmoneyCell" bundle:nil] forCellReuseIdentifier:@"RRPmoneyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPChDetailsMapCell" bundle:nil] forCellReuseIdentifier:@"RRPChDetailsMapCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPChDetilsCommentCell" bundle:nil] forCellReuseIdentifier:@"RRPChDetilsCommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPChDetilsFeatureCell" bundle:nil] forCellReuseIdentifier:@"RRPChDetilsFeatureCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPChDetailsCommentShowCell" bundle:nil] forCellReuseIdentifier:@"RRPChDetailsCommentShowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPChDetailsAllCommentCell" bundle:nil] forCellReuseIdentifier:@"RRPChDetailsAllCommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPChDetilsInformCell" bundle:nil] forCellReuseIdentifier:@"RRPChDetilsInformCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPChDetilsServiceCell" bundle:nil] forCellReuseIdentifier:@"RRPChDetilsServiceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPChDetilsCommendCell" bundle:nil] forCellReuseIdentifier:@"RRPChDetilsCommendCell"];
    //门票类型
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPTicketTypeCell" bundle:nil] forCellReuseIdentifier:@"RRPTicketTypeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPScenicTicketCell" bundle:nil] forCellReuseIdentifier:@"RRPScenicTicketCell"];
    //更多门票
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPTicketPopMoreCell" bundle:nil] forCellReuseIdentifier:@"RRPTicketPopMoreCell"];
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"RRPChDetilsCommendContentCell" bundle:nil] forCellWithReuseIdentifier:@"RRPChDetilsCommendContentCell"];
}
//懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,RRPWidth, RRPHeight-64)];
        self.tableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(246, 246, 246), IWColor(200, 200, 200));
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    }
    return _tableView;
}
//最新的数据
- (void)loadNewData
{
    [self requestDataWithPage:1 ID:self.sceneryID];
    [self requestAmbitusDataWithPage:1];
    [self.tableView.header endRefreshing];
}
- (void)setUpRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.header beginRefreshing];
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
        //NSLog(@"订单详情%@",dict);
        //检查字典中是否含有：“<NULL>”这样的字符串，有就改为“”
        NSDictionary * nullDict = [RRPPrintObject nullDic:dict];
        self.orderDic = [[NSDictionary alloc] init];
        self.orderDic = nullDict;
        //NSLog(@"订单详情%@",self.orderDic);
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
        [self.moneyTableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
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


//显示导航栏
- (void)showNavigationBar:(NSNotification *)notification
{
    self.navigationController.navigationBar.hidden = NO;
    //之前移除导航栏 响应者链被破坏 重新显示导航栏的时候需要重新加载页面 才能恢复响应者链
    [self.view addSubview:self.tableView];
    
}


#pragma mark - UITableViewDataSource
//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      if (section == 0) {
            return 0;
        }else if (section == 1) {
            return 2;
        }else if (section == 2) {
            return 2;
        }else if (section == 3) {
            return 1;
        }else if (section == 4) {
            return 1;
        }else if (section == 5){
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

        }else
        {
            return 2;
        }
    }
//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

//cell展示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        //第一分区
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                //地图
                RRPChDetailsMapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPChDetailsMapCell" forIndexPath:indexPath];
                //取消点击样式
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell showData:self.homeSelectedDetailModel];
                return cell;
            }else{
//            }else if (indexPath.row == 1) {
                //评星
                RRPChDetilsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPChDetilsCommentCell" forIndexPath:indexPath];
                //取消点击样式
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell showDataWithStar:self.homeSelectedDetailModel.avg_score CommentCount:self.homeSelectedDetailModel.comment_count];
                return cell;
//            }else {
//                //景点特色
//                RRPChDetilsFeatureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPChDetilsFeatureCell" forIndexPath:indexPath];
//                //取消点击样式
//                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//                return cell;
                
            }
            //第二分区 评论
        }else if (indexPath.section == 2) {
            //评论
            if (indexPath.row == 0) {
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
            //第三分区 须知
        }else if (indexPath.section == 3) {
            //须知
            RRPChDetilsInformCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPChDetilsInformCell" forIndexPath:indexPath];
            //取消点击样式
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell showDataWithSelectedDetailModel:self.homeSelectedDetailModel];
            return cell;
            //第四分区
        }else if (indexPath.section == 4) {
            //在线客服
            RRPChDetilsServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPChDetilsServiceCell" forIndexPath:indexPath];
            //取消点击样式
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
            //第五分区
        }else if(indexPath.section == 5){
                
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
    
         //第六分区
        }else{
            if (indexPath.row == 0) {
                //给tableView第六分区的第一个cell添加collectionView
                UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                //取消点击样式
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell addSubview:self.collectionView];//把collectionView添加到tableView的cell上
                return cell;
            }else {
                //第六分区的第二个cell
                //查看全部评论
                RRPChDetilsCommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPChDetilsCommendCell" forIndexPath:indexPath];
                //取消点击样式
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
        }
}

#pragma mark - UITableViewDelegate
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
       if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                if (self.commentStatus == 1) {
                    return [RRPChDetailsCommentShowCell cellHeight:self.commentImageArr.count];
                }else{
                    return 0;
                }
            }else {                
                    return 50;
            }
        }else if (indexPath.section == 3) {
            
            return [RRPChDetilsInformCell cellHeight:self.homeSelectedDetailModel];
            
        }else if (indexPath.section == 6) {
            if (indexPath.row == 0) {
                return 388;
            }else {
                return 50;
            }
        }else if(indexPath.section == 5){
        
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
                        return [RRPScenicTicketCell cellHeight:self.selectedTicketModel];
                    
                    }
                }
            }
        }else
        {
            return 50;
        }

   }
//区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
        if (section == 0) {
            return RRPWidth/740*350;
        }else if (section == 1) {
            return 0;
        }else if (section == 2) {
            return 12.5;
        }else if (section == 6) {
            return 62.5;
        }else if (section == 5)
        {
            return 12.5;
        }else
        {
            return 12.5;
        }
   }
//区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        if (section == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, RRPWidth/740*350)];
            imageView.userInteractionEnabled = YES;
//        imageView.image = [UIImage imageNamed:@"精选封面"];
        NSURL *imageURL = [NSURL URLWithString:[self.imageUrlArray firstObject]];
        [imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"当季热玩750-326"]];
            
            //创建手势
            self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            //向视图添加手势
            [imageView addGestureRecognizer:self.tap];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(RRPWidth - 50, RRPWidth/740*350 - 30, 40, 20)];
            label.textColor = IWColor(250, 250, 250);
//            label.text = @"55张";
            label.text =[NSString stringWithFormat:@"%ld张",self.imageUrlArray.count];
            label.adjustsFontSizeToFitWidth = YES;//改变字体大小填满label
            [imageView addSubview:label];
            return imageView;
        }else if (section == 6) {
            //整个区头view
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 62.5)];
            view.dk_backgroundColorPicker = DKColorWithColors(IWColor(246, 246, 246), IWColor(200, 200, 200));
            //上分割线
            UIView *wireOneView = [[UIView alloc] initWithFrame:CGRectMake(0, 12.5, RRPWidth, 1)];
            wireOneView.backgroundColor = IWColor(221, 221, 221);
            [view addSubview:wireOneView];
            //放周边推荐图标和字样的view
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 13.5, RRPWidth, 50)];
            contentView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
            [view addSubview:contentView];
            //周边推荐图标
            UIImageView *recommendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
            recommendImageView.image = [UIImage imageNamed:@"sign-list-around"];
            [contentView addSubview:recommendImageView];
            //周边推荐字样
            UILabel *recommendLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(recommendImageView.frame)+10, 15, 100, 20)];
            recommendLabel.text = @"周边推荐";
            recommendLabel.font = [UIFont systemFontOfSize:16];
            [contentView addSubview:recommendLabel];
            
            //下分割线
            UIView *wireTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contentView.frame)+0.5, RRPWidth, 1)];
            wireTwoView.backgroundColor = IWColor(221, 221, 221);
            [view addSubview:wireTwoView];
            
            return view;
        }else {
            UIView *view = [[UIView alloc] init];
            return view;
        }
}
//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.section == 1 && indexPath.row == 0) {
            NSInteger statu = [RRPFindTopModel shareRRPFindTopModel].status;
            if (statu == 1) {
                RRPMapController *map = [[RRPMapController alloc] init];
                // 116.400002 40.000000 鸟巢  六道口 40.016077 116.356199  华业 39.919390 116.487878  114.400002  30.600000武汉
                map.afferentLatitude = [self.homeSelectedDetailModel.latitude doubleValue];
                map.afferentLongitude = [self.homeSelectedDetailModel.longitude doubleValue];
                map.selfLatitude = self.selfLatitude;
                map.selfLongitude = self.selfLongitude;
                //统计:地图查看
                [MobClick event:@"16"];
                [self.navigationController pushViewController:map animated:YES];
            }
        }else if (indexPath.section == 1 && indexPath.row == 1) {
            //跳到评论界面
            RRPCDCommmentController *CDComment = [[RRPCDCommmentController alloc] init];
            CDComment.sceneryid = self.sceneryID;
            CDComment.type = @"全部";
            //统计:评论点击
            NSDictionary *dict = @{@"sceneryname":self.sceneryName,@"sceneryID":self.sceneryID};
            [MobClick event:@"17" attributes:dict];

            [self.navigationController pushViewController:CDComment animated:YES];
//        }else if (indexPath.section == 1 && indexPath.row == 2) {
//            NSLog(@"跳到景点特色");
        }else if (indexPath.section == 2 && indexPath.row == 1) {
            //跳到评论界面
            RRPCDCommmentController *CDComment = [[RRPCDCommmentController alloc] init];
            CDComment.sceneryid = self.sceneryID;
            CDComment.type = @"全部";
            //统计:评论点击
            NSDictionary *dict = @{@"sceneryname":self.sceneryName,@"sceneryID":self.sceneryID};
            [MobClick event:@"17" attributes:dict];

            [self.navigationController pushViewController:CDComment animated:YES];
        }else if (indexPath.section == 4 && indexPath.row == 0) {
            //在线客服
            self.coverView = [[RRPCoverView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, RRPHeight)];
            self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToController:)];
            tap.numberOfTapsRequired = 1;
            //统计:在线客服点击
            NSDictionary *dict = @{@"sceneryname":self.sceneryName,@"sceneryID":self.sceneryID};
            [MobClick event:@"19" attributes:dict];

            //向视图添加手势
            [self.coverView addGestureRecognizer:tap];
            [self.view addSubview:self.coverView];
            
        }else if (indexPath.section == 6 && indexPath.row == 1) {
            //跳到去全部周边推荐
            RRPHomeAmbitusController *ambitusVC = [[RRPHomeAmbitusController alloc] init];
            ambitusVC.sceneryid = self.sceneryID;
            //统计:周边全部点击
            NSDictionary *dict = @{@"sceneryname":self.sceneryName,@"sceneryID":self.sceneryID};
            [MobClick event:@"22" attributes:dict];
            [self.navigationController pushViewController:ambitusVC animated:YES];
        }
}


#pragma mark - 手势方法的实现
//轻拍
- (void)tap:(UITapGestureRecognizer *)tap {
    RRPDetailsImageController *image = [[RRPDetailsImageController alloc] init];
    image.imageURLArray = self.imageUrlArray;
    [self.navigationController pushViewController:image animated:YES];
}

- (void)tapToController:(UITapGestureRecognizer *)tap {
    [self.coverView removeFromSuperview];
}

//弹出更多
- (void)popMoreTicketAction:(NSNotification *)notification
{
    
    self.moreStr = @"更多";
    [self.tableView reloadData];
}
//查看全部评论
- (void)AllCommentAction:(NSNotification *)notification
{
//    UIButton *sender = [notification valueForKey:@"userInfo"][@"value"];
    //查看须知
    RRPNoticeController *noticeVC = [[RRPNoticeController alloc] init];
    noticeVC.homeSelectedModel = self.homeSelectedDetailModel;
    [self.navigationController pushViewController:noticeVC animated:YES];
}
#pragma mark - collectionView部分
//collectonView懒加载
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 388) collectionViewLayout:self.flowLayout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.dk_backgroundColorPicker = DKColorWithColors(IWColor(250, 250, 250), IWColor(200, 200, 200));
    }
    return _collectionView;
}


#pragma mark - UICollectionViewDataSource
//分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.peripheryArray.count;
}
//cell展示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RRPChDetilsCommendContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RRPChDetilsCommendContentCell" forIndexPath:indexPath];
    [cell showDataWithModel:self.peripheryArray[indexPath.row]];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//items大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((RRPWidth-30) / 2, 175);
}
//cell边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 0, 10);
}
#pragma mark - UICollectionViewDelegate
//collection cell 点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //动画类型
    //kCATransitionFade ;淡隐淡出
    //kCATransitionMoveIn ;推开
    //kCATransitionPush ;移入
    //kCATransitionReveal;移出
    //suckEffect（三角）
    //rippleEffect（水波抖动）
    //pageCurl（上翻页）
    //pageUnCurl（下翻页）
    //oglFlip（上下翻转）
    //cameraIris/cameraIrisHollowOpen/cameraIrisHollowClose  （镜头快门，这一组动画是有效果，只是很难看，不建议使用
    CATransition *transition = [CATransition animation];
    transition.type = @"kCATransitionFade";
    //动画类型
    transition.subtype = kCATransitionFromTop;
    //动画时长
    transition.duration = 1;
    [self.tableView.layer addAnimation:transition forKey:nil];
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    RRPPeripheryModel *model = self.peripheryArray[indexPath.row];
    [self requestDataWithPage:1 ID:model.ID];
    self.sceneryID = model.ID;
    self.sceneryName = model.sceneryname;
    self.sceneryIntroduce = [NSString stringWithFormat:@"%@星级 %@ 价格:%@",model.grade,model.label,model.sellerprice];
    self.navigationItem.title = model.sceneryname;
    //统计:周边景区点击
    NSDictionary *dict = @{@"sceneryname":model.sceneryname,@"sceneryID":model.ID};
    [MobClick event:@"21" attributes:dict];
    [self requestCollectionData];
    [self layoutRightButton];
    [self viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.saveListArr = [@[] mutableCopy];
    //判断收藏
    //请求数据
    [self requestCollectionData];
    [self.tableView reloadData];
}
//请求收藏数据
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
//        NSLog(@"收藏%@",dict);
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
