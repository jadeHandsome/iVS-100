//
//  HDVideoCtrl.h
//  cmsv6
//
//  Created by Apple on 13-4-5.
//  Copyright (c) 2013年 babelstar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    E_PlayCtrlBtn_Ptz       = 0,
    E_PlayCtrlBtn_Record    = 1,
    E_PlayCtrlBtn_Stop      = 2,
    E_PlayCtrlBtn_Capture   = 3,
    E_PlayCtrlBtn_Sound     = 4,
    E_PlayCtrlBtn_Talkback  = 5,
    E_PlayCtrlBtn_Fullscreen  = 6
}E_PlayCtrlBtn;

@protocol HDVideoCtrlDelegate <NSObject>
- (void)onCtrlBtnDown:(E_PlayCtrlBtn)type;
@end


@interface HDVideoCtrl : UIView
{
    UIImageView* imageViewBtnBK;
    id<HDVideoCtrlDelegate> delegate;
    UIButton* btnPtz;
    UIButton* btnStop;       //player也是它！
    UIButton* btnCapture;
    UIButton* btnSound;
}

@property(nonatomic,assign) id<HDVideoCtrlDelegate> delegate;
@property(nonatomic,retain) UIButton* btnPtz;
@property(nonatomic,retain) UIButton* btnStop;       //player也是它！
@property(nonatomic,retain) UIButton* btnCapture;
@property(nonatomic,retain) UIButton* btnSound;

-(void)setCtrlPos;
-(void)changePlayButton:(BOOL)bPlay;
-(void)changeSoundButton:(BOOL)bOpen;
-(void)changeRecordButton:(BOOL)bRecord;
-(void)showLight:(UIButton*)btn show:(BOOL)isShow;
@end
