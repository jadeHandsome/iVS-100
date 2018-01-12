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
#import <BaiduMapAPI_Map/BMKPolyline.h>
#import <BaiduMapAPI_Map/BMKPolylineView.h>
#import "KRCustomView.h"
#import "CustomAnnotationView.h"
#import <MapKit/MapKit.h>
#import <SMCalloutView/SMCalloutView.h>
@import GoogleMaps;
static const CGFloat CalloutYOffset = 10.0f;
@interface LocationViewController ()<MAMapViewDelegate,AMapSearchDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate,GMSMapViewDelegate>
@property (nonatomic, strong) MAMapView *gaodeView;
@property (nonatomic, strong) BMKMapView *baiduMap;
@property (nonatomic, strong) GMSMapView *googleMap;
@property (nonatomic, strong) NSDictionary *carInfo;
@property (nonatomic, strong) AMapSearchAPI *amapSearch;
@property (nonatomic, strong) NSString *localStr;
@property (nonatomic,strong) BMKGeoCodeSearch *baiduSearcher;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) GMSCameraPosition *camera;
@property (strong, nonatomic) SMCalloutView *calloutView;
@property (strong, nonatomic) UIView *emptyCalloutView;
@property (nonatomic, strong) NSMutableArray *locationArray;
@end

@implementation LocationViewController
{
    NSTimer *locTimer;
    BOOL isAnnoSelect;
    MAPolyline *mapoly;
    BMKPolyline* polyline;
    GMSPolyline *googlePolyline;
//    CLLocationCoordinate2D *locationArray;
}
//- (NSMutableArray *)locationArray {
//    if (!_locationArray) {
//        _locationArray = [NSMutableArray array];
//    }
//    return _locationArray;
//}
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
    [self getLocation];
    isAnnoSelect = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    locTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getLocation) userInfo:nil repeats:YES];
    self.navigationItem.title = SharedUserInfo.termSn;
    
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
    [self.gaodeView setZoomLevel:16];
    [self.gaodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)setUpBaidu {
    self.baiduMap = [[BMKMapView alloc]init];
    self.baiduMap.showsUserLocation = NO;
    self.baiduMap.delegate = self;
    [self.baiduMap setZoomLevel:16];
//    self.baiduMap.userTrackingMode = BMKUserTrackingModeFollow;
    [self.view addSubview:self.baiduMap];
    [self.baiduMap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)setUpGoogle {
    self.emptyCalloutView = [[UIView alloc] initWithFrame:CGRectZero];
    self.calloutView = [[SMCalloutView alloc] init];
    self.calloutView.contentView = [UIView new];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:22.290664
                                                            longitude:114.195304
                                                                 zoom:16];
    self.googleMap = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = self.googleMap;
    self.googleMap.delegate = self;
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(22.290664, 114.195304);
//    marker.title = @"香港";
//    marker.snippet = @"Hong Kong";
//    marker.map = self.googleMap;
    
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
    NSValue *vale = [NSValue valueWithMACoordinate:CLLocationCoordinate2DMake([dic[0][@"latitude"] doubleValue], [dic[0][@"longitude"] doubleValue])];
    [self.locationArray addObject:vale];
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
        _geocoder=[[CLGeocoder alloc]init];
        
        GMSMutablePath *path = [GMSMutablePath path];
        for (NSValue *value in self.locationArray) {
            CLLocationCoordinate2D loc;
            [value getValue:&loc];
            [path addCoordinate:loc];
        }
        if (googlePolyline) {
            googlePolyline.map = nil;
        }
        googlePolyline = [GMSPolyline polylineWithPath:path];
        googlePolyline.strokeWidth = 8.f;
        googlePolyline.geodesic = YES;
        googlePolyline.strokeColor = ThemeColor;
        googlePolyline.map = self.googleMap;
        CLLocation *location=[[CLLocation alloc]initWithLatitude:[dic[0][@"latitude"] doubleValue] longitude:[dic[0][@"longitude"] doubleValue]];
//        CLLocation *location1 = [CLLocation alloc]initWithCoordinate:<#(CLLocationCoordinate2D)#> altitude:<#(CLLocationDistance)#> horizontalAccuracy:<#(CLLocationAccuracy)#> verticalAccuracy:<#(CLLocationAccuracy)#> timestamp:<#(nonnull NSDate *)#>
        [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error||placemarks.count==0) {
                NSLog(@"获取失败");
            }else
            {
//                @property (nonatomic, readonly, copy, nullable) NSString *name; // eg. Apple Inc.
//                @property (nonatomic, readonly, copy, nullable) NSString *thoroughfare; // street name, eg. Infinite Loop
//                @property (nonatomic, readonly, copy, nullable) NSString *subThoroughfare; // eg. 1
//                @property (nonatomic, readonly, copy, nullable) NSString *locality; // city, eg. Cupertino
//                @property (nonatomic, readonly, copy, nullable) NSString *subLocality; // neighborhood, common name, eg. Mission District
//                @property (nonatomic, readonly, copy, nullable) NSString *administrativeArea; // state, eg. CA
                
                CLPlacemark *firstPlacemark=[placemarks firstObject];
                
                self.localStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",firstPlacemark.administrativeArea?firstPlacemark.administrativeArea:@"",firstPlacemark.subLocality?firstPlacemark.subLocality:@"",firstPlacemark.locality?firstPlacemark.locality:@"",firstPlacemark.subThoroughfare?firstPlacemark.subThoroughfare:@"",firstPlacemark.thoroughfare?firstPlacemark.thoroughfare:@"",firstPlacemark.name?firstPlacemark.name:@""];
                if (!self.camera) {
                    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[dic[0][@"latitude"] doubleValue]
                                                                            longitude:[dic[0][@"longitude"] doubleValue]
                                                                                 zoom:15];
                    [self.googleMap setCamera:camera];
                    _camera = camera;
                }
                [self.googleMap clear];
                CLLocationCoordinate2D position = CLLocationCoordinate2DMake([dic[0][@"latitude"] doubleValue], [dic[0][@"longitude"] doubleValue]);
                GMSMarker *london = [GMSMarker markerWithPosition:position];
                london.icon = [UIImage imageNamed:@"位置图标"];
                london.map = self.googleMap;
                //        london.title = @"London";
                london.infoWindowAnchor = CGPointMake(0.5, 1);
                if (isAnnoSelect) {
                    [self.googleMap setSelectedMarker:london];
                }
                
                
                
                
//                NSLog(@"str====%@",firstPlacemark.);
            }
        }];
            
        
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
        BOOL tempS = isAnnoSelect;
        [self.baiduMap removeAnnotations:self.baiduMap.annotations];
        isAnnoSelect = tempS;
        if (polyline) {
            [self.baiduMap removeOverlay:polyline];
        }
        CLLocationCoordinate2D coor[self.locationArray.count];
        for (int i = 0; i < self.locationArray.count; i ++) {
            NSValue *value = self.locationArray[i];
            [value getValue:&(coor[i])];
        }
        polyline = [BMKPolyline polylineWithCoordinates:coor count:4];
        [self.baiduMap addOverlay:polyline];
        [self.baiduMap addAnnotation:annotation];
        if (isAnnoSelect) {
            [self.baiduMap selectAnnotation:annotation animated:YES];
        }
        

    }
    
}
// Override
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = ThemeColor;
        polylineView.lineWidth = 8.0;
        
        return polylineView;
    }
    return nil;
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
            annotationView.block = ^(BOOL selected) {
                isAnnoSelect = selected;
            };
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
                annotationView.block = ^(BOOL selected) {
                    isAnnoSelect = selected;
                };
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
            [self.gaodeView setZoomLevel:16 animated:YES];
            
            [self.gaodeView setCenterCoordinate:coordinate animated:YES];
        }
        
        TRAnnotation *pointAnnotation  = [[TRAnnotation alloc] init];
        pointAnnotation.coordinate = coordinate;
        pointAnnotation.image = [UIImage imageNamed:@"位置图标"];
        [self.gaodeView removeOverlays:self.gaodeView.annotations];
        CLLocationCoordinate2D locaArray[self.locationArray.count];
        for (int i = 0; i < self.locationArray.count; i ++) {
            NSValue *value = self.locationArray[i];
            [value getValue:&(locaArray[i])];
        }
        if (mapoly) {
            [self.gaodeView removeOverlay:mapoly];
        }
        mapoly = [MAPolyline polylineWithCoordinates:locaArray count:self.locationArray.count];
        
        [self.gaodeView addOverlay:mapoly];
        [self.gaodeView addAnnotation:pointAnnotation];
        if (isAnnoSelect) {
            [self.gaodeView selectAnnotation:pointAnnotation animated:YES];
        }
        
