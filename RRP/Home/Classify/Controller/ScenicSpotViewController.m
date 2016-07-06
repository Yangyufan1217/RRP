//
//  ScenicSpotViewController.m
//  RRP
//
//  Created by sks on 16/2/29.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "ScenicSpotViewController.h"
#import "PrefixHeader.pch"
#import "CityPictureCell.h"
#import "RRPChoicenessDetailsController.h"
#import "RPPCityNameCell.h"
#import "RRPHomeClassifyModel.h"
#import "RRPClassifyListModel.h"


typedef NS_ENUM(NSInteger, refState){
    refStateHeader = 0,
    refStateFooter = 1,
};
@interface ScenicSpotViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UITableView *listTableView;
@property (nonatomic,strong)UICollectionView *listCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)NSMutableArray *listArray;
@property (nonatomic, strong)NSMutableArray *cityListArray;
@property (nonatomic, assign) NSInteger refreshNumber;//刷新number
@property (nonatomic, strong)NSString *classcode;

@end

@implementation ScenicSpotViewController
//视图将要出现的时候 隐藏底部tabBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.listCollectionView reloadData];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.listArray = [@[] mutableCopy];
    self.cityListArray = [@[] mutableCopy];
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout = flowLayout;
    //cell在X轴上的间距,默认10
    self.flowLayout.minimumInteritemSpacing = 10;
    //cell在Y轴上的间距,默认10
    self.flowLayout.minimumLineSpacing = 7.5;
    //滚动方向,默认垂直滚动
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //右侧图片列表
    [self layoutCollectionView];
    //取出首页分类列表后面部分放入数组
    for (int i = 8 ; i < self.classifyArray.count ; i++) {
        RRPHomeClassifyModel *model = self.classifyArray[i];
        [self.listArray addObject:model];
    }
    //注册tableViewcell
    [_listCollectionView registerNib:[UINib nibWithNibName:@"CityPictureCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    //注册collectionViewcell
    [_listTableView registerNib:[UINib nibWithNibName:@"RPPCityNameCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cityNameCell"];
    
    //请求右侧数据
    RRPHomeClassifyModel *model = self.classifyArray[0];
    self.classcode = model.classcode;
    [self setUpRefreshWithClasscode];
    
    
}
//请求右侧数据
- (void)downLoadData:(refState)refState andPageNumber:(NSInteger)page ListID:(NSString *)listID
{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"scenery_list" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:listID forKey:@"classcode"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"limit"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [manager POST:HomeClassifyList  parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取数据
        NSDictionary *calssifyListDic = responseObject;
        NSInteger code = [[calssifyListDic[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            NSMutableArray *cityListArray = [NSMutableArray array];
            for (NSDictionary *dic in calssifyListDic[@"ResponseBody"]) {
                RRPClassifyListModel *classifyListModel = [RRPClassifyListModel mj_objectWithKeyValues:dic];
                [cityListArray addObject:classifyListModel];
            }
            if (refState == refStateHeader) {
                [self.cityListArray removeAllObjects];
                self.refreshNumber = 1;
                [self.cityListArray addObjectsFromArray:cityListArray];
            }else{
                if (self.refreshNumber!= page) {
                    [self.cityListArray addObjectsFromArray:cityListArray];
                }
            }
            

        }else if (code == 4001)
        {
            [self.cityListArray removeAllObjects];
        }
        [self.listCollectionView.header endRefreshing];
        //刷新数据
        [self.listCollectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}
//左侧城市列表
- (UITableView *)listTableView
{
    if (_listTableView == nil) {
        self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 72, 100, RRPHeight-72)];
        //设计数据源 代理
        self.listTableView.dataSource = self;
        self.listTableView.delegate = self;
        //隐藏滚动条
        self.listTableView.showsVerticalScrollIndicator = NO;
        
        //隐藏cell的分割线
        self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.listTableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(242, 242, 242), IWColor(150, 150, 150));
        //添加父视图
        [self.view addSubview:_listTableView];
    }
    return _listTableView;

}

#pragma mark - UITableViewDataSource UITableViewDelegate
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
//设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPPCityNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityNameCell" forIndexPath:indexPath];
    //取消点击样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    RRPHomeClassifyModel *model = self.classifyArray[indexPath.row];
    cell.cityNameLabel.text = model.name;
    if (indexPath.row == 0) {
        cell.backgroundImage.image = [UIImage imageNamed:@"更多-选中"];
        cell.cityNameLabel.textColor =  [UIColor whiteColor];
    }else {
        cell.backgroundImage.image = [UIImage imageNamed:@"gray.png"];
        cell.cityNameLabel.textColor = [UIColor blackColor];
    }
    return cell;
}
//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
//选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        for (int i = 0; i < self.classifyArray.count ; i++) {
            //第一分区的第i个cell
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
            RPPCityNameCell *cell = [tableView cellForRowAtIndexPath:index];
            cell.backgroundImage.image = [UIImage imageNamed:@"gray.png"];
            cell.cityNameLabel.textColor = [UIColor blackColor];
        }
        //获取选中cell
        RPPCityNameCell  *cell = [self.listTableView cellForRowAtIndexPath:indexPath];
        RRPHomeClassifyModel *model = self.classifyArray[indexPath.row];
        self.classcode = model.classcode;
        //统计:首页分类更多标签点击
    NSDictionary *dict = @{@"labelname":model.name,@"classcode":model.classcode};
    [MobClick event:@"11" attributes:dict];
        [self setUpRefreshWithClasscode];
        cell.backgroundImage.image = [UIImage imageNamed:@"更多-选中"];
        cell.cityNameLabel.textColor =  [UIColor whiteColor];
}


