//
//  KRMyTextView.h
//  Dntrench
//
//  Created by kupurui on 16/10/26.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KRMyTextView : UITextView
@property(nonatomic,copy) NSString *myPlaceholder;  //文字

@property(nonatomic,strong) UIColor *myPlaceholderColor; //文字颜色
@end
