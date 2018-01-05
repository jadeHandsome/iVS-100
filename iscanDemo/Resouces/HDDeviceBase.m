//
//  HDDeviceBase.m
//  iscanMC
//
//  Created by xsz on 21/8/14.
//  Copyright (c) 2014年 hongdian. All rights reserved.
//

#import "HDDeviceBase.h"
#import "HDDeviceStatus.h"

@implementation HDDeviceBase

@synthesize status;

- (void)dealloc {
    [super dealloc];
}

- (BOOL) isOnline
{
    if (status != nil && status.online > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) hasVideo
{
    return YES;
//    if (devType == DEVICE_TYPE_MOBILE) {
//        return NO;
//    } else {
//        return YES;
//    }
}

- (BOOL) isGpsType
{
    if (devType == 3) {
        return FALSE;
    } else {
        return TRUE;
    }
}

- (NSString*)getChannelName:(int) chn
{
    NSArray *arrName = [chnName componentsSeparatedByString:@","];
    if (chn < [arrName count]) {
        return [NSString stringWithFormat:@"%@", [arrName objectAtIndex:chn] ];
    } else {
        return [NSString stringWithFormat:@"CH %d", (chn + 1)];
    }
}

- (NSString*)getVideoUrl:(int) chn
{
    NSArray *arrUrl = [videoUrl componentsSeparatedByString:@","];
    if (chn < [arrUrl count]) {
        return [NSString stringWithFormat:@"%@", [arrUrl objectAtIndex:chn] ];
    } else {
        return [NSString stringWithFormat:@""];
    }
}

@end
