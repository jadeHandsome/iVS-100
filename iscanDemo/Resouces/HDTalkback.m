//
//
#import "HDTalkback.h"
//#import <zeromq-ios/zmq.h>
#import "zmq.h"

//
@implementation HDTalkback


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lock=[[NSLock alloc] init];
    }
    return self;
}
-(void)GetError:(ASIHTTPRequest *) requst{
    
}
-(void)GetResult:(ASIHTTPRequest *) requst{
    NSData *resData = [requst responseData];
    NSDictionary *data = [[CJSONDeserializer deserializer] deserializeAsDictionary:resData error:nil];
    if ([@"0" isEqual:[data objectForKey:@"errorCode"]]) {
        ip1=[data objectForKey:@"fepIp"];
        port1=[data objectForKey:@"fepPort"];
        ip2=[data objectForKey:@"svrIp"];
        port2=[data objectForKey:@"svrPort"];
        
        self.videoId=[data objectForKey:@"videoId"];
        
        
        [self openZMQ:ip2 port:port2];
        
//        ijkffcoder=[[IJKFFCoder alloc] init];
//        [ijkffcoder initcode];
        [self startTalkback];
    }
    else
    {
        mTalkbackHandle = 0;
        [self.audioStartOrEnd setTitle:NSLocalizedString(@"open_talk", nil) forState:UIControlStateNormal];
        self.hudImg.hidden=YES;
        
    }
//    [self.view hideHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.audioStartOrEnd.enabled=YES;
    });
}
-(void)getchannel:(NSString *)hostUrl
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *nettype=[userDefault valueForKey:@"nettype"];
    NSString *subUrl = [NSString stringWithFormat:@"term/getiScanRes.dcw" ];
    NSString *url = [NSString stringWithFormat:hostUrl, subUrl];
    NSURL *dataUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:dataUrl];
    [request setPostValue:self.termSn forKey:@"termSn"];
    [request setPostValue:[NSString stringWithFormat:@"%d",([nettype intValue]+1)] forKey:@"ip_type"];
    [request setPostValue:@"2" forKey:@"type"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult:)];
    [request setDidFailSelector:@selector(GetError:)];
//    [self.view showHUD];
    
}



-(BOOL)openZMQ:(NSString*)ip port:(NSString*)port
{
    
    context=zmq_init(1);
    requester=zmq_socket(context, ZMQ_DEALER);
    const char* url=[[NSString stringWithFormat:@"tcp://%@:%@",ip,port] UTF8String];
    zmq_connect(requester, url);
    
    NSString* data = [NSString stringWithFormat:@"cmd=requesttalk.iscan;sn=%@;session=7;content=<?xml version=\"1.0\" encoding=\"UTF-8\"?><cmd name=\"requesttalk.iscan\" handler=\"tran\"><dev><id>%@</id><channel>-1</channel></dev><talk_id>%@</talk_id><fep> <ip>%@</ip><port>%@</port></fep></cmd>",self.termSn,self.termSn,self.videoId,ip1,port1 ];
    const char* cmd=[data UTF8String];
    int len=strlen(cmd);
    zmq_send(requester, cmd, len, 1);
    
    isZmqLive=true;
    [NSThread detachNewThreadSelector:@selector(zmqRevMsg) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(sendHeartBeat) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(checkheart) toTarget:self withObject:nil];

    //[self startTalkback];
    return YES;
}

-(void)zmqRevMsg
{
    
    while (isZmqLive) {
        
        
        char* buf=malloc(sizeof(char)*1024);
        int len = 0;
        [self.lock lock];
        len=zmq_recv(requester, buf, 1024, 1);
        [self.lock unlock];
        if (len>0) {
            
            newHeartbeatTime=[[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] longLongValue];
            
            printf("rev msg info \n %s msg len %d \n",buf,len);
            
            if (strstr(buf, "requesttalk.iscan;")) {
                if (strstr(buf, "<code>0</code>")) {
                    printf("============request talk success!================");
                }
                else
                {
                    [self stopTalkback];
                    printf("============request talk failed!================");
                }
            }
            else if (strstr(buf, "talkdata.iscan;"))
            {
//                printf("rev msg info \n %s msg len %d \n",buf,len);
                
                unsigned char* data=malloc(sizeof(char)*164);
                memcpy(data, buf+(len-164), 164);
                [mAudioPlay hd_input_data:data bufferlen:164];
                free(data);

            }
            else
            {
                
            }
            
        }
        else{
            [NSThread sleepForTimeInterval:0.01];
        }
        free(buf);
        
    }
}

