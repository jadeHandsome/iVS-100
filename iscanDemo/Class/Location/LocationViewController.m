//
//  LocationViewController.m
//  iVS-100
//
//  Created by 曾洪磊 on 2018/1/3.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "LocationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import "KRCustomAnnotationView.h"
#import "TRAnnotation.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import "KRCustomView.h"
#import "CustomAnnotationView.h"
@import GoogleMaps;
@interface LocationViewController ()<MAMapViewDelegate,AMapSearchDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate>
@property (nonatomic, strong) MAMapView *gaodeView;
@property (nonatomic, strong) BMKMapView *baiduMap;
@property (nonatomic, strong) GMSMapView *googleMap;
@property (nonatomic, strong) NSDictionary *carInfo;
@property (nonatomic, strong) AMapSearchAPI *amapSearch;
@property (nonatomic, strong) NSString *localStr;
@property (nonatomic,strong) BMKGeoCodeSearch *baiduSearcher;
@end

@implementation LocationViewController
{
    NSTimer *locTimer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    switch (SharedUserInfo.mapType) {
        case 1:
        {
            //高德地图
            [self setUpGaode];
        }
            break;
        case 2:
        {
            //百度地图
            [self setUpBaidu];
        }
            break;
        case 3:
        {
            //谷歌地图
            [self setUpGoogle];
        }
            break;
            
        default:
            break;
    }

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    locTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getLocation) userInfo:nil repeats:YES];
    self.navigationItem.title = SharedUserInfo.device.departName;
    
}
- (void)getLocation {
    
    NSLog(@"%@",SharedUserInfo.device.vin);
    ASIHTTPRequest *request = [SharedSDK getCarLocation:SharedUserInfo.baseUrl Vid:SharedUserInfo.device.id Target:self Success:@selector(succLoc:) Failure:@selector(defaultLoc:)];
    [request startAsynchronous];
}
- (void)setUpGaode {
    self.gaodeView = [[MAMapView alloc]init];
    self.gaodeView.showsUserLocation = NO;
    [self.view addSubview:self.gaodeView];
    self.gaodeView.delegate = self;
    [self.gaodeView setZoomLevel:10];
    [self.gaodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)setUpBaidu {
    self.baiduMap = [[BMKMapView alloc]init];
    self.baiduMap.showsUserLocation = NO;
    self.baiduMap.delegate = self;
    [self.baiduMap setZoomLevel:13];
//    self.baiduMap.userTrackingMode = BMKUserTrackingModeFollow;
    [self.view addSubview:self.baiduMap];
    [self.baiduMap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)setUpGoogle {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:22.290664
                                                            longitude:114.195304
                                                                 zoom:14];
    self.googleMap = [GMSMapView mapWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT) camera:camera];
    [self.view addSubview:self.googleMap];
}
- (void)pop {
    [locTimer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)fresh {
    ASIHTTPRequest *request = [SharedSDK getCarLocation:SharedUserInfo.baseUrl Vid:SharedUserInfo.device.id Target:self Success:@selector(succLoc:) Failure:@selector(defaultLoc:)];
    [request startAsynchronous];
}
- (void)succLoc:(ASIFormDataRequest *)requst {
    NSData *data = [requst responseData];
    NSArray *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"成功 -- %@",dic);
    if ([dic count] == 0) {
        return;
    }
    self.carInfo = [dic[0] copy];
    
    if (SharedUserInfo.mapType == 1) {
        //高德
        self.amapSearch = [[AMapSearchAPI alloc] init];
        self.amapSearch.delegate = self;
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        
        regeo.location = [AMapGeoPoint locationWithLatitude:[dic[0][@"latitude"] doubleValue] longitude:[dic[0][@"longitude"] doubleValue]];
        regeo.requireExtension            = YES;
        [self.amapSearch AMapReGoecodeSearch:regeo];
    } else if (SharedUserInfo.mapType == 2) {
        //百度
        _baiduSearcher =[[BMKGeoCodeSearch alloc]init];
        _baiduSearcher.delegate = self;
        
        CLLocationCoordinate2D pt = CLLocationCoordinate2DMake([dic[0][@"latitude"] doubleValue], [dic[0][@"longitude"] doubleValue]);
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeoCodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [_baiduSearcher reverseGeoCode:reverseGeoCodeSearchOption];
        
        if(flag)
        {
            
        }
        else
        {
            
        }
    } else {
        //谷歌
    }
    
//     KRCustomAnnotationView *annos = (KRCustomAnnotationView *)self.selectedAnon;
    
}
- (void)defaultLoc:(ASIFormDataRequest *)requst {
    NSData *data = [requst responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"失败 -- %@",dic);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- baiduDelegate
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
//        result.addressDetail.字段;//包含了所有的信息   province:  省  city:  城市  district : 区 streetName: 路名  streetNumber:路号
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.carInfo[@"latitude"] doubleValue], [self.carInfo[@"longitude"] doubleValue]);
        self.localStr = [NSString stringWithFormat:@"%@%@%@%@%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
        if (self.baiduMap.annotations.count == 0) {
//            [self.baiduMap setZoomLevel:13 animated:YES];
            
            [self.baiduMap setCenterCoordinate:coordinate animated:YES];
            
//            [self.gaodeView setCenterCordinate:coordinate animated:YES];
        }
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = coordinate;
//        annotation.title = @"这里是北京";
        [self.baiduMap removeAnnotations:self.baiduMap.annotations];
        [self.baiduMap addAnnotation:annotation];
        [self.baiduMap selectAnnotation:annotation animated:YES];

    }
    
}

