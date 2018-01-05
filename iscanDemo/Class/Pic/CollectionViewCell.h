//
//  CollectionViewCell.h
//  iVS-100
//
//  Created by 曾洪磊 on 2018/1/4.
//  Copyright © 2018年 hilook.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^image_click)(NSInteger tags);
@interface CollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) image_click block;
- (void)setDataWith:(NSDictionary *)dic;
@end