-(void)sendHeartBeat
{
    if (isZmqLive) {
        //发送心跳
        NSString* heartbeat = @"cmd=heartbeat;cmdcode=-999;session=7;content=<?xml version=\"1.0\" encoding=\"UTF-8\"?><cmd name=\"heartbeat\" ></cmd>";
        const char* data=[heartbeat UTF8String];
        int len=strlen(data);
        while (isZmqLive&&requester!=NULL) {
            
            oldHeartbeatTime=newHeartbeatTime;
            
            [self.lock lock];
            zmq_send(requester, data, len, 1);
            [self.lock unlock];
            [NSThread sleepForTimeInterval:5];
        }
    }
}

-(BOOL)closeZMQ
{
    NSString* heartbeat = [NSString stringWithFormat:@"cmd=stoptalk.iscan;cmdcode=-999;session=7;content=<?xml version=\"1.0\" encoding=\"UTF-8\"?><cmd name=\"stoptalk.iscan\" handler=\"tran\"><talk_id>%@</talk_id></cmd>",self.videoId ];
    const char* data=[heartbeat UTF8String];
    int len=strlen(data);
    
    [self.lock lock];
    zmq_send(requester, data, len, 1);
    [self.lock unlock];
    
    isZmqLive=false;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*2), dispatch_get_current_queue(), ^{
//        [lock release];
//    });
    
    zmq_close(requester);
    zmq_term(context);
    
    
    return YES;
}

-(void)checkheart
{
    oldHeartbeatTime=0;
    newHeartbeatTime=0;
    while (isZmqLive) {
        [NSThread sleepForTimeInterval:5];
        if (oldHeartbeatTime==newHeartbeatTime) {
            [NSThread sleepForTimeInterval:3];
            if (oldHeartbeatTime==newHeartbeatTime) {
                [self stopTalkback];
            }
        }
    }
}

- (BOOL)startTalk:(NSString *)baseUrl
{
    [self getchannel:baseUrl];
    return YES;
}

- (BOOL)startTalkback
{
    BOOL ret = NO;
    if (mTalkbackHandle == 0) {
        //NETMEDIA_TBOpenTalkback([devIdno UTF8String], 0, 0, &mTalkbackHandle);
        //NETMEDIA_TBStartTalkback(mTalkbackHandle);
        mTalkbackHandle=1;
        if (mTalkbackHandle != 0) {
//            [NSThread detachNewThreadSelector:@selector(playSound) toTarget:self withObject:nil];
//            [self playSound];
            if ([self startRecord]) {
                ret = YES;
                [NSThread detachNewThreadSelector:@selector(playSound) toTarget:self withObject:nil];
            } else {
                [self stopTalkback];
            }
            
        }
        
    }

    return ret;
}

- (BOOL)stopTalkback
{
    BOOL ret = FALSE;
    if (mTalkbackHandle != 0) {
        
        self.audioStartOrEnd.enabled=NO;
        
        [self closeZMQ];
        [self stopSound];
        [self stopRecord];
//        [NSThread detachNewThreadSelector:@selector(stopRecord) toTarget:self withObject:nil];
        
        
//        if (!isZmqLive&&ijkffcoder!=nil)
//        {
//            [ijkffcoder uninitcode];
//            [ijkffcoder release];
//            ijkffcoder=nil;
//        }
        
        //NETMEDIA_TBStopTalkback(mTalkbackHandle);
        //NETMEDIA_TBCloseTalkback(mTalkbackHandle);
        mTalkbackHandle = 0;
        [self.audioStartOrEnd setTitle:NSLocalizedString(@"open_talk", nil) forState:UIControlStateNormal];
        self.hudImg.hidden=YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.audioStartOrEnd.enabled=YES;
            
        });
        ret = YES;
    }
    
    return ret;
}

