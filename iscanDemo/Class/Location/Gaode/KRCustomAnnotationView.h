//
//  KRCustomAnnotationView.h
//  fitnessDog
//
//  Created by kupurui on 16/11/23.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "KRCustomView.h"
typedef void(^SELECTED_ADD)(BOOL selected);
@interface KRCustomAnnotationView : MAAnnotationView
@property (nonatomic, strong) KRCustomView *calloutView;
@property (nonatomic, strong) NSDictionary *myData;
@property (nonatomic, strong) SELECTED_ADD block;
//@property (nonatomic, strong) SELECTED_ADD block;
@end
