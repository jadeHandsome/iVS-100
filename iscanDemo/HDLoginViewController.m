//
//  HDLoginViewController.m
//  iScanMC
//
//  Created by zqh on 14-8-20.
//  Copyright (c) 2014年 zqh. All rights reserved.
//
#import "HDLoginViewController.h"
#import "CommanUtils.h"
#import "iscanMCSdk.h"
#import "HDDeviceListViewController.h"
@interface HDLoginViewController ()
{
    CommanUtils *util;
    iscanMCSdk *sdk;
    MBProgressHUD *HUD;
}
@property (retain, nonatomic) IBOutlet UITextField *userName;
@property (retain, nonatomic) IBOutlet UITextField *password;
@property (retain, nonatomic) IBOutlet UIButton *loginBtn;
@property (retain,nonatomic) IBOutlet UILabel *settingLabel;

@end

@implementation HDLoginViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

-(IBAction)settingClick:(id)sender
{
    HDSettingViewController * settingController=[[[HDSettingViewController alloc] init] autorelease];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (IBAction)loginBtnClick:(id)sender {

    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    

    
    if (self.userName.text==nil||[self.userName.text isEqualToString:@""]) {
            [util showTips:self.view Title:@"账号不能为空"];
     
        return;
    }
    if (self.password.text==nil||[self.password.text isEqualToString:@""]) {
        [util showTips:self.view Title:@"密码不能为空"];
        return;
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"登录中...";
    HUD.mode = MBProgressHUDModeIndeterminate;
    ASIHTTPRequest *request =  [sdk loginSystem:BASE_URL UserName:self.userName.text UserPass:self.password.text Target:self Success:@selector(GetResult:) Failure:@selector(GetError:)];
    [HUD showAnimated:YES whileExecutingBlock:^{
        [request startAsynchronous];
    }];
}
-(void)hideHud{
    [HUD removeFromSuperview];
    [HUD release];
    HUD = nil;
}
-(void)GetResult:(ASIHTTPRequest *) requst{
    [self hideHud];
    NSData *data = [requst responseData];
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    if ([@"\"0\"" isEqualToString:result])
    {
        HDDeviceListViewController *devicelistController=[[HDDeviceListViewController alloc] init];
        [self.navigationController pushViewController:devicelistController animated:YES];
    }
    else if([@"\"-2\"" isEqualToString:result])
    {
       
       [util showTips:self.view Title:@"用户名密码错误"];
    }
    else
    {
        [util showTips:self.view Title:@"无效用户"];
    }
   
}
-(void)GetError:(ASIHTTPRequest *) requst{
    [util showTips:self.view Title:@"服务器响应失败"];
    [self hideHud];
}

-(void) gotoDeviceListPage
{
    //HDDeviceListViewController *devicelistController=[[[HDDeviceListViewController alloc] init] autorelease];
    
    //[self.navigationController pushViewController:devicelistController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    util = [CommanUtils new];
    sdk = [iscanMCSdk new];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title= @"登录";
    
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    
    [self.navigationItem.backBarButtonItem setTitle:@"用户登录"];
    self.settingLabel.text=@"设置";
    
    NSUserDefaults *nsdefault=[NSUserDefaults standardUserDefaults];
    self.userName.text=[nsdefault valueForKey:@"username"];
    self.password.text=[nsdefault valueForKey:@"password"];
    
    UITapGestureRecognizer *getsture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingClick:)];
    self.settingLabel.userInteractionEnabled=YES;
    [self.settingLabel addGestureRecognizer:getsture];
    
    [self.navigationController.navigationBar customNavigationBar];
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor]}];
    
}

-(IBAction)viewClick:(id)sender
{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_userName release];
    [_password release];
    [_loginBtn release];
    [super dealloc];
}
@end
