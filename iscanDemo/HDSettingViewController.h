//
//  HDSettingViewController.h
//  iscanMC2
//
//  Created by zqh on 14-8-28.
//  Copyright (c) 2014年 zqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPopoverListView.h"

@interface HDSettingViewController : UIViewController<UIPopoverListViewDataSource, UIPopoverListViewDelegate>

@property(nonatomic,retain) IBOutlet UITextField *ipLabel;
@property(nonatomic,retain) IBOutlet UITextField *portLabel;
@property(nonatomic,retain) IBOutlet UIButton *netTypePicker;

@end
