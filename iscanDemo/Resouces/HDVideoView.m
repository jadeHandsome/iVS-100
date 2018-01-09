//
//  HDVideoView.m
//  cmsv6
//
//  Created by Apple on 13-4-5.
//  Copyright (c) 2013年 babelstar. All rights reserved.
//

#import "HDVideoView.h"
#import "HDSubVideo.h"

NSString* PRIVI_VIDEO			= @"621";		//视频
NSString* PRIVI_VIDEO_SOUND     = @"622";		//声音
NSString* PRIVI_VIDEO_TALK		= @"623";		//对讲
NSString* PRIVI_VIDEO_MONITOR	= @"624";		//监听
NSString* PRIVI_VIDEO_DEV_CAPTURE	= @"625";	//前端抓拍
NSString* PRIVI_VIDEO_PTZ		= @"626";		//云台
NSString* PRIVI_VIDEO_RECORD	= @"627";		//录像
#define MAX_CHANNEL_CNT     16

@interface HDVideoView ()

-(void)createCtrl;
-(void)setSplitWindow:(HDArrangeType)type;

-(void)onClick:(id)sender;
-(void)onDblClk:(id)sender;
-(void)onPin:(id)sender;
-(void)onSwipe:(id)sender;
-(HDSubVideo*)getSubVideo:(int)index;
-(BOOL)isOneVideoMode;
-(int)getShowVideoCount;
@end

@implementation HDVideoView

@synthesize delegate;
@synthesize subViewArray;
@synthesize activeIndex;
@synthesize baseUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[ UIColor blackColor]];
//        mTalkback = [[HDTalkback alloc] init];
    }
    return self;
}
-(void)setBaseURl:(NSString*)url{
    baseUrl = url;
    [self createCtrl ];
    [self setCtrlPos ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    selDevice = nil;
    
}

- (void)viewDidUnload
{
    subViewArray = nil;
    arrange = nil;
//    [mTalkback release]; mTalkback = nil;
    [super viewDidUnload];
}

-(void)setSubViewsTermSn:(NSString*)sn
{
    for (HDSubVideo *view in subViewArray) {
        view.termSn=sn;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createCtrl
{
    arrange = [[ HDArrange alloc]init ];
    arrange.num = self.channelsList.count;
    arrange.delegate = self;
    subViewArray = [[ NSMutableArray alloc ] init ];
    activeIndex = 0;
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    
    for( int i = 0 ; i < MAX_CHANNEL_CNT; ++i )
    {
        //子窗体
        HDSubVideo* subView = [[ HDSubVideo alloc ]init ];
        subView.videoview=self;
        [subView.labelChannel setText:[ NSString stringWithFormat:@"%d", i + 1 ] ];
        subView.channel = [NSString stringWithFormat:@"%d",i+1];
        subView.viewIndex = i;
        subView.baseUrl = baseUrl;
        subView.termSn = _termSn;
        [scrollView addSubview: subView ];
        [arrange addView:i view: subView ];
        [subViewArray insertObject: subView atIndex: i ];
        
    }
    //设置默认通道数 有待完善，针对不同通道数！要可操作缩放
    //[arrange setChannelCnt: 6 ];
    
    HDSubVideo* selView = [ subViewArray objectAtIndex: 0 ];
    [selView setIsFocus: YES ];
    SharedUserInfo.currentChannel = @"1";
    //单击
    UITapGestureRecognizer* tap1 = [[ UITapGestureRecognizer alloc ]initWithTarget:self action:@selector(onClick:) ];
    tap1.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer: tap1 ];
    
    //双击
    UITapGestureRecognizer* tapGesture = [[ UITapGestureRecognizer alloc ]initWithTarget:self action:@selector(onDblClk:) ];
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture ];
   
    //双指捏或者向外拨
    UIPinchGestureRecognizer* pinGesture = [[ UIPinchGestureRecognizer alloc ]initWithTarget:self action:@selector(onPin:) ];
    [self.view addGestureRecognizer: pinGesture ];
    
    //划动,左右划动，要两个手势？
    UISwipeGestureRecognizer* swipeGesture1 = [[ UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwipe:) ];
    swipeGesture1.direction = UISwipeGestureRecognizerDirectionLeft ;//向左划动
    [self.view addGestureRecognizer: swipeGesture1 ];
    
    UISwipeGestureRecognizer* swipeGesture2 = [[ UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwipe:) ];
    swipeGesture2.direction = UISwipeGestureRecognizerDirectionRight;//向右划动
    [self.view addGestureRecognizer: swipeGesture2 ];
    
}

-(void)setCtrlPos
{
    float spaceX = 5;//1;
    float spaceY = 60;//1;
    float itemWidth = (SIZEWIDTH - 3 * spaceX) / 2 ;
    float itemHeight = (SIZEWIDTH - 3 * spaceX) / 2 * 3 / 4;
    scrollView.frame = self.view.bounds;
    NSInteger line = self.channelsList.count / 2 + self.channelsList.count % 2 == 0 ? 0 : 1;
    scrollView.contentSize = CGSizeMake(SIZEWIDTH, 10 + (spaceY + itemHeight) * line + 10 + 10 + HEIGHT(300) - spaceY);
    [self setSplitWindow: E_ArrangeType_16 ];
}

-(void)setSplitWindow:(HDArrangeType)type
{
    CGRect rcArea = self.view.bounds;
    rcArea.origin.x += 1;
    rcArea.origin.y += 1;
    rcArea.size.width -= 2;
    rcArea.size.height -= 2;
    
    [arrange arrangeView:rcArea type:type ];
}

-(void)onSelView:(int)index
{
    [self switchActiveView:index];
    [self updatePlayBar];
    /*
    if( index != activeIndex )
    {
        HDSubVideo* subViewOld = [ subViewArray objectAtIndex: activeIndex ];
        HDSubVideo* subViewNew = [ subViewArray objectAtIndex: index ];
        [subViewOld setIsFocus: NO ];
        [subViewOld reflash];
        [subViewNew setIsFocus: YES ];
        [subViewNew reflash];
        
        activeIndex = index;
    }*/
}

-(void)onClick:(id)sender
{
    UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*)sender;
    CGPoint point = [tapGesture locationInView:self.view ];
    int viewIndex = [arrange getViewIndex: point ];
    SharedUserInfo.currentChannel = [NSString stringWithFormat:@"%d",viewIndex + 1];
    [ self onSelView: viewIndex ];
}

