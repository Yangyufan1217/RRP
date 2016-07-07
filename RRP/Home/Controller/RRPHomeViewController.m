//
//  RRPHomeViewController.m
//  RRP
//
//  Created by sks on 16/2/16.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPHomeViewController.h"
#import "RRPHomeOneTableViewCell.h"
#import "RRPChoicenessViewController.h"
#import "RRPChoicenessDetailsController.h"
#import "RRPCollectionCell.h"
#import "ScenicSpotViewController.h"
#import "RRPClassifyDetailController.h"
#import "RRPCityListViewController.h"
#import "RRPDataRequestModel.h"
#import "RRPHomeSelected.h"
#import "RRPHomeCircleModel.h"
#import "RRPHomeSearchModel.h"
#import "RRPHomeSearchCell.h"
#import "RRPHomeCircleModel.h"
#import "RRPHomeClassifyModel.h"
#import "RRPFindTopModel.h"
#import "RRPAllCityHandle.h"
#import "SDCycleScrollView.h"
@interface RRPHomeViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate,SDCycleScrollViewDelegate> {
    BOOL Transform;
}
enum refreshState
{
    refreshHeader,
    refreshFooter
};
typedef enum refreshState refreshState;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *classifyView;//分类View
@property (nonatomic, strong) UIButton *button;//分类按钮
@property (nonatomic, strong) UILabel *classifyLabel;
@property (nonatomic, strong) UIButton *transformButton;//转换按钮
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)NSDictionary *homeSelectedDic;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic,strong)NSMutableArray *showDateArray;//展示数组
@property (nonatomic,strong)NSMutableArray *horizonShowArray;
@property (nonatomic,strong)NSMutableArray *searchArray;//搜索数据
@property (nonatomic, strong)NSDictionary *circleDic;
@property (nonatomic, strong)NSDictionary *homeClassifyDic;
@property (nonatomic,strong)NSMutableArray *circlePicArray;//轮播图数组
@property (nonatomic,strong)NSMutableArray *homeClassifyArray;
@property (nonatomic,strong)NSMutableArray *moreArray;
@property (nonatomic,strong)RRPHomeClassifyModel *classifyModel;
@property (nonatomic,strong)RRPHomeCircleModel *circleModel;
//searchBar
@property (nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UITableView *searchResult;
@property (nonatomic,strong) NSMutableArray *nameArray;
@property (nonatomic,strong) CLLocationManager *locationManager;//地图


-(void)initTableView;//创建搜索结果的示意图


@end

@implementation RRPHomeViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    [self.searchResult removeFromSuperview];
    
    if ([[RRPAllCityHandle shareAllCityHandle].passCityModel.city_name length] > 0) {
            self.cityName = [RRPAllCityHandle shareAllCityHandle].passCityModel.city_name;
            if ([self.cityName length] > 4) {
                self.cityName = [self.cityName substringWithRange:NSMakeRange(0, 4)];
            }
            //设置左侧城市列表item
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.cityName style:(UIBarButtonItemStyleDone) target:self action:@selector(pushToCityListView:)];
            [self.navigationItem.leftBarButtonItem setTintColor:IWColor(0, 122, 255)];
        }else
        {
            self.cityName = @"城市";
            //设置左侧城市列表item
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.cityName style:(UIBarButtonItemStyleDone) target:self action:@selector(pushToCityListView:)];
            [self.navigationItem.leftBarButtonItem setTintColor:IWColor(0, 122, 255)];
        
        }
    [self networkWithPage:1];
    [self requestCircleScrollData];
    [self requestNavigationListData];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.dk_backgroundColorPicker = DKColorWithColors(IWColor(240, 240, 240), IWColor(200, 200, 200));

    //给数组开辟空间
    self.dateArray = [@[] mutableCopy];
    self.showDateArray = [@[] mutableCopy];
    self.horizonShowArray = [@[] mutableCopy];
    self.circlePicArray = [@[] mutableCopy];
    self.searchArray = [@[] mutableCopy];
    self.nameArray = [@[] mutableCopy];
    self.homeClassifyArray = [@[] mutableCopy];
    self.moreArray = [@[] mutableCopy];

    
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

    
    [self layoutsearchBar];
   
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"RRPHomeOneTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"RRPHomeOneTableViewCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"RRPCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"RRPCollectionCell"];
    [self.view addSubview:self.tableView];
    //注册通知 接收消息 实现方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSelectedNewData) name:@"门票精选丄拉加载" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSelectedMoreData) name:@"门票精选下拉刷新" object:nil];
    //从缓存取出轮播图数据
    self.circleDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"轮播图"];
    if (self.circleDic != nil) {
        [self.circlePicArray removeAllObjects];
        if ([self.circleDic[@"ResponseBody"] isKindOfClass:[NSDictionary class]]) {
            for (NSDictionary *dic in self.circleDic[@"ResponseBody"][@"scenery"]) {
                RRPHomeCircleModel *circleModel = [RRPHomeCircleModel mj_objectWithKeyValues:dic];
                [self.circlePicArray addObject:circleModel];
            }
        }
        [self.tableView reloadData];
    }
    //从缓存取出景区分类数据
    self.homeClassifyDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"景区分类"];
    if (self.homeClassifyDic != nil) {
        for (NSDictionary *dic in self.homeClassifyDic[@"ResponseBody"][@"list"]) {
            self.classifyModel = [RRPHomeClassifyModel mj_objectWithKeyValues:dic];
            [self.homeClassifyArray addObject:self.classifyModel];
        }
        for (NSDictionary *dic in self.homeClassifyDic[@"ResponseBody"][@"more"]) {
            self.classifyModel = [RRPHomeClassifyModel mj_objectWithKeyValues:dic];
            [self.moreArray addObject:self.classifyModel];
        }
        [self.tableView reloadData];
    }
    //从缓存取出门票精选数据
    self.homeSelectedDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"门票精选"];
    if ([self.homeSelectedDic[@"ResponseBody"] isKindOfClass:[NSDictionary class]]) {
        for (NSDictionary *dic in self.homeSelectedDic[@"ResponseBody"]) {
            RRPHomeSelected *homeSelected = [RRPHomeSelected mj_objectWithKeyValues:dic];
            [self.dateArray addObject:homeSelected];
        }
        if (self.dateArray.count <= 8) {
            self.horizonShowArray = self.dateArray;
        }else
        {
            //横排展示
            for (int i = 0; i < 8; i++) {
                [self.horizonShowArray addObject:self.dateArray[i]];
            }
        }
        [self.collectionView reloadData];
    }
    
    [self networkWithPage:1];
    [self requestCircleScrollData];
    [self requestNavigationListData];
    [self shareDownLoadData];//分享参数请求
    
    NSInteger statu = [RRPFindTopModel shareRRPFindTopModel].status;
    if (statu == 1) {
        //配置用户Key
        [MAMapServices sharedServices].apiKey = MapKey;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
}

