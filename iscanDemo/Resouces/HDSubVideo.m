//
//  HDSubVideo.h
//  iScanMC
//
//  Created by xsz on 21/8/14
//  Copyright (c) 2014年 hongdian. All rights reserved.
//

#import "HDSubVideo.h"
#import "HDVideoView.h"
typedef enum HDFilmMode: NSUInteger
{
    E_FilmMode_Original     = 0,
    E_FilmMode_Full         = 1,
    E_FilmMode_16_9         = 2,
    E_FilmMode_4_3          = 3
}E_FilmMode;

@interface HDSubVideo ()
-(void)createCtrl;
-(void)setCtrlPos;
- (void)addRoundedRectToPath: (CGContextRef)context rc: (CGRect )rect width:(float )ovalWidth height:( float )ovalHeight;
-(CGRect)getFilmRect:(CGRect)rcArea mode:(E_FilmMode)mode;
-(UIImage *)formatImage:(int)width height:(int)height;
-(void)updateTitle;
@end

@implementation HDSubVideo
@synthesize isFocus;
@synthesize labelChannel;
@synthesize imageViewVideo;
@synthesize channel;
@synthesize viewIndex;

- (id)init
{
    loadState = MPMovieLoadStateUnknown;
    playState = MPMoviePlaybackStateStopped;
    labelChannel = nil;
    indicatorView = nil;
    self.player = nil;
    return [super init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createCtrl ];
    }
    return self;
}

-(void)dealloc
{
    labelChannel = nil;
    if (self.player != nil) {
        [self.player shutdown];
        [self removeVideoNotificationObservers];
        self.player = nil;
    }
    
    
    loadState = MPMovieLoadStateUnknown;
    playState = MPMoviePlaybackStateStopped;
    indicatorView = nil;
    [super dealloc ];
}

-(void)setFrame:(CGRect)theFrame
{
    [super setFrame:theFrame ];
    [self setCtrlPos ];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code.
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 2.0);
    
    float red = isFocus ? 27/255.0: 0/255.0;
    float green = isFocus ? 149/255.0: 0/255.0;
    float blue = isFocus ? 248/255.0: 0/255.0;
    
    //设置颜色
    CGContextSetRGBStrokeColor(context, red, green, blue, 1.0);
    //开始一个起始路径
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 5);
    //画矩形
    //CGContextAddRect( context, rect );
    [self addRoundedRectToPath: context rc:rect width:0 height:0 ];
    //连接上面定义的坐标点
    CGContextStrokePath(context);
    //CGContextClosePath( context );
}

//画圆角矩形
- (void)addRoundedRectToPath: (CGContextRef)context rc: (CGRect )rect width:(float )ovalWidth height:( float )ovalHeight
{
    
    if ( 0 == ovalWidth || 0 == ovalHeight )
    {
        
        CGContextAddRect(context, rect);
        return;
    }
    float fw = 0.0;
    float fh = 0.0;
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    //CGContextClosePath(context);
    CGContextRestoreGState(context);
    
    CGContextMoveToPoint(context, rect.origin.x + rect.size.width , rect.origin.y + ovalHeight );
    CGContextAddLineToPoint( context, rect.origin.x + rect.size.width ,  rect.origin.y + rect.size.height - ovalHeight );
}

