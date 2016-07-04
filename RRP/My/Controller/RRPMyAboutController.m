//
//  RRPMyAboutController.m
//  RRP
//
//  Created by sks on 16/3/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMyAboutController.h"
#import "RRPMyAboutCell.h"
#import "RRPCompanyIntroduceController.h"
#import "RRPFeedbackController.h"
#import "RRPMyProtocolController.h"

@interface RRPMyAboutController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *logoImageView;//人人票图标
@property (nonatomic, strong) UILabel *nameLabel;//人人票公司名字
@property (nonatomic, strong) UILabel *versionLabel;//版本号



@end

@implementation RRPMyAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorWithColors(IWColor(241, 241, 241), IWColor(200, 200, 200));
    self.title = @"关于我们";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPMyAboutCell" bundle:nil] forCellReuseIdentifier:@"RRPMyAboutCell"];
    [self.view addSubview:self.tableView];
    
    
}
//懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,RRPWidth, RRPHeight)];
        self.tableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(241, 241, 241), IWColor(200, 200, 200));
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
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
        return 4;
    }
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRPMyAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyAboutCell" forIndexPath:indexPath];
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.RRPtitleLabel.text = @"公司介绍";
            cell.wireOneLabel.hidden = YES;
            cell.shadowLabel.hidden = YES;
        }else if (indexPath.row == 1) {
            cell.RRPtitleLabel.text = @"联系我们";
            cell.wireOneLabel.hidden = YES;
            cell.shadowLabel.hidden = YES;
        }else if (indexPath.row == 2) {
            cell.RRPtitleLabel.text = @"意见反馈";
        }else {
            cell.RRPtitleLabel.text = @"用户协议";
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 1 && indexPath.row == 0) || (indexPath.section == 1 && indexPath.row == 1)) {
        return 45;
    }else {
        return 55;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 180;
    }else {
        return 0;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        view.dk_backgroundColorPicker = DKColorWithColors(IWColor(241, 241, 241), IWColor(200, 200, 200));
        self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((RRPWidth - 80)/2, 30, 80, 80)];
        self.logoImageView.image = [UIImage imageNamed:@"人人票logo-1"];
        self.logoImageView.layer.cornerRadius = 15;
        self.logoImageView.layer.masksToBounds = YES;
        [view addSubview:self.logoImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.logoImageView.frame) + 15, RRPWidth - 20, 15)];
        self.nameLabel.textColor = IWColor(52, 52, 52);
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.text = @"北京人人票网络科技有限公司";
        self.nameLabel.textAlignment = 1;
        [view addSubview:self.nameLabel];
        
        self.versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.nameLabel.frame) + 10, RRPWidth -20, 10)];
        self.versionLabel.textAlignment = 1;
        self.versionLabel.textColor = IWColor(157, 157, 157);
        self.versionLabel.font = [UIFont systemFontOfSize:10];
        self.versionLabel.text = [NSString stringWithFormat:@"iOS %@",[RRPFindTopModel shareRRPFindTopModel].version_number];
        [view addSubview:self.versionLabel];
        
        return view;
    }else {
        return nil;
    }
}

//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            RRPCompanyIntroduceController *companyIntroduce = [[RRPCompanyIntroduceController alloc] init];
            //统计:关于我们公司介绍点击
            [MobClick event:@"96"];
            [self.navigationController pushViewController:companyIntroduce animated:YES];
        }else if (indexPath.row == 1) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"4006-982-666" message:@"正常工作日:09:00-17:00"  preferredStyle:(UIAlertControllerStyleAlert)];
            // 创建按钮
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                NSInteger status = [RRPFindTopModel shareRRPFindTopModel].status;
                if (status == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4006982666"]];
                    //统计:联系我们点击
                    [MobClick event:@"97"];
                }
            }];
            // 注意取消按钮只能添加一个
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
                // 点击按钮后的方法直接在这里面写
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            //添加按钮 将按钮添加到UIAlertController对象上
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            //将UIAlertController模态出来 相当于UIAlertView show 的方法
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
            
        }else if (indexPath.row == 2) {
            RRPFeedbackController *feedback = [[RRPFeedbackController alloc] init];
            [self.navigationController pushViewController:feedback animated:YES];
            
        }else {
            RRPMyProtocolController *protocol = [[RRPMyProtocolController alloc] init];
            //统计:用户协议点击
            [MobClick event:@"99"];
            [self.navigationController pushViewController:protocol animated:YES];
        }
    }
}

- (void) viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
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
