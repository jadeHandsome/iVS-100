//
//  LoginViewController.m
//  iVS-100
//
//  Created by 曾洪磊 on 2018/1/5.
//  Copyright © 2018年 hilook.com. All rights reserved.
//

#import "LoginViewController.h"
//#import "HDDeviceListViewController.h"
#import "SettingViewController.h"
#import "CarListViewController.h"
#import "BaseNaviViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameInput;
@property (weak, nonatomic) IBOutlet UITextField *pwdInput;
@property (weak, nonatomic) IBOutlet UIButton *remberBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *gojibNtn;
@property (nonatomic, strong) NSDictionary *settingDic;
@end

@implementation LoginViewController
- (void)awakeFromNib {
    [super awakeFromNib];
    self.userNameInput.placeholder = Localized(@"请输入用户名");
    self.pwdInput.placeholder = Localized(@"请输入密码");
    [self.remberBtn setTitle:Localized(@"记住密码") forState:UIControlStateNormal];
    [self.loginBtn setTitle:Localized(@"登录") forState:UIControlStateNormal];
    [self.gojibNtn setTitle:Localized(@"高级设置") forState:UIControlStateNormal];
}
- (void)loadLocation {
    self.userNameInput.placeholder = Localized(@"请输入用户名");
    self.pwdInput.placeholder = Localized(@"请输入密码");
    [self.remberBtn setTitle:Localized(@"记住密码") forState:UIControlStateNormal];
    [self.loginBtn setTitle:Localized(@"登录") forState:UIControlStateNormal];
    [self.gojibNtn setTitle:Localized(@"高级设置") forState:UIControlStateNormal];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLocation];
    LRViewBorderRadius(self.loginBtn, 5, 0, [UIColor clearColor]);
    self.userNameInput.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    self.pwdInput.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    [_userNameInput setValue:[UIColor whiteColor]
              forKeyPath:@"_placeholderLabel.textColor"];
    [_pwdInput setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];

    if (self.userNameInput.text && self.pwdInput.text) {
        self.remberBtn.selected = YES;
//        [self loginClick:nil];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)remenberClick:(id)sender {
    [self.remberBtn setSelected:!self.remberBtn.selected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginClick:(id)sender {
    [self.userNameInput resignFirstResponder];
    [self.pwdInput resignFirstResponder];
    
    
    
    if (self.userNameInput.text==nil||[self.pwdInput.text isEqualToString:@""]) {
        [self showHUDWithText:Localized(@"账号不能为空")];
        
        return;
    }
    if (self.pwdInput.text==nil||[self.pwdInput.text isEqualToString:@""]) {
        [self showHUDWithText:Localized(@"密码不能为空")];
        return;
    }
    
    [self showLoadingHUD];
    ASIHTTPRequest *request =  [SharedSDK loginSystem:SharedUserInfo.baseUrl UserName:self.userNameInput.text UserPass:self.pwdInput.text Target:self Success:@selector(GetResult:) Failure:@selector(GetError:)];
    [request startAsynchronous];
    
   
}
-(void)GetResult:(ASIHTTPRequest *) requst{
    [self hideHUD];
    NSData *data = [requst responseData];
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    if ([@"\"0\"" isEqualToString:result])
    {
        if (self.remberBtn.selected) {
            [[NSUserDefaults standardUserDefaults] setObject:self.userNameInput.text forKey:@"phone"];
            [[NSUserDefaults standardUserDefaults] setObject:self.pwdInput.text forKey:@"pwd"];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phone"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pwd"];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:self.settingDic forKey:@"setting"];
        [[KRUserInfo sharedKRUserInfo] setValuesForKeysWithDictionary:self.settingDic];
        CarListViewController *devicelistController=[[CarListViewController alloc] init];
        [self presentViewController:[[BaseNaviViewController alloc] initWithRootViewController:devicelistController] animated:YES completion:nil] ;
    }
    else if([@"\"-2\"" isEqualToString:result])
    {
        [self showHUDWithText:Localized(@"用户名密码错误")];
//        [util showTips:self.view Title:@"用户名密码错误"];
    }
    else
    {
         [self showHUDWithText:Localized(@"无效用户")];
//        [util showTips:self.view Title:@"无效用户"];
    }
    
}
-(void)GetError:(ASIHTTPRequest *) requst{
    [self showHUDWithText:Localized(@"服务器响应失败")];
//    [util showTips:self.view Title:@"服务器响应失败"];
}
- (IBAction)settingClick:(id)sender {
    SettingViewController *set = [SettingViewController new];
    [self.navigationController pushViewController:set animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    self.navigationController.navigationBar.hidden = NO;
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
