

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class HDAudioPlay;
@protocol HDAudioPlayDelegate <NSObject>
- (int)playAudio:(HDAudioPlay *)realplay inBuffer:(void*)buffer length:(int)len;
@end

#define AUDIO_BUFFER_SIZE                               640
#define AUDIO_PLAY_BUFFERS_NUMBER						10

@interface HDAudioPlay : NSObject
{
    AudioQueueRef d_audio_play;
    AudioQueueBufferRef d_audio_play_buffers[AUDIO_PLAY_BUFFERS_NUMBER];
    BOOL isAudioPlay;
}
@property(nonatomic, assign) id<HDAudioPlayDelegate> delegate;
- (BOOL) playSound;
- (BOOL) stopSound;
@end
