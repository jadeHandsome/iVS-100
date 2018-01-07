//
//  HDArrange.m
//  cmsv6
//
//  Created by Apple on 13-4-5.
//  Copyright (c) 2013年 babelstar. All rights reserved.
//

#import "HDArrange.h"

@interface HDArrange()

-(void)getXYcount:(HDArrangeType)type xcount:(int*)lpXcnt ycount:(int*)lpYcnt;
-(int)getShowCnt:(HDArrangeType)type;
-(int)getCurrentShowCnt;
-(int)getTotalPage;
-(BOOL)isPointInRect:(CGPoint)point :(CGRect)rect;
-(void)arrangeEx:(CGRect)rcArea type:(HDArrangeType)arrangeType index:(int)pageIndex;

@end

@implementation HDArrange

@synthesize delegate;
@synthesize m_bOnlyOne;
@synthesize m_arrangeTypeNew;
@synthesize m_nPageIndex;
@synthesize m_nShowViewIndex;

- (id)init
{
    self = [super init];
    if (!self)
    {
        self = (HDArrange*)[[NSObject alloc] init];
    }
    originalViewArray = [[ NSMutableArray alloc ]init ];
    viewArray = [[ NSMutableArray alloc ]init ];
    m_arrangeTypeNew = E_ArrangeType_4;
    m_arrangeTypeOld = E_ArrangeType_4;
    m_nShowViewIndex = 0;
    m_nPageIndex = 0;
    m_bOnlyOne = NO;
    memset( m_rectArray, 0x00,sizeof(m_rectArray));
    m_nAllowedShowCnt = MAX_VIEW_CNT;
    
    return self;
}

-(void)dealloc
{
    viewArray = nil;
    originalViewArray = nil;
    [super dealloc ];
}


//添加窗口
-(void)addView:(int)index view:(UIView *)_view
{
    [originalViewArray insertObject:_view atIndex:index ];
    [viewArray insertObject:_view atIndex:index ];
}

-(void)clearAllViews
{
    [viewArray removeAllObjects ];
}


//设置布局
-(void)arrangeView:(CGRect) rcArea type:(HDArrangeType)arrangeType
{
    m_rcOldArea = m_rcNewArea;
    m_rcNewArea = rcArea;
    m_arrangeTypeNew = arrangeType;
    m_arrangeTypeOld = m_arrangeTypeNew;
    
    //根据 m_nStartIndex 所在上一个page来显示布局
    int showCnt = [self getShowCnt: arrangeType ];
    int nPageIndex = m_nShowViewIndex  /showCnt;
    m_nPageIndex = nPageIndex;
    
    [self arrangeEx:rcArea type: arrangeType  index: m_nPageIndex ];
}

-(void)arrangeView
{
    [self arrangeView:m_rcNewArea type:m_arrangeTypeNew];
}

//不包含stopViewIndex
-(void)arrangeEx:(CGRect)rcArea type:(HDArrangeType)arrangeType index:(int)pageIndex
{
    int nRow = 0;
    int nCol = 0;
    [self getXYcount: arrangeType xcount: &nRow ycount: &nCol ];
    int showCnt = nRow * nCol;
    int totalPage = ( [ viewArray count ] + showCnt - 1 ) / showCnt;
    if( pageIndex < 0 || pageIndex >= totalPage )
    {
        return;
    }
    
    int startViewIndex = pageIndex * showCnt;
    int stopViewIndex = startViewIndex + showCnt;
    if( pageIndex == ( totalPage - 1 ) )
    {
        stopViewIndex = [viewArray count ] ;
        startViewIndex = stopViewIndex - showCnt;
        if( startViewIndex < 0 )
        {
            startViewIndex = 0;
        }
    }
    //Howard 2012-11-07
    if( m_nShowViewIndex < startViewIndex || m_nShowViewIndex >= stopViewIndex )
    {
        m_nShowViewIndex = startViewIndex;
    }
    
    float spaceX = 5;//1;
    float spaceY = 60;//1;
    float itemWidth = (SIZEWIDTH - 3 * spaceX) / 2 ;
    float itemHeight = (SIZEWIDTH - 3 * spaceX) / 2 * 3 / 4;
    CGRect rcTemp;
    rcTemp.size.width = itemWidth;
    rcTemp.size.height = itemHeight;
    BOOL bJumpOut = NO;
    
    for( int i = 0 ; i < nCol; ++i )
    {
        for( int k = 0; k < nRow; ++k )
        {
            rcTemp.origin.y = 10 + (spaceY + itemHeight) * k ;
            rcTemp.origin.x = spaceX + (spaceX + itemWidth) * i;
            
            int nIndex = ( k * nCol + i ) + startViewIndex;
            if( nIndex >= stopViewIndex )
            {
                bJumpOut = YES;
                break;
            }
            
            UIView* subView = [viewArray objectAtIndex: nIndex  ];
            subView.frame = rcTemp;
            [subView setNeedsDisplay ]; //为了重绘,刷新窗口
            //[subView setCtrlPos ];//这个方法必须实现！//Howard 2012-11-15
            subView.hidden = NO;
            if (k * 2 + i + 1 > self.num) {
                subView.hidden = YES;
            }
            m_rectArray[ nIndex ] = rcTemp;
        }
        
        if( bJumpOut )
        {
            break;
        }
    }
    
    if( showCnt > ( stopViewIndex - startViewIndex ) )
    {
        showCnt = stopViewIndex - startViewIndex;
    }
    
    //其他隐藏
    for( int n = 0; n < [ viewArray count ]; ++n )
    {
        if( n < startViewIndex || n >= ( startViewIndex + showCnt ) )
        {
            UIView* subView = [viewArray objectAtIndex: n ];
            subView.hidden = YES;
            //[subView stop ];
        }
    }
}

