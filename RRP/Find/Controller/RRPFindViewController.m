//
//  RRPFindViewController.m
//  RRP
//
//  Created by sks on 16/2/16.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPFindViewController.h"
#import "RRPFindTopViewCell.h"
#import "RRPFindBottonViewCell.h"
#import "RRPHotelListController.h"
#import "RRPEntertainmentListController.h"
#import "RRPSaleListViewController.h"
#import "RRPFindListDetailController.h"
#import "RRPCateListController.h"
#import "RRPFindActiveCell.h"
#import "RRPFindSeasonController.h"
#import "RRPFindTopModel.h"


typedef NS_ENUM(NSInteger, refState){
    refStateHeader = 0,
    refStateFooter = 1,
};

@interface RRPFindViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *activityArray;
@property (nonatomic, assign) NSInteger refreshNumber;//刷新number
@property (nonatomic, strong) NSDictionary * responseBody;//存数据的字典




@end

@implementation RRPFindViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
//    [self downLoadData:refStateHeader andPageNumber:1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发现";
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.dataArray = [@[] mutableCopy];
    self.listArray = [@[] mutableCopy];
    self.activityArray = [@[] mutableCopy];
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout = flowLayout;
    //cell在X轴上的间距,默认10
    self.flowLayout.minimumInteritemSpacing = 7.5;
    //cell在Y轴上的间距,默认10
    self.flowLayout.minimumLineSpacing = 7.5;
    //滚动方向,默认垂直滚动
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"RRPFindTopViewCell" bundle:nil] forCellWithReuseIdentifier:@"RRPFindTopViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"RRPFindActiveCell" bundle:nil] forCellWithReuseIdentifier:@"RRPFindActiveCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"RRPFindBottonViewCell" bundle:nil] forCellWithReuseIdentifier:@"bottomCell"];
    [self.view addSubview:self.collectionView];
    
    //判断字典是否为空
    self.responseBody = [[NSUserDefaults standardUserDefaults]objectForKey:@"ResponseHead"];
    if (self.responseBody != nil) {
        if (self.responseBody[@"class_data"] != nil) {
            //分类
            for (NSDictionary *dic in self.responseBody[@"class_data"]) {
                RRPFindModel *findModel = [RRPFindModel mj_objectWithKeyValues:dic];
                [self.dataArray addObject:findModel];
            }
            [RRPFindTopModel shareRRPFindTopModel].classcodeArray = self.dataArray;
        }
        if (self.responseBody[@"next_data"] != nil) {
            for (NSDictionary *dic in self.responseBody[@"next_data"]) {
                [self.activityArray addObject:dic];
            }
            [RRPFindTopModel shareRRPFindTopModel].dataArray = self.activityArray;
        }
        if (self.responseBody[@"scenery"] != nil) {
            //列表
            for (NSDictionary *dic in self.responseBody[@"scenery"]) {
                RRPFindModel *findModel = [RRPFindModel mj_objectWithKeyValues:dic];
                [self.listArray addObject:findModel];
            }
        }
        [self.collectionView reloadData];
    }
    [self downLoadData:refStateHeader andPageNumber:1];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, RRPHeight) collectionViewLayout:self.flowLayout];
        self.collectionView.dk_backgroundColorPicker = DKColorWithColors(IWColor(241, 240, 246), IWColor(200, 200, 200));
        //设置代理
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _collectionView;
}
//下拉刷新
- (void)loadNewData
{
    [self downLoadData:refStateHeader andPageNumber:1];
    [self.collectionView.header endRefreshing];
}

//加载更多
- (void)loadMoreData
{
    if (self.listArray.count % 15 == 0) {
        [self downLoadData:refStateFooter andPageNumber:(NSInteger)(self.listArray.count/15 + 1)];
    }else
    {
        self.collectionView.footer = nil;
    }
    [self.collectionView.footer endRefreshing];
}

