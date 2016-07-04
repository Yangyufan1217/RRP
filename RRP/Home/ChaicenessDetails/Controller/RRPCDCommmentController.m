//
//  RRPCDCommmentController.m
//  RRP
//
//  Created by sks on 16/2/25.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPCDCommmentController.h"
#import "RRPCDCommmentCell.h"
#import "RRPCoverView.h"
#import "RRPAllCommentModel.h"

typedef NS_ENUM(NSInteger, refState){
    refStateHeader = 0,
    refStateFooter = 1,
};
@interface RRPCDCommmentController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *allCommentArray;
@property (nonatomic, strong) RRPAllCommentModel *allCommentModel;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, assign) NSInteger commentImageStatus;
@property (nonatomic, strong) NSMutableArray *commentImageArr;
@property (nonatomic, assign) NSInteger refreshNumber;//刷新number
@property (nonatomic, strong) NSString *labelName;
@property (nonatomic, strong) NSMutableDictionary *ycLabelDic;

@end

@implementation RRPCDCommmentController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部评论";
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.allCommentArray = [@[] mutableCopy];
    self.labelArray = [@[] mutableCopy];
    self.commentImageArr = [@[] mutableCopy];
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPCDCommmentCell" bundle:nil] forCellReuseIdentifier:@"RRPCDCommmentCell"];
    [self.view addSubview:self.tableView];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Login:) name:@"user" object:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];
    [self requestAllCommentDataWithRestate:refStateHeader andPageNumber:1];
}
- (void)Login:(NSNotification *)notification {
    [[MyAlertView sharedInstance]showFrom:@"登录即可点赞"];
    RRPLoginViewController *loginVC = [[RRPLoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}
//获取全部评论
- (void)requestAllCommentDataWithRestate:(refState)refState andPageNumber:(NSInteger)page
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"all_comment" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.sceneryid forKey:@"sceneryid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"limit"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic removeObjectForKey:@"list_name"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:HomeAllCommnent parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    //获取数据
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    NSDictionary * dict = [RRPPrintObject nullDic:dic];

        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            NSMutableArray *allCommentArray = [NSMutableArray array];
            //遍历ResponseBody
            for (NSDictionary *commentDic in dict[@"ResponseBody"][@"all_comment"]) {
                NSMutableDictionary *allDict = [NSMutableDictionary dictionary];
                [allDict setValue:commentDic[@"comment"] forKey:@"comment"];
                [allDict setValue:commentDic[@"createdtime"] forKey:@"createdtime"];
                [allDict setValue:commentDic[@"forward"] forKey:@"forward"];
                [allDict setValue:commentDic[@"head_img"] forKey:@"head_img"];
                [allDict setValue:commentDic[@"likeit"] forKey:@"likeit"];
                [allDict setValue:commentDic[@"likeit_id"] forKey:@"likeit_id"];
                [allDict setValue:commentDic[@"likeit_status"] forKey:@"likeit_status"];
                [allDict setValue:commentDic[@"memberid"] forKey:@"memberid"];
                [allDict setValue:commentDic[@"mid"] forKey:@"mid"];
                [allDict setValue:commentDic[@"orderid"] forKey:@"orderid"];
                [allDict setValue:commentDic[@"pc_id"] forKey:@"pc_id"];
                [allDict setValue:commentDic[@"sceneryid"] forKey:@"sceneryid"];
                [allDict setValue:commentDic[@"score"] forKey:@"score"];
                [allDict setValue:commentDic[@"ticketid"] forKey:@"ticketid"];
                [allDict setValue:commentDic[@"updatetime"] forKey:@"updatetime"];
                [allDict setValue:commentDic[@"username"] forKey:@"username"];
                [allDict setValue:commentDic[@"comment_score"] forKey:@"comment_score"];
                [allDict setValue:commentDic[@"comment_img_status"] forKey:@"comment_img_status"];
                //评论图片是否存在
                NSInteger commentImageStatus = [commentDic[@"comment_img_status"]  integerValue];
                if (commentImageStatus == 1) {
                    NSMutableDictionary *commentImageDic = commentDic[@"comment_img"];
                    [allDict setValue:commentImageDic forKey:@"commentImageDic"];
                }else {
                    [allDict setValue:nil forKey:@"commentImageArr"];
                }
                NSMutableDictionary *commentImageDic = commentDic[@"comment_img"];
                [allDict setValue:commentImageDic forKey:@"commentImageDic"];
                RRPAllCommentModel *allCommentModel = [RRPAllCommentModel mj_objectWithKeyValues:allDict];
                [allCommentArray addObject:allCommentModel];
            }
            //获取标签
            NSMutableArray *labelArray = [NSMutableArray array];
            NSInteger labelCode = [dict[@"ResponseBody"][@"label_status"] integerValue];
            if (labelCode == 1) {
                self.ycLabelDic = [NSMutableDictionary dictionary];
                for (NSString *key in dict[@"ResponseBody"][@"comment_count"]){
                    NSDictionary *labelDic = [[NSDictionary alloc] init];
                    labelDic = [dict[@"ResponseBody"][@"comment_count"] valueForKey:key];
                    NSString *count = [labelDic valueForKey:@"count"];
                    NSString *desc = [labelDic valueForKey:@"desc"];
                    NSString *comment_code = [labelDic valueForKey:@"comment_code"];
                    NSString *label = [NSString stringWithFormat:@"%@(%@)%@",desc,count,comment_code];
                    [labelArray addObject:label];
                    [self.ycLabelDic setValue:comment_code forKey:desc];
                }
                
            }
            if (refState == refStateHeader) {
                [self.allCommentArray removeAllObjects];
                [self.labelArray removeAllObjects];
                self.refreshNumber = 1;
                [self.allCommentArray addObjectsFromArray:allCommentArray];
                [self.labelArray addObjectsFromArray:labelArray];
            }else{
                if (self.refreshNumber!= page) {
                    [self.allCommentArray addObjectsFromArray:allCommentArray];
                }
            }
        }
       //刷新页面
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

}
//根据标签获取评论
- (void)requestCommentDataByLabelWithRestate:(refState)refState andPageNumber:(NSInteger)page Name:(NSString *)name
{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"all_comment" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.sceneryid forKey:@"sceneryid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"limit"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:name forKey:@"list_name"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [manager POST:HomeByLableGetComment parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取数据
        NSDictionary *dict = responseObject;
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            NSMutableArray *allCommentArray = [NSMutableArray array];
            //遍历ResponseBody
            for (NSDictionary *commentDic in dict[@"ResponseBody"][@"all_comment"]) {
                NSMutableDictionary *allDict = [NSMutableDictionary dictionary];
                [allDict setValue:commentDic[@"comment"] forKey:@"comment"];
                [allDict setValue:commentDic[@"createdtime"] forKey:@"createdtime"];
                [allDict setValue:commentDic[@"forward"] forKey:@"forward"];
                [allDict setValue:commentDic[@"head_img"] forKey:@"head_img"];
                [allDict setValue:commentDic[@"likeit"] forKey:@"likeit"];
                [allDict setValue:commentDic[@"likeit_id"] forKey:@"likeit_id"];
                [allDict setValue:commentDic[@"likeit_status"] forKey:@"likeit_status"];
                [allDict setValue:commentDic[@"memberid"] forKey:@"memberid"];
                [allDict setValue:commentDic[@"mid"] forKey:@"mid"];
                [allDict setValue:commentDic[@"orderid"] forKey:@"orderid"];
                [allDict setValue:commentDic[@"pc_id"] forKey:@"pc_id"];
                [allDict setValue:commentDic[@"sceneryid"] forKey:@"sceneryid"];
                [allDict setValue:commentDic[@"score"] forKey:@"score"];
                [allDict setValue:commentDic[@"ticketid"] forKey:@"ticketid"];
                [allDict setValue:commentDic[@"updatetime"] forKey:@"updatetime"];
                [allDict setValue:commentDic[@"username"] forKey:@"username"];
                [allDict setValue:commentDic[@"comment_score"] forKey:@"comment_score"];
                [allDict setValue:commentDic[@"comment_img_status"] forKey:@"comment_img_status"];
                //评论图片是否存在
                NSInteger commentImageStatus = [commentDic[@"comment_img_status"]  integerValue];
                if (commentImageStatus == 1) {
                    NSMutableDictionary *commentImageDic = commentDic[@"comment_img"];
                    [allDict setValue:commentImageDic forKey:@"commentImageDic"];
                }else {
                    [allDict setValue:nil forKey:@"commentImageArr"];
                }
                RRPAllCommentModel *allCommentModel = [RRPAllCommentModel mj_objectWithKeyValues:allDict];
                [allCommentArray addObject:allCommentModel];
            }
            if (refState == refStateHeader) {
                [self.allCommentArray removeAllObjects];
                self.refreshNumber = 1;
                [self.allCommentArray addObjectsFromArray:allCommentArray];
            }else{
                if (self.refreshNumber!= page) {
                    [self.allCommentArray addObjectsFromArray:allCommentArray];
                }
            }
        }
        //发布通知 刷新页面
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
    }];
    
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,RRPWidth, RRPHeight+49)];
        self.tableView.dk_backgroundColorPicker = DKColorWithColors(IWColor(246, 246, 246), IWColor(200, 200, 200));
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
//下拉刷新
- (void)loadNewData
{
    if ([self.type isEqualToString:@"全部"]) {
        [self requestAllCommentDataWithRestate:refStateHeader andPageNumber:1];
    }else {
        [self requestCommentDataByLabelWithRestate:refStateHeader andPageNumber:1 Name:self.labelName];
    }
    [self.tableView.header endRefreshing];
}
//加载更多
- (void)loadMoreData
{
    if (self.allCommentArray.count % 15 == 0) {
        if ([self.type isEqualToString:@"全部"]) {
            [self requestAllCommentDataWithRestate:refStateFooter andPageNumber:(NSInteger)(self.allCommentArray.count/15 + 1)];
        }else {
            [self requestCommentDataByLabelWithRestate:refStateFooter andPageNumber:(NSInteger)(self.allCommentArray.count/15 + 1) Name:self.labelName];
        }
    }else{
        self.tableView.footer = nil;
    }
    [self.tableView.footer endRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allCommentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RRPCDCommmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPCDCommmentCell" forIndexPath:indexPath];
    //取消点击样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    RRPAllCommentModel *model = self.allCommentArray[indexPath.row];
    [cell shoeDataWithModel:model];
    if ([model.likeit_status isEqualToString:@"1"]) {
        cell.usesImageView.image = [UIImage imageNamed:@"sign-list-use"];
        cell.usesButton.layer.borderColor = IWColor(255, 88, 11).CGColor;
        cell.usesLabel.textColor = IWColor(255, 88, 11);
        cell.usesNumaberLabel.textColor = IWColor(255, 88, 11);
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RRPCDCommmentCell cellHeight:self.allCommentArray[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

//区头
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headView = [[UIView alloc] init];
    self.headView.dk_backgroundColorPicker = DKColorWithColors(IWColor(245, 245, 245), IWColor(200, 200, 200));
    [self labelShowSectionhead];
    return self.headView;
}


- (void)labelShowSectionhead {
    NSArray *historySearchArray = [[NSArray alloc] initWithObjects:@"全部",@"最新",@"好评(301)",@"中评(301)",@"差评(301)",@"有图(301)",@"服务好(301)",@"性价比高(301)", nil];
    NSMutableArray *labelArr = [NSMutableArray array];
    for (NSString *label in self.labelArray) {
        NSString *labelname = [label componentsSeparatedByString:@")"].firstObject;
        NSString *labelName = [NSString stringWithFormat:@"%@)",labelname];
        [labelArr addObject:labelName];
    }
    historySearchArray = labelArr;
    UIFont *font = [UIFont systemFontOfSize:12];
    
    float itemSpace = 10;//每个记录之间的间隙
    float itemHeight = 30;
    
    float currentX = 0;//边距
    float currentY = 0;
    for (int index = 0; index < historySearchArray.count; index++) {
        NSString *itemString = [historySearchArray objectAtIndex:index];
        CGSize size = [itemString sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, itemHeight)];
        size.width = size.width + 10;//为了给每个label 留点显示边距  ＋10
        if (size.width > RRPWidth - itemSpace * 2) {
            size.width = RRPWidth - itemSpace * 2;
        }
        if (currentX + size.width > RRPWidth - 2 * itemSpace) {//计算的宽度大于 屏幕的宽度
            currentY = currentY + itemHeight + itemSpace;
            currentX = 0;
        }
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        button.frame = CGRectMake(currentX + itemSpace, currentY + itemSpace, size.width, itemHeight);
        button.backgroundColor = IWColor(250, 250, 250);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 1;
        [button setTitleColor:IWColor(50, 50, 50) forState:(UIControlStateNormal)];
        button.layer.borderColor = IWColor(225, 225, 225).CGColor;
        button.layer.borderWidth = 1;
        [button setTitle:itemString forState:(UIControlStateNormal)];
        button.titleLabel.font = font;
        [self.headView addSubview:button];
        
        [button addTarget:self action:@selector(lableClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        currentX += size.width + 10;
    }
}
//标签点击事件
- (void)lableClickAction:(UIButton *)bt
{
     NSString *label = [bt.titleLabel.text componentsSeparatedByString:@"("].firstObject;
    self.labelName =  [self.ycLabelDic valueForKey:label];
    [self requestCommentDataByLabelWithRestate:refStateHeader andPageNumber:1 Name:self.labelName];
    self.type = @"其他";
}
//返回
- (void)returnAction:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];

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
