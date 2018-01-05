//
//  SettingBean.h
//  iscanMCSdk
//
//  Created by xsz on 8/3/17.
//  Copyright © 2017 hilook.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingBean : NSObject
{
    NSString *ip;
    NSString *port;
    NSString *numbers;
    NSString *interval;
    NSString *nettype;
}
@property (nonatomic, copy) NSString* ip;
@property (nonatomic, copy) NSString* port;
@property (nonatomic, copy) NSString* numbers;
@property (nonatomic, copy) NSString* interval;
@property (nonatomic, copy) NSString* nettype;
@end
