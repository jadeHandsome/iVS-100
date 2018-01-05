//
//  CollectionViewCell.m
//  iVS-100
//
//  Created by 曾洪磊 on 2018/1/4.
//  Copyright © 2018年 hilook.com. All rights reserved.
//

#import "CollectionViewCell.h"
@interface CollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end
@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    LRViewBorderRadius(self.mainImageView, 5, 0, [UIColor clearColor]);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick)];
    self.mainImageView.userInteractionEnabled = YES;
    [self.mainImageView addGestureRecognizer:tap];
}
- (void)setDataWith:(NSDictionary *)dic {
    [self.mainImageView sd_setImageWithURL:dic[@"imgPath"] placeholderImage:[UIImage new]];
    NSString *str = [NSString stringWithFormat:@"%@\n%@",dic[@"channelName"],dic[@"createDate"]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttributes:@{NSForegroundColorAttributeName:LRRGBColor(61, 61, 61)} range:[str rangeOfString:dic[@"createDate"]]];
    
}
- (void)imageClick {
    if (self.block) {
        self.block(self.row);
    }
}
@end
