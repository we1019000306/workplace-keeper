//
//  MapKitViewController.m
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/24.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//

#import "MapKitViewController.h"
#import <MapKit/MapKit.h>
#import "UIView+Extension.h"
#import "MYLocationViewController.h"

@interface MapKitViewController ()<MKMapViewDelegate>
@property(nonatomic ,strong) CLGeocoder *geocoder;
@property(nonatomic,strong) MKMapView *mkMapView;
@property (nonatomic, strong) CLLocationManager *mgr;
@end

@implementation MapKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WS(ws);
    self.mkMapView = [[MKMapView alloc]init];
    self.mkMapView.delegate = self;
    self.mkMapView.userTrackingMode =  MKUserTrackingModeFollow;
    self.mkMapView.rotateEnabled = NO;

    [self.view addSubview:self.mkMapView];
    [self.mkMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(0, 0));
        make.size.mas_equalTo(CGSizeMake(ws.view.width, ws.view.height));
    }];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        // 主动请求权限
        self.mgr = [[CLLocationManager alloc] init];
        
        [self.mgr requestAlwaysAuthorization];
    }

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    /*
     地图上蓝色的点就称之为大头针
     大头针可以拥有标题/子标题/位置信息
     大头针上显示什么内容由大头针模型确定(MKUserLocation)
     */
    // 设置大头针显示的内容
    //    userLocation.title = @"黑马";
    //    userLocation.subtitle = @"牛逼";
    
    // 利用反地理编码获取位置之后设置标题
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSLog(@"获取地理位置成功 name = %@ locality = %@", placemark.name, placemark.locality);
        userLocation.title = placemark.name;
        userLocation.subtitle = placemark.locality;
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:placemark.name forKey:@"name"];
        [accountDefaults setObject:placemark.locality forKey:@"locality"];

    }];
    // 获取用户的位置
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    // 指定经纬度的跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.009310,0.007812);
    // 将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度范围
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    // 设置显示区域
    [self.mkMapView setRegion:region animated:YES];

}

#pragma mark - 懒加载
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
@end
