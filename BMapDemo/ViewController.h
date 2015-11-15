//
//  ViewController.h
//  BMapDemo
//
//  Created by Cloudox on 15/11/14.
//  Copyright © 2015年 Cloudox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface ViewController : UIViewController <BMKMapViewDelegate,BMKLocationServiceDelegate>


@end

