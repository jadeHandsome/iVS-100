//
//  KRUserInfo.m
//  Dntrench
//
//  Created by kupurui on 16/10/18.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import "KRUserInfo.h"

@implementation KRUserInfo
singleton_implementation(KRUserInfo)
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
- (NSString *)baseUrl {
    NSString *urltemp=@"http://172.16.22.246:52467/iVS-100/%@";
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *ip=[userDefault valueForKey:@"ip"];
    NSString *port=[userDefault valueForKey:@"port"];
    
    if (ip==nil) {
        ip=@"172.16.22.246";
    }
    if (port==nil) {
        port=@"52467";
    }
    
    urltemp=[NSString stringWithFormat:@"http://%@:%@/iVS-100/%@",ip,port,@"%@"];
    
    return [NSString stringWithFormat:urltemp,@"%@"];
}
- (NSInteger)mapType {
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"map"]) {
        return 1;
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"map"] isEqualToString:Localized(@"高德地图")]) {
        return 1;
    } else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"map"] isEqualToString:Localized(@"百度地图")]) {
        return 2;
    } else {
        return 3;
    }
}
@end
