//
//  KRMySegmentView.h
//  AlementHome
//
//  Created by 曾洪磊 on 2017/12/5.
//  Copyright © 2017年 曾洪磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KRMySegmentView : UIView
- (void)setSelectIndex:(NSInteger)index;
- (instancetype)initWithFrame:(CGRect)frame andSegementArray:(NSArray *)segementArray andColorArray:(NSArray *)colorArray andClickHandle:(void(^)(NSInteger index))clickHandle;
@end
