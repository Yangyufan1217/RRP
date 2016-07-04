//
//  XLCycleScrollView.m
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import "XLCycleScrollView.h"

@implementation XLCycleScrollView

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize currentPage = _curPage;
@synthesize datasource = _datasource;
@synthesize delegate = _delegate;
@synthesize nettimer;

//- (void)dealloc
//{
//    [_scrollView release];
//    [_pageControl release];
//    [_curViews release];
//    [super dealloc];
//}

- (void)CarouselView
{
    if (nettimer) {
        [nettimer invalidate];
        nettimer = nil;
    }
    
    _pageControl.hidden = YES;
}



-(void)exitRelease
{
    if (nettimer) {
        [nettimer invalidate];
        nettimer = nil;
    }
    self.delegate = nil;
    self.datasource = nil;
    _totalPages = 0;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 10;
        rect.size.height = 10;
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.userInteractionEnabled = NO;
        
        
        //获取通知中心单例对象
//        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
//        //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
//        [center addObserver:self selector:@selector(exitRelease) name:@"relesase" object:nil];
//        

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitRelease) name:@"relesase" object:nil];
        [self addSubview:_pageControl];
        
        
        
        _curPage = 0;
    }
    return self;
}

- (void)setDataource:(id<XLCycleScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadData];
}

- (void)reloadData
{
    _totalPages = [_datasource numberOfPages];
    if (nettimer) {
        [nettimer invalidate];
        nettimer = nil;
    }
    if (_totalPages == 0) {
        _curPage = 0;
        return;
    }
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
    if (_totalPages>1)
    {
        nettimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerclick:) userInfo:nil repeats:YES];
    }
    else
    {
        _scrollView.scrollEnabled = NO;
    }
    
}
-(void)timerclick:(NSTimer *)timer
{
    [_scrollView setContentOffset:CGPointMake(2*self.frame.size.width, 0)animated:YES];
}
- (void)loadData
{
    if (_totalPages == 0) {
        return;
    }
    _pageControl.currentPage = _curPage;
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *v = [_curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

- (void)getDisplayImagesWithCurpage:(int)page {
    
    if(_datasource &&[_datasource respondsToSelector:@selector(pageAtIndex:)] && _delegate)
    {
        int pre = [self validPageValue:_curPage-1];
        int last = [self validPageValue:_curPage+1];
        
        if (!_curViews) {
            _curViews = [[NSMutableArray alloc] init];
        }
        
        [_curViews removeAllObjects];
        
        [_curViews addObject:[_datasource pageAtIndex:pre]];
        [_curViews addObject:[_datasource pageAtIndex:page]];
        [_curViews addObject:[_datasource pageAtIndex:last]];
    }
    

}

- (int)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_curPage];
    }
    
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        [self loadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    
}

@end