//门票精选丄拉加载
- (void)loadSelectedNewData
{
    [self networkWithPage:1];
}
//门票精选下拉刷新
- (void)loadSelectedMoreData
{
   [self networkWithPage:1];
}
//最新的数据
- (void)loadNewData
{
    [self networkWithPage:1];
    [self requestCircleScrollData];
    [self requestNavigationListData];
    [self.tableView.header endRefreshing];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation * currLocation = [locations lastObject];
    [RRPYCSigleClass mapLatitudeLongitudePassByValue].latitude = [NSString stringWithFormat:@"%.14f",currLocation.coordinate.latitude];
    [RRPYCSigleClass mapLatitudeLongitudePassByValue].longitude = [NSString stringWithFormat:@"%.14f",currLocation.coordinate.longitude];
    
    NSString *location = [NSString stringWithFormat:@"%@%@",[RRPYCSigleClass mapLatitudeLongitudePassByValue].latitude,[RRPYCSigleClass mapLatitudeLongitudePassByValue].longitude];
    if (![location isEqualToString:@","]) {
        [self networkWithPage:1];
    }
}



//跳转城市列表界面
- (void)pushToCityListView:(UIBarButtonItem *)item
{
    RRPCityListViewController *cityListVC = [[RRPCityListViewController alloc] init];
    //统计:首页顶部城市点击
    [MobClick event:@"5"];
    [self.navigationController pushViewController:cityListVC animated:YES];
}
//搜索框
- (void)layoutsearchBar {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth-100, 35)];//allocate titleView
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.backgroundImage = [UIImage imageNamed:@"375-64.jpg"];
    searchBar.delegate = self;
    searchBar.frame = CGRectMake(0, 0, RRPWidth-100, 35);
    searchBar.placeholder = @"搜索你想去的地方";
    [titleView addSubview:searchBar];
    //Set to titleView
    self.searchBar = searchBar;
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;
}

