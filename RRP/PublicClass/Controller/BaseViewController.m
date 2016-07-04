//
//  BaseViewController.m
//  HXyoga
//
//  Created by TuHaiSheng on 15/10/17.
//  Copyright © 2015年 WakeYoga. All rights reserved.
//

#import "BaseViewController.h"
#import "Utility.h"
@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

/**
 *   修改navigationbar的背景图片
 *
 *  @param animated <#animated description#>
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置左边按钮和navigationBar
    UIButton *leftButton = [Utility createButtonWithFrame:CGRectMake(0, 0, 44, 44) title:nil imageName:nil bgImageName:@"back" target:self method:@selector(btnClick:)];
      self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    //修改navigationBar 的title的字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:IWColor(90, 113, 131)}];
    
    [self showPopGestureRecognizerBackController];
}



- (void)showPopGestureRecognizerBackController{
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=7.0f) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }else{
        return YES;
    }
}

-(void)btnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
