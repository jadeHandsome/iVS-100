//
//  BaseViewController.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/4.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorRgbValue(0xFFFFFF);
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

#pragma  mark ----- pop退出
- (void)popOut{
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popOutAction)];
}

- (void)popOutAction{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark  -------- userDefaults ---------
- (void)saveToUserDefaultsWithKey:(NSString *)key Value:(id)value{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)getFromDefaultsWithKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma  mark   -------- 常用的正则判断
//手机号
- (BOOL)cheakPhoneNumber:(NSString *)phoneNum{
    return [self NSRegularExpressionWithExpression:@"^1[3|4|5|7|8][0-9]\\d{8}$" AndCheakStr:phoneNum];
}
//检查密码格式6~16位
- (BOOL)cheakPwd:(NSString *)pwd{
    if(pwd){
        if(pwd.length >= 6 && pwd.length <= 16){
            return YES;
        }
        else{
            return NO;
        }
    }
    else{
        return NO;
    }
}

- (BOOL)NSRegularExpressionWithExpression:(NSString *)Expression AndCheakStr:(NSString *)cheakStr{
    NSPredicate *Predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Expression];
    return [Predicate evaluateWithObject:cheakStr];
}

#pragma mark ----------- MBProgressHUD ----------------
- (void)showLoadingHUD{
    [self showLoadingHUDWithText:nil];
}

- (void)showLoadingHUDWithText:(NSString *)text{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.bezelView.backgroundColor = [UIColor blackColor];
//    hud.contentColor = [UIColor whiteColor];

    
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.backgroundColor = LRRGBAColor(87, 87, 87, 1);
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.alpha = 1.0;

    HUD.bezelView.backgroundColor = COLOR(12, 12, 12, 1);
    HUD.contentColor = [UIColor whiteColor];
    if (text != nil) {
        HUD.label.text = text;
    }

    //自定义动画
    UIImageView *gifImageView = [[UIImageView alloc] init];
    gifImageView.backgroundColor = [UIColor clearColor];
    gifImageView.contentMode = UIViewContentModeScaleAspectFill;
    NSMutableArray *arrM = [[NSMutableArray alloc] init];
    for (int i = 3; i < 12; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"img%d", i]];
        [arrM addObject:image];
    }
    [gifImageView setAnimationImages:arrM];
    [gifImageView setAnimationDuration:1.0];
    [gifImageView setAnimationRepeatCount:0];
    [gifImageView startAnimating];
    
    HUD.customView = gifImageView;

    
    
    
}

- (void)showHUDWithText:(NSString *)text{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:1.0f];
}

- (void)hideHUD{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
