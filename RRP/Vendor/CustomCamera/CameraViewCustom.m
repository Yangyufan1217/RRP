//
//  CameraViewCustom.m
//  HXyoga
//
//  Created by TuHaiSheng on 16/1/4.
//  Copyright © 2016年 WakeYoga. All rights reserved.
//

#import "CameraViewCustom.h"
#import "CameraSessionView.h"
@interface CameraViewCustom () <CACameraSessionDelegate>
@property(nonatomic, weak)CameraSessionView * cameraView;
@end

@implementation CameraViewCustom

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    CameraSessionView *cameraView = [[CameraSessionView alloc] initWithFrame:self.view.frame];
    self.cameraView = cameraView;
    cameraView.delegate = self;
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.6];
    [applicationLoadViewIn setType:kCATransitionReveal];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[cameraView layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    [self.view addSubview:_cameraView];

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
