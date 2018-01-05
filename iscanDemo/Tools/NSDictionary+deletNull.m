//
//  NSDictionary+deletNull.m
//  FeiYang
//
//  Created by 曾洪磊 on 2017/12/21.
//  Copyright © 2017年 曾洪磊. All rights reserved.
//

#import "NSDictionary+deletNull.h"

@implementation NSDictionary (deletNull)
- (NSDictionary *)deleteNull{
    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in self.allKeys) {
        
        if ([[self objectForKey:keyStr] isEqual:[NSNull null]]) {
            
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            
            [mutableDic setObject:[self objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}
@end