//双击某窗体,切换单窗口显示和多窗口显示
-(void)onDblClk:(int)viewIndex
{
    [UIView beginAnimations:nil context:NULL];//启用动画移动
    [UIView setAnimationDuration: 0.30 ];
    [UIView setAnimationBeginsFromCurrentState:YES ];
    ///////////////////
    
    if( !m_bOnlyOne )
	{
		[self onlyShowOne:viewIndex ];
	}
	else
	{
        //根据 m_nStartIndex 所在上一个page来显示布局
        int showCnt = [self getShowCnt: m_arrangeTypeOld ];
        int nPageIndex =  m_nShowViewIndex  /showCnt;
        m_nPageIndex = nPageIndex;
        [self arrangeEx:m_rcNewArea type:m_arrangeTypeOld index:nPageIndex];
        m_arrangeTypeNew = m_arrangeTypeOld;
	}
	m_bOnlyOne = !m_bOnlyOne ;
    
    /////////////////////
    [UIView commitAnimations];//完成动画移动
    
    [delegate onArrangeChange];
}

-(void)onlyShowOne:(int)viewIndex
{
    m_arrangeTypeNew = E_ArrangeType_1;
    m_nShowViewIndex = viewIndex;
    m_nPageIndex = viewIndex;//修正翻页索引
    
    UIView* viewDest = [ viewArray objectAtIndex: viewIndex ];
    viewDest.hidden = NO;
    viewDest.frame = m_rcNewArea;
    m_rectArray[ viewIndex ] = m_rcNewArea;
    
    //[viewDest setCtrlPos ];//Howard 2012-11-15
    for( int i = 0 ; i < [ viewArray count ]; ++i )
    {
        if( i != viewIndex )
        {
            UIView* view = [ viewArray objectAtIndex: i ];
            view.hidden = YES;
            view.frame = m_rcNewArea;//Howard 2012-10-31
            [view setNeedsDisplay ]; //为了重绘,刷新窗口
            //[view setCtrlPos ];//Howard 2012-11-15
            
        }
    }
}

-(void)getXYcount:(HDArrangeType)type xcount:(int *)lpXcnt ycount:(int *)lpYcnt
{
    switch( type )
    {
        case E_ArrangeType_1:
            *lpXcnt = 1;
            *lpYcnt = 1;
            break;
        case E_ArrangeType_4:
            *lpXcnt = 2;
            *lpYcnt = 2;
            break;
        case E_ArrangeType_10:
            *lpXcnt = 4;
            *lpYcnt = 2;
            break;
        case E_ArrangeType_16:
            *lpXcnt = 8;
            *lpYcnt = 2;
            break;
        default:
            *lpXcnt = 1;
            *lpYcnt = 1;
    }
}

-(int)getShowCnt:(HDArrangeType)type
{
    int showCnt = 0;
    int nRow = 0;
    int nCol = 0;
    [self getXYcount:type xcount:&nRow ycount:&nCol ];
    showCnt = nRow * nCol;
    return showCnt;
}

