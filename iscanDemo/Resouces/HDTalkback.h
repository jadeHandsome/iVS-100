

#import <Foundation/Foundation.h>
#import "HDAudioPlay.h"
#import "HDAudioRecord.h"
#import "IJKFFMoviePlayerController.h"
//#import <IJKMediaFramework/IJKFFMoviePlayerController.h>
#include "IJKFFCodec.h"
//#import <IJKMediaFramework/IJKFFOptions.h>
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"

@interface HDTalkback : NSObject<HDAudioPlayDelegate, HDAudioRecordDelegate,ASIHTTPRequestDelegate>
{
    long mTalkbackHandle;
    //TTXAudioPlay* mAudioPlay;
    IJKFFMoviePlayerController* mAudioPlay;
    HDAudioRecord* mAudioRecord;
    
    void* context;
    void* requester;
    bool isZmqLive;
    
    NSString* ip1;
    NSString* port1;
    NSString* ip2;
    NSString* port2;
    
    IJKFFCoder* ijkffcoder;
    
    long long oldHeartbeatTime;
	long long newHeartbeatTime;
    
}

@property(nonatomic,retain) UIView* view;

@property(nonatomic,retain) UIButton* audioStartOrEnd;
@property(nonatomic,retain) NSString* videoId;
@property(nonatomic,retain)     NSLock* lock;
@property(nonatomic,retain) NSString* termSn;
@property(nonatomic,retain) UIImageView* hudImg;
@property(nonatomic,assign) int hudImgH;
@property(nonatomic,assign) int hudImgY;
- (BOOL)startTalkback;
- (BOOL)stopTalkback;
- (void)playSound;
- (void)stopSound;
- (BOOL)isTalkback;
- (BOOL)startTalk:(NSString *)baseUrl;
@end
