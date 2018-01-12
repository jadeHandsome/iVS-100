//
//  TTXPtzView.m
//  cmsv6
//
//  Created by Apple on 13-4-10.
//  Copyright (c) 2013年 babelstar. All rights reserved.
//

#import "HDPtzView.h"
//#include "netmediaapi.h"

#define PTZ_SPEED_MAX      255
#define PTZ_SPEED_MIN      0

#define TAG_PTZ_MID        50

@interface HDPtzView ()
-(void)createCtrl;
-(void)onSpeedSliderChannged;
-(void)onPtzTouchDown:(id)sender;
-(void)onPtzTouchUp:(id)sender;
-(void)sendBtnCmd:(NSInteger)tag townDown:(BOOL)bTouchDown param:(NSInteger)nParam;
-(void)sendPtzCmd:(NSInteger)nCmd speed:(NSInteger)nSpeed param:(NSInteger)nParam;

-(UIButton*)createPtzBtn:(NSString*)normal_image_name selImage:(NSString*)sel_image_name;
-(UIButton*)createOtherBtn:(NSString*)normal_image_name selImage:(NSString*)sel_image_name;
@end

@implementation HDPtzView

@synthesize delegate;
@synthesize btnUp;
@synthesize btnDown;
@synthesize btnRight;
@synthesize btnLeft;
@synthesize btnUpLeft;
@synthesize btnUpRight;
@synthesize btnDownRight;
@synthesize btnDownLeft;
@synthesize btnMid;

@synthesize btnFocusIn;
@synthesize btnFocusOut;
@synthesize btnZoomIn;
@synthesize btnZoomOut;
@synthesize btnApertureIn;
@synthesize btnApertureOut; //光圈
@synthesize btnLight;       //灯光
@synthesize btnWiper;       //雨刷
@synthesize speedSlider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self createCtrl];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIButton*)createPtzBtn:(NSString*)normal_image_name selImage:(NSString*)sel_image_name
{
    UIButton* btn = [ UIButton buttonWithType: UIButtonTypeCustom ];
    [btn setImage:[ UIImage imageNamed:normal_image_name ] forState:UIControlStateNormal ];
    [btn setImage:[ UIImage imageNamed:sel_image_name ] forState:UIControlStateHighlighted ];
    [btn addTarget:self action:@selector(onPtzTouchDown: ) forControlEvents:UIControlEventTouchDown ];
    [btn addTarget:self action:@selector(onPtzTouchUp: ) forControlEvents:UIControlEventTouchUpInside ];
    
    return btn;
}

- (void)setTitle:(UIButton *)btn title:(NSString *)title{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    LRViewBorderRadius(btn, 5, 1, [UIColor grayColor]);
}


-(UIButton*)createOtherBtn:(NSString*)normal_image_name selImage:(NSString*)sel_image_name
{
    UIButton* btn = [ UIButton buttonWithType: UIButtonTypeCustom ];
    [btn setBackgroundImage:[ UIImage imageNamed:normal_image_name ] forState:UIControlStateNormal ];
    [btn setBackgroundImage:[ UIImage imageNamed:sel_image_name ] forState:UIControlStateSelected ];
    [btn addTarget:self action:@selector(onPtzTouchDown: ) forControlEvents:UIControlEventTouchDown ];
    [btn addTarget:self action:@selector(onPtzTouchUp: ) forControlEvents:UIControlEventTouchUpInside ];
    
    return btn;
}

