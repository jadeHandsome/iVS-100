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
@property (weak, nonatomic) IBOutlet UILabel *left1;
@property (weak, nonatomic) IBOutlet UILabel *left2;
@property (weak, nonatomic) IBOutlet UILabel *left3;
@property (weak, nonatomic) IBOutlet UILabel *left4;
@property (weak, nonatomic) IBOutlet UILabel *left5;
@property (weak, nonatomic) IBOutlet UILabel *left6;

@end
@implementation KRCustomView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.left1.text = Localized(@"终端ID：");
    self.left2.text = Localized(@"状态：");
    self.left3.text = Localized(@"所属机构：");
    self.left4.text = Localized(@"时间：");
    self.left5.text = Localized(@"速度：");
    self.left6.text = Localized(@"参考位置：");
    
    
}

- (void)click:(UITapGestureRecognizer *)tap; {
    
    NSLog(@"点击了当前的callout -- tag == %ld",tap.view.tag);
    
    return;
}
- (void)setDataWithDic:(NSDictionary *)dic {
    self.IDLabel.text = SharedUserInfo.term.termSn;
    self.statusLabel.text = [SharedUserInfo.term.online integerValue] ? @"在线" : @"离线";
    self.partLabel.text = SharedUserInfo.device.departName;
    self.timeLabel.text = dic[@"time"];
    self.locationView.text = dic[@"location"];
    self.speedLabel.text = [NSString stringWithFormat:@"%@",dic[@"speed"]];
}


@end
