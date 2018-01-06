//
//  KRUserInfo.h
//  Dntrench
//
//  Created by kupurui on 16/10/18.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "DeviceModel.h"
@interface KRUserInfo : NSObject
singleton_interface(KRUserInfo)
@property (nonatomic, assign) NSInteger mapType;//1高德 2百度 3谷歌
@property (nonatomic, strong) DeviceModel *device;
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, strong) NSString *termSn;
@end