-(void)createCtrl
{
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(WIDTH(70), HEIGHT(17.5) , HEIGHT(185), HEIGHT(185))];
    container.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(container, HEIGHT(92.5), 1, COLOR(192, 193, 197, 1));
    [self.view addSubview:container];
    
    
    btnLeft = [self createPtzBtn: @"left" selImage: @"left_s" ];
    btnRight = [self createPtzBtn: @"right" selImage: @"right_s" ];
    btnUp  = [self createPtzBtn: @"up" selImage: @"up_s" ];
    btnDown = [self createPtzBtn: @"down" selImage: @"down_s" ];
    
    
    btnUpLeft = [self createPtzBtn: @"ptz/up_left.png" selImage: @"ptz/up_left_sel.png" ];
    btnUpRight = [self createPtzBtn: @"ptz/up_right.png" selImage: @"ptz/up_right_sel.png" ];
    btnDownLeft = [self createPtzBtn: @"ptz/down_left.png" selImage: @"ptz/down_left_sel.png" ];
    btnDownRight = [self createPtzBtn: @"ptz/down_right.png" selImage: @"ptz/down_right_sel.png" ];
    btnMid = [self createPtzBtn: @"ptz/mid.png" selImage: @"ptz/mid_sel.png" ];
    
    
    btnUp.frame = CGRectMake(HEIGHT(37.5), HEIGHT(10), HEIGHT(110), HEIGHT(51));
    btnDown.frame = CGRectMake(HEIGHT(37.5), HEIGHT(124), HEIGHT(110), HEIGHT(51));
    btnLeft.frame = CGRectMake(HEIGHT(10),HEIGHT(37.5), HEIGHT(51),HEIGHT(110));
    btnRight.frame = CGRectMake(HEIGHT(124),HEIGHT(37.5), HEIGHT(51),HEIGHT(110));
    
    
    UIImageView *circleImage = [[UIImageView alloc] initWithFrame:CGRectMake(HEIGHT(60), HEIGHT(60), HEIGHT(65), HEIGHT(65))];
    circleImage.contentMode = UIViewContentModeCenter;
    circleImage.image = [UIImage imageNamed:@"circle"];
    [container addSubview:circleImage];
    
    
    UIView *rightContainer = [[UIView alloc] initWithFrame:CGRectMake(WIDTH(70) + HEIGHT(185), 0, SIZEWIDTH - 20 - WIDTH(70) - HEIGHT(185), HEIGHT(220))];
    rightContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rightContainer];
    
    
    
    
    


    btnFocusIn = [self createPtzBtn: @"focus_in" selImage: @"focus_in_s" ];
    btnFocusOut = [self createPtzBtn: @"focus_out" selImage: @"focus_out_s" ];
    btnZoomIn = [self createPtzBtn: @"zoom_in" selImage: @"zoom_in_s" ];
    btnZoomOut = [self createPtzBtn: @"zoom_out" selImage: @"zoom_out_s" ];
    btnApertureIn = [self createPtzBtn: @"aperture_in" selImage: @"aperture_in_s" ];
    btnApertureOut = [self createPtzBtn: @"aperture_out" selImage: @"aperture_out_s" ];
    
    [self setTitle:btnFocusIn title:Localized(@"焦点拉近")];
    [self setTitle:btnFocusOut title:Localized(@"焦点拉远")];
    [self setTitle:btnZoomIn title:Localized(@"镜头放大")];
    [self setTitle:btnZoomOut title:Localized(@"镜头缩小")];
    [self setTitle:btnApertureIn title:Localized(@"光圈放大")];
    [self setTitle:btnApertureOut title:Localized(@"光圈缩小")];
    
    CGFloat itemW = (rightContainer.bounds.size.width - WIDTH(90)) / 2;
    CGFloat itemH = (HEIGHT(220) - HEIGHT(30)) / 3;
    
    btnZoomIn.frame = CGRectMake(WIDTH(30), HEIGHT(10), itemW , itemH);
    btnZoomOut.frame = CGRectMake(WIDTH(30) + WIDTH(30) + itemW, HEIGHT(10), itemW , itemH);
    btnApertureIn.frame = CGRectMake(WIDTH(30), HEIGHT(10) + HEIGHT(10) + itemH, itemW , itemH);
    btnApertureOut.frame = CGRectMake(WIDTH(30) + WIDTH(30) + itemW, HEIGHT(10) + HEIGHT(10) + itemH, itemW , itemH);
    btnFocusIn.frame = CGRectMake(WIDTH(30)  + WIDTH(30) + itemW , HEIGHT(10) + (HEIGHT(10) + itemH) * 2, itemW , itemH);
    btnFocusOut.frame = CGRectMake(WIDTH(30), HEIGHT(10) + (HEIGHT(10) + itemH) * 2, itemW , itemH);
    
    btnLight = [self createOtherBtn: @"ptz/light.png" selImage: @"ptz/light_sel.png" ];
    btnWiper = [self createOtherBtn: @"ptz/wiper.png" selImage: @"ptz/wiper_sel.png" ];
    
    btnLeft.tag = GPS_PTZ_MOVE_LEFT;
    btnRight.tag = GPS_PTZ_MOVE_RIGHT;
    btnUp.tag = GPS_PTZ_MOVE_TOP;
    btnDown.tag = GPS_PTZ_MOVE_BOTTOM;
    btnUpLeft.tag = GPS_PTZ_MOVE_LEFT_TOP;
    btnUpRight.tag = GPS_PTZ_MOVE_RIGHT_TOP;
    btnDownLeft.tag = GPS_PTZ_MOVE_LEFT_BOTTOM;
    btnDownRight.tag = GPS_PTZ_MOVE_RIGHT_BOTTOM;
    btnMid.tag = TAG_PTZ_MID;
    
    btnFocusIn.tag = GPS_PTZ_FOCUS_DEL;
    btnFocusOut.tag = GPS_PTZ_FOCUS_ADD;
    btnZoomIn.tag = GPS_PTZ_LIGHT_DEL;
    btnZoomOut.tag = GPS_PTZ_LIGHT_ADD;
    btnApertureIn.tag = GPS_PTZ_ZOOM_DEL;
    btnApertureOut.tag = GPS_PTZ_ZOOM_ADD;
    btnLight.tag = GPS_PTZ_LIGHT_OPEN;
    btnWiper.tag = GPS_PTZ_WIPER_OPEN;
    
    
    speedSlider = [[ UISlider alloc ]init ];
    [speedSlider addTarget:self action:@selector(onSpeedSliderChannged) forControlEvents:UIControlEventValueChanged];
    speedSlider.maximumValue = PTZ_SPEED_MAX;
    speedSlider.minimumValue = PTZ_SPEED_MIN;
    speedSlider.value = ( PTZ_SPEED_MIN + PTZ_SPEED_MAX ) / 2 ;
    
    [container addSubview: btnLeft ];
    [container addSubview: btnRight ];
    [container addSubview: btnUp ];
    [container addSubview: btnDown ];
