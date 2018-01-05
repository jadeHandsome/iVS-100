//
//  HDArrange.h
//  cmsv6
//
//  Created by Apple on 13-4-5.
//  Copyright (c) 2013年 babelstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define MAX_VIEW_CNT       16   //32

@protocol HDArrangeDelegate <NSObject>
- (void)onArrangeChange;
@end

typedef enum HDArrangeType: NSUInteger {
    E_ArrangeType_1     = 1,
    E_ArrangeType_4     = 2,
    E_ArrangeType_9     = 3,
    E_ArrangeType_16    = 4
} HDArrangeType;

@interface HDArrange : NSObject
{
    id<HDArrangeDelegate> delegate;
    NSMutableArray* originalViewArray;  //窗体数组      //原始的
    NSMutableArray* viewArray;          //窗体数组      //用于播放的，具体数目和通道数相关
    CGRect m_rectArray[ MAX_VIEW_CNT ]; //显示区域数组
    CGRect m_rcNewArea;                 //显示区域
    CGRect m_rcOldArea;                 //上次显示区域
    HDArrangeType m_arrangeTypeNew;     //布局类型
    HDArrangeType m_arrangeTypeOld;     //上一次非单窗口显示类型
    int m_nShowViewIndex;               //显示单窗口时的窗口索引
    BOOL m_bOnlyOne;                    //当前是否只显示了一个窗口
    int m_nPageIndex;                   //页面，用于翻页
    int m_nAllowedShowCnt;              //允许显示最大窗体数，和通道数目相关
}

@property(nonatomic,assign) id<HDArrangeDelegate> delegate;
@property(nonatomic, assign ) BOOL m_bOnlyOne;            //通道号
@property(nonatomic, assign ) int m_nPageIndex;                   //页面，用于翻页
@property(nonatomic, assign ) int m_nShowViewIndex;
@property(nonatomic, assign ) HDArrangeType m_arrangeTypeNew;          //窗口序号

//添加窗口
-(void)addView:(int)index view:(UIView*)_view;
-(void)clearAllViews;
//设置最大通道数目
-(void)setChannelCnt:(int)channelCnt;

//设置布局
-(void)arrangeView:(CGRect) rcArea type:(HDArrangeType)arrangeType;
//双击某窗体,切换单窗口显示和多窗口显示
-(void)onDblClk:(int)viewIndex;
-(void)onlyShowOne:(int)viewIndex;
-(int)getViewIndex:(CGPoint)point;
-(void)arrangeView;

//翻页操作
-(void)gotoPage:(int)pageIndex;
-(void)previousPage;
-(void)nextPage;
//缩放操作，本质是单个窗体<==>全部窗体 各种布局的变化
-(void)zoomIn;//放大，可见窗口数由多到少
-(void)zoomOut;//缩小，可见窗口数由少到多

-(int)getSelViewIndex;

//判断是否可以翻页
-(BOOL)isEnabledTurnPage;

@end
