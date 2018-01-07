//
//  HDPreviewView.h
//  iScanMC
//
//  Created by xsz on 21/8/14
//  Copyright (c) 2014年 hongdian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDVideoCtrl.h"
#import "HDPtzView.h"
#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"
#import "HDVideoView.h"
#import "BaseViewController.h"
@class iscanMCSdk;
@interface HDPreviewView : BaseViewController <HDVideoViewDelegate, HDVideoCtrlDelegate,TTXPtzViewDelegate,ASIHTTPRequestDelegate>
{
    HDVideoView* videoView;
    HDVideoCtrl* videoCtrl;
    HDPtzView* ptzView;
    NSString* selDevIdno;
    iscanMCSdk *sdk;
}
@property(nonatomic,retain) NSDictionary *device;
@property(nonatomic,retain) NSDictionary *term;

@property(nonatomic,retain) NSString *termSn;
@property(nonatomic,retain) NSString *ip1;
@property(nonatomic,retain) NSString *port1;

@property(nonatomic,retain) NSString *ip2;
@property(nonatomic,retain) NSString *port2;

@property(nonatomic,retain) NSMutableArray *channels;
@property(nonatomic,retain) NSMutableArray *videoIds;
- (void)setTermSnInfo:(NSString *)termSn;
- (void)startWork;
- (void)stopWork;
- (void)onResume;

@end
