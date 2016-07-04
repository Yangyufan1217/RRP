//
//  RRPFindActivityController.m
//  RRP
//
//  Created by sks on 16/4/18.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPFindActivityController.h"
#import "RRPChoicenessDetailsController.h"

@interface RRPFindActivityController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIWebView *contentView;
@property (nonatomic,strong)NSString *sceneryID;//景点id
@property (nonatomic, strong) NSString *sceneryName;//景点名
@property (nonatomic, strong) NSString * stringUrl;

@end

@implementation RRPFindActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"下一站";
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.contentView];
    /**
     *  longitude 经度
     latitude 纬度
     *116.400002 40.000000 鸟巢
     *  @return
     */
    
}


//WebView
- (UIWebView *)contentView {
    if (_contentView == nil) {
        self.contentView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, RRPWidth, RRPHeight-64)];
        self.contentView.backgroundColor = IWColor(255, 255, 255);
        self.contentView.scalesPageToFit = YES;
        self.contentView.scrollView.delegate = self;
        if ([RRPYCSigleClass mapLatitudeLongitudePassByValue].longitude.length > 0 && [RRPYCSigleClass mapLatitudeLongitudePassByValue].latitude.length > 0) {
            self.stringUrl = [NSString stringWithFormat:FindNext,[RRPYCSigleClass mapLatitudeLongitudePassByValue].longitude,[RRPYCSigleClass mapLatitudeLongitudePassByValue].latitude];
        }else {
            self.stringUrl = [NSString stringWithFormat:FindNext,116.400002,40.000000];
        }
        NSURL * url = [NSURL URLWithString:self.stringUrl];
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
    BOOL flag = [urlString hasPrefix:@"http://renrenpiao/"];
    if (flag) {
        //判断接javascriptnexttravelclick方法名
        if([urlString rangeOfString:@"javascriptnexttravelclick"].location != NSNotFound){
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
            //统计:下一站列表景区点击
            NSDictionary *dict = @{@"sceneryname":self.sceneryName,@"sceneryID":self.sceneryID};
            [MobClick event:@"46" attributes:dict];
            [self.navigationController pushViewController:choicenessDetails animated:YES];
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
