//
//  CameraViewController.m
//  HXyoga
//
//  Created by YangJiLei on 16/1/7.
//  Copyright © 2016年 WakeYoga. All rights reserved.
//

#import "CameraViewController.h"
//#import "HXImageCompileViewController.h"
#import "RRPMyCommentController.h"


@interface CameraViewController ()

@property (strong, nonatomic) LLSimpleCamera *camera;//拍照时对象显示框
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;//闪光
@property (strong, nonatomic) UIImageView *photoView;//拍出来的照片
@end

@implementation CameraViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
//    Navbar *bar = (Navbar *)self.navigationController.navigationBar;
//    bar.cusBarStyele = UIBarStyleDefault;
//    bar.stateBarColor = IWColor(241, 241, 247);
    self.tabBarController.tabBar.hidden = YES;
    [self.camera start];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;

    [self.camera stop];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = IWColor(245, 245, 245);
    self.flashButton = [Utility createButtonWithFrame:CGRectMake(0, 0, 44, 44) title:nil imageName:nil bgImageName:@"camera-flash-auto" target:self method:@selector(flashButtonPressed:)];
    self.flashButton.tag = 900;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.flashButton];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.camera = [[LLSimpleCamera alloc] initWithQuality:CameraQualityPhoto];
    [self.camera attachToViewController:self withDelegate:self];
    self.camera.view.frame = CGRectMake(0, 0, RRPWidth, RRPWidth+150);
    self.camera.fixOrientationAfterCapture = NO;
    [self.view addSubview:self.camera.view];
    
    float height = RRPHeight-RRPWidth+150;
    
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButton.frame = CGRectMake(0, 0, 29.0f, 22.0f);
    self.switchButton.center = CGPointMake(45+14, RRPWidth+height/2);
    [self.switchButton setImage:[UIImage imageNamed:@"camera-switch"] forState:UIControlStateNormal];
    [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchButton];
    
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapButton.frame = CGRectMake(0, 0, 60.0f, 60.0f);
    self.snapButton.center = CGPointMake(RRPWidth/2, RRPWidth+height/2);
    [self.snapButton setBackgroundImage:[UIImage imageNamed:@"screen"] forState:UIControlStateNormal];
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];
    
    
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    self.photoView.backgroundColor = [UIColor clearColor];
    self.photoView.contentMode = UIViewContentModeScaleToFill;
    self.photoView.center = CGPointMake(RRPWidth-82, RRPWidth+height/2);
    self.photoView.hidden = YES;
    self.photoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick)];
    [self.photoView addGestureRecognizer:photoTap];
    [self.view addSubview:self.photoView];


}





/* camera buttons */
- (void)switchButtonPressed:(UIButton *)button {
    [self.camera togglePosition];
}

- (void)flashButtonPressed:(UIButton *)button {
    CameraFlash flash = [self.camera toggleFlash];
    if(flash == CameraFlashOn) {
        [self.flashButton setBackgroundImage:[UIImage imageNamed:@"camera-flash-on"] forState:UIControlStateNormal];
    }
    else if(flash == CameraFlashOff) {
        [self.flashButton setBackgroundImage:[UIImage imageNamed:@"camera-flash-off"] forState:UIControlStateNormal];
    }else{
        [self.flashButton setBackgroundImage:[UIImage imageNamed:@"camera-flash-auto"] forState:UIControlStateNormal];
    }
}

- (void)snapButtonPressed:(UIButton *)button {
    
    [self.camera capture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* camera delegates */
- (void)cameraViewController:(LLSimpleCamera *)cameraVC didCaptureImage:(UIImage *)image {
    self.photoView.hidden = NO;
    self.photoView.image = image;
}
- (void)photoClick {
    //代理传值
    if ([self.delegate respondsToSelector:@selector(RRPMyCommentPassByValue:andImage:)]) {
        [self.delegate RRPMyCommentPassByValue:nil andImage:self.photoView.image];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)cameraViewController:(LLSimpleCamera *)cameraVC didChangeDevice:(AVCaptureDevice *)device {
    
    // device changed, check if flash is available
    if(cameraVC.isFlashAvailable) {
        self.flashButton.hidden = NO;
    }
    else {
        self.flashButton.hidden = YES;
    }
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
