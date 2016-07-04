//
//  RRPNotCommentController.m
//  RRP
//
//  Created by sks on 16/3/10.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPNotCommentController.h"
#import "RRPNonPaymentCell.h"
#import "RRPNoCommentModel.h"
#import "RRPNoPayModel.h"
#import "RRPMyCommentController.h"
typedef NS_ENUM(NSInteger, refState){
    refStateHeader = 0,
    refStateFooter = 1,
};
@interface RRPNotCommentController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *noCommentArray;
@end

@implementation RRPNotCommentController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.title = @"待评价";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = IWColor(0, 122, 255);

    self.noCommentArray = [@[] mutableCopy];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPNonPaymentCell" bundle:nil] forCellReuseIdentifier:@"RRPNonPaymentCell"];
    [self.view addSubview:self.tableView];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getValue:) name:@"评论" object:nil];
}
//返回
- (void)returnAction:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];

}
//获取值
-(void)getValue:(NSNotification *)notification
{
    
    UIButton *sender = [notification valueForKey:@"userInfo"][@"value"];
    RRPNonPaymentCell * cell = (RRPNonPaymentCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    //跳转评论界面
    RRPMyCommentController *noCommentVC = [[RRPMyCommentController alloc] init];
    RRPNoPayModel *model = self.noCommentArray[path.row];
    noCommentVC.imageUrl = model.imgurl;
    noCommentVC.sceneryName = model.ticketname;
    noCommentVC.ticketPrice = model.origin;
    noCommentVC.ticketID = model.oid;
    //统计:待评价评论按钮点击
    NSDictionary *dict = @{@"ticketname":model.ticketname,@"oid":model.oid,@"origin":model.origin};
    [MobClick event:@"63" attributes:dict];
    [self.navigationController pushViewController:noCommentVC animated:YES];
    
}

//请求数据
- (void)downLoadData:(refState)refState andPageNumber:(NSInteger)page
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"notevaluate_order" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:MyNoComment parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //检查字典中是否含有：“<NULL>”这样的字符串，有就改为“”
        NSDictionary * nullDict = [RRPPrintObject nullDic:dict];
        NSInteger code = [[nullDict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000)  {
            [self.noCommentArray removeAllObjects];
            for (NSDictionary *dic in nullDict[@"ResponseBody"]) {
                [dic setValue:@"3" forKey:@"type"];
                RRPNoPayModel *noCommentModel = [RRPNoPayModel mj_objectWithKeyValues:dic];
                [self.noCommentArray addObject:noCommentModel];
            }
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 7.5, RRPWidth, RRPHeight+42.5-7.5)];
        self.tableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(241, 244, 249), IWColor(200, 200, 200));
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
    [self downLoadData:refStateHeader andPageNumber:1];
    [self.tableView.header endRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noCommentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRPNonPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPNonPaymentCell" forIndexPath:indexPath];
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    cell.backgroundColor = IWColor(241, 244, 249);
    RRPNoPayModel *model = self.noCommentArray[indexPath.row];
    [cell showDataWithNoPayModel:model];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RRPNonPaymentCell cellHeight:self.noCommentArray[indexPath.row]];
    
}
- (void) viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    //请求数据
    [self downLoadData:refStateHeader andPageNumber:1];
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
