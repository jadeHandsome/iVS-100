//
//  CLTreeView_LEVEL2_Cell.m
//  CLTreeView
//
//  Created by 钟由 on 14-9-9.
//  Copyright (c) 2014年 flywarrior24@163.com. All rights reserved.
//

#import "CLTreeView_LEVEL2_Cell.h"

@implementation CLTreeView_LEVEL2_Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    int addX = _node.nodeshowLevel;
    addX = (addX<0?1:addX)*25; //根据节点所在的层次计算平移距离
    
    CGRect imgFrame = _headImg.frame;
    imgFrame.origin.x = 14 + addX;
//    _headImg.frame = imgFrame;
    
    CGRect nameFrame = _name.frame;
    nameFrame.origin.x = 45 + addX;
//    _name.frame = nameFrame;
    
//    CGRect signtureFrame = _signture.frame;
//    signtureFrame.origin.x = 62 + addX;
//    _signture.frame = signtureFrame;
//    CGRect tailImgFrame = _tailImg.frame;
//    tailImgFrame.origin.x = self.frame.size.width-_tailImg.frame.size.width-30;
//    _tailImg.frame = tailImgFrame;
    [self.tailImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(14 + addX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(35 + addX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.statuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tailImg.mas_centerY);
        make.right.equalTo(self.tailImg.mas_left).with.offset(-10);
    }];
}

- (void)dealloc {
    [_headImg release];
    [_tailImg release];
    [super dealloc];
}
@end