#pragma mark -- gaodeDelegate
- (id)mapView:(id)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([mapView isKindOfClass:[MAMapView class]]) {
        if ([annotation isKindOfClass:[MAUserLocation class]])
        {
            static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
            MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                 reuseIdentifier:userLocationStyleReuseIndetifier];
            }
            //        self.currentLocationView = annotationView;
            //CGRect rect = annotationView.frame;
            //rect.size = CGSizeMake(30, 30);
            //annotationView.frame = rect;
            //LRViewBorderRadius(annotationView, 15, 0, [UIColor clearColor]);
            //annotationView.clipsToBounds = YES;
            //self.userLocationAnnotationView = annotationView;
            return annotationView;
        }
        if ([annotation isKindOfClass:[TRAnnotation class]])
        {
            static NSString *reuseIndetifier = @"annotationReuseIndetifier";
            KRCustomAnnotationView *annotationView = (KRCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[KRCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
            }
            TRAnnotation *anno = (TRAnnotation *)annotation;
            annotationView.image = anno.image;
            NSMutableDictionary *dic = [self.carInfo mutableCopy];
            dic[@"location"] = self.localStr;
            [annotationView setMyData:dic];
            annotationView.canShowCallout = NO;
            // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView.centerOffset = CGPointMake(0, -18);
            return annotationView;
        }
    } else {
            if ([annotation isKindOfClass:[BMKPointAnnotation class]])
            {
                static NSString *reuseIndetifier = @"annotationReuseIndetifier";
                CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
                if (annotationView == nil)
                {
                    annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                                   reuseIdentifier:reuseIndetifier];
                }
                annotationView.image = [UIImage imageNamed:@"位置图标"];
                NSMutableDictionary *dic = [self.carInfo mutableCopy];
                dic[@"location"] = self.localStr;
                annotationView.myData = dic;
                annotationView.canShowCallout = NO;
                return annotationView;
            }
    }
    
    return nil;
}
/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        /* 包含 省, 市, 区以及乡镇.  */
        NSString *title = [NSString stringWithFormat:@"%@%@%@%@",
                      response.regeocode.addressComponent.province?: @"",
                      response.regeocode.addressComponent.city ?: @"",
                      response.regeocode.addressComponent.district?: @"",
                      response.regeocode.addressComponent.township?: @""];
        /* 包含 社区，建筑. */
        NSString *subTitle = [NSString stringWithFormat:@"%@%@",
                         response.regeocode.addressComponent.neighborhood?: @"",
                         response.regeocode.addressComponent.building?: @""];
        self.localStr = [title stringByAppendingString:subTitle];
//        ReGeocodeAnnotation *reGeocodeAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate
//                                                                                         reGeocode:response.regeocode];
        if (self.gaodeView.annotations.count == 0) {
            [self.gaodeView setZoomLevel:13 animated:YES];
            
            [self.gaodeView setCenterCoordinate:coordinate animated:YES];
        }
        
        TRAnnotation *pointAnnotation  = [[TRAnnotation alloc] init];
        pointAnnotation.coordinate = coordinate;
        pointAnnotation.image = [UIImage imageNamed:@"位置图标"];
        [self.gaodeView removeOverlays:self.gaodeView.annotations];
        [self.gaodeView addAnnotation:pointAnnotation];
        [self.gaodeView selectAnnotation:pointAnnotation animated:YES];
//        [self.gaodeView addAnnotation:pointAnnotation];
//        [self.mapView selectAnnotation:reGeocodeAnnotation animated:YES];
    }
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}
#pragma mark -- googleDelegate

@end
