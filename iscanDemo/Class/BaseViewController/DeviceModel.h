//
//  DeviceModel.h
//  iVS-100
//
//  Created by 曾洪磊 on 2018/1/4.
//  Copyright © 2018年 hilook.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject
//color = 1;
//departId = 2;
//departName = dcw;
//driverId = "<null>";
//driverName = "<null>";
//id = 1;
//mode = "<null>";
//nationality = "<null>";
//origId = "<null>";
//rtoln = "<null>";
//rtpn = "<null>";
//termList =     (
//                {
//                    csq = "<null>";
//                    netMode = "<null>";
//                    netType = "<null>";
//                    online = 1;
//                    sim = "";
//                    simType = 1;
//                    termSn = 075500000100;
//                    termType = 1;
//                }
//                );
//transCodeDate = "<null>";
//transType = "<null>";
//type = "<null>";
//vin = 123;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *departId;
@property (nonatomic, strong) NSString *departName;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *mode;
@property (nonatomic, strong) NSString *nationality;
@property (nonatomic, strong) NSString *origId;
@property (nonatomic, strong) NSString *rtoln;
@property (nonatomic, strong) NSString *rtpn;
@property (nonatomic, strong) NSArray *termList;
@property (nonatomic, strong) NSString *transCodeDate;
@property (nonatomic, strong) NSString *transType;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *vin;
@end
