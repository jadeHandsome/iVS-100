//
//  HDVideoView.h
//  iScanMC
//
//  Created by xsz on 21/8/14
//  Copyright (c) 2014年 hongdian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDArrange.h"

@class HDDeviceBase;

@protocol HDVideoViewDelegate <NSObject>
- (void)updatePlayBar;
@end

@interface HDVideoView : UIViewController <HDArrangeDelegate>
{
   
    HDArrange* arrange;
    int channelCount;
    
    NSTimeInterval recordTipTime;
    NSTimeInterval soundTipTime;
    BOOL isSounding;
    NSThread* updateThread;
    BOOL isPause;
//    HDTalkback* mTalkback;
    HDDeviceBase* selDevice;
    UIScrollView *scrollView;
}

@property(nonatomic) int activeIndex;
@property(nonatomic,retain) NSMutableArray* subViewArray;
@property(nonatomic,assign) id<HDVideoViewDelegate> delegate;
@property(nonatomic,retain) NSString *termSn;
@property(nonatomic,assign) int channelCount;
@property (nonatomic, strong) NSArray *channelsList;
@property(nonatomic,retain) NSString *baseUrl;
- (void)setCtrlPos;
- (void)switchActiveView: (int)index;
-(void)setBaseURl:(NSString*)url;
- (void)moveVideoView;

-(void)setSubViewsTermSn:(NSString*)sn;
- (BOOL)isSounding;
- (void)stopSound;
/*
 * 停止所有视频
 */
- (void)stopAllAV;

/*
 * 设置预览此设备的视频
 */
- (void)setViewDev:(HDDeviceBase*)device;

- (void)playView;

/*
 * 判断播放按钮的状态
 */
- (void)updatePlayBar;

/*
 * 获取是否当前的画面模式处理播放状态
 */
- (BOOL)isViewing;

/*
 * 获取是否当前的画面模式处理播放状态
 */
- (BOOL)isRecording;

/*
 * 判断是否正在播放声音
 */
- (BOOL)isSounding;

/*
 * 判断是否正在对讲
 */
- (BOOL)isTalkback;
    
/*
 * 抓拍图片
 */
- (void)capturePng:(NSString *)filePath;

/*
 * 判断是否正在预览
 */
- (BOOL)isFocusViewing;

/*
 * 云台控制
 */
- (void)ptzControl:(int)command speed:(int )nSpeed param:(int)nParam;

/*
 * 判断录像权限
 */
- (BOOL)checkRecordPrivi;

/*
 * 判断声音权限
 */
- (BOOL)checkSoundPrivi;

/*
 * 视频预览
 */
- (void)record;

/*
 * 声音控制
 */
- (void)sound;

/*
 * 更新声音状态
 */
- (void)updateSound;

/*
 * 双向对讲
 */
- (void)talkback;

@end
