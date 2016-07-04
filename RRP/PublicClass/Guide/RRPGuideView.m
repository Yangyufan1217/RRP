//
//  RRPGuideView.m
//  RRP
//
//  Created by WangZhaZha on 16/4/7.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPGuideView.h"

@interface RRPGuideView ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIImage *imageView;

@end
@implementation RRPGuideView
- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //布局ScrollView
        [self layoutScrollView];
        //布局ImageView
        [self layoutImageView];

    }
    return self;
}

- (void)layoutScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    //隐藏水平滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    //设置显示内容的大小
    _scrollView.contentSize = CGSizeMake(self.frame.size.width*3, self.frame.size.height);
    //整屏滑动
    _scrollView.pagingEnabled = YES;
    //设置代理
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
}

- (void)layoutImageView
{
    for (int i = 0; i < 3; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0,self.frame.size.width,self.frame.size.height)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d.png",i+1]];
        [_scrollView addSubview:imageView];
        //打开交互
        imageView.userInteractionEnabled = YES;

        if (i == 2) {
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            //开启旅程点击
            [MobClick event:@"3"];
            [imageView addGestureRecognizer:tap];
        }
    }
    
}
//手势点击方法
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self  removeFromSuperview];

}


@end
