//
//  ViewController.m
//  BMapDemo
//
//  Created by Cloudox on 15/11/14.
//  Copyright © 2015年 Cloudox. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface ViewController ()
@property (strong, nonatomic) BMKMapView* mapView;
@property (strong, nonatomic) BMKLocationService* locService;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _locService = [[BMKLocationService alloc]init];
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    self.view = _mapView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//        NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    _mapView.centerCoordinate = coordinate;
    
    [_mapView updateLocationData:userLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude
                                                longitude:userLocation.location.coordinate.longitude];
    __block NSString *province;
    __block NSString *cityName;
    __block NSString *cityStr;
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks) {
            province = placemark.administrativeArea;
            if (province.length == 0) {
                province = placemark.locality;
                cityName = placemark.subLocality;
                NSLog(@"cityName %@",cityName);//获取城市名
                NSLog(@"province %@ ++",province);
            }else {
                //获取街道地址
                cityStr = placemark.thoroughfare;
                //获取城市名
                cityName = placemark.locality;
                province = placemark.administrativeArea;
                NSLog(@"cityStr %@",cityStr);//获取街道地址（喻园大道）
                NSLog(@"cityName %@",cityName);//获取城市名（武汉市）
                NSLog(@"province %@",province);// 省份（湖北省）
                NSLog(@"name %@", placemark.name);// 整体地名（中国湖北省武汉市洪山区关山街道喻园大道）
                NSLog(@"subLocality %@", placemark.subLocality);// 区（洪山区）
            }
            break;
        }
        
    }];
//    [_locService stopUserLocationService];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

@end
