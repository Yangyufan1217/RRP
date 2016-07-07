//
//  RRPCityListViewController.m
//  RRP
//
//  Created by WangZhaZha on 16/3/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPCityListViewController.h"
#import "RRPAllCityModel.h"
#import "RRPAllCityHandle.h"
#import "RRPHomeHotCityCell.h"
#import "RRPHomeCityCell.h"
#import "RRPHomeLocationView.h"
#import "RRPHomeCityIndexView.h"
#import "RRPCityListHotCityView.h"
@interface RRPCityListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *allCityTableView;
@property (nonatomic,strong)NSMutableDictionary *allCityDic;//承装全部城市
@property (nonatomic,strong) NSMutableArray *dateArray;
@property (nonatomic,strong) NSMutableArray *allKeys;
@property (nonatomic,strong) NSSet *set;
@property (nonatomic,assign) NSInteger hotCityNumber;
@property (nonatomic,strong) NSMutableArray *nullArray;

@property (nonatomic,strong)NSMutableDictionary *allCityDefaultDic;
@property (nonatomic,strong)NSString *passCityName;
@end

@implementation RRPCityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //取消滚动视图的自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"城市列表";
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    //给数组开辟空间 并拷贝一份防止丢失 类似于深拷贝
    self.allCityDic = [NSMutableDictionary dictionary];
    self.dateArray = [@[] mutableCopy];
    self.hotCityArray = [@[] mutableCopy];
    //数组初始化
    self.nullArray = [@[] mutableCopy];

    [self.allCityTableView registerNib:[UINib nibWithNibName:@"RRPHomeCityCell" bundle:nil] forCellReuseIdentifier:@"RRPHomeCityCell"];
    [self.view addSubview:self.allCityTableView];
    [self requestHotCityWithPage:1];
    [self requestAllCityWithPage:1];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getValue) name:@"AllCityName" object:nil];
 }