#pragma mark - 网络数据加载
- (void)downLoadData:(refState)refState andPageNumber:(NSInteger)page
{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"all_sort" forKey:@"method"];
//    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"110100" forKey:@"city_code"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"limit"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:FindHome parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dict = [RRPPrintObject nullDic:dic];
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            self.responseBody = dict[@"ResponseBody"];
            [[NSUserDefaults standardUserDefaults] setValue:self.responseBody forKey:@"ResponseHead"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            //分类
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSDictionary *dic in self.responseBody[@"class_data"]) {
                RRPFindModel *findModel = [RRPFindModel mj_objectWithKeyValues:dic];
                [dataArray addObject:findModel];
            }
            //活动列表
            NSMutableArray *activityArray = [NSMutableArray array];
            for (NSDictionary *dic in self.responseBody[@"next_data"]) {
                [activityArray addObject:dic];
            }
            //列表
            NSMutableArray * listArray = [NSMutableArray array];
            for (NSDictionary *dic in self.responseBody[@"scenery"]) {
                RRPFindModel *findModel = [RRPFindModel mj_objectWithKeyValues:dic];
                [listArray addObject:findModel];
            }
            if (refState == refStateHeader) {
                [self.dataArray removeAllObjects];
                [self.listArray removeAllObjects];
                [self.activityArray removeAllObjects];
                self.refreshNumber = 1;
                [self.dataArray addObjectsFromArray:dataArray];
                [self.listArray addObjectsFromArray:listArray];
                [self.activityArray addObjectsFromArray:activityArray];
                [RRPFindTopModel shareRRPFindTopModel].classcodeArray = self.dataArray;
                [RRPFindTopModel shareRRPFindTopModel].dataArray = self.activityArray;
                
            }else{
                if (self.refreshNumber!= page) {
                    [self.listArray addObjectsFromArray:listArray];
                }
            }
            [self.collectionView reloadData];
        }else {
            if ([[Utility sharedInstance]codeWithLogin:code]
                )
            {
                NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
                [def setBool:NO forKey:@"isLogin"];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        self.responseBody = [[NSUserDefaults standardUserDefaults]objectForKey:@"ResponseHead"];
        if ([self.responseBody isKindOfClass:[NSDictionary class]]) {
            [[NSUserDefaults standardUserDefaults] setValue:self.responseBody forKey:@"ResponseHead"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            //分类
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSDictionary *dic in self.responseBody[@"class_data"]) {
                RRPFindModel *findModel = [RRPFindModel mj_objectWithKeyValues:dic];
                [dataArray addObject:findModel];
            }
            //活动列表
            NSMutableArray *activityArray = [NSMutableArray array];
            for (NSDictionary *dic in self.responseBody[@"next_data"]) {
                [activityArray addObject:dic];
            }
            //列表
            NSMutableArray * listArray = [NSMutableArray array];
            for (NSDictionary *dic in self.responseBody[@"scenery"]) {
                RRPFindModel *findModel = [RRPFindModel mj_objectWithKeyValues:dic];
                [listArray addObject:findModel];
            }
            if (refState == refStateHeader) {
                [self.dataArray removeAllObjects];
                [self.listArray removeAllObjects];
                [self.activityArray removeAllObjects];
                self.refreshNumber = 1;
                [self.dataArray addObjectsFromArray:dataArray];
                [self.listArray addObjectsFromArray:listArray];
                [self.activityArray addObjectsFromArray:activityArray];
                [RRPFindTopModel shareRRPFindTopModel].dataArray = self.activityArray;
                [RRPFindTopModel shareRRPFindTopModel].classcodeArray = self.dataArray;
            }else{
                if (self.refreshNumber!= page) {
                    [self.listArray addObjectsFromArray:listArray];
                }
            }
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource
//分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;

}
//item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray.count;
    }else if (section == 1)
    {
        return 1;
    }else
    {
        return self.listArray.count;
    }

}
//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        RRPFindTopViewCell *topCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RRPFindTopViewCell" forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            topCell.topBackImageView.image = [UIImage imageNamed:@"休闲"];
            topCell.bottomLabel.text = @"relax";
            [topCell show:self.dataArray[indexPath.row]];
        }
        if (indexPath.row == 1) {
            topCell.topBackImageView.image = [UIImage imageNamed:@"节日"];
            topCell.bottomLabel.text = @"festival";
            [topCell show:self.dataArray[indexPath.row]];
        }
        if (indexPath.row == 2) {
            topCell.topBackImageView.image = [UIImage imageNamed:@"娱乐"];
            topCell.bottomLabel.text = @"entertainment";
            [topCell show:self.dataArray[indexPath.row]];
        }
        if (indexPath.row == 3) {
            topCell.topBackImageView.image = [UIImage imageNamed:@"特价"];
            topCell.bottomLabel.text = @"price";
            [topCell show:self.dataArray[indexPath.row]];
        }
      return topCell;
    }else if(indexPath.section == 1) {
        RRPFindActiveCell *centerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RRPFindActiveCell" forIndexPath:indexPath];
        return centerCell;
    }else{
        RRPFindBottonViewCell *bottomCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bottomCell" forIndexPath:indexPath];
        [bottomCell show:self.listArray[indexPath.row]];
        return bottomCell;
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake((RRPWidth-25)/2, (RRPWidth-25)/4);
    }else if(indexPath.section == 1){
        return CGSizeMake(RRPWidth, 165);
    }else{
        return CGSizeMake(RRPWidth,RRPWidth/750*168*2);
    }
}
//判断分区设置Y轴距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 7.5;
    }else {
        return 0;
    }
}