- (void)initTableView{
    self.searchResult = [[UITableView alloc]initWithFrame:CGRectMake(0,64, RRPWidth, RRPHeight-64)];
    self.searchResult.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    _searchResult.dataSource = self;
    _searchResult.delegate =self;
    _searchResult.tableFooterView = [[UIView alloc]init];
    [_searchResult registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.searchResult];
    
}
#pragma mark - UISearchBarDelegate
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    searchBar.showsCancelButton = YES;//取消的字体颜色，
    [searchBar setShowsCancelButton:YES animated:YES];
    [self initTableView];
    //改变取消的文本
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
//    NSLog(@"我的");
    [self.searchResult removeFromSuperview];
//    self.tabBarController.tabBar.hidden = YES;

}
/**
 *  搜框中输入关键字的事件响应
 *
 *  @param searchBar  UISearchBar
 *  @param searchText 输入的关键字
 */
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText != nil && searchText.length > 0) {
      [self requestSearchDataWithName:searchText];
        //统计:首页搜索框点击
        NSDictionary *dict = @{@"searchtext":searchText};
        [MobClick event:@"33" attributes:dict];
    }
}
/**
 *  取消的响应事件
 *
 *  @param searchBar UISearchBar
 */
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    NSLog(@"取消吗");
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.searchResult removeFromSuperview];
    self.searchBar.placeholder = @"搜索你想去的地方";
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}
/**
 *  键盘上搜索事件的响应
 *
 *  @param searchBar UISearchBar
 */
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    NSLog(@"取");
    self.searchBar.placeholder = @"搜索你想去的地方";
//    searchBar.text = @"";
    [self requestSearchDataWithName:searchBar.text];
    //统计:首页搜索框点击
    NSDictionary *dict = @{@"searchtext":searchBar.text};
    [MobClick event:@"33" attributes:dict];
    [searchBar setShowsSearchResultsButton:YES];
//    [searchBar resignFirstResponder];
    
}
//懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,RRPWidth, RRPHeight-64-49)];
        self.tableView.dk_backgroundColorPicker =  DKColorWithColors(IWColor(246, 246, 246), IWColor(200, 200, 200));
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    }
    return _tableView;
}

#pragma mark - 网络数据加载
//请求搜索接口数据
- (void)requestSearchDataWithName:(NSString *)name
{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"app_search" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:name forKey:@"name"];
    if ([[RRPAllCityHandle shareAllCityHandle].passCityModel.city_code length] > 0) {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[RRPAllCityHandle shareAllCityHandle].passCityModel.city_code forKey:@"city_code"];
    }else{
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"110100" forKey:@"city_code"];
    }

    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:HomeSearch parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取数据
        NSDictionary *dict = responseObject;
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            [self.searchArray removeAllObjects];
            for (NSDictionary *dic in dict[@"ResponseBody"]) {
                RRPHomeSearchModel *searchModel = [RRPHomeSearchModel mj_objectWithKeyValues:dic];
                [self.searchArray addObject:searchModel];
                [self.nameArray addObject:searchModel.sceneryname];
            }
            [self.searchResult reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
}
//请求轮播图数据
- (void)requestCircleScrollData
{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"carousel_figure" forKey:@"method"];
    if ([[RRPAllCityHandle shareAllCityHandle].passCityModel.city_code length] > 0) {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[RRPAllCityHandle shareAllCityHandle].passCityModel.city_code forKey:@"city_code"];
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[RRPAllCityHandle shareAllCityHandle].passCityModel.province_code forKey:@"province_code"];
    }else{
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"110100" forKey:@"city_code"];
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"11" forKey:@"province_code"];
    }
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:HomeCircleScrollView parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //检查字典中是否含有：“<NULL>”这样的字符串，有就改为“”
        NSDictionary * nullDict = [RRPPrintObject nullDic:dict];
        self.circleDic = [[NSDictionary alloc] init];
        self.circleDic = nullDict;
        //轮播图缓存
        [[NSUserDefaults standardUserDefaults] setValue:self.circleDic forKey:@"轮播图"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSInteger code = [[self.circleDic[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000)  {
            [self.circlePicArray removeAllObjects];
            if ([self.circleDic[@"ResponseBody"] isKindOfClass:[NSDictionary class]]) {
                for (NSDictionary *dic in self.circleDic[@"ResponseBody"][@"scenery"]) {
                    RRPHomeCircleModel *circleModel = [RRPHomeCircleModel mj_objectWithKeyValues:dic];
                    [self.circlePicArray addObject:circleModel];
                }
            }
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        //从缓存取出轮播图数据
        self.circleDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"轮播图"];
        if (self.circleDic != nil) {
            //轮播图缓存
            [[NSUserDefaults standardUserDefaults] setValue:self.circleDic forKey:@"轮播图"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.circlePicArray removeAllObjects];
            if ([self.circleDic[@"ResponseBody"] isKindOfClass:[NSDictionary class]]) {
                for (NSDictionary *dic in self.circleDic[@"ResponseBody"][@"scenery"]) {
                    RRPHomeCircleModel *circleModel = [RRPHomeCircleModel mj_objectWithKeyValues:dic];
                    [self.circlePicArray addObject:circleModel];
                }
            }

        }
        [self.tableView reloadData];
    }];
}

