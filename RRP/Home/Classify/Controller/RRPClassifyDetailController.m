//
//  RRPClassifyDetailController.m
//  RRP
//
//  Created by sks on 16/3/1.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPClassifyDetailController.h"
#import "RRPClassifyListModel.h"
#import "RRPClassityFDetailCell.h"
#import "RRPChoicenessDetailsController.h"

typedef NS_ENUM(NSInteger, refState){
    refStateHeader = 0,
    refStateFooter = 1,
};
@interface RRPClassifyDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *classifyArray;
@property (nonatomic, assign) NSInteger refreshNumber;//刷新number

@end

@implementation RRPClassifyDetailController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.navigationItem.title = self.sceneryname;
    //取消滚动视图的自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.classifyArray = [@[] mutableCopy];
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPClassityFDetailCell" bundle:nil] forCellReuseIdentifier:@"RRPClassityFDetailCell"];
       //请求数据
    [self requestClassifyListDataWithRestate:refStateHeader andPageNumber:1];
  
    
}
//请求数据
- (void)requestClassifyListDataWithRestate:(refState)refState andPageNumber:(NSInteger)page
{
    
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"scenery_list" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.ID forKey:@"classcode"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"limit"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [manager POST:HomeClassifyList  parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取数据
        NSDictionary *calssifyListDic = responseObject;
        
        NSInteger code = [[calssifyListDic[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
             NSMutableArray *classifyArray = [NSMutableArray array];
            for (NSDictionary *dic in calssifyListDic[@"ResponseBody"]) {
                RRPClassifyListModel *classifyListModel = [RRPClassifyListModel mj_objectWithKeyValues:dic];
                [classifyArray addObject:classifyListModel];
            }
            if (refState == refStateHeader) {
                [self.classifyArray removeAllObjects];
                self.refreshNumber = 1;
                [self.classifyArray addObjectsFromArray:classifyArray];
            }else{
                if (self.refreshNumber!= page) {
                    [self.classifyArray addObjectsFromArray:classifyArray];
                }
            }
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

//懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,RRPWidth, RRPHeight-64)];
        self.tableView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.showsVerticalScrollIndicator = NO;
        //        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
- (void)loadNewData
{
    [self requestClassifyListDataWithRestate:refStateHeader andPageNumber:1];
    [self.tableView.header endRefreshing];
}
- (void)loadMoreData
{
    if (self.classifyArray.count % 15 == 0) {
      [self requestClassifyListDataWithRestate:refStateFooter andPageNumber:(NSInteger)(self.classifyArray.count/15 + 1)];
    }else {
        self.tableView.footer = nil;
    }
    [self.tableView.footer endRefreshing];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RRPClassityFDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPClassityFDetailCell" forIndexPath:indexPath];
    //取消点击样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    RRPClassifyListModel *classifyListModel = self.classifyArray[indexPath.row];
    [cell showDataWithModel:classifyListModel];
    return cell;
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.classifyArray.count;
    
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RRPWidth/375*128;
    
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRPChoicenessDetailsController *RRPChoicenessDetailsVC = [[RRPChoicenessDetailsController alloc] init];
    RRPClassifyListModel *classifyListModel = self.classifyArray[indexPath.row];
    //传值ID
    RRPChoicenessDetailsVC.sceneryID = classifyListModel.ID;
    RRPChoicenessDetailsVC.sceneryName = classifyListModel.sceneryname;
  
    [self.navigationController pushViewController:RRPChoicenessDetailsVC animated:YES];
    
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