#pragma mark - UICollectionViewDelegate
//设置页眉大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
   return CGSizeMake(RRPWidth, 15);
}


//设置边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
       return  UIEdgeInsetsMake(0, 8, 0, 8);
    }else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}


//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        //跳转休闲列表界面
        RRPCateListController *cateListVC = [[RRPCateListController alloc] init];
        RRPFindModel *findModel = self.dataArray[indexPath.row];
        cateListVC.classcode = findModel.classcode;
        //统计:休闲点击
        [MobClick event:@"37"];
        [self.navigationController pushViewController:cateListVC animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        //跳转节目列表界面
        RRPHotelListController *hotelListVC = [[RRPHotelListController alloc] init];
        RRPFindModel *findModel = self.dataArray[indexPath.row];
        hotelListVC.classcode = findModel.classcode;
        //统计:节日门票点击
        [MobClick event:@"39"];
        [self.navigationController pushViewController:hotelListVC animated:YES];
    }else if(indexPath.section == 0 && indexPath.row == 2) {
        //跳转娱乐列表界面
        RRPEntertainmentListController *entertainmentListVC = [[RRPEntertainmentListController alloc] init];
        RRPFindModel *findModel = self.dataArray[indexPath.row];
        entertainmentListVC.classcode = findModel.classcode;
        //统计:运动点击
        [MobClick event:@"41"];
        [self.navigationController pushViewController:entertainmentListVC animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        //跳转特价列列表界面
        RRPSaleListViewController *saleListVC = [[RRPSaleListViewController alloc] init];
        //统计:特价点击
        [MobClick event:@"43"];
        [self.navigationController pushViewController:saleListVC animated:YES];
    }else if (indexPath.section == 2) {
        RRPFindListDetailController *findListDetailVC = [[RRPFindListDetailController alloc] init];
        RRPFindModel *findModel = self.listArray[indexPath.row];
        findListDetailVC.ID = findModel.ID;
        findListDetailVC.sceneryname = findModel.sceneryname;
        //统计:发现通屏大图点击
        NSDictionary *dict = @{@"sceneryname":findModel.sceneryname,@"sceneryID":[NSString stringWithFormat:@"%ld",findModel.ID]};
        [MobClick event:@"51" attributes:dict];
        [self.navigationController pushViewController:findListDetailVC animated:YES];
    }
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