//        [self.gaodeView addAnnotation:pointAnnotation];
//        [self.mapView selectAnnotation:reGeocodeAnnotation animated:YES];
    }
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = ThemeColor;
//        polylineRenderer.lineJoin = kCALineJoinRound;
//        polylineRenderer.lineCapType  = kCALineCapRound;
        
        return polylineRenderer;
    }
    return nil;
}
#pragma mark -- googleDelegate
- (nullable UIView *)mapView:(GMSMapView *)mapView markerInfoContents:(GMSMarker *)marker {
    CLLocationCoordinate2D anchor = marker.position;
    CGPoint point = [mapView.projection pointForCoordinate:anchor];
    self.calloutView.calloutOffset = CGPointMake(0, -CalloutYOffset);
    KRCustomView *mark = [[[NSBundle mainBundle]loadNibNamed:@"KRCustomView" owner:self options:nil]firstObject];
    mark.frame = CGRectMake(0, 0, SCREEN_WIDTH - 30, 150);
    mark.backgroundColor = [UIColor clearColor];
//    mark.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y + 150 + 20);
    NSMutableDictionary *dic = [self.carInfo mutableCopy];
    dic[@"location"] = self.localStr;
    [mark setDataWithDic:dic];
    //取消默认背景
//    SMCalloutBackgroundView *calloutBgView = [[SMCalloutBackgroundView alloc] initWithFrame:CGRectZero];
//    self.calloutView.backgroundView = calloutBgView;
//    self.calloutView.contentView = googleTipView;
//    self.calloutView.hidden = NO;
//    CGRect calloutRect = CGRectZero;
//    calloutRect.origin = point;
//    calloutRect.size = CGSizeZero;
//    [self.calloutView presentCalloutFromRect:calloutRect
//                                      inView:mapView
//                           constrainedToView:mapView
//                                    animated:YES];
    //SMCalloutView中contentView
   
    //取消默认背景
    SMCalloutBackgroundView *calloutBgView = [[SMCalloutBackgroundView alloc] initWithFrame:CGRectZero];
    self.calloutView.backgroundView = calloutBgView;
    self.calloutView.contentView = mark;
    self.calloutView.hidden = NO;
    CGRect calloutRect = CGRectZero;
    calloutRect.origin = CGPointMake(point.x - 10, point.y + 150 + 20);
    calloutRect.size = CGSizeZero;
    [self.calloutView presentCalloutFromRect:calloutRect
                                      inView:self.googleMap
                           constrainedToView:self.googleMap
                                    animated:NO];
    return self.emptyCalloutView;
}

@end