//请求景区分类数据
- (void)requestNavigationListData
{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"navigation_list" forKey:@"method"];
    if ([[RRPAllCityHandle shareAllCityHandle].passCityModel.city_code length] > 0) {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[RRPAllCityHandle shareAllCityHandle].passCityModel.city_code forKey:@"city_code"];
    }else{
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"110100" forKey:@"city_code"];
    }
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:HomeCircleScrollView parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //检查字典中是否含有：“<NULL>”这样的字符串，有就改为“”
        NSDictionary * nullDict = [RRPPrintObject nullDic:dict];
        self.homeClassifyDic = [[NSDictionary alloc] init];
        self.homeClassifyDic = nullDict;
        [[NSUserDefaults standardUserDefaults] setValue:self.homeClassifyDic forKey:@"景区分类"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000)  {
            [self.homeClassifyArray removeAllObjects];
            for (NSDictionary *dic in dict[@"ResponseBody"][@"list"]) {
                self.classifyModel = [RRPHomeClassifyModel mj_objectWithKeyValues:dic];
                [self.homeClassifyArray addObject:self.classifyModel];
            }
            [self.moreArray removeAllObjects];
            for (NSDictionary *dic in dict[@"ResponseBody"][@"more"]) {
                self.classifyModel = [RRPHomeClassifyModel mj_objectWithKeyValues:dic];
                [self.moreArray addObject:self.classifyModel];
            }
            
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        //从缓存取出景区分类数据
        self.homeClassifyDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"景区分类"];
        if (self.homeClassifyDic != nil) {
            [[NSUserDefaults standardUserDefaults] setValue:self.homeClassifyDic forKey:@"景区分类"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.homeClassifyArray removeAllObjects];
            for (NSDictionary *dic in self.homeClassifyDic[@"ResponseBody"][@"list"]) {
                self.classifyModel = [RRPHomeClassifyModel mj_objectWithKeyValues:dic];
                [self.homeClassifyArray addObject:self.classifyModel];
            }
            [self.moreArray removeAllObjects];
            for (NSDictionary *dic in self.homeClassifyDic[@"ResponseBody"][@"more"]) {
                self.classifyModel = [RRPHomeClassifyModel mj_objectWithKeyValues:dic];
                [self.moreArray addObject:self.classifyModel];
            }
            [self.tableView reloadData];
        }
        
    }];
}
//请求精选门票数据
- (void)networkWithPage:(NSInteger)pag {
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"selected_ticket" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"selected" forKey:@"selected"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic removeObjectForKey:@"limit"];
    NSString *longitude = [RRPYCSigleClass mapLatitudeLongitudePassByValue].longitude;
    NSString *latitude = [RRPYCSigleClass mapLatitudeLongitudePassByValue].latitude;
    NSString *location = [NSString stringWithFormat:@"%@,%@",longitude,latitude];
    if (longitude.length > 0 && latitude.length > 0) {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:location forKey:@"location"];
        [self.locationManager stopUpdatingLocation];
    }else {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"116.46,39.92" forKey:@"location"];
    }
    if ([[RRPAllCityHandle shareAllCityHandle].passCityModel.city_code length] > 0) {
        [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[RRPAllCityHandle shareAllCityHandle].passCityModel.city_code forKey:@"city_code"];
    }else{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"110100" forKey:@"city_code"];
    }
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:HomeSelected parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //检查字典中是否含有：“<NULL>”这样的字符串，有就改为“”
        NSDictionary * nullDict = [RRPPrintObject nullDic:dict];
        self.homeSelectedDic = [[NSDictionary alloc] init];
        self.homeSelectedDic = nullDict;
        [[NSUserDefaults standardUserDefaults] setValue:self.homeSelectedDic forKey:@"门票精选"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSInteger code = [[nullDict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        [self.showDateArray removeAllObjects];
        [self.dateArray removeAllObjects];
        [self.horizonShowArray removeAllObjects];
        if (code == 1000)  {
            for (NSDictionary *dic in dict[@"ResponseBody"]) {
                RRPHomeSelected *homeSelected = [RRPHomeSelected mj_objectWithKeyValues:dic];
                [self.dateArray addObject:homeSelected];
            }
            if (self.dateArray.count <= 8) {
                self.horizonShowArray = self.dateArray;
            }else
            {
              //横排展示
            for (int i = 0; i < 8; i++) {
                [self.horizonShowArray addObject:self.dateArray[i]];
              }
            }
        }
        [self.collectionView reloadData];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [[Utility sharedInstance]showAfnError:error];
        [self.showDateArray removeAllObjects];
        [self.dateArray removeAllObjects];
        [self.horizonShowArray removeAllObjects];
        //从缓存取出门票精选数据
        self.homeSelectedDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"门票精选"];
        if (self.homeSelectedDic != nil) {
            [[NSUserDefaults standardUserDefaults] setValue:self.homeSelectedDic forKey:@"门票精选"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            for (NSDictionary *dic in self.homeSelectedDic[@"ResponseBody"]) {
                RRPHomeSelected *homeSelected = [RRPHomeSelected mj_objectWithKeyValues:dic];
                [self.dateArray addObject:homeSelected];
            }
            
            if (self.dateArray.count <= 8) {
                self.horizonShowArray = self.dateArray;
            }else
            {
                //横排展示
                for (int i = 0; i < 8; i++) {
                    [self.horizonShowArray addObject:self.dateArray[i]];
                }
            }
            [self.collectionView reloadData];
        }

    }];
}
#pragma mark - UITableViewDataSource
//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return 2;
    }else
    {
        return 1;
    }
    
}

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        if (section == 0) {
            return 0;
        }else {
                return self.horizonShowArray.count;
        }
    }else
    {
        return self.searchArray.count;
    }
}
//cell展示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
            RRPHomeOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPHomeOneTableViewCell" forIndexPath:indexPath];
            //取消点击样式
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.dk_backgroundColorPicker = DKColorWithColors(IWColor(240, 240, 240), IWColor(150, 150, 150));
        if (self.horizonShowArray.count > 0) {
             [cell showDateWithRRPHomeSelected:self.horizonShowArray[indexPath.row]];
        }
            return cell;
    }else{
        //SearchBar
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        RRPHomeSearchModel *model = self.searchArray[indexPath.row];
        cell.textLabel.text = model.sceneryname;
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        return RRPWidth/740*350+95;
    }else
    {
        return 40;
    }
    
}
//区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (tableView == self.tableView) {
        if (section == 0) {
            return RRPWidth/750*238+190;
        }else {
            return 30;
        }

    }else
    {
        return 0.1;
    }
}
//区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    if (tableView == self.tableView ) {
        if (section == 0) {
            view.dk_backgroundColorPicker = DKColorWithColors(IWColor(240, 240, 240), IWColor(200, 200, 200));
            NSMutableArray *cyclePic = [[NSMutableArray alloc] init];
            for (RRPHomeCircleModel *circleModel in self.circlePicArray) {
                [cyclePic addObject:circleModel.imgurl];
            }
            //轮播图View
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, RRPWidth, RRPWidth/750*238) delegate:self placeholderImage:[UIImage imageNamed:@"当季热玩750-326"]];
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            cycleScrollView.delegate = self;
            cycleScrollView.currentPageDotColor = [UIColor whiteColor];
            cycleScrollView.imageURLStringsGroup = cyclePic;
            [view addSubview:cycleScrollView];

            //分类View
            self.classifyView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cycleScrollView.frame), RRPWidth, 190)];
            self.classifyView.backgroundColor = [UIColor whiteColor];
            self.classifyView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
            [view addSubview:self.classifyView];
            [self classifyButton];
        }else {
            view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
            UIImageView *featuredImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7.5, 15, 15)];
            featuredImageView.image = [UIImage imageNamed:@"精选"];
            [view addSubview:featuredImageView];
            
            UILabel *featuredLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(featuredImageView.frame)+7.5, 7.5, 200, 15)];
            featuredLabel.text = @"门票精选";
            featuredLabel.textColor = IWColor(235, 0, 68);
            featuredLabel.font = [UIFont systemFontOfSize:15];
            [view addSubview:featuredLabel];
            
            
            UIButton *moreButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
            moreButton.frame = CGRectMake(RRPWidth - 40, 7.5, 35, 15);
            [moreButton setTitle:@"更多>>" forState:(UIControlStateNormal)];
            [moreButton addTarget:self action:@selector(moreButton) forControlEvents:(UIControlEventTouchUpInside)];
            moreButton.titleLabel.font = [UIFont systemFontOfSize:10.5];
            [moreButton setTitleColor:IWColor(100, 100, 100) forState:UIControlStateNormal];
            [view addSubview:moreButton];
            
            
        }
        return view;

    }else
    {
        return nil;
    
    }
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
        RRPChoicenessDetailsController *choicenessDetails = [[RRPChoicenessDetailsController alloc] init];
        RRPHomeCircleModel *circleModel = self.circlePicArray[index];
        //传值
        choicenessDetails.sceneryID = circleModel.ID;
        choicenessDetails.sceneryName = circleModel.sceneryname;
        //统计:轮播图点击
        NSDictionary *dict = @{@"sceneryname":circleModel.sceneryname,@"ID":circleModel.ID};
        [MobClick event:@"7" attributes:dict];
        [self.navigationController pushViewController:choicenessDetails animated:YES];

}

