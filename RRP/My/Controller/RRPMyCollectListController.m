//
//  RRPMyCollectListController.m
//  RRP
//
//  Created by sks on 16/3/16.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMyCollectListController.h"
#import "RRPMyCollectListCell.h"
#import <AFHTTPRequestOperationManager.h>
#import "RRPCollectionModel.h"
#import "RRPChoicenessDetailsController.h"
typedef NS_ENUM(NSInteger, refState){
    refStateHeader = 0,
    refStateFooter = 1,
};

@interface RRPMyCollectListController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *collectionArray;
@property (nonatomic, assign) NSInteger refreshNumber;//刷新number

@end

@implementation RRPMyCollectListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.title = @"收藏";
    self.collectionArray = [@[] mutableCopy];
    //取消滚动视图的自适应
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPMyCollectListCell" bundle:nil] forCellReuseIdentifier:@"RRPMyCollectListCell"];
    [self.view addSubview:self.tableView];
    
    //请求数据
     [self requestDataWithPage:refStateHeader andPageNumber:1];
}
//请求数据
- (void)requestDataWithPage:(refState)refState andPageNumber:(NSInteger)page
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"collection_scenery" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"limit"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:MySave parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //检查字典中是否含有：“<NULL>”这样的字符串，有就改为“”
        NSDictionary * nullDict = [RRPPrintObject nullDic:dict];
        NSInteger code = [[nullDict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000)  {
             NSMutableArray *collectionArray = [NSMutableArray array];
            for (NSDictionary *dic in nullDict[@"ResponseBody"]) {
                RRPCollectionModel *collectionModel = [RRPCollectionModel mj_objectWithKeyValues:dic];
                [collectionArray addObject:collectionModel];
            }

            if (refState == refStateHeader) {
                [self.collectionArray removeAllObjects];
                self.refreshNumber = 1;
                [self.collectionArray addObjectsFromArray:collectionArray];
            }else{
                if (self.refreshNumber!= page) {
                    [self.collectionArray addObjectsFromArray:collectionArray];
                }
            }
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
//请求删除收藏
- (void)requestDeletContactWithModel:(RRPCollectionModel *)model
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"delete_collection" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:model.sid forKey:@"sceneryid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [manager POST:MyCollection parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取数据
        NSDictionary *dict = responseObject;
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
//            NSString *msg = dict[@"ResponseBody"][@"msg"];
//            [[MyAlertView sharedInstance]showFrom:msg];
            //统计:收藏景区右侧取消按钮点击
            NSDictionary *stasticsDic = @{@"sceneryname":model.sname,@"sceneriID":model.sid};
            [MobClick event:@"71" attributes:stasticsDic];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,RRPWidth, RRPHeight)];
        self.tableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(236, 236, 236), IWColor(200, 200, 200));
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        
    }
    return _tableView;
}
//最新的数据
- (void)loadNewData
{
    [self requestDataWithPage:refStateHeader andPageNumber:1 ];
    [self.tableView.header endRefreshing];
}
//下拉刷新
- (void)loadMoreData
{
    if (self.collectionArray.count % 15 == 0) {
        [self requestDataWithPage:refStateFooter andPageNumber:(NSInteger)(self.collectionArray.count/15 + 1)];
    }else
    {
        self.tableView.footer = nil;
    }
    
    [self.tableView.footer endRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.collectionArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRPMyCollectListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyCollectListCell" forIndexPath:indexPath];
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    RRPCollectionModel *model = self.collectionArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.backView.layer.masksToBounds = YES;
    cell.backView.layer.cornerRadius = 5;
    [cell showDataWithModel:model];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRPChoicenessDetailsController *choicenessDetails = [[RRPChoicenessDetailsController alloc] init];
    RRPCollectionModel *model = self.collectionArray[indexPath.row];
    //传值
    choicenessDetails.sceneryID = model.sid;
    choicenessDetails.sceneryName = model.sname;
    choicenessDetails.imageURL = model.imgurl;
    //统计:收藏景区点击
    NSDictionary *dict = @{@"sceneryName":model.sname,@"sceneryID":model.sid};
    [MobClick event:@"70" attributes:dict];
    [self.navigationController pushViewController:choicenessDetails animated:YES];

}
//自定义的背后样式
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个删除按钮
    UITableViewRowAction *cancelCollectRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消收藏" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //删除
        RRPCollectionModel *model = self.collectionArray[indexPath.row];
        [self requestDeletContactWithModel:model];
        [self viewDidLoad];
    }];
    cancelCollectRowAction.backgroundColor = [UIColor colorWithRed:20 green:0 blue:0 alpha:0.2];
    // 将设置好的按钮放到数组中返回
     return @[cancelCollectRowAction];
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
