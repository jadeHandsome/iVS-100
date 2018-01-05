//
//  CommanUtils.m
//  Hilook
//
//  Created by xsz on 29/6/16.
//  Copyright © 2016 hongdian.com. All rights reserved.
//

#import "CommanUtils.h"
#import "UIView+SDAutoLayout.h"
#import "MBProgressHUD.h"

@implementation CommanUtils

-(void)addEyeToEditTxt:(UITextField *)pwdField Target:(id)target ImageClick:(SEL)clickImg{
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
    rightImg.userInteractionEnabled = YES;
    rightImg.image = [UIImage imageNamed:@"display.png"];
    pwdField.rightView = rightImg;
    pwdField.rightViewMode = UITextFieldViewModeWhileEditing;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:target action:clickImg];
    [rightImg addGestureRecognizer:singleTap];
    [singleTap release];
}
-(void)switchPwdShowOnOff:(UITextField *)pwdField{
    NSString *text = pwdField.text;
    pwdField.text = @"";
    pwdField.secureTextEntry = !pwdField.secureTextEntry;
    pwdField.text = text;
}
-(void)showTips:(UIView *)parent Title:(NSString *)str{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:parent];
    [parent addSubview:HUD];
    HUD.labelText = str;
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    }completionBlock:^{
        [HUD removeFromSuperview];
        [HUD release];
    }];
}
//tip view
-(UILabel *)createTopTipView:(NSString *)title ParentView:(UIView *)parent{
    UILabel *configTxt = [UILabel new];
    [parent addSubview:configTxt];
    configTxt.text = title;
    configTxt.backgroundColor = LoginBtnColor;
    configTxt.alpha = 0.8;
    configTxt.textAlignment = NSTextAlignmentCenter;
    configTxt.numberOfLines = 1;
    configTxt.textColor = [UIColor whiteColor];
    configTxt.font = [UIFont systemFontOfSize:15];
    configTxt.sd_layout
    .heightIs(30)
    .widthIs(mainSize.width).topSpaceToView(parent , TopBarHeight - 1 + StatusBarRect.size.height );
    return configTxt;
}

