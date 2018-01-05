//
//  TermModel.h
//  iVS-100
//
//  Created by 曾洪磊 on 2018/1/4.
//  Copyright © 2018年 hilook.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TermModel : NSObject
//csq = "<null>";
//netMode = "<null>";
//netType = "<null>";
//online = 1;
//sim = "";
//simType = 1;
//termSn = 075500000100;
//termType = 1;
@property (nonatomic, strong) NSString *csq;
@property (nonatomic, strong) NSString *netMode;
@property (nonatomic, strong) NSString *online;
@property (nonatomic, strong) NSString *sim;
@property (nonatomic, strong) NSString *simType;
@property (nonatomic, strong) NSString *termSn;
@property (nonatomic, strong) NSString *termType;
@end
