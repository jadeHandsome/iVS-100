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
 
 
    [btnPtz setBackgroundImage:[UIImage imageNamed:@"ptz.png"] forState:UIControlStateNormal ];
    [btnStop setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal ];
    [btnCapture setBackgroundImage:[UIImage imageNamed:@"capture.png"] forState:UIControlStateNormal ];
    [btnSound setBackgroundImage:[UIImage imageNamed:@"sound_open.png"] forState:UIControlStateNormal ];
    
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
    
    const int BTN_WIDTH = 26;
    const int BTN_HEIGHT = 26;
    const int BTN_SPACE = 22;//26;
    int nMidX = rcClient.origin.x + rcClient.size.width/ 2;
    int y = ( rcClient.size.height - BTN_HEIGHT ) / 3;
    //int x = nMidX - BTN_WIDTH/3;
    int x = nMidX;
    CGRect rcMid = CGRectMake( x, y, BTN_WIDTH, BTN_HEIGHT );
    CGRect rcBtn = rcMid;
    //往左
    rcBtn.origin.x -= ( BTN_WIDTH + BTN_SPACE/2 );
    btnCapture.frame = rcBtn;
    rcBtn.origin.x -= ( BTN_WIDTH + BTN_SPACE );
    btnPtz.frame = rcBtn;
    rcBtn.origin.x -= ( BTN_WIDTH + BTN_SPACE );
    btnStop.frame = rcBtn;
    //往右
    rcBtn = rcMid;
    rcBtn.origin.x += ( BTN_SPACE/2 );
    btnSound.frame = rcBtn;

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
    [self showLight: btn show: YES ];
    
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
    [self showLight: btn show: NO ];
}

@end
