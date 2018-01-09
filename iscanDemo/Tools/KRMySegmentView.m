//
//  KRMySegmentView.m
//  AlementHome
//
//  Created by 曾洪磊 on 2017/12/5.
//  Copyright © 2017年 曾洪磊. All rights reserved.
//

#import "KRMySegmentView.h"
typedef void(^clickHandle)(NSInteger index);
@interface KRMySegmentView()
@property (nonatomic, strong) NSArray *segemenArray;
@property (nonatomic, strong) clickHandle block;
@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation KRMySegmentView
- (NSArray *)segemenArray {
    if (!_segemenArray) {
        _segemenArray = [NSArray array];
    }
    return _segemenArray;
}
- (UIColor *)defaultColor {
    if (!_defaultColor) {
        _defaultColor = LRRGBColor(152, 152, 152);
    }
    return _defaultColor;
}
- (UIColor *)selectColor {
    if (!_selectColor) {
        _selectColor = ThemeColor;
    }
    return _selectColor;
}
- (instancetype)initWithFrame:(CGRect)frame andSegementArray:(NSArray *)segementArray andColorArray:(NSArray *)colorArray andClickHandle:(void (^)(NSInteger))clickHandle {
    if (self = [super initWithFrame:frame]) {
        self.segemenArray = [segementArray copy];
        self.block = clickHandle;
        if (colorArray.count == 2) {
            self.defaultColor = colorArray[0];
            self.selectColor = colorArray[1];
        }
        [self setUpSegement];
    }
    return self;
}
- (void)setUpSegement {
    UIView *temp = self;
    for (int i = 0; i < self.segemenArray.count; i ++) {
        UIButton *clickBtn = [[UIButton alloc]init];
        [self addSubview:clickBtn];
        [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(temp.mas_left);
            } else {
                make.left.equalTo(temp.mas_right);
            }
            if (i == self.segemenArray.count - 1) {
                make.right.equalTo(self.mas_right);
            }
            if (i > 0) {
                make.width.equalTo(temp.mas_width);
            }
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        if (i == 0) {
            clickBtn.selected = YES;
        }
        clickBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        clickBtn.tag = 100 + i;
        [clickBtn addTarget:self action:@selector(clickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [clickBtn setTitleColor:self.defaultColor forState:UIControlStateNormal];
        [clickBtn setTitleColor:self.selectColor forState:UIControlStateSelected];
        [clickBtn setTitle:Localized(self.segemenArray[i]) forState:UIControlStateNormal];
        temp = clickBtn;
        
    }
    self.lineView = [[UIView alloc]init];
    [self addSubview:self.lineView];
    CGSize size = [KRBaseTool getNSStringSize:self.segemenArray[0] andViewWight:MAXFLOAT andFont:15];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@2);
        make.width.equalTo(@(SCREEN_WIDTH * 1.0 / self.segemenArray.count));
        make.centerX.equalTo([self viewWithTag:100].mas_centerX);
    }];
    _lineView.backgroundColor = ThemeColor;
}
- (void)clickBtnClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected = NO;
        }
    }
    NSString *str = self.segemenArray[sender.tag - 100];
    CGSize size = [KRBaseTool getNSStringSize:str andViewWight:MAXFLOAT andFont:15];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sender.mas_centerX);
        make.width.equalTo(@(SCREEN_WIDTH * 1.0 / self.segemenArray.count));
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@2);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        sender.selected = YES;
        if (self.block) {
            self.block(sender.tag - 100);
        }
    } ];
    
}
- (void)reloadData {
    for (UIButton *sub in self.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            [sub setTitle:Localized(self.segemenArray[[self.subviews indexOfObject:sub]]) forState:UIControlStateNormal];
        }
    }
}
- (void)setSelectIndex:(NSInteger)index {
    UIButton *sender = [self viewWithTag:index + 100];
    [self clickBtnClick:sender];
}
@end
