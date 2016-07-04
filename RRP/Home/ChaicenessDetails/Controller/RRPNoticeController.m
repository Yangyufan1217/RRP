//
//  RRPNoticeController.m
//  RRP
//
//  Created by sks on 16/3/1.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPNoticeController.h"
#import "RRPNoticeCell.h"
#import "RRPHomeSelectedDetailModel.h"

@interface RRPNoticeController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;//底层tableView


@end

@implementation RRPNoticeController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取消滚动视图的自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.dk_backgroundColorPicker = DKColorWithColors(IWColor(240, 240, 240), IWColor(200, 200, 200));
    //左侧返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPNoticeCell" bundle:nil] forCellReuseIdentifier:@"RRPNoticeCell"];
    
    [self.view addSubview:self.tableView];
}
//返回
- (void)returnAction:(UIBarButtonItem *)bt
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 74, RRPWidth - 20, RRPHeight - 64-20)];
        self.tableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(240, 240, 240), IWColor(200, 200, 200));
        //tableView切边框
//        self.tableView.layer.borderWidth = 1;
//        self.tableView.layer.borderColor = IWColor(213, 213, 213).CGColor;
//        self.tableView.layer.masksToBounds = YES;
//        self.tableView.layer.cornerRadius = 1;
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
//        self.tableView.userInteractionEnabled = NO;

    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
//分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRPNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPNoticeCell" forIndexPath:indexPath];
    //取消点击样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor whiteColor];

    if (indexPath.row == 0) {
        cell.bigtiteLabel.text = @"开放时间";
        [cell showDataWithSelectedDetailStr:self.homeSelectedModel.businesshours];
        return cell;
    }else if (indexPath.row == 1){
        cell.bigtiteLabel.text = @"特惠政策";
        [cell showDataWithSelectedDetailStr:self.homeSelectedModel.favouredpolicy];
        return cell;
    }else
    {
        cell.bigtiteLabel.text = @"温馨提示";
        [cell showDataWithSelectedDetailStr:self.homeSelectedModel.reminder];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [RRPNoticeCell cellHeight:self.homeSelectedModel.businesshours];
    }else if (indexPath.row == 1)
    {
        return [RRPNoticeCell cellHeight:self.homeSelectedModel.favouredpolicy];
    }else
    {
        return [RRPNoticeCell cellHeight:self.homeSelectedModel.reminder];
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
