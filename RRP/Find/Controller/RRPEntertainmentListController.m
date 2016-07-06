//
//  RRPEntertainmentListController.m
//  RRP
//
//  Created by WangZhaZha on 16/3/8.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPEntertainmentListController.h"
#import "RRPCateListLeftCell.h"
#import "RRPCateListRightCell.h"
#import "FindRecreationModel.h"
#import "RRPFindListDetailController.h"

typedef NS_ENUM(NSInteger, refState){
    refStateHeader = 0,
    refStateFooter = 1,
};

@interface RRPEntertainmentListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;//数据
@property (nonatomic, assign) NSInteger refreshNumber;//刷新number



@end

@implementation RRPEntertainmentListController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"娱乐";
    self.view.dk_backgroundColorPicker = DKColorWithColors(IWColor(241, 240, 246), IWColor(200, 200, 200));
    //取消滚动视图的自适应
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.dataArray = [@[] mutableCopy];
    [self downLoadData:refStateHeader andPageNumber:1];
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPCateListLeftCell" bundle:nil] forCellReuseIdentifier:@"RRPCateListLeftCell"];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPCateListRightCell" bundle:nil] forCellReuseIdentifier:@"RRPCateListRightCell"];



}
//懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,RRPWidth, RRPHeight-64+45)];
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(241, 240, 246), IWColor(200, 200, 200));
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
//最新的数据
- (void)loadNewData
{
    [self downLoadData:refStateHeader andPageNumber:1];
    [self.tableView.header endRefreshing];
}

//下拉刷新
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
//请求搜索接口数据
- (void)downLoadData:(refState)refState andPageNumber:(NSInteger)page
{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"sort_scenery_list" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%@",self.classcode] forKey:@"classcode"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"limit"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:FindRecreation parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取数据
        NSDictionary *dict = responseObject;
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSDictionary *dic in dict[@"ResponseBody"]) {
                FindRecreationModel *model = [FindRecreationModel mj_objectWithKeyValues:dic];
                [dataArray addObject:model];
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
            [self.tableView reloadData];
        }else {
//            NSLog(@"%ld",code);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 2 == 0) {
        RRPCateListLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPCateListLeftCell" forIndexPath:indexPath];
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        [cell show:self.dataArray[indexPath.row]];
        return cell;
    }else{
        RRPCateListRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPCateListRightCell" forIndexPath:indexPath];
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        [cell showData:self.dataArray[indexPath.row]];
        return cell;
    }

}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RRPWidth/750*370;
    
}
//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRPFindListDetailController *findListDetailVC = [[RRPFindListDetailController alloc] init];
    FindRecreationModel *model = self.dataArray[indexPath.row];
    findListDetailVC.ID = model.ID;
    findListDetailVC.sceneryname = model.sceneryname;
    findListDetailVC.imageURL = model.imgurl;
    //统计:运动列表景区点击
    NSDictionary *dict = @{@"sceneryname":model.sceneryname,@"sceneryID":[NSString stringWithFormat:@"%ld",model.ID]};
    [MobClick event:@"42" attributes:dict];
    [self.navigationController pushViewController:findListDetailVC animated:YES];
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
