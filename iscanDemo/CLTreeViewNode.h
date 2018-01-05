//
//  CLTreeViewNode.h
//  CLTreeView
//
//  Copyright (c) 2014年 flywarrior24@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLTreeViewNode : NSObject

@property (nonatomic) int nodeLevel; //节点所处层次
@property (nonatomic) int nodeshowLevel; //节点显示的层次
@property (nonatomic) int type; //节点类型
@property (nonatomic) int onlineDevCnt; //在线设备数量
@property (nonatomic) int totalDevCnt; //设备数量
@property (nonatomic,retain) id nodeData;//节点数据
@property (nonatomic,retain) NSDictionary* nodeValue;//节点数据
@property (nonatomic) BOOL isExpanded;//节点是否展开
@property (strong,nonatomic) NSMutableArray *sonNodes;//子节点

@end