//点击热门城市跳转会首页
- (void)getValue
{
    [self.navigationController popViewControllerAnimated:YES];

}
//请求热门城市数据
- (void)requestHotCityWithPage:(NSInteger)page
{
    
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"hot_city" forKey:@"method"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [manager POST:HomeHotCity parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取数据
        NSDictionary *hotCityDic = responseObject;
        NSInteger code = [[hotCityDic[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            for (NSDictionary *dic in hotCityDic[@"ResponseBody"]) {
                RRPAllCityModel *hotCityModel = [RRPAllCityModel mj_objectWithKeyValues:dic];
                [self.hotCityArray addObject:hotCityModel];
            }
        }
        [self.allCityTableView reloadData];
        self.hotCityNumber = self.hotCityArray.count;
        [RRPAllCityHandle shareAllCityHandle].hotCityNumber = self.hotCityArray.count;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//请求全部城市列表
- (void)requestAllCityWithPage:(NSInteger)page {
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"all_city" forKey:@"method"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [manager POST:HomeAllCity parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取数据
        NSDictionary *dict = responseObject;
//        NSLog(@"全部城市%@",dict);
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            for (NSDictionary *dic in dict[@"ResponseBody"]) {
                RRPAllCityModel *model = [RRPAllCityModel mj_objectWithKeyValues:dic];
                //获取对应分组名
                NSString *groupName = [self getFirstNameWithChineseName:model.city_name];
                //获取对应分组
                NSMutableArray *group = [self.allCityDic valueForKey:groupName];
                if (group == nil) {
                    group = [NSMutableArray array];
                    //添加到字典中
                    [self.allCityDic setValue:group forKey:groupName];
                    //添加新的key
                    [self.allKeys addObject:groupName];
                    //重新排序
                    [self.allKeys sortUsingSelector:@selector(compare:)];
                }
                //将城市添加到分组中
                [group addObject:model];
            }
        }
        [self.allCityDic setValue:self.nullArray forKey:@"#"];
        [self.allCityDic setValue:self.nullArray forKey:@"*"];
        //获取所有key 并进行排序
        NSArray *sortArr = [[self.allCityDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        self.allKeys = [NSMutableArray arrayWithArray:sortArr];
        //刷新数据
        [self.allCityTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//获取字符串首字母并把它转化为大写英文字母
- (NSString *) getFirstNameWithChineseName:(NSString *)name
{
    //转化为可变字符串
    NSMutableString *muName = [NSMutableString stringWithFormat:@"%@",name];
    //转化为带音调的拼音
    CFStringTransform((CFMutableStringRef)muName , NULL, kCFStringTransformMandarinLatin, NO);
    //转化为不带音调的拼音
    CFStringTransform((CFMutableStringRef)muName, NULL, kCFStringTransformStripDiacritics, NO);
    return [[muName substringToIndex:1] uppercaseString];
    
}
//懒加载 全部城市tableView
- (UITableView *)allCityTableView
{
    if (_allCityTableView == nil) {
        self.allCityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,30,RRPWidth, RRPHeight-10) style:(UITableViewStyleGrouped)];
        self.allCityTableView.tableFooterView = [[UIView alloc] init];
        self.allCityTableView.showsVerticalScrollIndicator = NO;
        self.allCityTableView.delegate = self;
        self.allCityTableView.dataSource = self;
    }
    return _allCityTableView;


}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRPHomeCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPHomeCityCell" forIndexPath:indexPath];
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    //获取对应key
    NSString *key = self.allKeys[indexPath.section];
    //获取对应分组
    NSMutableArray *group = [self.allCityDic valueForKey:key];
    //获取对应元素
    RRPAllCityModel *cityModel = group[indexPath.row];
    cell.cityName.text = cityModel.city_name;
    return cell;
}
//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.allKeys.count;
    
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //获取对应key
    NSString *key = self.allKeys[section];
    //获取对应分组
    NSMutableArray *group = [self.allCityDic valueForKey:key];
    return group.count;
    
}
#pragma mark - UITableViewDelegate

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
//区头
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 69;
    }else if (section == 1) {
//        if ([RRPAllCityHandle shareAllCityHandle].hotCityNumber != 0) {
//            if ([RRPAllCityHandle shareAllCityHandle].hotCityNumber % 3 == 0) {
//                return  [RRPAllCityHandle shareAllCityHandle].hotCityNumber/3*38+40;
//            }else{
//                
//                return  ([RRPAllCityHandle shareAllCityHandle].hotCityNumber/3+1)*38+40;
//            }
//        }else
//        {
//            return 23;
//        }
        return 200;
        
    }else {
        return 23;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        RRPHomeLocationView *locationCityView = [[RRPHomeLocationView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth,69)];
       return locationCityView;
    }else if (section == 1) {
       
        RRPCityListHotCityView *hotCityView = [[RRPCityListHotCityView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, self.hotCityHeight+23)];
        hotCityView.hotCityArray = self.hotCityArray;
        hotCityView.height = self.hotCityHeight;
        return hotCityView;
    }else{
        RRPHomeCityIndexView *indexView = [[RRPHomeCityIndexView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 23)];
        indexView.indexLabel.text = self.allKeys[section];
        return indexView;
    }
}
//区尾
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
//索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.allKeys;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取对应key
    NSString *key = self.allKeys[indexPath.section];
    //获取对应分组
    NSMutableArray *group = [self.allCityDic valueForKey:key];
    //获取对应元素
    RRPAllCityModel *cityModel = group[indexPath.row];
    
    //统计:城市列表点击事件
    NSDictionary *dict = @{@"cityname":cityModel.city_name,@"citycode":cityModel.city_code,@"provincecode":cityModel.province_code,@"type":@"非热门城市"};
    [MobClick event:@"6" attributes:dict];
    [MobClick setLogEnabled:YES];
    
    //发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AllCityName" object:self userInfo:@{@"value":cityModel}];
    [RRPAllCityHandle shareAllCityHandle].passCityModel = cityModel;
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
