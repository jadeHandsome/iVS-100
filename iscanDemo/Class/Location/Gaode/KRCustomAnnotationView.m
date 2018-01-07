//
//  KRCustomAnnotationView.m
//  fitnessDog
//
//  Created by kupurui on 16/11/23.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import "KRCustomAnnotationView.h"
#import "UIImageView+WebCache.h"
#import "KRUserInfo.h"
@implementation KRCustomAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.block) {
        self.block(selected);
    }
    
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
    
    [super setSelected:selected animated:animated];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        CGPoint tempoint = [self.calloutView convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.calloutView.bounds, tempoint))
        {
            view = self.calloutView;
        }
    }
    return view;
}
@end
