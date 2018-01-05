//
//  HDSettingViewController.m
//  iscanMC2
//
//  Created by zqh on 14-8-28.
//  Copyright (c) 2014年 zqh. All rights reserved.
//

#import "HDSettingViewController.h"
#import "iscanMCSdk.h"

@interface HDSettingViewController (){
    iscanMCSdk *sdk;
}
@property(nonatomic,retain) NSArray * pickitems;
@end

@implementation HDSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title= @"参数设置";
        [self.navigationItem rightBarButtonItem].title= @"确定";
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"sure" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
        
        self.pickitems=[NSArray arrayWithObjects:@"局域网", @"电信", @"联通", nil];
    }
    return self;
}
- (IBAction)viewClick:(id)sender {
    
    [self.ipLabel resignFirstResponder];
    [self.portLabel resignFirstResponder];
}

-(void)rightBtnClick:(id)sender
{
    [sdk setSettingInfoIp:self.ipLabel.text Port:self.portLabel.text Number:@"" Interval:@"" NetType:[NSString stringWithFormat:@"%d",self.netTypePicker.tag]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    SettingBean *bean = [sdk getSettingInfo];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *ip= bean.ip;
    NSString *port= bean.port;
    NSString *nettype= bean.nettype;
    if (ip==nil) {
        ip=@"172.16.22.246";
        [userDefault setObject:ip forKey:@"ip"];
    }
    if (port==nil) {
        port=@"52467";
        [userDefault setObject:port forKey:@"port"];
    }
    if (nettype==nil) {
        nettype=@"0";
        [userDefault setObject:nettype forKey:@"nettype"];
    }
    
    self.ipLabel.text=ip;
    self.portLabel.text=port;
    [self.netTypePicker setTitle:([nettype isEqualToString:@"0"]?@"局域网":([nettype isEqualToString:@"1"])?@"电信":@"联通") forState:UIControlStateNormal];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
   sdk = [iscanMCSdk new];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickitems count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickitems objectAtIndex:row];
}

- (IBAction)popClickAction:(id)sender
{
    CGFloat xWidth = self.view.bounds.size.width - 20.0f;
    CGFloat yHeight = 272.0f;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = FALSE;
    [poplistview setTitle:NSLocalizedString(@"qing_xuan_ze", nil)];
    [poplistview show];
    [poplistview release];
  
}


#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier] autorelease];
    
    int row = indexPath.row;
    
    if(row == 0){
        cell.textLabel.text = @"局域网";
//        cell.imageView.image = [UIImage imageNamed:@"ic_facebook.png"];
    }else if (row == 1){
        cell.textLabel.text = @"电信";
//        cell.imageView.image = [UIImage imageNamed:@"ic_twitter.png"];
    }else
    {
        cell.textLabel.text = @"联通";
//        cell.imageView.image = [UIImage imageNamed:@"ic_google_plus.png"];
    }
    
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s : %d", __func__, indexPath.row);
    // your code here
   
    [self.netTypePicker setTitle:(indexPath.row==0?@"局域网":(indexPath.row==1)?@"电信":@"联通") forState:UIControlStateNormal];
    [self.netTypePicker setTag:indexPath.row];
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}



@end
