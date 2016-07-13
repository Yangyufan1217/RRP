//
//  RRPHomeAmbitusController.m
//  RRP
//
//  Created by WangZhaZha on 16/5/5.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPHomeAmbitusController.h"
#import "RRPChoicenessCell.h"
#import "RRPChoicenessDetailsController.h"
#import "RRPPeripheryModel.h"


typedef NS_ENUM(NSInteger, refState){
    refStateHeader = 0,
    refStateFooter = 1,
};
@interface RRPHomeAmbitusController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *homeAmbitusArr;
@property (nonatomic, assign) NSInteger refreshNumber;//刷新number


@end

@implementation RRPHomeAmbitusController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.dk_backgroundColorPicker = DKColorWithColors(IWColor(236, 236, 236), IWColor(200, 200, 200));
    self.navigationItem.title = @"周边推荐";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = IWColor(0, 122, 255);
    self.homeAmbitusArr = [@[] mutableCopy];
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"RRPChoicenessCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"RRPChoicenessCell"];
    [self.tableView dequeueReusableCellWithIdentifier:@"RRPChoicenessCell"];
    
    [self.view addSubview:self.tableView];
    
    
    //请求周边推荐数据
    [self requestAmbitusWithPage:refStateHeader andPageNumber:1];
 

}
//请求周边推荐数据
- (void)requestAmbitusWithPage:(refState)refState andPageNumber:(NSInteger)page
{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"peripheral_ticket" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.sceneryid forKey:@"sceneryid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic removeObjectForKey:@"location"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%ld",page]  forKey:@"limit"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [manager POST:HomePeripheral parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取数据
        NSDictionary *dict = responseObject;
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            NSMutableArray *homeAmbitusArr = [NSMutableArray array];
            //遍历ResponseBody
            for (NSDictionary *dic in dict[@"ResponseBody"]) {
                RRPPeripheryModel *peripheryModel = [RRPPeripheryModel mj_objectWithKeyValues:dic];
                [homeAmbitusArr addObject:peripheryModel];
            }
            
            if (refState == refStateHeader) {
                [self.homeAmbitusArr removeAllObjects];
                self.refreshNumber = 1;
                [self.homeAmbitusArr addObjectsFromArray:homeAmbitusArr];
            }else{
                if (self.refreshNumber!= page) {
                    [self.homeAmbitusArr addObjectsFromArray:homeAmbitusArr];
                }
            }
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}

//返回
- (void)returnAction:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,RRPWidth, RRPHeight+49)];
        self.tableView.backgroundColor = IWColor(236, 236, 236);
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
    [self requestAmbitusWithPage:refStateHeader andPageNumber:1];
    [self.tableView.header endRefreshing];
}
//下拉刷新
- (void)loadMoreData
{
    if (self.homeAmbitusArr.count % 15 == 0) {
         [self requestAmbitusWithPage:refStateFooter andPageNumber:(NSInteger)(self.homeAmbitusArr.count/15 + 1)];
    }else
    {
        self.tableView.footer = nil;
    }
    [self.tableView.footer endRefreshing];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        //周边推荐
        return self.homeAmbitusArr.count;
    }
}
//cell展示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRPChoicenessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPChoicenessCell" forIndexPath:indexPath];
    //取消点击样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    cell.backView.layer.masksToBounds = YES;
    cell.backView.layer.cornerRadius = 5;
    RRPPeripheryModel *model = self.homeAmbitusArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}


#pragma mark - UITableViewDelegate
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
//区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 106;
    }else {
        return 0;
    }
}
//区头视图
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 106)];
    imageView.image = [UIImage imageNamed:@"门票精选"];
    return imageView;
}
//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RRPChoicenessDetailsController *choicenessDetails = [[RRPChoicenessDetailsController alloc] init];
    RRPPeripheryModel *model = self.homeAmbitusArr[indexPath.row];
    choicenessDetails.sceneryID = model.ID;
    choicenessDetails.sceneryName = model.sceneryname;
    choicenessDetails.imageURL = model.imgurl;
    [self.navigationController pushViewController:choicenessDetails animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
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
