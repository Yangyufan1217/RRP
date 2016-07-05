//
//  RRPCityListHotCityView.m
//  RRP
//
//  Created by WangZhaZha on 16/3/23.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPCityListHotCityView.h"
#import "RRPHomeHotCityCell.h"
#import "RRPAllCityModel.h"
#import "RRPAllCityHandle.h"
@interface RRPCityListHotCityView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@end

@implementation RRPCityListHotCityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //布局topView
        [self layoutTopView];
        
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.flowLayout = flowLayout;
        //cell在X轴上的间距,默认10
        self.flowLayout.minimumInteritemSpacing = 10;
        //cell在Y轴上的间距,默认10
        self.flowLayout.minimumLineSpacing = 10;
        //滚动方向,默认垂直滚动
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //注册cell
        [self.collectionView registerNib:[UINib nibWithNibName:@"RRPHomeHotCityCell" bundle:nil] forCellWithReuseIdentifier:@"RRPHomeHotCityCell"];
        [self addSubview:self.collectionView];
        
    }
    return self;
    
}
- (void)layoutTopView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 23)];
    topView.dk_backgroundColorPicker = DKColorWithColors(IWColor(235, 235, 235), IWColor(200, 200, 200));
    [self addSubview:topView];
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (topView.frame.size.height-15)/2, RRPWidth-20, 15)];
    topLabel.textAlignment = NSTextAlignmentLeft;
    topLabel.font = [UIFont systemFontOfSize:13];
    topLabel.textColor = IWColor(109, 109, 114);
    topLabel.text = @"热门城市";
    [topView addSubview:topLabel];

}
//collectonView懒加载
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        if ([RRPAllCityHandle shareAllCityHandle].hotCityNumber % 3 == 0) {
            self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,23, RRPWidth,[RRPAllCityHandle shareAllCityHandle].hotCityNumber/3*38+17) collectionViewLayout:self.flowLayout];
            
        }else {
            self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,23, RRPWidth,([RRPAllCityHandle shareAllCityHandle].hotCityNumber/3+1)*38+17) collectionViewLayout:self.flowLayout];
        }
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.dk_backgroundColorPicker = DKColorWithColors(IWColor(250, 250, 250), IWColor(150, 150, 150));
    }
    return _collectionView;
}
#pragma mark - UICollectionViewDataSource
//分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hotCityArray.count;
}
//cell展示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RRPHomeHotCityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RRPHomeHotCityCell" forIndexPath:indexPath];
    
    self.hotCityModel = self.hotCityArray[indexPath.row];
    NSString *hotCityName = self.hotCityModel.city_name;
    if ([hotCityName length] > 4) {
        hotCityName = [self.hotCityModel.city_name substringWithRange:NSMakeRange(0, 4)];
    }
    cell.cityNameLabel.text = hotCityName;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//items大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((RRPWidth-100)/3, 30);
}
//cell边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 20, 0, 20);
}
#pragma mark - UICollectionViewDelegate
//collection cell 点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.hotCityModel = self.hotCityArray[indexPath.row];
    //发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AllCityName" object:self userInfo:@{@"value":self.hotCityModel}];
    //统计:城市列表点击事件
    NSDictionary *dict = @{@"cityname":self.hotCityModel.city_name,@"citycode":self.hotCityModel.city_code,@"provincecode":self.hotCityModel.province_code,@"type":@"热门城市"};
    [MobClick event:@"6" attributes:dict];

    //把城市信息Model传给首页
    [RRPAllCityHandle shareAllCityHandle].passCityModel = self.hotCityModel;

}

@end
