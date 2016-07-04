//
//  RRPAllOrderController.m
//  RRP
//
//  Created by sks on 16/3/10.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPAllOrderController.h"
#import "RRPAllOrderCell.h"
#import "RRPAllOrderModel.h"

typedef NS_ENUM(NSInteger, refState){
    refStateHeader = 0,
    refStateFooter = 1,
};
@interface RRPAllOrderController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allOrderArray;
@end

@implementation RRPAllOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorWithColors(IWColor(241, 244, 249), IWColor(200, 200, 200));
    self.title = @"全部订单";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = IWColor(0, 122, 255);
    self.allOrderArray = [@[] mutableCopy];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPAllOrderCell" bundle:nil] forCellReuseIdentifier:@"RRPAllOrderCell"];
    [self.view addSubview:self.tableView];
    //请求数据
    [self downLoadData:refStateHeader andPageNumber:1];
}
//返回
- (void)returnAction:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];

}
//请求数据
- (void)downLoadData:(refState)refState andPageNumber:(NSInteger)page {
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"all_order" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:MyAllOrder parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //检查字典中是否含有：“<NULL>”这样的字符串，有就改为“”
        NSDictionary *nullDict = [RRPPrintObject nullDic:dict];
        NSInteger code = [[nullDict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000)  {
            [self.allOrderArray removeAllObjects];
            for (NSDictionary *dic in nullDict[@"ResponseBody"]) {
                RRPAllOrderModel *allOrderModel = [RRPAllOrderModel mj_objectWithKeyValues:dic];
                [self.allOrderArray addObject:allOrderModel];
            }
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
  
    }];

    

}
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 7.5, RRPWidth, RRPHeight+42.5-7.5)];
        self.tableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(241, 244, 249), IWColor(200, 200, 200));
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allOrderArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRPAllOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPAllOrderCell" forIndexPath:indexPath];
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    cell.backgroundColor = IWColor(241, 244, 249);
    RRPAllOrderModel *model = self.allOrderArray[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RRPAllOrderCell cellHeight:self.allOrderArray[indexPath.row]];
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