- (void)createCtrl
{
    isFocus = NO;
    
    [self setBackgroundColor:[ UIColor blackColor ]];
    
    imageViewVideo = [[ UIImageView alloc ]init ];
    imageViewVideo.image = [UIImage imageNamed:@"播放"];
    [self addSubview: imageViewVideo ];
    
    imageViewVideo.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playiconClick:)] autorelease];
    [imageViewVideo addGestureRecognizer:tap];
    
    UIFont* font = [ UIFont fontWithName:@"Arial" size:12 ];
    labelChannel = [[ UILabel alloc] init ];
    [labelChannel setTextAlignment:NSTextAlignmentLeft ];
    [labelChannel setTextColor: [ UIColor whiteColor] ];
    [labelChannel setBackgroundColor:[ UIColor clearColor ] ];
    [labelChannel setFont: font ];
    [self addSubview:labelChannel ];
    
    
    tipLabel = [[UILabel alloc]init ];
    [tipLabel setTextAlignment:NSTextAlignmentCenter ];
    [tipLabel setTextColor:[ UIColor whiteColor ] ];
    [tipLabel setBackgroundColor:[ UIColor clearColor ] ];
    [tipLabel setFont:font ];
    [tipLabel setText: @"loading" ];
    tipLabel.hidden = YES;
    [self addSubview:tipLabel ];
    
    indicatorView = [[ UIActivityIndicatorView alloc ]init ];
    [self addSubview: indicatorView ];
}
//click play btn
-(void)playiconClick:(id)sender
{
    NSLog(@"%@",sender);
    imageViewVideo.hidden=YES;
    [self getchannel:[self viewIndex]];
}
-(void)GetResult:(ASIHTTPRequest *) requst{
    
    NSData *resData = [requst responseData];
    NSString *result = [[NSString alloc] initWithData:resData  encoding:NSUTF8StringEncoding];
    NSDictionary *data = [[CJSONDeserializer deserializer] deserializeAsDictionary:resData error:nil];
    NSLog(@"---------------%@" ,result);
    if ([@"0" isEqual:[data objectForKey:@"errorCode"]]) {
        NSString *ip1=[data objectForKey:@"fepIp"];
        NSString *port1=[data objectForKey:@"fepPort"];
        NSString *ip2=[data objectForKey:@"svrIp"];
        NSString *port2=[data objectForKey:@"svrPort"];
        NSMutableArray *channels=[data objectForKey:@"channelList"];
        if (_curIndex>=[channels count]) {
            imageViewVideo.hidden=NO;
            return;
        }
        
        videoUrl=[NSString stringWithFormat:@"rtsp://%@:%@/%@_%@_%@_%@_%@.iscan",ip2,port2,ip1,port1,self.termSn,[channels[_curIndex] objectForKey:@"channelNo"],[data objectForKey:@"videoId"]];
        
        HDDeviceBase* device = [[HDDeviceBase alloc] init];
        
        device.chnCount = [channels count];
        
        self.videoview.channelCount=[channels count];
        
        [self StartAV];
    }else{
        imageViewVideo.hidden=NO;
        [indicatorView stopAnimating ];
    }
    
    
}
-(void)GetError:(ASIHTTPRequest *) requst{
    imageViewVideo.hidden=NO;
    [indicatorView stopAnimating ];
}
-(void)getchannel:(int)index
{
    _curIndex = index;
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *nettype=[userDefault valueForKey:@"nettype"];
    NSString *subUrl = [NSString stringWithFormat:@"term/getiScanRes.dcw" ];
    NSString *url = [NSString stringWithFormat:_baseUrl, subUrl];
    NSURL *dataUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:dataUrl];
    [request setPostValue:self.termSn forKey:@"termSn"];
    [request setPostValue:[NSString stringWithFormat:@"%d",([nettype intValue]+1)] forKey:@"ipType"];
    [request setPostValue:@"1" forKey:@"transType"];
    [request setPostValue:@"1" forKey:@"type"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult:)];
    [request setDidFailSelector:@selector(GetError:)];
    
    
    imageViewVideo.hidden=YES;
    [indicatorView startAnimating ];
    [request startAsynchronous];
}

