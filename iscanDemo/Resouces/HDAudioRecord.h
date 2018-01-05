#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "HDAudioPlay.h"

@class HDAudioRecord;
@protocol HDAudioRecordDelegate <NSObject>
- (void)recordAudio:(HDAudioRecord *)record inBuffer:(void*)buffer length:(int)len;
@end

@interface HDAudioRecord : NSObject
{
    AudioQueueRef d_audio_recording;
    AudioQueueBufferRef d_audio_recording_buffers[AUDIO_PLAY_BUFFERS_NUMBER];
    BOOL isRecording;
}
@property(nonatomic, assign) id<HDAudioRecordDelegate> delegate;
- (BOOL) startRecord;
- (BOOL) stopRecord;
@end