-(void)onDblClk:(id)sender
{
    UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*)sender;
    CGPoint point = [tapGesture locationInView:self.view ];
    int viewIndex = [arrange getViewIndex: point ];
    SharedUserInfo.currentChannel = [NSString stringWithFormat:@"%d",viewIndex + 1];
    [ self onSelView: viewIndex ];
    
    [arrange onDblClk: viewIndex];
}

-(void)onPin:(id)sender
{
    UIPinchGestureRecognizer* pinGesture = (UIPinchGestureRecognizer*)sender;
    if( UIGestureRecognizerStateEnded != pinGesture.state )
    {
        return;
    }
    
    float factor = [pinGesture scale ];
    if( factor > 1.0 )
    {
        [arrange zoomIn ];
    }
    else
    {
        //足够显示，不能变小窗体 //Howard 2012-11-12
        if( ![arrange isEnabledTurnPage ])
        {
            return;
        }
        [arrange zoomOut ];
    }
}


-(void)onSwipe:(id)sender
{
    //足够显示，不能翻页 //Howard 2012-11-12
    if( ![arrange isEnabledTurnPage ])
    {
        return;
    }
    
    [UIView beginAnimations:nil context:NULL];//启用动画移动
    [UIView setAnimationDuration: 0.50 ];
    [UIView setAnimationBeginsFromCurrentState:YES ];
    
    UISwipeGestureRecognizer* swipGesture = (UISwipeGestureRecognizer*)sender;
    if( UISwipeGestureRecognizerDirectionRight == swipGesture.direction )
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        //Howard 2012-11-05 有待完善，要判断是否可翻页
        //[getApp().videoView onStop ]; 2013-04-05
        [arrange previousPage ];
        [self onSelView: [arrange getSelViewIndex ]];
        //[self playPage ];
    }
    else if(UISwipeGestureRecognizerDirectionLeft == swipGesture.direction)
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        //Howard 2012-11-05 有待完善，要判断是否可翻页
        //[getApp().videoView onStop ]; 2013-04-05
        [arrange nextPage ];
        [self onSelView: [arrange getSelViewIndex ]];
        //[self playPage ];
    }
    [UIView commitAnimations];//完成动画移动
}

-(HDSubVideo*)getSubVideo:(int)index
{
    HDSubVideo* subView = [subViewArray objectAtIndex: index ];
    return subView;
}

