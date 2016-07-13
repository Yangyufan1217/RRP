//
//  RRPChoicenessViewController.m
//  RRP
//
//  Created by sks on 16/2/17.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPChoicenessViewController.h"
#import "RRPChoicenessCell.h"
#import "RRPChoicenessDetailsController.h"
#import "RRPHomeSelected.h"

typedef NS_ENUM(NSInteger, refState){
    refStateHeader = 0,
    refStateFooter = 1,
};
@interface RRPChoicenessViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *homeSelectArr;
@property (nonatomic, assign) NSInteger refreshNumber;//刷新number

@end

@implementation RRPChoicenessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.dk_backgroundColorPicker = DKColorWithColors(IWColor(236, 236, 236), IWColor(200, 200, 200));
    self.navigationItem.title = @"精选门票";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = IWColor(0, 122, 255);
    self.homeSelectArr = [@[] mutableCopy];
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"RRPChoicenessCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"RRPChoicenessCell"];
    [self.tableView dequeueReusableCellWithIdentifier:@"RRPChoicenessCell"];
    
    [self.view addSubview:self.tableView];
    
    
    //请求门票精选数据
    [self requestHomeSeletWithPage:refStateHeader andPageNumber:1];
      
}
//请求门票精选数据
- (void)requestHomeSeletWithPage:(refState)refState andPageNumber:(NSInteger)page
{
    
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"selected_ticket" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"selected" forKey:@"selected"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"limit"];
    NSString *longitude = [RRPYCSigleClass mapLatitudeLongitudePassByValue].longitude;
    NSString *latitude = [RRPYCSigleClass mapLatitudeLongitudePassByValue].latitude;
    NSString *location = [NSString stringWithFormat:@"%@,%@",longitude,latitude];
    if (longitude.length > 0 && latitude.length > 0) {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:location forKey:@"location"];
    }else {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"116.46,39.92" forKey:@"location"];
    }
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:HomeSelected parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"门票精选%@",dict);
        //检查字典中是否含有：“<NULL>”这样的字符串，有就改为“”
        NSDictionary * nullDict = [RRPPrintObject nullDic:dict];
        NSInteger code = [[nullDict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        
        if (code == 1000)  {
            
            NSMutableArray *homeSelectArr = [NSMutableArray array];
            for (NSDictionary *dic in dict[@"ResponseBody"]) {
                RRPHomeSelected *homeSelected = [RRPHomeSelected mj_objectWithKeyValues:dic];
                [homeSelectArr addObject:homeSelected];
            }
            if (refState == refStateHeader) {
                [self.homeSelectArr removeAllObjects];
                self.refreshNumber = 1;
                [self.homeSelectArr addObjectsFromArray:homeSelectArr];
            }else{
                if (self.refreshNumber!= page) {
                    [self.homeSelectArr addObjectsFromArray:homeSelectArr];
                }
            }

        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [[Utility sharedInstance]showAfnError:error];
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
    [self requestHomeSeletWithPage:refStateHeader andPageNumber:1];
    [self.tableView.header endRefreshing];
}
//下拉刷新
- (void)loadMoreData
{
    if (self.homeSelectArr.count % 15 == 0) {
        [self requestHomeSeletWithPage:refStateFooter andPageNumber:(NSInteger)(self.homeSelectArr.count/15 + 1)];
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
        return self.homeSelectArr.count;
    }
}
//cell展示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRPChoicenessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPChoicenessCell" forIndexPath:indexPath];
    //取消点击样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
     RRPHomeSelected *model = self.homeSelectArr[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.backView.layer.masksToBounds = YES;
    cell.backView.layer.cornerRadius = 5;
    [cell showDataWithTicketSelectedModel:model];
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
     RRPHomeSelected *model = self.homeSelectArr[indexPath.row];
    choicenessDetails.sceneryID = model.sceneryid;
    choicenessDetails.sceneryName = model.sceneryname;
    choicenessDetails.imageURL = model.imgurl;
    //统计:门票精选更多列表景区点击
    NSDictionary *dict = @{@"sceneryName":model.sceneryname,@"sceneryID":model.sceneryid};
    [MobClick event:@"13" attributes:dict];
    [self.navigationController pushViewController:choicenessDetails animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
