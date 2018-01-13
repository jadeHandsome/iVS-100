//
//  BaseTabbarViewController.m
//  WisdomRiver
//
//  Created by 曾洪磊 on 2017/12/14.
//  Copyright © 2017年 曾洪磊. All rights reserved.
//

#import "BaseTabbarViewController.h"
#import "LocationViewController.h"
#import "PicViewController.h"
#import "TalkViewController.h"
#import "VideoViewController.h"
#import "BaseNaviViewController.h"
#import "HDPreviewView.h"
@interface BaseTabbarViewController ()

@end

@implementation BaseTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = ThemeColor;
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化主tabbar

- (void)setUp {
    //首页
    LocationViewController *loc = [LocationViewController new];
//    loc.device = self.device;
    BaseNaviViewController *homeNav = [[BaseNaviViewController alloc]initWithRootViewController:loc];
//    homeNav.
    [homeNav.tabBarItem setImage:[[UIImage imageNamed:@"定位未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [homeNav.tabBarItem setSelectedImage:[UIImage imageNamed:@"定位选中"]];
    //[home.tabBarItem setSelectedImage:[UIImage imageNamed:@"商城-已选中"]];
    homeNav.tabBarItem.title = Localized(@"定位");
    //社区
    PicViewController *pic = [PicViewController new];
//    pic.device = self.device;
    BaseNaviViewController *community = [[BaseNaviViewController alloc]initWithRootViewController:pic];
    
    [community.tabBarItem setImage:[[UIImage imageNamed:@"图片未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [community.tabBarItem setSelectedImage:[[UIImage imageNamed:@"图片选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    community.tabBarItem.title = Localized(@"图片");
    //安装
    BaseNaviViewController *install = [[BaseNaviViewController alloc]initWithRootViewController:[TalkViewController new]];
    [install.tabBarItem setImage:[[UIImage imageNamed:@"对讲未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [install.tabBarItem setSelectedImage:[[UIImage imageNamed:@"对讲选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    install.tabBarItem.title = Localized(@"对讲");
    //购物车
    HDPreviewView *pre = [[HDPreviewView alloc]init];
//    pre.term = self.tepTerm;
//    pre.device = self.tepDevice;
//    [pre setTermSnInfo:SharedUserInfo.termSn];
    BaseNaviViewController *buyCar = [[BaseNaviViewController alloc]initWithRootViewController:pre];
    buyCar.tabBarItem.title = Localized(@"视频");
    [buyCar.tabBarItem setImage:[[UIImage imageNamed:@"视频未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [buyCar.tabBarItem setSelectedImage:[[UIImage imageNamed:@"视频选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //我的
    self.viewControllers = @[homeNav,buyCar,community,install];
    
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
