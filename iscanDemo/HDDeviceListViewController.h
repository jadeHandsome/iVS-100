//
//  HDDeviceListViewController.h
//  iScanMC
//
//  Created by zqh on 14-8-22.
//  Copyright (c) 2014年 zqh. All rights reserved.
//

#import "HDDeviceListViewCell.h"
#import "HDLoginViewController.h"
#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"
#import "HDPreviewView.h"
@interface HDDeviceListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,ASIHTTPRequestDelegate>

@property (nonatomic, assign) NSUInteger numberOfRowsInSection0;
@property (nonatomic, assign) NSUInteger numberOfRowsInSection1;
@end
