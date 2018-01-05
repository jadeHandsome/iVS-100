//
//  iscanMCSdk.m
//  iscanMCSdk
//
//  Created by xsz on 7/3/17.
//  Copyright © 2017 hilook.com. All rights reserved.
//

#import "iscanMCSdk.h"
#import "HDVideoView.h"
#import "HDTalkback.h"
@implementation iscanMCSdk
-(HDTalkback *)initTalkView:(UIView *)parent TalkImg:(UIImageView *)imgTalk TalkBtn:(UIButton *)talkBtn TermSn:(NSString *)terSn{
    HDTalkback *mTalkback = [[HDTalkback alloc] init];
    mTalkback.view=parent;
    mTalkback.termSn=terSn;
    mTalkback.hudImg= imgTalk;
    mTalkback.hudImgH=imgTalk.frame.size.height;
    mTalkback.hudImgY=imgTalk.frame.origin.y;
    mTalkback.audioStartOrEnd= talkBtn;
    return mTalkback;
}
-(void)startTalk:(HDTalkback *)talkView BaseUrl:(NSString *)baseUrl{
    if(talkView){
        [talkView startTalk:baseUrl];
    }
}
-(void)stopTalk:(HDTalkback *)talkView{
    if(talkView){
        [talkView stopTalkback];
    }
}
-(BOOL)isTalking:(HDTalkback *)talkView{
    BOOL res = false;
    if(talkView){
        res = [talkView isTalkback];
    }
    return res;
}

