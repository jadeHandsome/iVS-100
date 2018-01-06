//
//  CLTreeView_LEVEL0_Cell.m
//  CLTreeView
//
//  Created by 钟由 on 14-9-9.
//  Copyright (c) 2014年 flywarrior24@163.com. All rights reserved.
//

#import "CLTreeView_LEVEL0_Cell.h"
#define LEFT_MARGIN 10
#define TOP_MARGIN   5

#define HEAD_IMG_LEFT_MARGIN 100  // 头像与名字间的间隔
#define HEADER_IMG_WIDTH 20
#define HEADER_IMG_HEIGHT 20
#define NAME_LABEL_WIDTH 100
#define NAME_LABEL_HEIGHT 25
#define SIG_LABEL_WIDTH 150
#define SIG_LABEL_HEIGHT 15

@implementation CLTreeView_LEVEL0_Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.imgView setClipsToBounds:YES];
        
        //头像
//        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_MARGIN, TOP_MARGIN, HEADER_IMG_WIDTH, HEADER_IMG_HEIGHT)];
//        [self.contentView addSubview:_imgView];
//        
//        //名字
//        _name = [[UILabel alloc]initWithFrame:CGRectMake(HEADER_IMG_WIDTH+HEAD_IMG_LEFT_MARGIN, TOP_MARGIN, NAME_LABEL_WIDTH, NAME_LABEL_HEIGHT)];
//        _name.backgroundColor  = [UIColor clearColor];
//        _name.font = [UIFont systemFontOfSize:15];
//        [self.contentView addSubview:_name];
//        
//        //个性签名
//        _signture = [[UILabel alloc]initWithFrame:CGRectMake(HEADER_IMG_WIDTH+HEAD_IMG_LEFT_MARGIN, NAME_LABEL_HEIGHT+TOP_MARGIN, SIG_LABEL_WIDTH, SIG_LABEL_HEIGHT)];
//        _signture.backgroundColor  = [UIColor clearColor];
//        _signture.textColor = [UIColor lightGrayColor];
//        _signture.font = [UIFont systemFontOfSize:10];
//        [self.contentView addSubview:_signture];
        
//        _arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(290, 5, 50, 50)];
//        [self.contentView addSubview:_arrowView];
        
        //分割线
//        _imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_MARGIN, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame)-LEFT_MARGIN, 1)];
//        [self.contentView addSubview:_imageLine];
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
    int addX = _node.nodeshowLevel*25; //根据节点所在的层次计算平移距离
    CGRect imgFrame = _imgView.frame;
    imgFrame.origin.x = 10 + addX;
    _imgView.frame = imgFrame;
    
    CGRect nameFrame = _name.frame;
    nameFrame.origin.x = 70 + addX;
    _name.frame = nameFrame;
    
    CGRect signtureFrame = _signture.frame;
    signtureFrame.origin.x = 70 + addX;
    _signture.frame = signtureFrame;
}

- (void)dealloc
{
    [_imgView release];
    [_name release];
    [_signture release];
    [_arrowView release];
//    [_imageLine release];
    [super dealloc];
}

@end
