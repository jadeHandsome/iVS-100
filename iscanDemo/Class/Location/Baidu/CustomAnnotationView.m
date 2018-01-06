//
//  CustomAnnotationView.m
//  iVS-100
//
//  Created by 曾洪磊 on 2018/1/6.
//  Copyright © 2018年 hilook.com. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setSelected:(BOOL)selected
{
    
    if (self.selected == selected)
    {
        
        return;
        
        
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            self.calloutView = [[[NSBundle mainBundle]loadNibNamed:@"KRCustomView" owner:self options:nil]firstObject];
            self.calloutView.frame = CGRectMake(0, 150, SCREEN_WIDTH - 30, 150);
            
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y + 150 + 20);
            
            [self.calloutView setDataWithDic:self.myData];
            //            [self.calloutView setData];
        }
        
        //        if (![KRUserInfo sharedKRUserInfo].canCallOut) {
        [self addSubview:self.calloutView];
        //            [KRUserInfo sharedKRUserInfo].canCallOut = YES;
        
        //        } else {
        
        //        }
        
        //self.block(self.myData);
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected];
}

@end
