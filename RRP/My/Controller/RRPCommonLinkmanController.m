//
//  RRPCommonLinkmanController.m
//  RRP
//
//  Created by sks on 16/3/21.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPCommonLinkmanController.h"
#import "RRPCommonLinkmanCell.h"
#import "RRPAddContactPersonController.h"
#import "RRPTicketContactModel.h"
@interface RRPCommonLinkmanController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *addNameLabel;//添加联系人
@property (nonatomic,strong) UIImageView *addImageView;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) NSMutableArray *contactArray;//联系人
@property (nonatomic,strong)NSDictionary *contactDic;

@end

@implementation RRPCommonLinkmanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.title = @"常用联系人";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPCommonLinkmanCell" bundle:nil] forCellReuseIdentifier:@"RRPCommonLinkmanCell"];
    [self.view addSubview:self.tableView];
    
    //注册通知 编辑 实现方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editContact:) name:@"editContact" object:nil];

}
//编辑获取所在行
- (void)editContact:(NSNotification *)notification
{
    UIButton *sender = [notification valueForKey:@"userInfo"][@"value"];
    RRPCommonLinkmanCell * cell = (RRPCommonLinkmanCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    RRPTicketContactModel *model = self.contactArray[path.row];
    RRPAddContactPersonController *addContactVC = [[RRPAddContactPersonController alloc] init];
    addContactVC.editModel = model;
    addContactVC.submitType = @"编辑";
    //统计:常用联系人编辑按钮
    [MobClick event:@"86"];
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
                //统计:常用联系人右侧删除按钮点击
                [MobClick event:@"87"];
                
                
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
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
//cell数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return self.contactArray.count;
    }
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RRPCommonLinkmanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPCommonLinkmanCell" forIndexPath:indexPath];
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    RRPTicketContactModel *model = self.contactArray[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}

#pragma mark - UITableViewDelegate
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78;
}
//区头区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 50;
    }else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }else {
        return 0;
    }
}
//区头
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    self.addImageView.image = [UIImage imageNamed:@"添加取票人"];
    [view addSubview:self.addImageView];
    
    self.addNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.addImageView.frame)+25, 17, 100, 16)];
    self.addNameLabel.backgroundColor =[UIColor clearColor];
    self.addNameLabel.text = @"添加取票人";
    self.addNameLabel.textColor = IWColor(68, 218, 255);
    self.addNameLabel.font = [UIFont systemFontOfSize:16];
    self.addNameLabel.textAlignment = 0;
    [view addSubview:self.addNameLabel];
    
    self.addButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.addButton.frame = CGRectMake(RRPWidth - 30, 17.5, 15, 15);
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"home-middleList-more"] forState:(UIControlStateNormal)];
    [self.addButton addTarget:self action:@selector(addButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:self.addButton];
    
    return view;
}

//区尾
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = IWColor(242, 245, 247);
//    view.dk_backgroundColorPicker = DKColorWithColors(IWColor(242, 245, 247), IWColor(200, 200, 200));
    return view;
}

- (void)addButton:(UIButton *)sender {
    RRPAddContactPersonController *addContactPerson = [[RRPAddContactPersonController alloc] init];
    //统计:常用联系人添加联系人按钮点击
    [MobClick event:@"85"];
    [self.navigationController pushViewController:addContactPerson animated:YES];
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

- (void) viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.contactArray = [@[] mutableCopy];
    [self requestAllContactData];
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