//    [self.view addSubview: btnUpLeft ];
//    [self.view addSubview: btnUpRight ];
//    [self.view addSubview: btnDownLeft ];
//    [self.view addSubview: btnDownRight ];
//    [self.view addSubview: btnMid ];
    
    [rightContainer addSubview: btnFocusIn ];
    [rightContainer addSubview: btnFocusOut ];
    [rightContainer addSubview: btnZoomIn ];
    [rightContainer addSubview: btnZoomOut ];
    [rightContainer addSubview: btnApertureIn ];
    [rightContainer addSubview: btnApertureOut ];
//    [self.view addSubview: btnLight ];
//    [self.view addSubview: btnWiper ];
    //[self.view addSubview: labelSpeed ];
//    [self.view addSubview: speedSlider ];
    
    
    
    
}

-(void)setCtrlPos
{
//    CGRect rcClient = self.view.bounds;
//
//    const int slider_height = 30;
//    const int slider_width = 180;
//
//    const int ptzBtnWidth = 41;
//    const int ptzBtnHeight = 41;
//
//    const int other_btn_width = 28;
//    const int other_btn_height = 28;
//
//    const int light_width = 28;
//    const int light_height = 28;
//    const int wiper_width = 28;
//    const int wiper_height = 28;
//    //Howard 2012-11-03
//    int midX = rcClient.origin.x + rcClient.size.width/2;
//    int midY = rcClient.origin.y + rcClient.size.height/2;
//
//    //中间按钮的位置偏移
//    int x0 = midX - ptzBtnWidth/2;//136 ;//Howard 2012-11-03
//    int y0 = midY - ptzBtnHeight/2;//156;//Howard 2012-11-03
//    //左上按钮的位置偏移
//    int xx = x0 - 49;//87;
//    int yy = y0 - 52;//104;
//
//    //横向按钮的水平间隔
//    int xSpace1 = 35;
//    //纵向按钮的垂直间隔
//    int ySpace1 = 35;
//
//    //左上与右上按钮的水平间隔
//    int xSpace2 = 100;
//    int ySpace2 = 100;
//
//
//    CGRect rcMid;
//    rcMid.size.width = ptzBtnWidth;
//    rcMid.size.height = ptzBtnHeight;
//    rcMid.origin.x = x0;
//    rcMid.origin.y = y0;
//    btnMid.frame = rcMid;
//
//    CGRect rcLeft = rcMid;
//    rcLeft.origin.x = rcMid.origin.x - xSpace1 - ptzBtnWidth;
//    btnLeft.frame = rcLeft;
//
//    CGRect rcRight = rcMid;
//    rcRight.origin.x = rcMid.origin.x + xSpace1 + ptzBtnWidth;
//    btnRight.frame = rcRight;
//
//    CGRect rcUp = rcMid;
//    rcUp.origin.y = rcMid.origin.y - ySpace1 - ptzBtnHeight;
//    btnUp.frame = rcUp;
//
//    CGRect rcDown = rcMid;
//    rcDown.origin.y = rcMid.origin.y + ySpace1 + ptzBtnHeight;
//    btnDown.frame = rcDown;
//
//
//    //左上
//    CGRect rcUpLeft;
//    rcUpLeft.size.width = ptzBtnWidth;
//    rcUpLeft.size.height = ptzBtnHeight;
//    rcUpLeft.origin.x = xx;
//    rcUpLeft.origin.y = yy;
//    btnUpLeft.frame = rcUpLeft;
//
//    CGRect rcUpRight = rcUpLeft;
//    rcUpRight.origin.x += xSpace2;
//    btnUpRight.frame = rcUpRight;
//
//    CGRect rcDownLeft = rcUpLeft;
//    rcDownLeft.origin.y += ySpace2;
//    btnDownLeft.frame = rcDownLeft;
//
//    CGRect rcDownRight = rcUpRight;
//    rcDownRight.origin.y += ySpace2;
//    btnDownRight.frame = rcDownRight;
//
//    //其他按钮
//    //上面一排
//    int topOffset = 14;
//    int distance = 18;
//    int margin = 16;
//    CGRect rcFocusOut;
//    rcFocusOut.size.width = other_btn_width;
//    rcFocusOut.size.height = other_btn_height;
//    rcFocusOut.origin.x = rcClient.origin.x + margin;
//    rcFocusOut.origin.y = topOffset;
//    btnFocusOut.frame = rcFocusOut;
//
//    CGRect rcFocusIn = rcFocusOut;
//    rcFocusIn.origin.x += distance + other_btn_width;
//    btnFocusIn.frame = rcFocusIn;
//
//    CGRect rcZoomOut = rcFocusOut;
//    rcZoomOut.origin.x = rcClient.origin.x + ( rcClient.size.width/2 - distance/2 - other_btn_width );
//    btnZoomOut.frame = rcZoomOut;
//
//    CGRect rcZoomIn = rcZoomOut;
//    rcZoomIn.origin.x += distance + other_btn_width;
//    btnZoomIn.frame = rcZoomIn;
//
//    CGRect rcApertureIn = rcFocusOut;
//    rcApertureIn.origin.x = rcClient.origin.x + rcClient.size.width - margin - other_btn_width;
//    btnApertureIn.frame = rcApertureIn;
//
//    CGRect rcApertureOut = rcApertureIn;
//    rcApertureOut.origin.x -= (distance + other_btn_width);
//    btnApertureOut.frame = rcApertureOut;
//
//    //灯光，雨刷，速度
//    int bottomOffset = 14;
//    int margin_light = 16;
//    int distance_light = 18;
//
//    CGRect rcLight;
//    rcLight.size.width = light_width;
//    rcLight.size.height = light_height;
//    rcLight.origin.x = margin_light;
//    rcLight.origin.y = rcClient.origin.y + rcClient.size.height - light_height - bottomOffset;
//    btnLight.frame = rcLight;
//
//    CGRect rcWiper;
//    rcWiper.size.width = wiper_width;
//    rcWiper.size.height = wiper_height;
//    rcWiper.origin.x = rcLight.origin.x + light_width + distance_light;
//    rcWiper.origin.y = rcLight.origin.y ;
//    btnWiper.frame = rcWiper;
//
//    CGRect rcSpeed;
//    rcSpeed.size.width = slider_width;
//    rcSpeed.size.height = slider_height;
//    rcSpeed.origin.x = rcClient.origin.x + rcClient.size.width - slider_width - margin_light;
//    rcSpeed.origin.y = rcClient.origin.y + rcClient.size.height - slider_height - bottomOffset;
//    speedSlider.frame = rcSpeed;
    
}

