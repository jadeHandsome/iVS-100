//
//  HDDeviceBase.h
//  iscanMC
//
//  Created by xsz on 21/8/14.
//  Copyright (c) 2014年 hongdian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDDeviceObject.h"

@class HDDeviceStatus;

@interface HDDeviceBase : HDDeviceObject
{
    HDDeviceStatus* status;
}

@property (nonatomic, retain) HDDeviceStatus* status;

- (BOOL) isOnline;
- (BOOL) hasVideo;
- (BOOL) isGpsType;
- (NSString*)getChannelName:(int) chn;
- (NSString*)getVideoUrl:(int) chn;

@end
