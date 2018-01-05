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
@import GoogleMaps;
@interface LocationViewController ()
@property (nonatomic, strong) MAMapView *gaodeView;
@property (nonatomic, strong) BMKMapView *baiduMap;
@property (nonatomic, strong) GMSMapView *googleMap;
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(fresh)];
    locTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getLocation) userInfo:nil repeats:YES];
    
}
- (void)getLocation {
    ASIHTTPRequest *request = [SharedSDK getCarLocation:SharedUserInfo.baseUrl Vid:self.device.id Target:self Success:@selector(succLoc:) Failure:@selector(defaultLoc:)];
    [request startAsynchronous];
}
- (void)setUpGaode {
    self.gaodeView = [[MAMapView alloc]init];
    self.gaodeView.showsUserLocation = YES;
    [self.view addSubview:self.gaodeView];
    [self.gaodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)setUpBaidu {
    self.baiduMap = [[BMKMapView alloc]init];
    self.baiduMap.showsUserLocation = YES;
    self.baiduMap.userTrackingMode = BMKUserTrackingModeFollow;
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
    ASIHTTPRequest *request = [SharedSDK getCarLocation:SharedUserInfo.baseUrl Vid:SharedUserInfo.termSn Target:self Success:@selector(succLoc:) Failure:@selector(defaultLoc:)];
    [request startAsynchronous];
}
- (void)succLoc:(ASIFormDataRequest *)requst {
    NSData *data = [requst responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"成功 -- %@",dic);
}
- (void)defaultLoc:(NSDictionary *)dic {
    NSLog(@"失败 -- %@",dic);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- baiduDelegate

#pragma mark -- gaodeDelegate

#pragma mark -- googleDelegate

@end