- (BOOL)isTalkback
{
    return mTalkbackHandle != 0 ? YES : NO;
}

- (void)playSound
{
    if (mTalkbackHandle != 0) {
//        if (mAudioPlay == nil) {
//            mAudioPlay = [[TTXAudioPlay alloc] init];
//            mAudioPlay.delegate = self;
//            [mAudioPlay playSound];
//        }
        if (mAudioPlay==nil) {
            [NSThread sleepForTimeInterval:3];
            mAudioPlay=[[IJKFFMoviePlayerController alloc] initWithContentURL:NULL withOptions:nil];
            [mAudioPlay hd_open_stream:1];
        }
    }
}

- (void)stopSound
{
//    if (mAudioPlay != nil) {
//        [mAudioPlay stopSound];
//        [mAudioPlay release];
//        mAudioPlay = nil;
//    }
    if (mAudioPlay!=nil) {
        [mAudioPlay hd_close_stream];
        [mAudioPlay shutdown];
        mAudioPlay=nil;
    }
}

/*
 * 开始声音录制
 */
- (BOOL)startRecord {
    BOOL ret = NO;
    if (mTalkbackHandle != 0) {
        [mAudioRecord release];
        mAudioRecord = [[HDAudioRecord alloc] init];
        mAudioRecord.delegate = self;
        ret = [mAudioRecord startRecord];
    }
   
    return ret;
}

/*
 * 停止声音录制
 */
- (void)stopRecord {
    if (mAudioRecord != nil) {
        
        [mAudioRecord stopRecord];
        [mAudioRecord release];
        mAudioRecord = nil;
    }
}

-(void)updateHud:(uint8_t*)data length:(int)len
{
    int v = 0;

    if (data==NULL) {
        return;
    }
    for (int i = 0; i < len; i++) {
        v += data[i] * data[i];
    }

    double dB=-90;
    dB= 20*log10(sqrt((v/(double)len))/32768.0);//分贝
//    NSLog(@"%f   %f",self.hudImg.frame.size.height,(dB));
    
    CGFloat newH=self.hudImgH*90/55.0-self.hudImgH/55.0*(dB+120);
    CGFloat newY=self.hudImgY+(self.hudImgH-newH);
    
    CGRect rect=CGRectMake(self.hudImg.frame.origin.x, newY, self.hudImg.frame.size.width, newH);
    self.hudImg.frame=rect;
    
}


#pragma mark HDAudioRecordDelegate Methods
- (void)recordAudio:(HDAudioRecord *)record inBuffer:(void*)buffer length:(int)len;
{
    //NETMEDIA_TBSendWavData(mTalkbackHandle, buffer, len);
//    [mAudioPlay hd_input_data:buffer bufferlen:len];
    
    if (isZmqLive) {
        
        [self updateHud:buffer length:len];
        
        uint8_t hsHead[4];
        hsHead[0]=0x00;
        hsHead[1]=0x01;
        hsHead[2]=0x50;
        hsHead[3]=0x00;
        
        uint8_t* encodedata=malloc(4096);
        int size=0;
//        size=[ijkffcoder encoder:buffer srclen:len dest:encodedata];
//        printf("encode data len = %d \n",size);
        if (size>0) {
            const char* data = [[NSString stringWithFormat:@"cmd=talkdata.iscan;cmdcode=-999;talk_id=%@;sn=%@;content_type=bin;content_length=%d;content=",self.videoId,self.termSn,(size+4)] UTF8String];
            int dataLen=strlen(data);
            
            uint8_t* buf=malloc(dataLen+size+4);
            
            memcpy(buf, data, dataLen);
            memcpy(buf+dataLen,hsHead , 4);
            memcpy(buf+dataLen+4, encodedata, size);
            
            
            [self.lock lock];
            zmq_send(requester, buf, dataLen+size+4, 1);
            [self.lock unlock];
            free(buf);
        }
        
        free(encodedata);
        
        
//        printf("zmq send data len = %d \n",len);
    }
    
    
}

@end

