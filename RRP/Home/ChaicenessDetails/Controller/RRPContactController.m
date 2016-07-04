//
//  RRPContactController.m
//  RRP
//
//  Created by sks on 16/3/4.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPContactController.h"
#import "RRPContactOneCell.h"
#import "RRPAddCTPersonClickCell.h"
#import "RRPRelationPersonCell.h"
#import "RRPAllCityHandle.h"
#import "RRPTicketContactModel.h"
#import "RRPAddContactPersonController.h"
@interface RRPContactController ()<UITableViewDataSource,UITableViewDelegate>{
    NSIndexPath* checkedIndexPath;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSDictionary *contactDic;
@property (nonatomic,strong) NSMutableArray *contactArray;
@property (nonatomic,assign) NSInteger starCount;
@property (nonatomic,assign) NSInteger row;//单选下标
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;
@property (nonatomic,strong)NSMutableArray *contactShowArray;

@end

@implementation RRPContactController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.contactArray = [@[] mutableCopy];
    self.contactShowArray = [@[] mutableCopy];
    [self requestAllContactData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    //让代理执行协议中的方法
    [_delegate passValueWithArray:self.contactShowArray];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorWithColors(IWColor(242, 245, 247), IWColor(200, 200, 200));
    self.title = @"选取取票人";
    if ([self.personCount isEqualToString:@"0"]) {
        self.personCount = @"1";
    }
    //左侧返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];
    //右侧完成按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(finishAction:)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPContactOneCell" bundle:nil] forCellReuseIdentifier:@"RRPContactOneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPAddCTPersonClickCell" bundle:nil] forCellReuseIdentifier:@"RRPAddCTPersonClickCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPRelationPersonCell" bundle:nil] forCellReuseIdentifier:@"RRPRelationPersonCell"];
    [self.view addSubview:self.tableView];
    
    //注册通知 加星 实现方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addStarAction:) name:@"加星" object:nil];
    //注册通知 减星 实现方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downStarAction:) name:@"减星" object:nil];
    //注册通知 编辑 实现方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editContact:) name:@"editContact" object:nil];
}
//返回
- (void)returnAction:(UIBarButtonItem *)bt
{
    [self.navigationController popViewControllerAnimated:YES];
}
//右侧完成按钮
- (void)finishAction:(UIBarButtonItem *)item
{
    //让代理执行协议中的方法
    [_delegate passValueWithArray:self.contactShowArray];
    [self.navigationController popViewControllerAnimated:YES];
}
//加星
- (void)addStarAction:(NSNotification *)notification
{
    self.starCount++;
    [RRPAllCityHandle shareAllCityHandle].starCount = self.starCount;
    UIButton *sender = [notification valueForKey:@"userInfo"][@"value"];
    RRPRelationPersonCell * cell = (RRPRelationPersonCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    self.row = path.row;
    RRPTicketContactModel *contactModel = self.contactArray[path.row];
    [self.contactShowArray addObject:contactModel];
    [self.tableView reloadData];

}
//减星
- (void)downStarAction:(NSNotification *)notification
{
    self.starCount--;
    [RRPAllCityHandle shareAllCityHandle].starCount = self.starCount;
    UIButton *sender = [notification valueForKey:@"userInfo"][@"value"];
    RRPRelationPersonCell * cell = (RRPRelationPersonCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    self.row = path.row;
    RRPTicketContactModel *contactModel = self.contactArray[path.row];
    [self.contactShowArray removeObject:contactModel];
    [self.tableView reloadData];

}
//编辑获取所在行
- (void)editContact:(NSNotification *)notification
{
    UIButton *sender = [notification valueForKey:@"userInfo"][@"value"];
    RRPRelationPersonCell * cell = (RRPRelationPersonCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    RRPTicketContactModel *model = self.contactArray[path.row];
    RRPAddContactPersonController *addContactVC = [[RRPAddContactPersonController alloc] init];
    addContactVC.editModel = model;
    addContactVC.submitType = @"编辑";
    [self.navigationController pushViewController:addContactVC animated:YES];
}
//获取全部取票人
- (void)requestAllContactData
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"commoncontacts" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
//    NSLog(@"%@",dic);
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:MyContact parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        self.contactDic = [[NSDictionary alloc] init];
        self.contactDic = dict;
//        NSLog(@"订单详情%@",self.contactDic);
        NSInteger code = [[self.contactDic[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000 ) {
            //判断normal_data 是否为空
    
                [self.contactArray removeAllObjects];
                for (NSDictionary *dic in self.contactDic[@"ResponseBody"]) {
                    RRPTicketContactModel *contactModel =  [RRPTicketContactModel mj_objectWithKeyValues:dic];
                    [self.contactArray addObject:contactModel];
                }
        }else if (code == 250) {
            self.contactArray = nil;
        }
       [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}
//删除
- (void)requestDeletContactWithModel:(RRPTicketContactModel *)model
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"normal_delete" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:model.mr_id forKey:@"mr_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"user_id"];
    
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
//    NSLog(@"删除%@",dic);
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:GetPriceCanlender parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"删除联系人%@",dict);
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000)  {
            if ([[dict[@"ResponseBody"] valueForKey:@"code"] integerValue] == 2000) {
                NSString *msg = [dict[@"ResponseBody"] valueForKey:@"msg"];
                
//                [self.tableView reloadData];
                
             }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

}
//懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,RRPWidth, RRPHeight)];
        self.tableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(246, 246, 246), IWColor(200, 200, 200));
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else{
       return self.contactArray.count;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        RRPContactOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPContactOneCell" forIndexPath:indexPath];
        if ([[RRPAllCityHandle shareAllCityHandle].orderModel.isrealname isEqualToString:@"0"]) {
            //非实名制 只需添加一名取票人
            cell.needNumberLabel.text = @"1";
            cell.grossNumberLabel.text = @"1";
        }else
        {
            cell.needNumberLabel.text = self.personCount;
            cell.grossNumberLabel.text = self.personCount;
        
        }
        cell.selectNumberLabel.text = [NSString stringWithFormat:@"%ld",[RRPAllCityHandle shareAllCityHandle].starCount ];;
        //取消点击样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.dk_backgroundColorPicker = DKColorWithColors(IWColor(242, 245, 247), IWColor(200, 200, 200));
        return cell;
    }else if (indexPath.row == 1 && indexPath.section == 0) {
        RRPAddCTPersonClickCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPAddCTPersonClickCell" forIndexPath:indexPath];
        //取消点击样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
        return cell;
    }else {
        RRPRelationPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPRelationPersonCell" forIndexPath:indexPath];
        //取消点击样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell showDataWithModel:self.contactArray[indexPath.row]];
        return cell;
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 45;
    }else if (indexPath.row == 1 && indexPath.section == 0) {
        return 60;
    }else {
        return 78;
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //设置某一行是否可编辑
    if (indexPath.section == 1) {
        return YES;
    }else
    {
     return NO;
    }
    
}
//删除常用联系人
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.section == 1) {
            //删除
            RRPTicketContactModel *model = self.contactArray[indexPath.row];
            [self requestDeletContactWithModel:model];
            [self viewWillAppear:YES];
            
        }
        
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
