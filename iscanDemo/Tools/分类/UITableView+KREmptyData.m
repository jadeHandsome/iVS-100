//
//  UITableView+KREmptyData.m
//  fitnessDog
//
//  Created by kupurui on 17/1/17.
//  Copyright © 2017年 CoderDX. All rights reserved.
//

#import "UITableView+KREmptyData.h"

@implementation UITableView (KREmptyData)
- (void)tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount
{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UIView *back = [[UIView alloc]init];
        
        UIImageView *noDataImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty"]];
        [back addSubview:noDataImage];
        [noDataImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@80);
            make.centerY.equalTo(back.mas_centerY);
            make.centerX.equalTo(back.mas_centerX);
        }];
        [back sizeToFit];
        self.backgroundView = back;
        
//        UILabel *messageLabel = [UILabel new];
//
//        messageLabel.text = message;
//        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//        messageLabel.textColor = [UIColor lightGrayColor];
//        messageLabel.textAlignment = NSTextAlignmentCenter;
//        [messageLabel sizeToFit];
//
//        self.backgroundView = messageLabel;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}
@end