//右侧图片列表
- (void)layoutCollectionView
{
    self.listCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.listTableView.frame), 72,RRPWidth-self.listTableView.frame.size.width, RRPHeight-64) collectionViewLayout:self.flowLayout];
    _listCollectionView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.listCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.listCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataWithClasscode:)];
    [self.view addSubview:_listCollectionView];
    _listCollectionView.showsVerticalScrollIndicator = NO;
    //设置代理 数据源
    _listCollectionView.dataSource = self;
    _listCollectionView.delegate = self;
    
}
- (void)setUpRefreshWithClasscode
{
    
    self.listCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.listCollectionView.header beginRefreshing];
    [self.listCollectionView.header endRefreshing];

}

- (void)loadNewData
{
    [self downLoadData:refStateHeader andPageNumber:1 ListID:self.classcode];
    [self.listCollectionView.header endRefreshing];
}


//加载更多
- (void)loadMoreDataWithClasscode:(NSString *)classcode
{
    if (self.classifyArray.count % 15 == 0) {
        [self downLoadData:refStateFooter andPageNumber:self.classifyArray.count/15 + 1 ListID:self.classcode];
    }else
    {
        self.listCollectionView.footer = nil;
    }
    
     [self.listCollectionView.footer endRefreshing];
}

#pragma mark - UICollectionViewDataSource UICollectionViewDelegate
//分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;

}
//item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.cityListArray.count;
}
//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CityPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = IWColor(30, 90, 123);
    RRPClassifyListModel *model = self.cityListArray[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
#pragma mark - UICollectionViewFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.listCollectionView.frame.size.width - 48),(self.listCollectionView.frame.size.width - 48)/240*120);
}
//设置边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 19, 20, 19);
}

//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到订票详情页
    RRPChoicenessDetailsController *RRPChoicenessDetailsVC = [[RRPChoicenessDetailsController alloc] init];
    RRPClassifyListModel *model = self.cityListArray[indexPath.row];
    RRPChoicenessDetailsVC.sceneryID = model.ID;
    RRPChoicenessDetailsVC.sceneryName = model.sceneryname;
    RRPChoicenessDetailsVC.imageURL = model.imgurl;
    RRPChoicenessDetailsVC.sceneryIntroduce = [NSString stringWithFormat:@"现价只需%@",model.sellerprice];
    //统计:景区列表点击
    NSDictionary *dict = @{@"sceneryName":model.sceneryname,@"sceneryID":model.ID};
    [MobClick event:@"12" attributes:dict];
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