- (void)switchActiveView: (int)index
{
    if (activeIndex != index) {
        [[self getSubVideo:activeIndex] setIsFocus:NO];
        [[self getSubVideo:activeIndex] reflash];
        activeIndex = index;
        [[self getSubVideo:activeIndex] setIsFocus:YES];
        [[self getSubVideo:activeIndex] reflash];
        [self updateSound];
    }
}

- (BOOL)isOneVideoMode
{
    if (arrange.m_bOnlyOne || arrange.m_arrangeTypeNew == 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (int)getShowVideoCount
{
    return arrange.m_arrangeTypeNew * arrange.m_arrangeTypeNew;
}

- (void)moveVideoView
{
   [arrange arrangeView];
}

/*
 * 停止所有视频
 */
- (void)stopAllAV
{
    for (int i = 0; i < MAX_CHANNEL_CNT; ++ i) {
        [[self getSubVideo:i] StopAV:YES];
        [[self getSubVideo:i] setViewInfo:@"" idno:@"" chn:i name:@"" url:@""];
    }
//    [self stopTalkback];
    [self updatePlayBar];
    selDevice = nil;
//    devIdno = @"";
}

/*
 * 设置预览此设备的视频
 */
- (void)setViewDev:(HDDeviceBase*)device
{
    selDevice = device;
//    devIdno = device.idno;
    int i = 0;
    for (i = 0; i < device.chnCount; ++ i) {
        [[self getSubVideo:i] setViewInfo:device.devName idno:device.idno chn:i name:[device getChannelName:i] url:[device getVideoUrl:i]];
    }
    for (i = device.chnCount; i < MAX_CHANNEL_CNT; ++ i) {
        [[self getSubVideo:i] setViewInfo:@"" idno:@"" chn:i name:@"" url:@""];
    }
    //切换画面数目模式
    BOOL resize = NO;
    channelCount = device.chnCount;
    if (channelCount == 1) {
        if (arrange.m_arrangeTypeNew != E_ArrangeType_1 || arrange.m_nPageIndex != 0) {
            arrange.m_arrangeTypeNew = E_ArrangeType_1;
            arrange.m_nPageIndex = 0;
            arrange.m_nShowViewIndex = 0;
            resize = YES;
            [self switchActiveView:0];
        }
    } else {
        if (arrange.m_nPageIndex != 0) {
            arrange.m_nPageIndex = 0;
            arrange.m_nShowViewIndex = 0;
            resize = YES;
            [self switchActiveView:0];
        }
        if (arrange.m_arrangeTypeNew == E_ArrangeType_1) {
            arrange.m_arrangeTypeNew = E_ArrangeType_4;
            resize = YES;
        }
        if (arrange.m_bOnlyOne) {
            arrange.m_bOnlyOne = NO;
            resize = YES;
        }
    }
    [arrange setChannelCnt:device.chnCount];
    
    if (resize) {
        [self moveVideoView];
    }
}


- (void)playView
{

    if ( selDevice == nil )
    {
        return;
    }
    
    //当前画面模式为4画面，则同时开始4个画面的视频
    //如果为1画面，则开启1个画面的视频
    if ([self isOneVideoMode]) {
        HDSubVideo* subVideo = [self getSubVideo:activeIndex];
        if ([subVideo isViewing]) {
            [subVideo StopAV:YES];
        } else {
            [subVideo StartAV];
            //更新声音状态
            [self updateSound];
        }
    } else {
        HDDeviceBase* device = selDevice;
        int begIndex = arrange.m_nPageIndex * (arrange.m_arrangeTypeNew * arrange.m_arrangeTypeNew);
        int endIndex = (arrange.m_nPageIndex + 1) * (arrange.m_arrangeTypeNew * arrange.m_arrangeTypeNew);
        if ([self isViewing]) {
            for (int i = begIndex; i < endIndex && i < device.chnCount; ++ i) {
                [[self getSubVideo:i] StopAV:YES];
            }
        } else {
            for (int i = 0; i < begIndex && i < device.chnCount; ++ i) {
                [[self getSubVideo:i] StopAV:YES];
            }
            for (int i = endIndex; i < device.chnCount; ++ i) {
                [[self getSubVideo:i] StopAV:YES];
            }
            for (int i = begIndex; i < endIndex && i < device.chnCount; ++ i) {
                if (![[self getSubVideo:i] isViewing])
                {
                    [[self getSubVideo:i] StartAV];
                }
            }
            //更新声音状态
            [self updateSound];
        }
    }
    [self updatePlayBar];
}

/*
 * 判断播放按钮的状态
 */
- (void)updatePlayBar {
    [delegate updatePlayBar];
}

/*
 * 获取是否当前的画面模式处理播放状态
 */
- (BOOL)isViewing
{
    if ([self isOneVideoMode])
    {
        return [[self getSubVideo:activeIndex] isViewing];
    }
    else
    {
        if (selDevice != nil )
        {
            int begIndex = arrange.m_nPageIndex * (arrange.m_arrangeTypeNew * arrange.m_arrangeTypeNew);
            int totalCount = begIndex + [self getShowVideoCount];
            BOOL allViewing = YES;
            for (int i = begIndex; i < totalCount && i < selDevice.chnCount; ++ i)
            {
                if (! [[self getSubVideo:i] isViewing])
                {
                    allViewing = NO;
                }
            }
            return allViewing;
        }
        else
        {
            return false;
        }
    }
}

/*
 * 获取是否当前的画面模式处理Record状态
 */
- (BOOL)isRecording {
//    if ([self isOneVideoMode]) {
//        return [[self getSubVideo:activeIndex] isRecording];
//    } else {
////        if (devIdno.length > 0) {
//        if (selDevice != nil) {
//            int begIndex = arrange.m_nPageIndex;
//            int totalCount = begIndex + [self getShowVideoCount];
//            BOOL allRecording = YES;
//            for (int i = begIndex; i < totalCount && i < selDevice.chnCount; ++ i) {
//                if (![[self getSubVideo:i] isRecording]) {
//                    allRecording = NO;
//                }
//            }
//            return allRecording;
//        } else {
//            return false;
//        }
//    }
    return NO;
}

/*
 * 判断是否正在播放声音
 */
- (BOOL)isSounding {
    return isSounding;
}

/*
 * 判断是否正在对讲
 */
- (BOOL)isTalkback {
    //return (mTalkback != nil) && [mTalkback isTalkback];
    return FALSE;
}

/*
 * 抓拍图片
 */
- (void)capturePng:(NSString *)filePath {
    BOOL ret = NO;
    if ([[self getSubVideo:activeIndex] isViewing]) {
        ret = [[self getSubVideo:activeIndex] savePngFile:filePath];
    }

}

/*
 * 判断是否正在预览
 */
- (BOOL)isFocusViewing {
    return [[self getSubVideo:activeIndex] isViewing];
}

/*
 * 云台控制
 */
- (void)ptzControl:(int)command speed:(int )nSpeed param:(int)nParam {
    [[self getSubVideo:activeIndex] ptzControl:command speed:nSpeed param:nParam];
}

/*
 * 判断录像权限
 */
- (BOOL)checkRecordPrivi {

    return YES;
}

/*
 * 判断声音权限
 */
- (BOOL)checkSoundPrivi {

    return YES;
}

/*
 * 视频预览
 */
- (void)record {

}

/*
 * 声音控制
 */
- (void)sound
{
    if (!isSounding) {
        //判断焦点画面是否正在播放声音
        if ([[self getSubVideo:activeIndex] isViewing]) {
                for (int i = 0; i < self.channelCount; ++ i) {
                    [[self getSubVideo:i] stopSound];
                }
                
//                [self stopTalkback];
            
                [[self getSubVideo:activeIndex] playSound];
                isSounding = YES;
                [self updatePlayBar];
            
        }
    } else {
        [self stopSound];
    }
}

/*
 * 停止声音
 */
- (void)stopSound
{
//    if (selDevice != nil ) {
        for (int i = 0; i < self.channelCount; ++ i) {
            [[self getSubVideo:activeIndex] stopSound];
        }
//    }
    
    isSounding = NO;
    [self updatePlayBar];
}

/*
 * 更新声音状态
 */
- (void)updateSound
{
    
    if (isSounding && [[self getSubVideo:activeIndex] isViewing]) {
        if (![[self getSubVideo:activeIndex] isSounding]) {
            //关闭其它通道的声音预览
            if (selDevice != nil ) {
                for (int i = 0; i < self.channelCount; ++ i) {
                    if (i != activeIndex) {
                        [[self getSubVideo:i] stopSound];
                    }
                }
            
                //打开焦点画面的声音预览
                [[self getSubVideo:activeIndex] playSound];
            }
        } 
    }
}

/*
 * 双向对讲
 */
- (void)talkback
{

}

- (void)stopTalkback {

}

// ------- @protocol HDArrangeDelegate
- (void)onArrangeChange
{
    [self updatePlayBar];
}

@end
