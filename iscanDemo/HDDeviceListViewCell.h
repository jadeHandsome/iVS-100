//
//  HDDeviceListViewCell.h
//  iscanMC2
//
//  Created by zqh on 14-8-27.
//  Copyright (c) 2014年 zqh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDDeviceListViewCell : UITableViewCell

@property(nonatomic,retain) IBOutlet UIImageView *img;
@property(nonatomic,retain) IBOutlet UILabel *carNo;
@property(nonatomic,retain) IBOutlet UILabel *carState;
@property(nonatomic,retain) IBOutlet UIImageView *img2;

@property(nonatomic,retain) IBOutlet UIView *view;

@end
