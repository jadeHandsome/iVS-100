//
//  CommanUtils.h
//  Hilook
//
//  Created by xsz on 29/6/16.
//  Copyright © 2016 hongdian.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#define mainSize [UIScreen mainScreen].bounds.size
#define LoginBtnColor [UIColor colorWithRed:255/255 green:85.0f/255.0f blue:0 alpha:1]
#define NaviBarTxtColor [UIColor colorWithRed:89.0f/255.0f green:89.0f/255.0f blue:89.0f/255.0f alpha:1]
#define NaviBarBgColor [UIColor whiteColor]
#define NaviBarLineColor [UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:171.0f/255.0f alpha:1]
#define UpdateBtnColor [UIColor colorWithRed:255/255 green:143.0f/255.0f blue:106.0f/255.0f alpha:1]
#define AlbumTabAndRdBtnColor [UIColor colorWithRed:255.0f/255.0f green:84.0f/255.0f blue:0 alpha:1]
#define TableSeparatorColor [UIColor colorWithRed:226.0f/255.0f green:232.0f/255.0f blue:241.0f/255.0f alpha:1]
#define StatusBarRect [[UIApplication sharedApplication] statusBarFrame]
#define TopBarHeight 50
#define BASE_URL [[UIApplication sharedApplication].delegate getBaseURL]
#define TMO_UIKIT_APP_IS_IOS7 ((__IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) && ([UIDevice currentDevice].systemVersion.floatValue >= 7.0))
#define TMO_UIKIT_APP_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface CommanUtils : NSObject

-(void)savePrivateDataForKey:(NSString *)key ForValue:(NSString *)val;
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
-(NSString *)convertDateToString:(NSDate *)date ForMat:(NSString *)format;
-(NSString *)convertDevUtcDate:(NSString *)utcStr;
-(NSDate *)getDateFromString:(NSString *)str;
-(NSString *)getCurrentDate:(NSString *)form;
- (long long) fileSizeAtPath:(NSString*) filePath;
- (id)transformedValue:(id)value;
- (BOOL) isBlankString:(NSString *)string;

-(NSString *)getDeviceSerialNum;
-(NSString *)getDeviceExtraInfo;



-(UILabel *)createLeftTitle:(NSString *)str ParentView:(UIView *)parent;
-(UILabel *)createRightLabel:(NSString *)str ParentView:(UIView *)parent LeftView:(UIView *)left;
-(void)createLayoutBottomLine:(UIView *)parent Width:(int)width;
-(UITextField *)createRightPwdEditTxt:(NSString *)tip ParentView:(UIView *)parent  LeftView:(UIView *)left;
-(UITextField *)createRightEditTxt:(NSString *)tip ParentView:(UIView *)parent LeftView:(UIView *)left Tag:(int)tag;

- (UIView *)setUpNavigationItem:(UIView *)parentView Target:(id)target Title:(NSString *)title LeftImageNormal:(NSString *)leftImgNor LeftImageSelect:(NSString *)leftImgSel RightImageNormal:(NSString *)rgtImgNor RightImageSel:(NSString *)rgtImgSel LeftImageClick:(SEL)clickLeft RightImageClick:(SEL)clickRight;

-(UILabel *)createTopTipView:(NSString *)title ParentView:(UIView *)parent;//show txt tip bar
-(void)showTips:(UIView *)parent Title:(NSString *)str;//show tip
-(void)switchPwdShowOnOff:(UITextField *)pwdField;//show pwd on/off
-(void)addEyeToEditTxt:(UITextField *)pwdField Target:(id)target ImageClick:(SEL)clickImg;
@end