-(void)setCtrlPos
{
    CGRect rcClient = self.bounds;
    const int BORDER_WIDTH = 1;
    
    CGRect rcLabel = rcClient;
    rcLabel.origin.x += 2;
    rcLabel.origin.y += 2;
    rcLabel.size.width = rcClient.size.width - 4 ;
    rcLabel.size.height = 20;
    [labelChannel setFrame: rcLabel ];
    
    CGRect rcArea = rcClient;
    rcArea.origin.x += BORDER_WIDTH;
    rcArea.origin.y += BORDER_WIDTH;
    rcArea.size.width -= 2 * BORDER_WIDTH;
    rcArea.size.height -= 2 * BORDER_WIDTH;
    
//    CGRect rcVideo = rcArea;
    rcVideo = rcArea;

    //if( isPad )
    {
        rcVideo = [self getFilmRect:rcArea mode:E_FilmMode_16_9 ];
    }
    imageViewVideo.frame = CGRectMake(rcArea.size.width * 3 / 8, (rcArea.size.height - rcArea.size.width/4)/2, rcArea.size.width/4, rcArea.size.width/4);
    imageViewVideo.contentMode = UIViewContentModeCenter;
    self.player.view.frame = rcVideo;
    
    
    CGRect rcTip = rcClient;
    rcTip.size.height = 20;
    rcTip.origin.y = ( rcClient.size.height - rcTip.size.height ) / 2;
    tipLabel.frame = rcTip;
    
    CGRect rcIndicator;
    int nIndicatorWidth = 24;
    int nIndecatorHeight = 24;
    rcIndicator.origin.x = ( rcClient.size.width -  nIndicatorWidth ) /2;
    rcIndicator.origin.y = rcTip.origin.y;//( rcClient.size.height -  nIndecatorHeight ) /2;
    rcIndicator.size.width = nIndicatorWidth;
    rcIndicator.size.height = nIndecatorHeight;
    indicatorView.frame = rcIndicator;
    indicatorView.center = imageViewVideo.center;
}

-(CGRect)getFilmRect:(CGRect)rcArea mode:(E_FilmMode)mode
{
    if( rcArea.size.width <= 0 || rcArea.size.height <= 0
       || E_FilmMode_Full == mode )
    {
        return rcArea;
    }
    CGRect rcDest = rcArea;
    double fWidth = rcArea.size.width;
    double fHeight = rcArea.size.height;
    double fRateHW = fHeight / fWidth;
    double fRateDest  = fRateHW;
    if( E_FilmMode_16_9 == mode )
    {
        fRateDest = 0.75;//3.0/4.0
    }
    else if( E_FilmMode_4_3 == mode )
    {
        fRateDest = 0.5625;//9.0/16.0
    }
    double fDestWidth = fWidth;
    double fDestHeight = fHeight;
    if( fRateHW > fRateDest )
    {
        fDestHeight = fDestWidth * fRateDest;
    }
    else
    {
        fDestWidth = fDestHeight / fRateDest;
    }
    
    rcDest.size.width = fDestWidth;
    rcDest.size.height = fDestHeight;
    rcDest.origin.x = rcArea.origin.x + ( fWidth - fDestWidth ) / 2;
    rcDest.origin.y = rcArea.origin.y + ( fHeight - fDestHeight ) / 2;
    return rcDest;
}

- (void)reflash
{
    [self setNeedsDisplay];

}

//把AVPicture转成图片
-(UIImage *)formatImage:(int)width height:(int)height
{
    UIImage *image = nil;
    
	return image;
}

- (void)setViewInfo:(NSString*)_devName idno:(NSString*)_devIdno chn:(int)_channel name:(NSString*)_chnName url:(NSString*)_videoUrl
{
    devName = [_devName copy];
    devIdno = [_devIdno copy];
    channel = _channel;
    chnName = [_chnName copy];
    videoUrl = [_videoUrl copy];
    
    [self updateTitle];
}

- (void)startPlayTimer
{
    //video detect
    timerPlay = [NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(onTimerPlay)
                                                 userInfo:nil
                                                  repeats:YES ];
}

- (void)stopPlayTimer
{
    if( timerPlay != nil)
    {
        [timerPlay invalidate ];
        timerPlay = nil;
    }
}

- (void)onTimerPlay
{
    [self updateView];
}

- (BOOL)StartAV {
    //先停止
    [self StopAV:NO];
    BOOL ret = NO;
    
    //启动视频
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:videoUrl] withOptions:nil];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = rcVideo;
    [self addSubview:self.player.view];
    
    
    [self installVideoNotificationObservers];
        
    [self.player prepareToPlay];
    [self.player play];
    
    rePlaydateTime = [[NSDate date]timeIntervalSince1970];
    [indicatorView startAnimating ];
    imageViewVideo.hidden=YES;
//    playState = MPMoviePlaybackStatePlaying;
    loadState = MPMovieLoadStatePlayable;
//    isLoading = true;
    ret = YES;
    [self startPlayTimer];
    
    return ret;
}

