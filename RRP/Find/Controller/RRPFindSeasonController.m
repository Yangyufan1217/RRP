//
//  RRPFindSeasonController.m
//  RRP
//
//  Created by sks on 16/4/19.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPFindSeasonController.h"
#import "RRPChoicenessDetailsController.h"

@interface RRPFindSeasonController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIWebView *contentView;
@property (nonatomic,strong)NSString *sceneryID;//景点id
@property (nonatomic, strong) NSString *sceneryName;//景点名
@end

@implementation RRPFindSeasonController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"当季热玩";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.contentView];
}
//WebView
- (UIWebView *)contentView {
    if (_contentView == nil) {
        self.contentView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, RRPWidth, RRPHeight-64)];
        self.contentView.backgroundColor = IWColor(255, 255, 255);
        self.contentView.scalesPageToFit = YES;
        self.contentView.scrollView.delegate = self;
        NSString * stringUrl = [NSString stringWithFormat:FindSeason,self.city_code,self.classcode];
        NSURL * url = [NSURL URLWithString:stringUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.contentView loadRequest:request];
        self.contentView.delegate = self;
        self.contentView.scrollView.showsVerticalScrollIndicator = NO;
        self.contentView.scrollView.delegate = self;
        self.contentView.scrollView.bounces = YES;
    }
    return _contentView;
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //判断接口是否以http://renrenpiao/开头
    BOOL flag = [urlString hasPrefix:@"http://app.renrenpiao.com/"];
    if (flag) {
        //判断接javascriptnexttravelclick方法名
        if([urlString rangeOfString:@"javascriptseasonhotplayclick"].location != NSNotFound){
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
            //统计:当季热玩景区列表点击
            NSDictionary *dict = @{@"sceneryname":self.sceneryName,@"sceneryID":self.sceneryID};
            [MobClick event:@"48" attributes:dict];
            [self.navigationController pushViewController:choicenessDetails animated:YES];
            return NO;
        }
    }
    return YES;
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
