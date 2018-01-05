#import "HDAudioPlay.h"

@implementation HDAudioPlay

- (void) dealloc
{
    [super dealloc];
}

static void HowardAudioQueueOutputCallback ( void *                  inUserData,
                                            AudioQueueRef           inAQ,
                                            AudioQueueBufferRef     inBuffer) {
    HDAudioPlay *audioPlay = inUserData;
    int nFillLength = 0;
    if (audioPlay.delegate != Nil) {
        nFillLength = [audioPlay.delegate playAudio:audioPlay inBuffer:inBuffer->mAudioData length:AUDIO_BUFFER_SIZE];
    }
    
    if (nFillLength < AUDIO_BUFFER_SIZE) {
        memset(inBuffer->mAudioData + nFillLength, 0, AUDIO_BUFFER_SIZE - nFillLength);
    }
    
    inBuffer->mAudioDataByteSize = AUDIO_BUFFER_SIZE;
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

- (BOOL) playSound {
    //Howard 2013-08-14 添加,设置话筒模式(声音播放的两种模式：听筒模式和话筒模式）
    if (!isAudioPlay) {
        UInt32 audioRoute = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty( kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRoute), &audioRoute );
        
        const AudioStreamBasicDescription asbd = {8000.0, kAudioFormatLinearPCM, 12, 2, 1, 2, 1, 16, 0};
        AudioQueueNewOutput(&asbd, HowardAudioQueueOutputCallback, self, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 0, &d_audio_play);
        for (int i = 0; i < AUDIO_PLAY_BUFFERS_NUMBER; i++) {
            AudioQueueAllocateBuffer(d_audio_play, AUDIO_BUFFER_SIZE, &d_audio_play_buffers[i]);
            d_audio_play_buffers[i]->mUserData = self;
            memset(d_audio_play_buffers[i]->mAudioData, 0, AUDIO_BUFFER_SIZE);
            d_audio_play_buffers[i]->mAudioDataByteSize = AUDIO_BUFFER_SIZE;
            AudioQueueEnqueueBuffer(d_audio_play, d_audio_play_buffers[i], 0, NULL);
        }
        
        AudioQueueSetParameter(d_audio_play, kAudioQueueParam_Volume, 1.0);
        AudioQueueStart(d_audio_play, NULL);
        isAudioPlay = YES;
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) stopSound {
    if (isAudioPlay) {
        [[NSNotificationCenter defaultCenter] removeObserver: self];
        
        AudioQueueStop(d_audio_play, YES);
        for (int i = 0; i < AUDIO_PLAY_BUFFERS_NUMBER; i++) {
            AudioQueueFreeBuffer(d_audio_play, d_audio_play_buffers[i]);
        }
        AudioQueueDispose(d_audio_play, YES);
        isAudioPlay = NO;
        return YES;
    } else {
        return NO;
    }
}

@end