- (BOOL)StopAV:(BOOL) bClear {
    BOOL ret = NO;
    
    if (self.player==nil) {
        return ret;
    }
    
    //if ( isLoading ) {
    if ( loadState != MPMovieLoadStateUnknown ) {
        [self stopPlayTimer];
        
        if ( bClear ) {
            self.player.view.frame = CGRectMake(0, 0,0,0);
            [self.player.view removeFromSuperview];

        }
        
        [self.player shutdown];
        [self removeVideoNotificationObservers];
        [self.player release];
        self.player = nil;
        
        
        playState = MPMoviePlaybackStateStopped;
        loadState = MPMovieLoadStateUnknown;
        //isLoading = NO;
        realRate = 0;
        isRecording = NO;
        ret = YES;
        
        if ([indicatorView isAnimating])
        {
            [indicatorView stopAnimating ];
            
        }
        imageViewVideo.hidden=NO;
        
        self.player.view.frame = rcVideo;
        [self reflash];
        
        [self stopSound];
        
        [self updateTitle];
    }
    return ret;
}

/*
 * 判断是否正在预览
 */
- (BOOL)isViewing {
    //return realHandle != 0 ? YES : NO;
    return loadState != MPMovieLoadStateUnknown ? YES : NO;
}

/*
 * 判断是否正在预览
 */
- (void) updateView
{
    if ( [self.player isPlaying] )
    {
        if ([indicatorView isAnimating])
        {
            [indicatorView stopAnimating];
        }
        if ( (loadState & MPMovieLoadStateStalled) != 0 )
        {
            if ( [[NSDate date]timeIntervalSince1970] - rePlaydateTime > 20 )
            {
                [self StartAV];
                rePlaydateTime = [[NSDate date]timeIntervalSince1970];
            }
        }
        else
        {
            rePlaydateTime = [[NSDate date]timeIntervalSince1970];
        }
    }
    else
    {
        if ( [[NSDate date]timeIntervalSince1970] - rePlaydateTime > 20 )
        {
            [self StartAV];
            rePlaydateTime = [[NSDate date]timeIntervalSince1970];
        }
    }
}



+ (NSString*)getFileFolder:(NSString*)folder
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* documentsDir = [ paths objectAtIndex: 0 ];
    //创建子目录
    NSString* subDir = [ documentsDir stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@", folder ] ];
    return subDir;
}



/*
 * 保存成BMP图片
 */
- (BOOL)savePngFile:(NSString *)imagePath {
  
    if ( self.player != nil )
    {
        
        [self.player snapshot:imagePath];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIImage* image= [[UIImage alloc] initWithContentsOfFile:imagePath];
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
            [image release];
        });
        return YES;
    }

    return NO;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{

}

/*
 * 云台控制
 */
int stopCMD=0;
- (void)ptzControl:(int)command speed:(int )nSpeed param:(int)nParam
{
//    NETMEDIA_RPlayPtzCtrl(realHandle, command, nSpeed, nParam);
    int cmd=command/100;
    int cmdstop=command%100;
    if (cmdstop!=0) {
        stopCMD=cmdstop;
    }
    
    if (nParam==0) {
        if (cmdstop==0) {
            [self pizContralCMD:stopCMD];
        }
        
    }
    else
    {
        [self pizContralCMD:cmd];
    }
    
}
-(void)GetPizResult:(ASIHTTPRequest *) requst{
    //[self.view showHUDWithText:@"拍照命令已发送，请稍后刷新。" hideDelayed:1];
    NSData *data = [requst responseData];
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    NSLog(@"%@--------------",result);
    
    
}
-(void)GetPizError:(ASIHTTPRequest *) requst{
   
}
-(void)pizContralCMD:(NSInteger)cmd
{
    ASIHTTPRequest *request = [SharedSDK pizControlCmd:SharedUserInfo.baseUrl TermSn:self.termSn Channel:self.channel Command:[NSString stringWithFormat:@"%ld",cmd] Target:self Success:@selector(GetPizResult:) Failure:@selector(GetPizError:)];
    [request startAsynchronous];
}

/*
 * 判断是否正在预览
 */
- (BOOL)isRecording {
    return isRecording;
}

