//
//  TTXPtzView.h
//  cmsv6
//
//  Created by Apple on 13-4-10.
//  Copyright (c) 2013年 babelstar. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GPS_PTZ_MOVE_LEFT	3234
#define GPS_PTZ_MOVE_RIGHT	3334
#define GPS_PTZ_MOVE_TOP	3034
#define GPS_PTZ_MOVE_BOTTOM	3134
#define GPS_PTZ_MOVE_LEFT_TOP       4
#define GPS_PTZ_MOVE_RIGHT_TOP      5
#define GPS_PTZ_MOVE_LEFT_BOTTOM	6
#define GPS_PTZ_MOVE_RIGHT_BOTTOM	7

#define GPS_PTZ_FOCUS_DEL   1214
#define GPS_PTZ_FOCUS_ADD 	1314
#define GPS_PTZ_LIGHT_DEL   2022
#define GPS_PTZ_LIGHT_ADD   2122
#define GPS_PTZ_ZOOM_DEL    6364
#define GPS_PTZ_ZOOM_ADD    6264
#define GPS_PTZ_LIGHT_OPEN	14
#define GPS_PTZ_LIGHT_CLOSE	15
#define GPS_PTZ_WIPER_OPEN	16
#define GPS_PTZ_WIPER_CLOSE	17
#define GPS_PTZ_CRUISE      18
#define GPS_PTZ_MOVE_STOP   1900

#define GPS_PTZ_SPEED_DEFAULT  128

@protocol TTXPtzViewDelegate <NSObject>
- (void)onPtzCtrl:(NSInteger)nCmd speed:(NSInteger)nSpeed param:(NSInteger)nParam;
@end

@interface HDPtzView : UIViewController
{
    id<TTXPtzViewDelegate> delegate;
    BOOL isLightOn;
    BOOL isWiperOn;
}

@property(nonatomic,assign) id<TTXPtzViewDelegate> delegate;
@property( strong, nonatomic) UIButton* btnUp;
@property( strong, nonatomic) UIButton* btnDown;
@property( strong, nonatomic) UIButton* btnRight;
@property( strong, nonatomic) UIButton* btnLeft;
@property( strong, nonatomic) UIButton* btnUpLeft;
@property( strong, nonatomic) UIButton* btnUpRight;
@property( strong, nonatomic) UIButton* btnDownRight;
@property( strong, nonatomic) UIButton* btnDownLeft;
@property( strong, nonatomic) UIButton* btnMid;

@property( strong, nonatomic) UIButton* btnFocusIn;
@property( strong, nonatomic) UIButton* btnFocusOut;
@property( strong, nonatomic) UIButton* btnZoomIn;
@property( strong, nonatomic) UIButton* btnZoomOut;
@property( strong, nonatomic) UIButton* btnApertureIn;
@property( strong, nonatomic) UIButton* btnApertureOut; //光圈
@property( strong, nonatomic) UIButton* btnLight;       //灯光
@property( strong, nonatomic) UIButton* btnWiper;       //雨刷
@property( strong, nonatomic) UISlider* speedSlider;
//@property( strong, nonatomic) UILabel* labelSpeed;


-(void)setCtrlPos;
@end