- (NSString*)getFileName:(NSString*)folder extend:(NSString*)extendName
{
    //文件名:日期时间+车辆编号+通道号
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    
    NSString* filename = [ NSString stringWithFormat:@"%@/%@.%@", folder, strDateTime, extendName ];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* documentsDir = [ paths objectAtIndex: 0 ];
    
    //创建子目录
    NSString* subDir = [ documentsDir stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@", folder ] ];
    [[NSFileManager defaultManager] createDirectoryAtPath: subDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString  *filePath = [documentsDir stringByAppendingPathComponent:filename ];
    return filePath;
}
-(void)startVideo:(HDVideoView *)videoView{
    if (![videoView.subViewArray[videoView.activeIndex] isViewing])
    {
        [videoView.subViewArray[videoView.activeIndex] StartAV];
    }
}
-(void)stopVideo:(HDVideoView *)videoView{
    if ([videoView.subViewArray[videoView.activeIndex] isViewing])
    {
        [videoView.subViewArray[videoView.activeIndex] StopAV:YES];
    }
}
-(BOOL)isVideoPlaying:(HDVideoView *)videoView{
    return [videoView.subViewArray[videoView.activeIndex] isViewing];
}
-(void)snapPicture:(HDVideoView *)videoView FilePath:(NSString *)path{
    [videoView capturePng:path];
}

-(BOOL)isAudioOpen:(HDVideoView *)videoView{
    return [videoView.subViewArray[videoView.activeIndex] isSounding];
}
-(void)closeAudio:(HDVideoView *)videoView{
    [videoView stopSound];
}
-(void)openAudio:(HDVideoView *)videoView{
    if(![videoView isSounding]){
        [videoView sound];
    }
}
-(void)switchAudio:(HDVideoView *)videoView{
    [videoView sound];
}
-(HDVideoView *)createVideoViewWithDelegate:(id)delegate{
    HDVideoView *videoView = [[ HDVideoView alloc ]init ];
    videoView.view.backgroundColor = [ UIColor blackColor ];
    videoView.delegate = delegate;
    return videoView;
}

-(ASIHTTPRequest *)sendCaptureCmd:(NSString *)hostUrl TermSn:(NSString *)termSN Channel:(NSString *)chan Number:(NSString *)num Interval:(NSString *)intv  Target:(id)target Success:(SEL)suc Failure:(SEL)fail{
    NSString *subUrl = [NSString stringWithFormat:@"term/snapshot.dcw" ];
    NSString *url = [NSString stringWithFormat:hostUrl, subUrl];
    NSURL *dataUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:dataUrl];
    [request setPostValue:termSN forKey:@"termSn"];
    [request setPostValue:chan forKey:@"channel"];
    if(num != nil){
        [request setPostValue:num forKey:@"numbers"];
    }
    
    [request setPostValue:intv forKey:@"interval"];
    [request setDelegate:target];
    [request setDidFinishSelector:suc];
    [request setDidFailSelector:fail];
    return request;
}

-(ASIHTTPRequest *)findCaptureImgList:(NSString *)hostUrl Vid:(NSString *)vid StartTime:(NSString *)start EndTime:(NSString *)end  page:(NSInteger)page  Target:(id)target Success:(SEL)suc Failure:(SEL)fail{
    NSString *subUrl = [NSString stringWithFormat:@"pic/findImgInfoList.dcw" ];
    NSString *url = [NSString stringWithFormat:hostUrl, subUrl];
    NSURL *dataUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:dataUrl];
    [request setPostValue:vid forKey:@"id"];
    [request setPostValue:vid forKey:@"startTime"];
    if(end != nil){
         [request setPostValue:end forKey:@"endTime"];
    }
   
    [request setPostValue:@"50" forKey:@"rows"];
    [request setPostValue:@(page) forKey:@"page"];
    [request setDelegate:target];
    [request setDidFinishSelector:suc];
    [request setDidFailSelector:fail];
    return request;
}
-(ASIHTTPRequest *)getCarLocation:(NSString *)hostUrl Vid:(NSString *)vid  Target:(id)target Success:(SEL)suc Failure:(SEL)fail{
    NSString *subUrl = [NSString stringWithFormat:@"busmanager/getEndPosByVid.dcw" ];
    NSString *url = [NSString stringWithFormat:hostUrl, subUrl];
    NSURL *dataUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:dataUrl];
    [request setPostValue:vid forKey:@"vid"];
    [request setDelegate:target];
    [request setDidFinishSelector:suc];
    [request setDidFailSelector:fail];
    return request;
}
-(ASIHTTPRequest *)pizControlCmd:(NSString *)hostUrl TermSn:(NSString *)termSN Channel:(NSString *)channel Command:(NSString *)cmd Target:(id)target Success:(SEL)suc Failure:(SEL)fail{
    NSString *subUrl = [NSString stringWithFormat:@"term/ptzControl.dcw" ];
    NSString *url = [NSString stringWithFormat:hostUrl, subUrl];
    NSURL *dataUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:dataUrl];
    [request setPostValue:termSN forKey:@"termSn"];
    [request setPostValue:channel forKey:@"channel"];
    [request setPostValue:cmd forKey:@"cmd"];
    [request setDelegate:target];
    [request setDidFinishSelector:suc];
    [request setDidFailSelector:fail];
    return request;
}
-(ASIHTTPRequest *)getCarChannelsForTalk:(NSString *)hostUrl TermSn:(NSString *)termSN NetType:(NSString *)netType Target:(id)target Success:(SEL)suc Failure:(SEL)fail{
    NSString *subUrl = [NSString stringWithFormat:@"term/getiScanRes.dcw" ];
    NSString *url = [NSString stringWithFormat:hostUrl, subUrl];
    NSURL *dataUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:dataUrl];
    [request setPostValue:termSN forKey:@"termSn"];
    [request setPostValue:netType forKey:@"ipType"];
    [request setPostValue:@"2" forKey:@"type"];
    [request setDelegate:target];
    [request setDidFinishSelector:suc];
    [request setDidFailSelector:fail];
    return request;
}
-(ASIHTTPRequest *)getCarChannels:(NSString *)hostUrl TermSn:(NSString *)termSN NetType:(NSString *)netType Target:(id)target Success:(SEL)suc Failure:(SEL)fail{
    NSString *subUrl = [NSString stringWithFormat:@"term/getiScanRes.dcw" ];
    NSString *url = [NSString stringWithFormat:hostUrl, subUrl];
    NSURL *dataUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:dataUrl];
    [request setPostValue:termSN forKey:@"termSn"];
    [request setPostValue:netType forKey:@"ipType"];
    [request setPostValue:@"1" forKey:@"transType"];
    [request setPostValue:@"1" forKey:@"type"];
    [request setDelegate:target];
    [request setDidFinishSelector:suc];
    [request setDidFailSelector:fail];
    return request;
}
-(ASIHTTPRequest *)getCarList:(NSString *)hostUrl OrgId:(NSString *)orgId Target:(id)target Success:(SEL)suc Failure:(SEL)fail{
    NSString *subUrl = [NSString stringWithFormat:@"vehicle/findVehicleViewList.dcw" ];
    NSString *url = [NSString stringWithFormat:hostUrl, subUrl];
    NSURL *dataUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:dataUrl];
    [request setPostValue:orgId forKey:@"departIds"];
    [request setPostValue:@"20000" forKey:@"rows"];
    [request setPostValue:@"1" forKey:@"page"];
    [request setDelegate:target];
    [request setDidFinishSelector:suc];
    [request setDidFailSelector:fail];
    return request;
}
-(ASIHTTPRequest *)getCarListWithCall:(NSString *)hostUrl OrgId:(NSString *)orgId Target:(id)target Success:(void (^)(ASIHTTPRequest *))argBlock{
    NSString *subUrl = [NSString stringWithFormat:@"vehicle/findVehicleViewList.dcw" ];
    NSString *url = [NSString stringWithFormat:hostUrl, subUrl];
    NSURL *dataUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:dataUrl];
    [request setPostValue:orgId forKey:@"departIds"];
    [request setPostValue:@"20000" forKey:@"rows"];
    [request setPostValue:@"1" forKey:@"page"];
    [request setDelegate:target];
    [request setDidFinishSelector:@selector(argBlock)];
    return request;
}
-(ASIHTTPRequest *)getOrganization:(NSString *)hostUrl Recur:(NSString *)recFlag Target:(id)target Success:(SEL)suc Failure:(SEL)fail{
    NSString *subUrl = [NSString stringWithFormat:@"organization/findOrgSimpleTree.dcw" ];
    NSString *url = [NSString stringWithFormat:hostUrl, subUrl];
    NSURL *dataUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:dataUrl];
    [request setPostValue:recFlag forKey:@"isRecursion"];
    [request setDelegate:target];
    [request setDidFinishSelector:suc];
    [request setDidFailSelector:fail];
    return request;
}
-(ASIHTTPRequest *)loginSystem:(NSString *)hostUrl UserName:(NSString *)name UserPass:(NSString *)pass Target:(id)target Success:(SEL)suc Failure:(SEL)fail{
    NSString *subUrl = [NSString stringWithFormat:@"loginReturnJson.dcw" ];
    NSString *url = [NSString stringWithFormat:hostUrl, subUrl];
    NSURL *dataUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:dataUrl];
    [request setPostValue:name forKey:@"name"];
    [request setPostValue:pass forKey:@"pwd"];
    [request setDelegate:target];
    [request setDidFinishSelector:suc];
    [request setDidFailSelector:fail];
    return request;
}

-(SettingBean *)getSettingInfo
{
    SettingBean *bean = [SettingBean new];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *ip=[userDefault valueForKey:@"ip"];
    NSString *port=[userDefault valueForKey:@"port"];
    NSString *nettype=[userDefault valueForKey:@"nettype"];
    NSString *capaturecount=[userDefault valueForKey:@"capaturecount"];
    NSString *capaturedelay=[userDefault valueForKey:@"capaturedelay"];
    bean.ip = ip;
    bean.port = port;
    bean.numbers = capaturecount;
    bean.interval = capaturedelay;
    bean.nettype = nettype;
    return bean;
}
-(void)setSettingInfoIp:(NSString *)ip Port:(NSString *)port Number:(NSString *)num Interval:(NSString *)intv NetType:(NSString *)netType
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setValue:ip forKey:@"ip"];
    [userDefault setValue:port forKey:@"port"];
    
    [userDefault setObject:netType forKey:@"nettype"];
    [userDefault setValue:num forKey:@"capaturecount"];
    [userDefault setValue:intv forKey:@"capaturedelay"];
    [userDefault synchronize];
}

@end