-(int)getCurrentShowCnt
{
    return [self getShowCnt:m_arrangeTypeNew  ];
}

-(int)getTotalPage
{
    int showCnt = [self getCurrentShowCnt ];
    //Howard 2012-11-12
    int totalCnt = ( m_nAllowedShowCnt < [viewArray count ] ? m_nAllowedShowCnt : [ viewArray count ] );
    int totalPage = (  totalCnt + showCnt - 1 )/ showCnt;//[ viewArray count ]
    return totalPage;
}

-(void)gotoPage:(int)pageIndex
{
    int showCnt = [self getCurrentShowCnt ];
    int totalCnt = ( m_nAllowedShowCnt < [ viewArray count ] ? m_nAllowedShowCnt : [ viewArray count ] );
    
    int totalPage = ( totalCnt  + showCnt - 1 )/ showCnt;
    if( pageIndex >= 0 && pageIndex < totalPage && m_nPageIndex != pageIndex )
    {
        m_nPageIndex = pageIndex;
        [self arrangeEx:m_rcNewArea type:m_arrangeTypeNew index:pageIndex ];
    }
}

-(void)previousPage
{
    int totalPage = [self getTotalPage ];
    int nPageIndex = m_nPageIndex;
    --nPageIndex;
    if( nPageIndex < 0 )
    {
        nPageIndex = totalPage - 1;
    }
    
    [self gotoPage: nPageIndex ];

    [delegate onArrangeChange];
}

-(void)nextPage
{
    int totalPage = [self getTotalPage ];
    int nPageIndex = m_nPageIndex;
    ++nPageIndex;
    if( nPageIndex >= totalPage )
    {
        nPageIndex = 0;
    }
    [self gotoPage: nPageIndex ];
    
    [delegate onArrangeChange];
}

//放大，可见窗口数由多到少
-(void)zoomIn
{
    int nTypeIndex = m_arrangeTypeNew;
    --nTypeIndex;
    if( nTypeIndex >= E_ArrangeType_1 )
    {
        [UIView beginAnimations:nil context:NULL];//启用动画移动
        [UIView setAnimationDuration: 0.20 ];
        [UIView setAnimationBeginsFromCurrentState:YES ];
        [self arrangeView:m_rcNewArea type:(HDArrangeType)nTypeIndex ];
        [UIView commitAnimations];//完成动画移动
    }
}

//缩小，可见窗口数由少到多
-(void)zoomOut
{
    int nTypeIndex = m_arrangeTypeNew;
    ++nTypeIndex;
    if( nTypeIndex <= E_ArrangeType_16 )
    {
        [UIView beginAnimations:nil context:NULL];//启用动画移动
        [UIView setAnimationDuration: 0.20 ];
        [UIView setAnimationBeginsFromCurrentState:YES ];
        [self arrangeView:m_rcNewArea type:(HDArrangeType)nTypeIndex ];
        [UIView commitAnimations];//完成动画移动
    }
}

-(BOOL)isPointInRect:(CGPoint)point :(CGRect)rect
{
    if( point.x >= rect.origin.x && point.y >= rect.origin.y )
    {
        CGPoint pt2 = CGPointMake( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height );
        if( point.x <= pt2.x && point.y <= pt2.y )
        {
            return YES;
        }
    }
    
    return NO;
}

-(int)getViewIndex:(CGPoint)point
{
    for( int i = 0 ; i < [viewArray count ]; ++i )
    {
        UIView* view = [viewArray objectAtIndex: i ];
        if( ( NO == view.hidden) && [self isPointInRect:point :view.frame ] )
        {
            return i ;
        }
    }
    
    return 0;
}


-(void)setChannelCnt:(int)channelCnt
{
    if( channelCnt > 0 && channelCnt < [ originalViewArray count ] )
    {
        m_nAllowedShowCnt = channelCnt;
    }
}

-(int)getSelViewIndex
{
    return m_nShowViewIndex;
}

//判断是否可以翻页
-(BOOL)isEnabledTurnPage
{
    //全部显示出来就不能翻页
    int showCnt = 0;
    for( id temp in viewArray )
    {
        UIView* view = (UIView*)temp;
        if( NO == view.hidden )
        {
            ++ showCnt;
        }
    }
    
    return ( showCnt < m_nAllowedShowCnt );
}



@end
