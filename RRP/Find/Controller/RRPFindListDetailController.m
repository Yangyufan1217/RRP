//
//  RRPFindListDetailController.m
//  RRP
//
//  Created by WangZhaZha on 16/3/14.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPFindListDetailController.h"
#import "RRPDetailOrderView.h"
#import "RRPChoicenessDetailsController.h"
@interface RRPFindListDetailController ()<UIWebViewDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NSString *sceneryID;//景点id
@property (nonatomic, strong) NSString *sceneryName;//景点名



@end

@implementation RRPFindListDetailController
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
    // Do any additional setup after loading the view.
    self.title = self.sceneryname;
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    [self.view addSubview:self.webView];

}

//WebView
- (UIWebView *)webView {
    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, RRPHeight)];
        self.webView.dk_backgroundColorPicker = DKColorWithColors(IWColor(255, 255, 255), IWColor(200, 200, 200));
        self.webView.scalesPageToFit = YES;
        self.webView.scrollView.delegate = self;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:FindAlone,(long)self.ID]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        self.webView.delegate = self;
        self.webView.scrollView.showsVerticalScrollIndicator = NO;
        self.webView.scrollView.delegate = self;
        self.webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
        self.webView.scrollView.bounces = YES;
        
    }
    return _webView;
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
            //统计:景区介绍html5页面末端的
            NSDictionary *dict = @{@"sceneryname":self.sceneryname,@"sceneryID":self.sceneryID};
            [MobClick event:@"52" attributes:dict];
            [self.navigationController pushViewController:choicenessDetails animated:YES];
        }
    }
    return YES;
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
