//
//  RRPCompanyIntroduceController.m
//  RRP
//
//  Created by sks on 16/3/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPCompanyIntroduceController.h"

@interface RRPCompanyIntroduceController ()<UIWebViewDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate>

@property (nonatomic,strong)UIWebView *webView;

@end

@implementation RRPCompanyIntroduceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"公司介绍";
    //取消滚动视图的自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.webView];
  
    
}

//WebView
- (UIWebView *)webView {
    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, RRPWidth, RRPHeight-64)];
        self.webView.backgroundColor = IWColor(255, 255, 255);
        self.webView.scalesPageToFit = YES;
        self.webView.scrollView.delegate = self;
        NSURL *url = [NSURL URLWithString:myCompanyIntro];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        self.webView.delegate = self;
        self.webView.scrollView.showsVerticalScrollIndicator = NO;
        self.webView.scrollView.delegate = self;
        self.webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
        self.webView.scrollView.bounces = NO;
    }
    return _webView;
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
