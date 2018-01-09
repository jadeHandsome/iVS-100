//
//  SettingViewController.h
//  iVS-100
//
//  Created by 曾洪磊 on 2018/1/5.
//  Copyright © 2018年 hilook.com. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^lauDidChange)(void);
@interface SettingViewController : BaseViewController
@property (nonatomic, assign) BOOL canPop;
@property (nonatomic, strong) lauDidChange block;
@end
