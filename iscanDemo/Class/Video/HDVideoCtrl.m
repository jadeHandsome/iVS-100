//
//  HDVideoCtrl.m
//  iscanMC
//
//  Created by Apple on 13-4-5.
//  Copyright (c) 2013年 babelstar. All rights reserved.
//

#import "HDVideoCtrl.h"
#import "HDAppDelegate.h"

@interface HDVideoCtrl()
-(void)createCtrl;
-(void)onBtnDown:(id)sender;
-(void)onBtnUp:(id)sender;
@end

@implementation HDVideoCtrl

@synthesize delegate;
@synthesize btnPtz;
@synthesize btnStop;       //player也是它！
@synthesize btnCapture;
@synthesize btnSound;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createCtrl ];
        [self setCtrlPos ];
    }
    return self;
}

-(void)dealloc
{
    imageViewBtnBK = nil;
    btnPtz = nil;
    btnStop = nil;
    btnCapture = nil;
    btnSound = nil;
    [super dealloc ];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)createCtrl
{
    imageViewBtnBK = [[ UIImageView alloc ]init ];
    btnPtz = [ UIButton buttonWithType: UIButtonTypeCustom ];
     btnStop = [ UIButton buttonWithType: UIButtonTypeCustom ];
    btnCapture = [ UIButton buttonWithType: UIButtonTypeCustom ];
    btnSound = [ UIButton buttonWithType: UIButtonTypeCustom ];
 
 
//    [btnPtz setBackgroundImage:[UIImage imageNamed:@"ptz.png"] forState:UIControlStateNormal ];
//    [btnStop setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal ];
//    [btnCapture setBackgroundImage:[UIImage imageNamed:@"capture.png"] forState:UIControlStateNormal ];
//    [btnSound setBackgroundImage:[UIImage imageNamed:@"sound_open.png"] forState:UIControlStateNormal ];
    [btnStop setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnSound setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnCapture setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnPtz setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnStop setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnSound setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnCapture setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnPtz setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    btnStop.titleLabel.font = [UIFont systemFontOfSize:12];
    btnSound.titleLabel.font = [UIFont systemFontOfSize:12];
    btnCapture.titleLabel.font = [UIFont systemFontOfSize:12];
    btnPtz.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnStop setTitle:Localized(@"停止视频") forState:UIControlStateNormal];
    [btnSound setTitle:Localized(@"打开声音") forState:UIControlStateNormal];
    [btnCapture setTitle:Localized(@"视频抓拍") forState:UIControlStateNormal];
    [btnPtz setTitle:Localized(@"云台控制") forState:UIControlStateNormal];
    
    
    [btnPtz addTarget:self action:@selector(onBtnDown:) forControlEvents: UIControlEventTouchDown ];
    [btnStop addTarget:self action:@selector(onBtnDown:) forControlEvents: UIControlEventTouchDown ];
    [btnCapture addTarget:self action:@selector(onBtnDown:) forControlEvents: UIControlEventTouchDown ];
    [btnSound addTarget:self action:@selector(onBtnDown:) forControlEvents: UIControlEventTouchDown ];
    
    [btnPtz addTarget:self action:@selector(onBtnUp:) forControlEvents: UIControlEventTouchUpInside|UIControlEventTouchUpOutside ];
    [btnStop addTarget:self action:@selector(onBtnUp:) forControlEvents: UIControlEventTouchUpInside|UIControlEventTouchUpOutside ];
    [btnCapture addTarget:self action:@selector(onBtnUp:) forControlEvents: UIControlEventTouchUpInside|UIControlEventTouchUpOutside ];
    [btnSound addTarget:self action:@selector(onBtnUp:) forControlEvents: UIControlEventTouchUpInside|UIControlEventTouchUpOutside ];
    
    btnPtz.tag = E_PlayCtrlBtn_Ptz;
    btnStop.tag = E_PlayCtrlBtn_Stop;
    btnCapture.tag = E_PlayCtrlBtn_Capture;
    btnSound.tag = E_PlayCtrlBtn_Sound;
    
    imageViewBtnBK.image = [ UIImage imageNamed:@"light.png" ];
    imageViewBtnBK.hidden = YES;
    [self addSubview:imageViewBtnBK ];
    [self addSubview: btnPtz ];
    [self addSubview: btnStop ];
    [self addSubview: btnCapture ];
    [self addSubview: btnSound ];
   
}

-(void)setCtrlPos
{
    CGRect rcClient = self.bounds;
    CGFloat itemH = rcClient.size.height;
    CGFloat itemW = rcClient.size.width / 4;
    btnStop.frame = CGRectMake(0, 0, itemW, itemH);
    btnSound.frame = CGRectMake(itemW, 0, itemW, itemH);
    btnCapture.frame = CGRectMake(itemW * 2, 0, itemW, itemH);
    btnPtz.frame = CGRectMake(itemW * 3, 0, itemW, itemH);
}

-(void)changePlayButton:(BOOL)bPlay
{
    [btnStop setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal ];
}
-(void)changeSoundButton:(BOOL)bOpen
{
    if( bOpen )
    {
        [btnSound setBackgroundImage:[UIImage imageNamed:@"sound_close.png"] forState:UIControlStateNormal ];
    }
    else
    {
        [btnSound setBackgroundImage:[UIImage imageNamed:@"sound_open.png"] forState:UIControlStateNormal ];
    }
}



-(void)showLight:(UIButton*)btn show:(BOOL)isShow
{
    int width = 80;
    int height = 80;
    int x0 = btn.frame.origin.x - ( width - btn.frame.size.width ) /2;
    int y0 = btn.frame.origin.y - ( height - btn.frame.size.height ) /2;
    imageViewBtnBK.frame = CGRectMake( x0, y0, width, height );
    imageViewBtnBK.hidden = !isShow;
}

-(void)onBtnDown:(id)sender
{
    UIButton* btn = (UIButton*)sender;
//    [self showLight: btn show: YES ];
    
    int type = E_PlayCtrlBtn_Ptz;
    if (btn == btnPtz)
    {
        type = E_PlayCtrlBtn_Ptz;
    }
    
    else if (btn == btnStop)
    {
        type = E_PlayCtrlBtn_Stop;
    }
    else if (btn == btnCapture)
    {
        type = E_PlayCtrlBtn_Capture;
    }
    else if (btn == btnSound)
    {
        type = E_PlayCtrlBtn_Sound;
    }
    
    
    [delegate onCtrlBtnDown:type];
}

-(void)onBtnUp:(id)sender
{
    UIButton* btn = (UIButton*)sender;
//    [self showLight: btn show: NO ];
}

@end
