//
//  RRPMapController.m
//  RRP
//
//  Created by sks on 16/3/28.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPMapController.h"



@interface RRPMapController ()<MAMapViewDelegate,AMapSearchDelegate> {
    MAMapView *_mapView;
    AMapSearchAPI *_search;
}

@property (nonatomic, strong) NSString *distance;//距离
@property (nonatomic, strong) NSString *durationTime;//预计时间
@property (nonatomic, strong) NSString *taxiCost;//打车费用
@property (nonatomic, strong) NSMutableArray *latitudeArray;//维度数组
@property (nonatomic, strong) NSMutableArray *longitudeArray;//经度数组
@property (nonatomic, strong) MAPolyline *commonPolyline;
@property (nonatomic, strong) MAPointAnnotation *pointAnnotation;
@property (nonatomic, strong) AMapDrivingRouteSearchRequest *request;
@property (nonatomic,strong) CLLocationManager *locationManager;//地图

@end

@implementation RRPMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"地图";
    self.latitudeArray = [@[] mutableCopy];
    self.longitudeArray = [@[] mutableCopy];
    
    
    
    //配置用户Key
    [MAMapServices sharedServices].apiKey = MapKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;//YES 为打开定位，NO为关闭定位
    /*MAUserTrackingModeNone：仅在地图上显示，不跟随用户位置。
    MAUserTrackingModeFollow：跟随用户位置移动，并将定位点设置成地图中心点。
    MAUserTrackingModeFollowWithHeading：跟随用户的位置和角度移动。*/
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    //显示地图类型
    _mapView.mapType = MAMapTypeStandard;
    //实时交通
    _mapView.showTraffic= YES;
    //指南针
    _mapView.showsCompass= YES; // 设置成NO表示关闭指南针；YES表示显示指南针
    _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 22+64); //设置指南针位置
    //比例尺
    _mapView.showsScale= YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 22+64);  //设置比例尺位置
    
    [AMapSearchServices sharedServices].apiKey = MapKey;
    //iOS SDK提供的大头针标注MAPinAnnotationView，通过它可以设置大头针颜色、是否显示动画、是否支持长按后拖拽大头针改变坐标等。
    self.pointAnnotation = [[MAPointAnnotation alloc] init];
    self.pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.afferentLatitude, self.afferentLongitude);
    [_mapView addAnnotation:self.pointAnnotation];
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    //构造AMapDrivingRouteSearchRequest对象，设置驾车路径规划请求参数
    self.request = [[AMapDrivingRouteSearchRequest alloc] init];
    //获取当前定位坐标
    self.selfLatitude = [[RRPYCSigleClass mapLatitudeLongitudePassByValue].latitude doubleValue];
    self.selfLongitude = [[RRPYCSigleClass mapLatitudeLongitudePassByValue].longitude doubleValue];
    self.request.origin = [AMapGeoPoint locationWithLatitude:self.selfLatitude longitude:self.selfLongitude];//出发点
    self.request.destination = [AMapGeoPoint locationWithLatitude:self.afferentLatitude longitude:self.afferentLongitude];
    // 驾车导航策略：0-速度优先（时间）；1-费用优先（不走收费路段的最快道路）；2-距离优先；3-不走快速路；4-结合实时交通（躲避拥堵）；5-多策略（同时使用速度优先、费用优先、距离优先三个策略）；6-不走高速；7-不走高速且避免收费；8-躲避收费和拥堵；9-不走高速且躲避收费和拥堵
    self.request.strategy = 0;//距离优先
    self.request.requireExtension = YES;
    //发起路径搜索
    [_search AMapDrivingRouteSearch:self.request];
    
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:self.afferentLatitude longitude:self.afferentLongitude];
    regeo.radius = 1000;
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeo];
    
    [self.view addSubview:_mapView];
}



//路线痕迹
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        polylineView.lineWidth = 5.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.8];
        polylineView.lineJoinType = kMALineJoinRound;//连接类型
        polylineView.lineCapType = kMALineCapRound;//端点类型
        
        return polylineView;
    }
    return nil;
}


////实现 MAMapViewDelegate 协议中的 mapView:viewForAnnotation:回调函数，设置标注样式。
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

//实现路径搜索的回调函数
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }
    //通过AMapNavigationSearchResponse对象处理搜索结果
//    NSString *route = [NSString stringWithFormat:@"Navi: %@", response.route];
    NSDictionary *dic = [RRPPrintObject getObjectData:response.route];
   //取时间距离
    self.distance = [NSString stringWithFormat:@"相距%.2lf千米",(CGFloat)[dic[@"paths"][0][@"distance"] integerValue]/1000];
    NSInteger duration = [dic[@"paths"][0][@"duration"] integerValue];
    if (duration < 3600) {
        //没有小时
        self.durationTime = [NSString stringWithFormat:@"自驾时间:%ld分钟",duration/60];
    }else {
        //是否为0分
        if (duration%3600/60 == 0) {
            //超过一个小时
            self.durationTime = [NSString stringWithFormat:@"自驾时间:%ld小时整",duration/3600];
        }else {
            //超过一个小时
            self.durationTime = [NSString stringWithFormat:@"自驾时间:%ld小时%ld分",duration/3600,duration%3600/60];
        }
    }
    
    self.pointAnnotation.subtitle = [NSString stringWithFormat:@"%@ %@",self.distance,self.durationTime];//提示
    
    
    //取坐标
    NSMutableArray *stepsArray = dic[@"paths"][0][@"steps"];
    for (int j = 0; j < stepsArray.count - 1 ; j++) {
        NSString *steps = dic[@"paths"][0][@"steps"][j][@"polyline"];
        //通过;符号分割，把字符串存进数组
        NSArray *oneArray = [steps componentsSeparatedByString:@";"];
        for (int i = 0; i < oneArray.count - 1; i++) {
            //通过,符号分割，把字符串存进数组
            NSArray *twoArray = [oneArray[i] componentsSeparatedByString:@","];
            [self.longitudeArray addObject:twoArray[0]];
            [self.latitudeArray addObject:twoArray[1]];
        }
    }
    //折线
    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[self.latitudeArray.count];
    for (int i = 0; i < self.latitudeArray.count; i++) {
        commonPolylineCoords[i].latitude = [self.latitudeArray[i] doubleValue];
        commonPolylineCoords[i].longitude = [self.longitudeArray[i] doubleValue];
    }
    //构造折线对象
    self.commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:self.latitudeArray.count];
    //在地图上添加折线对象
    [_mapView addOverlay:self.commonPolyline];
    
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSDictionary *dic = [RRPPrintObject getObjectData:response.regeocode];
//        NSLog(@"ReGeo: %@", dic);
        NSString *formattedAddress = dic[@"formattedAddress"];
//        NSLog(@"formattedAddress: %@", formattedAddress);
        self.pointAnnotation.title = formattedAddress;//名称
        [self.locationManager stopUpdatingLocation];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