-(void)onSpeedSliderChannged
{
    
}

-(void) onPtzTouchDown:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int tag = btn.tag;
    
    //特殊情况
    if( GPS_PTZ_LIGHT_OPEN == tag )
    {
        isLightOn = !isLightOn;
        btnLight.selected = isLightOn;
    }
    else if( GPS_PTZ_WIPER_OPEN == tag )
    {
        isWiperOn = !isWiperOn;
        btnWiper.selected = isWiperOn;
    }
    
    [self sendBtnCmd: tag townDown:YES param:0 ];
}

-(void)onPtzTouchUp:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    [self sendBtnCmd: btn.tag townDown:NO param:0 ];
}
NSInteger isdown=1;
-(void)sendBtnCmd:(NSInteger)tag townDown:(BOOL)bTouchDown param:(NSInteger)nParam
{
    int nCmd = GPS_PTZ_MOVE_STOP;
    
    if( bTouchDown )
    {
        isdown=1;
        switch ( tag)
        {
            case GPS_PTZ_LIGHT_OPEN:
            {
                nCmd = isLightOn ? GPS_PTZ_LIGHT_CLOSE: GPS_PTZ_LIGHT_OPEN;
            }
                break;
            case GPS_PTZ_WIPER_OPEN:
            {
                nCmd = isWiperOn ? GPS_PTZ_WIPER_CLOSE : GPS_PTZ_WIPER_OPEN;
            }
                break;
            default:
            {
                nCmd = tag;
            }
                break;
        }
    }
    else
    {
        isdown=0;
    }
    
    int nSpeed = speedSlider.value;
    
    [self sendPtzCmd: nCmd speed: nSpeed param:isdown];
}

-(void)sendPtzCmd:(NSInteger)nCmd speed:(NSInteger)nSpeed param:(NSInteger)nParam
{
    [delegate onPtzCtrl:nCmd speed:nSpeed param:nParam];
}

@end
