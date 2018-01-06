//
//  KRCustomView.m
//  fitnessDog
//
//  Created by kupurui on 16/11/23.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import "KRCustomView.h"
#import "UIImageView+WebCache.h"
@interface KRCustomView()
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *partLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationView;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@end
@implementation KRCustomView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
}

- (void)click:(UITapGestureRecognizer *)tap; {
    
    NSLog(@"点击了当前的callout -- tag == %ld",tap.view.tag);
    
    return;
}
- (void)setDataWithDic:(NSDictionary *)dic {
    self.IDLabel.text = dic[@"devIdno"];
    self.statusLabel.text = [dic[@"online"] integerValue] ? @"在线" : @"离线";
    self.partLabel.text = dic[@""];
    self.timeLabel.text = dic[@""];
}


@end
