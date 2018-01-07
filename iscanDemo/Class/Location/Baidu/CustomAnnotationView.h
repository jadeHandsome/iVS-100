//
//  CustomAnnotationView.h
//  iVS-100
//
//  Created by 曾洪磊 on 2018/1/6.
//  Copyright © 2018年 hilook.com. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKAnnotationView.h>
#import "KRCustomView.h"
typedef void(^AnnoSelected)(BOOL selected);
@interface CustomAnnotationView : BMKAnnotationView
@property (nonatomic, strong) KRCustomView *calloutView;
@property (nonatomic, strong) NSDictionary *myData;
@property (nonatomic, strong) AnnoSelected block;
@end
