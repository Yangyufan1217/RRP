//
//  RRPDetailsImageController.m
//  RRP
//
//  Created by sks on 16/2/24.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPDetailsImageController.h"
#import "RRPDetailsImageCell.h"
#import "RRPImageDetailsController.h"


@interface RRPDetailsImageController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation RRPDetailsImageController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], IWColor(200, 200, 200));
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = IWColor(0, 122, 255);
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout = flowLayout;
    //cell在X轴上的间距,默认10
    self.flowLayout.minimumInteritemSpacing = 0;
    //cell在Y轴上的间距,默认10
    self.flowLayout.minimumLineSpacing = 10;
    //滚动方向,默认垂直滚动
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    
    [self.collectionView registerNib:[UINib nibWithNibName:@"RRPDetailsImageCell" bundle:nil] forCellWithReuseIdentifier:@"RRPDetailsImageCell"];
    [self.view addSubview:self.collectionView];
    
}
//返回
- (void)returnAction:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}
//collectonView懒加载
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, RRPHeight) collectionViewLayout:self.flowLayout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.dk_backgroundColorPicker = DKColorWithColors(IWColor(240, 240, 240), IWColor(200, 200, 200));
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
    return self.imageURLArray.count;
}
//cell展示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RRPDetailsImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RRPDetailsImageCell" forIndexPath:indexPath];
    NSURL *imageURL = [NSURL URLWithString:self.imageURLArray[indexPath.row]];
    [cell.contentImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"点评124-124"]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//items大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((RRPWidth-40) / 3, (RRPWidth-40) / 3);
}
//cell边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark - UICollectionViewDelegate
//collection cell 点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RRPImageDetailsController *imageDetails = [[RRPImageDetailsController alloc] init];
    imageDetails.imageURLArray = self.imageURLArray;
    imageDetails.index = indexPath.row;
    [self.navigationController pushViewController:imageDetails animated:YES];
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
