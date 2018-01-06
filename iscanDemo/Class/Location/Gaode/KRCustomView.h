//
//  KRCustomView.h
//  fitnessDog
//
//  Created by kupurui on 16/11/23.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KRCustomView : UIView
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pingjia;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *cardNum;
@property (nonatomic, strong) NSDictionary *myData;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
