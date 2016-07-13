//
//  RRPLightOrderController.m
//  RRP
//
//  Created by WangZhaZha on 16/7/13.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPLightOrderController.h"
#import "RRPLightIntroduceCell.h"
#import "RRPOpenTimeCell.h"
#import "RRPGetTicketCell.h"
#import "RRPAddGetTicketView.h"
@interface RRPLightOrderController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *dateAndNumberView;
@property (nonatomic, strong) UIButton *addButton;//添加人数
@property (nonatomic, strong) UIButton *minusButton;//减少人数
@property (nonatomic, strong) UILabel *numberLabel;//购票人数
@property (nonatomic, strong) UIButton *moreButton;//更多日期
@property (nonatomic, strong) UITextField *phoneTf;

@end

@implementation RRPLightOrderController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单填写";
    self.view.backgroundColor = IWColor(242, 245, 247);
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPLightIntroduceCell" bundle:nil] forCellReuseIdentifier:@"RRPLightIntroduceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPOpenTimeCell" bundle:nil] forCellReuseIdentifier:@"RRPOpenTimeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPGetTicketCell" bundle:nil] forCellReuseIdentifier:@"RRPGetTicketCell"];
    [self.view addSubview:self.tableView];
    
}
//懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,RRPWidth, RRPHeight) style:(UITableViewStyleGrouped)];
        self.tableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(242, 245, 247), IWColor(200, 200, 200));
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 ) {
        RRPLightIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPLightIntroduceCell" forIndexPath:indexPath];
        //取消点击样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else if(indexPath.section == 1)
    {
    
        RRPOpenTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPOpenTimeCell" forIndexPath:indexPath];
        //取消点击样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else
    {
        RRPGetTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPGetTicketCell" forIndexPath:indexPath];
        //取消点击样式
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }
    
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = IWColor(242, 245, 247);
    self.dateAndNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, 6, RRPWidth, 49)];
    self.dateAndNumberView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(150, 150, 150));
    //日期
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 60, 15)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = IWColor(98, 98, 98);
    dateLabel.text = @"出行日期";
    dateLabel.font = [UIFont systemFontOfSize:15];
    [self.dateAndNumberView addSubview:dateLabel];
        
    self.moreButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.moreButton.frame = CGRectMake(CGRectGetMaxX(dateLabel.frame)+ 20,6, 70, 32);
    self.moreButton.layer.borderWidth = 1;
    self.moreButton.layer.borderColor = IWColor(240, 240, 240).CGColor;
    self.moreButton.layer.masksToBounds = YES;
    self.moreButton.layer.cornerRadius = 1;
    self.moreButton.backgroundColor = [UIColor whiteColor];
    [self.moreButton addTarget:self action:@selector(moreButton:) forControlEvents:(UIControlEventTouchUpInside)];
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 32)];
    moreLabel.text = @"12月17日";
    moreLabel.textAlignment = 1;
    moreLabel.textColor = IWColor(98, 98, 98);
    moreLabel.font = [UIFont systemFontOfSize:12];
    [self.moreButton addSubview:moreLabel];
    [self.dateAndNumberView addSubview:self.moreButton];
    //数量
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(RRPWidth - 150, 14, 30, 15)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = IWColor(98, 98, 98);
    nameLabel.text = @"数量";
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.dateAndNumberView addSubview:nameLabel];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(RRPWidth - 105, 7, 100, 30)];
    imageView.image = [UIImage imageNamed:@"形状-2"];
    imageView.userInteractionEnabled = YES;
    [self.dateAndNumberView addSubview:imageView];
    self.minusButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.minusButton.frame = CGRectMake(2, 2, 31, 26);
    [self.minusButton addTarget:self action:@selector(minusButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [imageView addSubview:self.minusButton];
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.minusButton.frame)+2, 2, 30, 26)];
    self.numberLabel.backgroundColor = [UIColor whiteColor];
    self.numberLabel.text = @"1";
    self.numberLabel.textAlignment = 1;
    self.numberLabel.font = [UIFont systemFontOfSize:15];
    self.numberLabel.textColor = IWColor(73, 73, 73);
    [imageView addSubview:self.numberLabel];
    
    if ([self.numberLabel.text isEqualToString:@"1"]) {
        [self.minusButton setBackgroundImage:[UIImage imageNamed:@"min1"] forState:(UIControlStateNormal)];
    }else {
        [self.minusButton setBackgroundImage:[UIImage imageNamed:@"min2"] forState:(UIControlStateNormal)];
    }
    
    
    self.addButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.addButton.frame = CGRectMake(CGRectGetMaxX(self.numberLabel.frame)+2, 2, 31, 26);
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:(UIControlStateNormal)];
    [self.addButton addTarget:self action:@selector(addButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [imageView addSubview:self.addButton];
    
    UIView *wireView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, RRPWidth, 1)];
    wireView.backgroundColor = IWColor(240, 240, 240);
    [self.dateAndNumberView addSubview:wireView];
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(wireView.frame), RRPWidth, 5)];
    baseView.backgroundColor = IWColor(242, 245, 247);
    [self.dateAndNumberView addSubview:baseView];
    [backView addSubview:self.dateAndNumberView];
    return backView;
   }else if(section == 2)
   {
    UIView *phoneView = [[UIView alloc] init];
    phoneView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 5)];
    topView.backgroundColor = IWColor(242, 245, 247);
    [phoneView addSubview:topView];
    UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(topView.frame)+7, 50, 32)];
    phone.textColor = IWColor(109,109,109);
    phone.font = [UIFont systemFontOfSize:15];
    phone.text = @"手机号";
    [phoneView addSubview:phone];
    
    NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5], NSFontAttributeName:[UIFont systemFontOfSize:15]};
    self.phoneTf = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phone.frame)+10, CGRectGetMaxY(topView.frame)+7, 195, 30)];
    self.phoneTf.backgroundColor = IWColor(245, 245, 245);
    self.phoneTf.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证手机号 必填" attributes:dic];
    self.phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    [phoneView addSubview:self.phoneTf];
    UIButton *phoneSureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    phoneSureButton.frame = CGRectMake(CGRectGetMaxX(self.phoneTf.frame)+5, CGRectGetMaxY(topView.frame)+8, 50, 30);
    [phoneSureButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [phoneView addSubview:phoneSureButton];
       
    return phoneView;
   }else
   {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
   }
}
//区尾
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *addView = [[UIView alloc] init];
        addView.backgroundColor = IWColor(242, 245, 247);
        RRPAddGetTicketView *messageView = [[RRPAddGetTicketView alloc] initWithFrame:CGRectMake(4,8, RRPWidth-8, 162)];
        [addView addSubview:messageView];
        return addView;
    }else
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }

}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    }else if(indexPath.section == 1){
        return 50;
    }else{
        return 165;
    }
}
//分区高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 54;
    }else if(section == 2) {
    
        return 50;
    }else
    {
        return 0.01;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 170;
    }else
    {
        return 0.01;
    }

}
//减数量
- (void)minusButton:(UIButton *) sender {
    if ([self.numberLabel.text integerValue] > 1) {
        self.numberLabel.text = [NSString stringWithFormat:@"%ld",[self.numberLabel.text integerValue]-1];
        if ([self.numberLabel.text integerValue] == 1) {
            [self.minusButton setBackgroundImage:[UIImage imageNamed:@"min1"] forState:(UIControlStateNormal)];
        }
    }
}
//加数量
- (void)addButton:(UIButton *) sender {
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",[self.numberLabel.text integerValue]+1];
    [self.minusButton setBackgroundImage:[UIImage imageNamed:@"min2"] forState:(UIControlStateNormal)];
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
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