/*
 * 启动或停止录像
 */
- (void)record
{
//    if (realHandle != 0) {
//        if (!isRecording) {
//            NETMEDIA_StartRecord(realHandle, "", [devName UTF8String]);
//        } else {
//            NETMEDIA_StopRecord(realHandle);
//        }
//        isRecording = !isRecording;
//    }
}

- (void)updateTitle
{
    if (isRecording)
    {
        if (chnName != nil && [chnName length] > 0)
        {
            labelChannel.text = [NSString stringWithFormat:@"%@ - %@ - REC", devName, chnName];
        }
        else
        {
            labelChannel.text = [NSString stringWithFormat:@"%@ - REC", devName];
        }
    }
    else
    {
        if ((devName != nil && devName.length > 0) || (chnName != nil && [chnName length] > 0))
        {
            if (chnName != nil && [chnName length] > 0)
            {
                labelChannel.text = [NSString stringWithFormat:@"%@ - %@", devName, chnName];
            }
            else
            {
                labelChannel.text = [NSString stringWithFormat:@"%@", devName];
            }
        }
        else
        {
            labelChannel.text = [NSString stringWithFormat:@"CH %@", self.channel];
        }
    }
}

/*
 * 启动录像
 */
- (BOOL)startRecord
{
//    if (realHandle != 0) {
//        if (!isRecording) {
//            NSString* recordPath = [HDSubVideo getFileFolder:@"record"];
//            NETMEDIA_StartRecord(realHandle, [recordPath UTF8String], [devName UTF8String]);
//            isRecording = YES;
//            [self updateTitle];
//        }
//    }
    return isRecording;
}

/*
 * 停止录像
 */
- (BOOL)stopRecord
{
    BOOL ret = NO;
//    if (realHandle != 0) {
//        if (isRecording) {
//            NETMEDIA_StopRecord(realHandle);
//            isRecording = NO;
//            ret = YES;
//            [self updateTitle];
//        }
//    }
    return ret;
}

/*
 * 开始声音播放
 */
- (void)playSound
{
    if ( self.player != nil )
    {
        [self.player playsound:YES];
        self.isSound=YES;
    }
}

/*
 * 停止声音播放
 */
- (void)stopSound
{
    if ( self.player != nil )
    {
        [self.player playsound:NO];
        self.isSound=NO;
    }
}

- (BOOL)isSounding
{
//    return mAudioPlay != nil ? YES : NO;
    return self.isSound;
}

#pragma mark HDAudioPlayDelegate Methods
//- (int)playAudio:(HDAudioPlay *)realplay inBuffer:(void*)buffer length:(int)len
//{
//    int nReadLen = len;
//    NETMEDIA_GetWavData(realHandle, buffer, &nReadLen);
//    //NSLog(@"NETMEDIA_TBGetWavData len:%d, nReadLen:%d", len, nReadLen);
//    return nReadLen;
//}


#pragma mark Video Notifications

- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    loadState = _player.loadState;
    
    if ((loadState & MPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: MPMovieLoadStatePlaythroughOK: %d\n", loadState);
    } else if ((loadState & MPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: MPMovieLoadStateStalled: %d\n", loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", loadState);
    }
}

- (void)videoPlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    
    playState = MPMoviePlaybackStateStopped;
    int reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: MPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case MPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: MPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: MPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)videoPlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    playState = _player.playbackState;
    
    switch (_player.playbackState)
    {
        case MPMoviePlaybackStateStopped: {
            NSLog(@"moviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case MPMoviePlaybackStatePlaying: {
            NSLog(@"moviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case MPMoviePlaybackStatePaused: {
            NSLog(@"moviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case MPMoviePlaybackStateInterrupted: {
            NSLog(@"moviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case MPMoviePlaybackStateSeekingForward:
        case MPMoviePlaybackStateSeekingBackward: {
            NSLog(@"moviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"moviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}


#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installVideoNotificationObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoPlayBackDidFinish:)
                                                 name:IJKMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoPlayBackStateDidChange:)
                                                 name:IJKMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeVideoNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMoviePlayerPlaybackStateDidChangeNotification object:_player];
}

@end
