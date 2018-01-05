//
//  iscanMCSdk.h
//  iscanMCSdk
//
//  Created by xsz on 7/3/17.
//  Copyright © 2017 hilook.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "SettingBean.h"
#import "ASIFormDataRequest.h"
@class HDVideoView;
@class HDTalkback;
@interface iscanMCSdk : NSObject

-(void)startTalk:(HDTalkback *)talkView BaseUrl:(NSString *)baseUrl;
-(void)stopTalk:(HDTalkback *)talkView;
-(BOOL)isTalking:(HDTalkback *)talkView;
-(HDTalkback *)initTalkView:(UIView *)parent TalkImg:(UIImageView *)imgTalk TalkBtn:(UIButton *)talkBtn TermSn:(NSString *)terSn;

- (NSString*)getFileName:(NSString*)folder extend:(NSString*)extendName;
-(void)stopVideo:(HDVideoView *)videoView;
-(void)startVideo:(HDVideoView *)videoView;
-(void)closeAudio:(HDVideoView *)videoView;
-(void)openAudio:(HDVideoView *)videoView;
-(void)switchAudio:(HDVideoView *)videoView;
-(BOOL)isAudioOpen:(HDVideoView *)videoView;
-(void)snapPicture:(HDVideoView *)videoView FilePath:(NSString *)path;
-(BOOL)isVideoPlaying:(HDVideoView *)videoView;

-(HDVideoView *)createVideoViewWithDelegate:(id)delegate;

-(SettingBean *)getSettingInfo;
-(void)setSettingInfoIp:(NSString *)ip Port:(NSString *)port Number:(NSString *)num Interval:(NSString *)intv NetType:(NSString *)netType;
-(ASIHTTPRequest *)loginSystem:(NSString *)hostUrl UserName:(NSString *)name UserPass:(NSString *)pass Target:(id)target Success:(SEL)suc Failure:(SEL)fail;
-(ASIHTTPRequest *)getOrganization:(NSString *)hostUrl Recur:(NSString *)recFlag Target:(id)target Success:(SEL)suc Failure:(SEL)fail;
-(ASIHTTPRequest *)getCarList:(NSString *)hostUrl OrgId:(NSString *)orgId Target:(id)target Success:(SEL)suc Failure:(SEL)fail;
-(ASIHTTPRequest *)getCarChannels:(NSString *)hostUrl TermSn:(NSString *)termSN NetType:(NSString *)netType Target:(id)target Success:(SEL)suc Failure:(SEL)fail;
-(ASIHTTPRequest *)getCarChannelsForTalk:(NSString *)hostUrl TermSn:(NSString *)termSN NetType:(NSString *)netType Target:(id)target Success:(SEL)suc Failure:(SEL)fail;
-(ASIHTTPRequest *)pizControlCmd:(NSString *)hostUrl TermSn:(NSString *)termSN Channel:(NSString *)channel Command:(NSString *)cmd Target:(id)target Success:(SEL)suc Failure:(SEL)fail;
-(ASIHTTPRequest *)getCarLocation:(NSString *)hostUrl Vid:(NSString *)vid  Target:(id)target Success:(SEL)suc Failure:(SEL)fail;
-(ASIHTTPRequest *)findCaptureImgList:(NSString *)hostUrl Vid:(NSString *)vid StartTime:(NSString *)start EndTime:(NSString *)end  page:(NSInteger)page Target:(id)target Success:(SEL)suc Failure:(SEL)fail;
-(ASIHTTPRequest *)sendCaptureCmd:(NSString *)hostUrl TermSn:(NSString *)termSN Channel:(NSString *)chan Number:(NSString *)num Interval:(NSString *)intv  Target:(id)target Success:(SEL)suc Failure:(SEL)fail;
-(ASIHTTPRequest *)getCarListWithCall:(NSString *)hostUrl OrgId:(NSString *)orgId Target:(id)target Success:(void (^)(ASIHTTPRequest *))argBlock;
@end