//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        RRPChoicenessDetailsController *choicenessDetails = [[RRPChoicenessDetailsController alloc] init];
        RRPHomeSelected *homeSelected = self.horizonShowArray[indexPath.row];
        //传值
        choicenessDetails.sceneryID = homeSelected.sceneryid;
        choicenessDetails.sceneryName = homeSelected.sceneryname;
        choicenessDetails.imageURL = homeSelected.imgurl;
        //统计:首页门票精选点击
        NSDictionary *dict = @{@"sceneryName":homeSelected.sceneryname,@"sceneryID":homeSelected.sceneryid};
        [MobClick event:@"9" attributes:dict];
        [self.navigationController pushViewController:choicenessDetails animated:YES];

    }else
    {
//        NSLog(@"点击了一个搜索cell%ld",indexPath.row);
        self.searchBar.placeholder = @"请输入你想要的";
        self.searchBar.text = @"";
        [self.searchBar setShowsCancelButton:NO animated:YES];
        [self.searchBar resignFirstResponder];

        RRPChoicenessDetailsController *choicenessDetails = [[RRPChoicenessDetailsController alloc] init];
        RRPHomeSearchModel *searchModel = self.searchArray[indexPath.row];
        //传值
        choicenessDetails.sceneryID = searchModel.ID;
        choicenessDetails.sceneryName = searchModel.sceneryname;
        [self.navigationController pushViewController:choicenessDetails animated:YES];
    }
    
}
//门票精选更多
- (void) moreButton {
    RRPChoicenessViewController *Choiceness = [[RRPChoicenessViewController alloc] init];
    //统计:首页门票精选更多
    [MobClick event:@"10"];
    [self.navigationController pushViewController:Choiceness animated:YES];
    
}
//转换按钮点击方法
- (void) transformButton:(UIButton *)sender {
    if (Transform == YES) {
        [self.transformButton setBackgroundImage:[UIImage imageNamed:@"竖排"] forState:(UIControlStateNormal)];
        Transform = NO;
    }else if (Transform == NO) {
        [self.transformButton setBackgroundImage:[UIImage imageNamed:@"田字排"] forState:(UIControlStateNormal)];
        Transform = YES;
    }
    [self.tableView reloadData];
    [self.collectionView reloadData];

}
//分类按钮创建
- (void)classifyButton {
    for (int i = 0; i <= 3; i++) {
        for (int j = 0; j<= 1; j++) {
            self.button = [UIButton buttonWithType:(UIButtonTypeSystem)];
            self.button.frame = CGRectMake(10 +((RRPWidth - 20-320)/3 + 80 )* i , 10+(10+80)*j, 80, 80);
            [self.button addTarget:self action:@selector(button:) forControlEvents:(UIControlEventTouchUpInside)];
            UIImageView *classifyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 50, 50)];
            [self.button addSubview:classifyImageView];
            
            self.classifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(classifyImageView.frame)+5, 50, 15)];
            self.classifyLabel.textColor = IWColor(50, 50, 50);
            self.classifyLabel.font = [UIFont systemFontOfSize:12];
            self.classifyLabel.textAlignment = 1;
            [self.button addSubview:self.classifyLabel];
            [self.classifyView addSubview:self.button];
            if (j == 0 && self.homeClassifyArray.count != 0) {
                if (i == 0) {
                    RRPHomeClassifyModel *model = self.homeClassifyArray[0];
                    self.classifyLabel.text = model.name;
                    self.button.tag = 110;
                    classifyImageView.image = [UIImage imageNamed:@"home-interestPlaces"];
                }else if (i == 1) {
                    RRPHomeClassifyModel *model = self.homeClassifyArray[1];
                    self.classifyLabel.text = model.name;
                    classifyImageView.image = [UIImage imageNamed:@"home-scenicSpot"];
                    self.button.tag = 111;
                }else if (i == 2) {
                    RRPHomeClassifyModel *model = self.homeClassifyArray[2];
                    self.classifyLabel.text = model.name;
                    classifyImageView.image = [UIImage imageNamed:@"home-naturalScenery"];
                    self.button.tag = 112;
                }else if (i == 3) {
                    RRPHomeClassifyModel *model = self.homeClassifyArray[3];
                    self.classifyLabel.text = model.name;
                    self.button.tag = 113;
                    classifyImageView.image = [UIImage imageNamed:@"home-hotspring"];
                }
                
            }else if (j == 1 && self.homeClassifyArray.count != 0) {
                if (i == 0) {
                    RRPHomeClassifyModel *model = self.homeClassifyArray[4];
                    self.classifyLabel.text = model.name;
                    classifyImageView.image = [UIImage imageNamed:@"动植物园"];
                    self.button.tag = 114;
                }else if (i == 1) {
                    RRPHomeClassifyModel *model = self.homeClassifyArray[5];
                    self.classifyLabel.text = model.name;
                    classifyImageView.image = [UIImage imageNamed:@"博物馆"];
                    self.button.tag = 115;
                }else if (i == 2) {
                    RRPHomeClassifyModel *model = self.homeClassifyArray[6];
                    self.classifyLabel.text = model.name;
                    classifyImageView.image = [UIImage imageNamed:@"home-entertainment"];
                    self.button.tag = 116;
                }else if (i == 3) {
                    self.classifyLabel.text = @"更多";
                    self.button.tag = 117;
                    classifyImageView.image = [UIImage imageNamed:@"更多"];
                }
            }
        }
    }
    
}
//分类按钮点击方法
- (void)button:(UIButton *)sender {
    if (sender.tag == 110) {
        //跳转到详情页面
        RRPClassifyDetailController *classifyDetailVC = [[RRPClassifyDetailController alloc] init];
        RRPHomeClassifyModel *classifyModel = self.homeClassifyArray[0];
        classifyDetailVC.ID = classifyModel.classcode;
        classifyDetailVC.sceneryname = classifyModel.name;
        //统计:首页分类按钮点击
        NSDictionary *dict = @{@"name":classifyModel.name,@"classcode":classifyModel.classcode};
        [MobClick event:@"8" attributes:dict];
        [self.navigationController pushViewController:classifyDetailVC animated:YES];
        
    }else if (sender.tag == 111) {
        //跳转到详情页面
        RRPClassifyDetailController *classifyDetailVC = [[RRPClassifyDetailController alloc] init];
        RRPHomeClassifyModel *classifyModel = self.homeClassifyArray[1];
        classifyDetailVC.ID = classifyModel.classcode;
        classifyDetailVC.sceneryname = classifyModel.name;
        //统计:首页分类按钮点击
        NSDictionary *dict = @{@"name":classifyModel.name,@"classcode":classifyModel.classcode};
        [MobClick event:@"8" attributes:dict];
        [self.navigationController pushViewController:classifyDetailVC animated:YES];
    }else if (sender.tag == 112) {
        //跳转到详情页面
        RRPClassifyDetailController *classifyDetailVC = [[RRPClassifyDetailController alloc] init];
        RRPHomeClassifyModel *classifyModel = self.homeClassifyArray[2];
        classifyDetailVC.ID = classifyModel.classcode;
        classifyDetailVC.sceneryname = classifyModel.name;
        //统计:首页分类按钮点击
        NSDictionary *dict = @{@"name":classifyModel.name,@"classcode":classifyModel.classcode};
        [MobClick event:@"8" attributes:dict];
        [self.navigationController pushViewController:classifyDetailVC animated:YES];
    }else if (sender.tag == 113) {
        //跳转到详情页面
        RRPClassifyDetailController *classifyDetailVC = [[RRPClassifyDetailController alloc] init];
        RRPHomeClassifyModel *classifyModel = self.homeClassifyArray[3];
        classifyDetailVC.ID = classifyModel.classcode;
        classifyDetailVC.sceneryname = classifyModel.name;
        //统计:首页分类按钮点击
        NSDictionary *dict = @{@"name":classifyModel.name,@"classcode":classifyModel.classcode};
        [MobClick event:@"8" attributes:dict];
        [self.navigationController pushViewController:classifyDetailVC animated:YES];
    }else if (sender.tag == 114) {
        //跳转到详情页面
        RRPClassifyDetailController *classifyDetailVC = [[RRPClassifyDetailController alloc] init];
        RRPHomeClassifyModel *classifyModel = self.homeClassifyArray[4];
        classifyDetailVC.ID = classifyModel.classcode;
        classifyDetailVC.sceneryname = classifyModel.name;
        //统计:首页分类按钮点击
        NSDictionary *dict = @{@"name":classifyModel.name,@"classcode":classifyModel.classcode};
        [MobClick event:@"8" attributes:dict];
        [self.navigationController pushViewController:classifyDetailVC animated:YES];
    }else if (sender.tag == 115) {
        //跳转到详情页面
        RRPClassifyDetailController *classifyDetailVC = [[RRPClassifyDetailController alloc] init];
        RRPHomeClassifyModel *classifyModel = self.homeClassifyArray[5];
        classifyDetailVC.ID = classifyModel.classcode;
        classifyDetailVC.sceneryname = classifyModel.name;
        //统计:首页分类按钮点击
        NSDictionary *dict = @{@"name":classifyModel.name,@"classcode":classifyModel.classcode};
        [MobClick event:@"8" attributes:dict];
        [self.navigationController pushViewController:classifyDetailVC animated:YES];
    }else if (sender.tag == 116) {
        //跳转到详情页面
        RRPClassifyDetailController *classifyDetailVC = [[RRPClassifyDetailController alloc] init];
        RRPHomeClassifyModel *classifyModel = self.homeClassifyArray[6];
        classifyDetailVC.ID = classifyModel.classcode;
        classifyDetailVC.sceneryname = classifyModel.name;
        //统计:首页分类按钮点击
        NSDictionary *dict = @{@"name":classifyModel.name,@"classcode":classifyModel.classcode};
        [MobClick event:@"8" attributes:dict];
        [self.navigationController pushViewController:classifyDetailVC animated:YES];
    }else if (sender.tag == 117) {
    //跳转到更多页面
    ScenicSpotViewController *scenicSpotVC =[[ScenicSpotViewController alloc] init];
        //传值
        scenicSpotVC.classifyArray = self.moreArray;
        //统计:更多
        [MobClick event:@"8_1"];
        [self.navigationController pushViewController:scenicSpotVC animated:YES];
    }
}
#pragma mark - collectionView部分
//collectonView懒加载
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 440) collectionViewLayout:self.flowLayout];
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
    return self.showDateArray.count;
}
//cell展示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RRPCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RRPCollectionCell" forIndexPath:indexPath];
    [cell showDate:self.showDateArray[indexPath.row]];
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
//items大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((RRPWidth-30) / 2, (self.collectionView.frame.size.height - 30)/2);
}
//cell边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 0, 10);
}
#pragma mark - UICollectionViewDelegate
//collection cell 点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RRPChoicenessDetailsController *choicenessDetails = [[RRPChoicenessDetailsController alloc] init];
    RRPHomeSelected *homeSelected = self.showDateArray[indexPath.row];
    //传值
    choicenessDetails.sceneryID = homeSelected.sceneryid;
    choicenessDetails.sceneryName = homeSelected.sceneryname;
    choicenessDetails.sceneryIntroduce = homeSelected.summary;
    [self.navigationController pushViewController:choicenessDetails animated:YES];
}
#pragma mark - 分享参数请求
- (void)shareDownLoadData {
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"app_share" forKey:@"method"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:HomeShare parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dict = [RRPPrintObject nullDic:dic];
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            [RRPFindTopModel shareRRPFindTopModel].content = dict[@"ResponseBody"][@"content"];
            [RRPFindTopModel shareRRPFindTopModel].download_link_ios = dict[@"ResponseBody"][@"download_link_ios"];
            [RRPFindTopModel shareRRPFindTopModel].download_share = dict[@"ResponseBody"][@"download_share"];
            [RRPFindTopModel shareRRPFindTopModel].imgurl = dict[@"ResponseBody"][@"imgurl"];
            [RRPFindTopModel shareRRPFindTopModel].title = dict[@"ResponseBody"][@"title"];
            [RRPFindTopModel shareRRPFindTopModel].status = [dict[@"ResponseBody"][@"status"] integerValue];
            if ([dict[@"ResponseBody"][@"status"] integerValue] == 2) {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                if ([user boolForKey:@"Firstwork"]) {
                    //不是第一次运行
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                message:@"GPS在后台持续运行，会大大降低电池的寿命。"
                                               delegate:self
                                      cancelButtonTitle:@"确认"
                                      otherButtonTitles:nil] show];
                    
                    [user setBool:YES forKey:@"Firstwork"];
                }
            }
            [RRPFindTopModel shareRRPFindTopModel].version_number = dict[@"ResponseBody"][@"version_number"];
            
          }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
         
            
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
