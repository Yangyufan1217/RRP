//
//  RRPDailySelectViewController.m
//  RRP
//
//  Created by WangZhaZha on 16/3/9.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPDailySelectViewController.h"
//#import "RRPDailyCollectCell.h"
#import "RRPDetailOrderView.h"
#import "RRPDailySelectCell.h"
#import "RRPDailySelectModel.h"
#import "RRPChoicenessDetailsController.h"

typedef NS_ENUM(NSInteger, refState){
    refStateHeader = 0,
    refStateFooter = 1,
};
@interface RRPDailySelectViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIWebViewDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate>{
    BOOL click;
}
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong)UIWebView *webView;//H5详情页面
@property (nonatomic, assign) NSInteger refreshNumber;//刷新number
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong)NSString *sceneryID;//景点id
@property (nonatomic, strong) NSString *sceneryName;//景点名
@property (nonatomic, strong)NSString *imageURL;//顶部图片

@end

@implementation RRPDailySelectViewController
//视图将要出现的时候 隐藏底部tabBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [@[] mutableCopy];
    
    //设置背景图片
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,64,RRPWidth, RRPWidth/750*335)];
    self.backImageView.image = [UIImage imageNamed:@"banner"];
    [self.view addSubview:_backImageView];
    //人人票精选
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(65, 17, RRPWidth-130, (RRPWidth-130)/484*70)];
    self.logoImageView.image = [UIImage imageNamed:@"人人票精选"];
    [self.backImageView addSubview:self.logoImageView];
    //bottomView
    self.bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,RRPHeight-self.backImageView.frame.size.height, RRPWidth, self.backImageView.frame.size.height)];
    self.bottomImageView.image = [UIImage imageNamed:@"人人票精选-背景图-下"];
    [self.view addSubview:self.bottomImageView];
    
    //设置背景颜色
    self.view.backgroundColor = IWColor(245,245, 245);
    //设置title
    self.title = @"每日精选";
    //布局collectionView
    [self layoutCollectionView];
    //cell在X轴上的间距,默认10
//    self.flowLayout.minimumInteritemSpacing = 0;
    //cell在Y轴上的间距,默认10
    self.flowLayout.minimumLineSpacing = 0;

    [self downLoadData:refStateHeader andPageNumber:1];
    
}
//布局collectionView
- (void)layoutCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动的方向 水平方向
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backImageView.frame)+17, RRPWidth, RRPHeight-self.backImageView.frame.size.height-17-47.5-64+20) collectionViewLayout:_flowLayout];
       self.collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    //设置代理 数据源
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"RRPDailySelectCell" bundle:nil] forCellWithReuseIdentifier:@"RRPDailySelectCell"];
    [self.view addSubview:_collectionView];
}

#pragma mark - 网络数据加载
- (void)downLoadData:(refState)refState andPageNumber:(NSInteger)page
{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"daily_selection" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.classcode forKey:@"classcode"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:FindChoiceness parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dict = [RRPPrintObject nullDic:dic];
        NSInteger code = [[dict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000) {
            for (NSDictionary *dic in dict[@"ResponseBody"]) {
                RRPDailySelectModel *model = [RRPDailySelectModel mj_objectWithKeyValues:dic];
                self.imageURL = model.imgurl;
                [self.dataArray addObject:model];
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
        NSLog(@"%@",error);
    }];
}



#pragma mark - UICollectionViewDataSource
//分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RRPDailySelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RRPDailySelectCell" forIndexPath:indexPath];
    [cell show:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((RRPHeight-self.backImageView.frame.size.height-17-47.5-64+20)/765*504, RRPHeight-self.backImageView.frame.size.height-17-47.5-64+20);

}


//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    click = YES;
    //webView视图 详情界面
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(RRPWidth/2, RRPHeight,0,0)];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    RRPDailySelectModel *model = self.dataArray[indexPath.row];
    self.title = model.sceneryname;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:FindAlone,model.ID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    //设置webView属性
    //隐藏水平 竖直滚动条
    self.webView.scrollView.
    showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    
    //开始动画
    [UIView beginAnimations:@"test" context:nil];
    //动画时长
    [UIView setAnimationDuration:1];
    /*
     *要进行动画设置的地方
     */
    self.webView.frame = CGRectMake(0, 64, RRPWidth, RRPHeight-64);
    
    //动画结束
    [UIView commitAnimations];
//    self.navigationController.navigationBar.hidden = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发现" style:(UIBarButtonItemStyleDone) target:self action:@selector(backAction:)];
}
- (void)backAction:(UIButton *)bt
{
      //返回动画
    self.webView.frame =CGRectMake(0, 0, RRPWidth, RRPHeight);
    //开始动画
    [UIView beginAnimations:@"test" context:nil];
    //动画时长
    [UIView setAnimationDuration:1];
    /*
     *要进行动画设置的地方
     */
    self.webView.frame=CGRectMake(RRPWidth/2, RRPHeight,0,0);
    //动画结束
    [UIView commitAnimations];
    if (click == NO) {
        [self.navigationController popViewControllerAnimated:YES];
        click = YES ;
    }else {
        click = NO;
    }
    self.title = @"每日精选";

}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //在这里获取到点击某个控件传过来的URL，截取字符串，对比，做相应处理。
    NSString *url = [[request URL] absoluteString];
    //把接口转成UTF-8的形式
    NSString *urlString = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //判断接口是否以http://renrenpiao/开头
    BOOL flag = [urlString hasPrefix:@"http://renrenpiao/"];
    if (flag) {
        //判断接javascriptsceneryclick方法名
        if([urlString rangeOfString:@"javascriptsceneryclick"].location != NSNotFound){
            //通过?符号分割，把字符串存进数组，下面可以按元素位置取
            NSArray *urlArray = [urlString componentsSeparatedByString:@"?"];
            //通过&符号分割，把字符串存进数组，下面可以按元素位置取
            NSArray *sceneryArray = [urlArray[1] componentsSeparatedByString:@"&"];
            //通过=符号分割，把字符串存进数组，下面可以按元素位置取
            self.sceneryID = [sceneryArray[0] componentsSeparatedByString:@"="][1];
            self.sceneryName = [sceneryArray[1] componentsSeparatedByString:@"="][1];
            RRPChoicenessDetailsController *choicenessDetails = [[RRPChoicenessDetailsController alloc] init];
            choicenessDetails.sceneryID = self.sceneryID;
            choicenessDetails.sceneryName = self.sceneryName;
            choicenessDetails.imageURL = [NSURL URLWithString:self.imageURL];
            //统计:每日精选列表景区点击
            NSDictionary *dict = @{@"sceneryname":self.sceneryName,@"sceneryID":self.sceneryID};
            [MobClick event:@"50" attributes:dict];
            [self.navigationController pushViewController:choicenessDetails animated:YES];
        }
    }
    return YES;
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
