
//
//  HDSubVideo.h
//  iScanMC
//
//  Created by xsz on 21/8/14
//  Copyright (c) 2014年 hongdian. All rights reserved.
//

#import "IJKMediaPlayer.h"
//#import <IJKMediaFramework/IJKMediaPlayer.h>
#import "IJKMediaPlayback.h"
//#import <IJKMediaFramework/IJKMediaPlayback.h>
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "HDDeviceBase.h"
@class HDVideoView;
@interface HDSubVideo : UIView<ASIHTTPRequestDelegate>
{
    BOOL isFocus;
    UILabel* tipLabel;
    UIActivityIndicatorView* indicatorView; //指示，菊花旋转

    //MPMoviePlaybackState  playState;
    MPMovieLoadState playState;
    MPMovieLoadState loadState;
    BOOL isRecording;

    int	videoWidth;	//视频宽度和高度
    int videoHeight;	//视频高度
    int videoRgb565Length;
    BOOL isVideoBmpVaild;
	NSTimeInterval rePlaydateTime;	//
    int realRate;
    NSTimer* timerPlay;
    
    NSString* devName;
    NSString* devIdno;
    NSString* chnName;
    NSString* videoUrl;
    
    CGRect  rcVideo;
    
}

@property(atomic, retain) id<IJKMediaPlayback> player;

@property(nonatomic, assign ) BOOL isFocus;          //窗口序号
@property(nonatomic, strong )UILabel* labelChannel;         //显示通道号
@property(nonatomic, strong )UIImageView* imageViewVideo;   //显示视频图像
@property(nonatomic, assign ) NSString *channel;            //通道号
@property(nonatomic, assign ) NSInteger viewIndex;          //窗口序号
@property(nonatomic,retain) HDVideoView* videoview;
@property(nonatomic,assign) BOOL isSound;
@property(nonatomic,retain) NSString *baseUrl;
@property(nonatomic,retain) NSString *termSn;
@property(nonatomic, assign ) NSInteger curIndex;
- (void)reflash;

- (void)setViewInfo:(NSString*)_devName idno:(NSString*)_devIdno chn:(int)_channel name:(NSString*)_chnName url:(NSString*)_videoUrl;

- (BOOL)StartAV;

- (BOOL)StopAV:(BOOL) bClear;

/*
 * 判断是否正在预览
 */
- (BOOL)isViewing;

/*
 * 判断是否正在预览
 */
- (void) updateView;

/*
 * 保存成BMP图片
 */
- (BOOL)savePngFile:(NSString *)filePath;

/*
 * 云台控制
 */
- (void)ptzControl:(int)command speed:(int )nSpeed param:(int)nParam;

/*
 * 判断是否正在预览
 */
- (BOOL)isRecording;

/*
 * 启动或停止录像
 */
- (void)record;

/*
 * 启动录像
 */
- (BOOL)startRecord;

/*
 * 停止录像
 */
- (BOOL)stopRecord;

/*
 * 开始声音播放
 */
- (void)playSound;

/*
 * 开始声音播放
 */
- (void)stopSound;

- (BOOL)isSounding;

+ (NSString*)getFileFolder:(NSString*)folder;

@end
