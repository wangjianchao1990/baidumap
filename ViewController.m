//
//  ViewController.m
//  baidumap
//
//  Created by MAC on 16/6/20.
//  Copyright © 2016年 银资. All rights reserved.
//

#import "ViewController.h"
#import "YOHomeParkInfoModel.h"

@interface ViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate>

@property(nonatomic,strong)BMKMapView *mapView;

@end

@implementation ViewController
{
    BMKLocationService* _locService;
    
    BMKPoiSearch *_searcher;
    
    BMKUserLocation * _myUserLocation;
}
- (BMKMapView *)mapView
{
    if (!_mapView) {
        BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
        
        _mapView = mapView;
    }
    return _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self userLocation];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initView
{
    [self.view addSubview:self.mapView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
#pragma mark - ___________定位_______
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)userLocation
{
//    _mapView.showsUserLocation = YES;

    _locService = [[BMKLocationService alloc]init];
    
    _locService.delegate = self;
    
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    
    [self startUserLocationService];
    
    
}

/// 开始定位
- (void)startUserLocationService
{
    [_locService startUserLocationService];
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    //  设置屏幕中心
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    //  设置显示比例尺
    _mapView.zoomLevel = 18;
    
    //  更新我的位置数据
    [_mapView updateLocationData:userLocation];
    
    _myUserLocation = userLocation;
    [self initNearbySearchOption];
    
    //  显示用户中心
    _mapView.showsUserLocation = YES;
    
    //初始化地理编码类
    //注意：必须初始化地理编码类
    BMKGeoCodeSearch * _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    
    //初始化逆地理编码类
    BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    //需要逆地理编码的坐标位置
    reverseGeoCodeOption.reverseGeoPoint = _myUserLocation.location.coordinate;
    
    BOOL reg = [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    
    if (reg) {
        NSLog(@"_____编码成功");
    }else
    {
        NSLog(@"_____编码失败");
    }
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        NSLog(@"%@",result);
        NSLog(@"%@----------%@",result.address,result.businessCircle);
    }else if (error == BMK_SEARCH_PERMISSION_UNFINISHED)
    {
        //
    }
}

#pragma mark ____________poi检索_______
- (void)initNearbySearchOption
{
    {
        //初始化检索对象
        _searcher =[[BMKPoiSearch alloc]init];
        _searcher.delegate = self;//不同时记得置空
        //发起检索
        BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
        //检索分页页码
        option.pageIndex = 0;
        //检索分页每页多少个
        option.pageCapacity = 16;
        //检索半径
        option.radius = 500;
        //检索中心   这种直接给坐标的写法，有助于封装
        option.location = CLLocationCoordinate2DMake(_myUserLocation.location.coordinate.latitude, _myUserLocation.location.coordinate.longitude);
        //检索关键字
        option.keyword = @"停车场";
        //发起检索
        BOOL flag = [_searcher poiSearchNearBy:option];
        
        if(flag)
        {
            NSLog(@"周边检索发送成功");
        }
        else
        {
            NSLog(@"周边检索发送失败");
        }
    }
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
//        NSLog(@"%@",poiResultList.poiInfoList);
        for (BMKPoiDetailResult *result in poiResultList.poiInfoList)
        {
            //  创建一个大头针
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            //  大头针坐标
            annotation.coordinate = CLLocationCoordinate2DMake(result.pt.latitude,result.pt.longitude);
            //  添加大头针
            [_mapView addAnnotation:annotation];
        }
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
