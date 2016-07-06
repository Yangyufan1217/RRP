//
//  RRPSaleListViewController.m
//  RRP
//
//  Created by WangZhaZha on 16/3/8.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPSaleListViewController.h"
#import "RRPOnSaleListCell.h"
#import "RRPFindSaleListModel.h"
#import "RRPFindModel.h"
#import "RRPFindTopModel.h"
#import "RRPSaleDetailController.h"

typedef NS_ENUM(NSInteger, refState){
    refStateHeader = 0,
    refStateFooter = 1,
};
@interface RRPSaleListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger refreshNumber;//刷新number


@end

@implementation RRPSaleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"特价";
    self.view.dk_backgroundColorPicker = DKColorWithColors(IWColor(241, 240, 246), IWColor(200, 200, 200));
    self.dataArray = [@[] mutableCopy];
    //取消滚动视图的自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPOnSaleListCell" bundle:nil] forCellReuseIdentifier:@"RRPOnSaleListCell"];
    [self downLoadData:refStateHeader andPageNumber:1];
    [self.view addSubview:self.tableView];

}

//懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10,64,RRPWidth-20, RRPHeight-64+45)];
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(241, 240, 246), IWColor(200, 200, 200));
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

//下拉刷新
- (void)loadNewData
{
    [self downLoadData:refStateHeader andPageNumber:1];
    [self.tableView.header endRefreshing];
}

//加载更多
- (void)loadMoreData
{
    if (self.dataArray.count % 15 == 0) {
          [self downLoadData:refStateFooter andPageNumber:(NSInteger)(self.dataArray.count/15 + 1)];
    }else
    {
        self.tableView.footer = nil;
    }
    [self.tableView.footer endRefreshing];
}


#pragma mark - 网络数据加载
- (void)downLoadData:(refState)refState andPageNumber:(NSInteger)page
{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"sort_price" forKey:@"method"];
    RRPFindModel *findModel = [RRPFindTopModel shareRRPFindTopModel].classcodeArray[3];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%@",findModel.classcode] forKey:@"classcode"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"limit"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:FindSpecial parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //获取数据
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dict = [RRPPrintObject nullDic:dic];
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSDictionary *dic in dict[@"ResponseBody"]) {
                NSMutableDictionary *modelDic = [NSMutableDictionary dictionary];
                [modelDic setValue:dic[@"id"] forKey:@"id"];
                [modelDic setValue:dic[@"imgurl"] forKey:@"imgurl"];
                [modelDic setValue:dic[@"sceneryname"] forKey:@"sceneryname"];
                [modelDic setValue:dic[@"ticket"][@"marketprice"] forKey:@"marketprice"];
                [modelDic setValue:dic[@"ticket"][@"sceneryid"] forKey:@"sceneryid"];
                [modelDic setValue:dic[@"ticket"][@"sellerprice"] forKey:@"sellerprice"];
                [modelDic setValue:dic[@"ticket"][@"ticketname"] forKey:@"ticketname"];
                [modelDic setValue:dic[@"ticket"][@"stdname"] forKey:@"stdname"];
                [modelDic setValue:dic[@"ticket"][@"stopselldate"] forKey:@"stopselldate"];
                RRPFindSaleListModel *saleListModel = [RRPFindSaleListModel mj_objectWithKeyValues:modelDic];
                [dataArray addObject:saleListModel];
            }

            if (refState == refStateHeader) {
                [self.dataArray removeAllObjects];
                self.refreshNumber = 1;
                [self.dataArray addObjectsFromArray:dataArray];
            }else{
                if (self.refreshNumber!= page) {
                    [self.dataArray addObjectsFromArray:dataArray];
                }
            }
        }else {
//            NSLog(@"%ld",(long)code);
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}



#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRPOnSaleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPOnSaleListCell" forIndexPath:indexPath];
    //取消点击样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell showCell:self.dataArray[indexPath.row]];
    return cell;
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 218;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRPSaleDetailController *saleDetailVC = [[RRPSaleDetailController alloc] init];
    RRPFindSaleListModel *saleListModel = self.dataArray[indexPath.row];
    saleDetailVC.sceneryID = [NSString stringWithFormat:@"%ld",saleListModel.sceneryid];
    saleDetailVC.sceneryIntroduce = [NSString stringWithFormat:@"活动期间:低值%@",saleListModel.sellerprice];
    if ([saleListModel.stdname length] != 0) {
        saleDetailVC.sceneryName = saleListModel.stdname;
    }else
    {
        saleDetailVC.sceneryName = saleListModel.sceneryname;
    }
    saleDetailVC.imageURL = saleListModel.imgurl;
    //统计:特价列表景区点击
    NSDictionary *dict = @{@"sceneryname":saleDetailVC.sceneryName,@"sceneryID":[NSString stringWithFormat:@"%ld",saleListModel.sceneryid]};
    [MobClick event:@"44" attributes:dict];
    
    [self.navigationController pushViewController:saleDetailVC animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
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
