//
//  RRPImageDetailsController.m
//  RRP
//
//  Created by sks on 16/2/25.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPImageDetailsController.h"

@interface RRPImageDetailsController ()<UIScrollViewDelegate>
@property(nonatomic, strong)UIScrollView *scrollView;//滚动视图
@property(nonatomic, strong)UIImageView *imageView;
//@property(nonatomic, strong)NSMutableArray *array;
@property(nonatomic, strong)UIPinchGestureRecognizer *pinch;//捏合手势
@property (nonatomic,strong)NSMutableArray *currentImageURLArr;

@end

@implementation RRPImageDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"景区图片";
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = IWColor(0, 122, 255);
    self.currentImageURLArr = [@[] mutableCopy];
   
    for (int i = 0; i < self.imageURLArray.count - self.index; i++) {
        [self.currentImageURLArr addObject:self.imageURLArray[self.index+i]];
    }

    [self.view addSubview:self.scrollView];
    
}
//返回
- (void)returnAction:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}
//滚动视图懒加载
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, RRPHeight)];
        self.scrollView.backgroundColor = [UIColor whiteColor];//颜色
        self.scrollView.dk_backgroundColorPicker = DKColorWithColors(IWColor(230, 230, 230), IWColor(200, 200, 200));
        self.scrollView.showsVerticalScrollIndicator = NO;//垂直线
        self.scrollView.showsHorizontalScrollIndicator = NO;//水平线
        self.scrollView.pagingEnabled = YES;//分页滚动
        self.scrollView.delegate = self;//代理
//        self.scrollView.bounces = NO;//设置滚动到边缘时不能再拖拽
        self.scrollView.contentSize = CGSizeMake(RRPWidth * self.currentImageURLArr.count, 0);//偏移量
        [self imageViews];
    }
    return _scrollView;
}
//imageView懒加载
- (void)imageViews {
    for (int i = 0; i < self.currentImageURLArr.count; i++) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(RRPWidth * i, 0, RRPWidth, RRPHeight)];
        NSURL *imageUrl = [NSURL URLWithString:self.currentImageURLArr[i]];
        [self.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"发现750-285"]];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:self.imageView];
    }
}


//捏合方法实现
- (void)pinch:(UIPinchGestureRecognizer *)pinch {
    //缩放
    self.imageView.transform =CGAffineTransformScale(self.imageView.transform, pinch.scale, pinch.scale);
    //重置缩放比例
    pinch.scale = 1;
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