//构造导航栏
- (UIView *)setUpNavigationItem:(UIView *)parentView Target:(id)target Title:(NSString *)title LeftImageNormal:(NSString *)leftImgNor LeftImageSelect:(NSString *)leftImgSel RightImageNormal:(NSString *)rgtImgNor RightImageSel:(NSString *)rgtImgSel LeftImageClick:(SEL)clickLeft RightImageClick:(SEL)clickRight
{
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 20, mainSize.width, TopBarHeight)];
    topBar.backgroundColor = NaviBarBgColor;
    
    [parentView addSubview:topBar];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, TopBarHeight - 1, mainSize.width, 0.5)];
    line.backgroundColor = NaviBarLineColor;
    [topBar addSubview:line];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, mainSize.width - 80, TopBarHeight - 10 * 2)];
    lab.text = title;
    lab.textColor = NaviBarTxtColor;
    lab.lineBreakMode = NSLineBreakByTruncatingTail;
    lab.numberOfLines = 1;
    lab.textAlignment = NSTextAlignmentCenter;
    [topBar addSubview:lab];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 80, TopBarHeight);
    [backBtn setImage:[UIImage imageNamed:leftImgNor] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:leftImgSel] forState:UIControlStateHighlighted];
    [backBtn addTarget:target action:clickLeft forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:backBtn];
    if(clickRight != nil){
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(mainSize.width - 80, 0, 80, 50);
        [rightBtn setImage:[UIImage imageNamed:rgtImgNor] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:rgtImgSel] forState:UIControlStateHighlighted];
        [rightBtn addTarget:target action:clickRight forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:rightBtn];
    }
    return topBar;
}
-(UILabel *)createLeftTitle:(NSString *)str ParentView:(UIView *)parent{
    UILabel *sn = [UILabel new];
    sn.text = str;
    sn.textColor = [UIColor blackColor];
    sn.lineBreakMode = NSLineBreakByTruncatingTail;
    sn.numberOfLines = 1;
    sn.textAlignment = NSTextAlignmentLeft;
    sn.font = [UIFont systemFontOfSize:13];
    [parent addSubview:sn];
    sn.sd_layout
    .widthIs(80)
    .heightIs(30)
    .centerYEqualToView(parent)
    .leftSpaceToView(parent , 0);
    return sn;
}
-(UILabel *)createRightLabel:(NSString *)str ParentView:(UIView *)parent LeftView:(UIView *)left{
    UILabel *sn = [UILabel new];
    sn.text = str;
    sn.textColor = [UIColor blackColor];
    sn.lineBreakMode = NSLineBreakByTruncatingTail;
    sn.numberOfLines = 1;
    sn.textAlignment = NSTextAlignmentLeft;
    sn.font = [UIFont systemFontOfSize:13];
    [parent addSubview:sn];
    sn.sd_layout
    .widthIs(mainSize.width - 80 - 100)
    .heightIs(30)
    .centerYEqualToView(parent)
    .leftSpaceToView(left , 10);
    return sn;
}
-(void)createLayoutBottomLine:(UIView *)parent Width:(int)width{
    UIView *ipLine = [UIView new];
    ipLine.backgroundColor = NaviBarLineColor;
    [parent addSubview:ipLine];
    ipLine.sd_layout
    .widthIs(width)
    .heightIs(0.5)
    .centerXEqualToView(parent)
    .bottomEqualToView(parent);
}
-(UITextField *)createRightPwdEditTxt:(NSString *)tip ParentView:(UIView *)parent LeftView:(UIView *)left{
    UITextField *tmp = [UITextField new];
    tmp.font = [UIFont systemFontOfSize:13];
    tmp.layer.cornerRadius = 5;
    tmp.placeholder = tip;
    tmp.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    tmp.layer.borderWidth = 0;
    tmp.textColor = [UIColor blackColor];
    [parent addSubview:tmp];
    tmp.secureTextEntry = YES;
    tmp.clearButtonMode = UITextFieldViewModeWhileEditing;
    tmp.sd_layout
    .widthIs(mainSize.width - 80 - 100)
    .heightIs(30)
    .centerYEqualToView(parent)
    .leftSpaceToView(left , 10);
    return tmp;
}
-(UITextField *)createRightEditTxt:(NSString *)tip ParentView:(UIView *)parent LeftView:(UIView *)left Tag:(int)tag{
    UITextField *tmp = [UITextField new];
    tmp.font = [UIFont systemFontOfSize:13];
    tmp.layer.cornerRadius = 5;
    tmp.placeholder = tip;
    tmp.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    tmp.layer.borderWidth = 0;
    tmp.textColor = [UIColor blackColor];
    [parent addSubview:tmp];
    tmp.secureTextEntry = NO;
    tmp.tag = tag;
    tmp.sd_layout
    .widthIs(mainSize.width - 80 - 100)
    .heightIs(30)
    .centerYEqualToView(parent)
    .leftSpaceToView(left , 10);
    return tmp;
}


-(NSString *)getDeviceSerialNum{
    NSString *identi = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return  identi;
}
-(NSString *)getDeviceExtraInfo{
    NSString *model = [[UIDevice currentDevice] model];
    NSString *sysVer = [[UIDevice currentDevice] systemVersion];
    return model;
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
//单个文件的大小

- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


- (id)transformedValue:(id)value
{
    
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}
-(NSString *)getCurrentDate:(NSString *)form{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:form];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;

}

-(NSString *)convertDevUtcDate:(NSString *)utcStr{
    NSDate *utcDate = [self getUTCDateFromString:utcStr];
    NSDate *localDate = [self getNowDateFromatAnDate:utcDate];
    NSString *res = [self convertDateToString:localDate ForMat:@"yyyy-MM-dd"];
    return res;
}

-(NSString *)convertDateToString:(NSDate *)date ForMat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]
                                      init];
    [dateFormatter setDateFormat:format];
    NSString *res = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return res;
}

-(NSDate *)getUTCDateFromString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]
                                      init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.000'Z'"];
    NSDate *localDate = [dateFormatter dateFromString:str];
    [dateFormatter release];
    return localDate;
}
-(NSDate *)getDateFromString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]
                                      init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *localDate = [dateFormatter dateFromString:str];
    [dateFormatter release];
    return localDate;
}

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDateNow = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate] autorelease];
    return destinationDateNow;
}

-(void)savePrivateDataForKey:(NSString *)key ForValue:(NSString *)val{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:val forKey:key];
    
    [defaults synchronize];
}
@end
