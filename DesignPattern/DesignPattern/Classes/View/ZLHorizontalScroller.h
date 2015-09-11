//
//  ZLHorizontalScroller.h
//  DesignPattern
//
//  Created by account on 15/9/10.
//  Copyright (c) 2015年 zhuli8. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLHorizontalScroller;

@protocol ZLHorizontalScrollerDelegate <NSObject>

@required
/**
 *  视图的数量
 */
- (NSInteger)numberOfViewsForHorizontalScroller:(ZLHorizontalScroller *)scroller;

/**
 *  指定索引位置的视图
 */
- (UIView *)horizontalScroller:(ZLHorizontalScroller *)scroller viewAtIndex:(NSInteger)index;

/**
 *  用户点击视图后的行为
 */
- (void)horizontalScroller:(ZLHorizontalScroller *)scroller clickedViewAtIndex:(NSInteger)index;

@optional
/**
 *  可选方法-初始化视图
 */
- (NSInteger)initialViewIndexForHorizontalScroller:(ZLHorizontalScroller *)scroller;
@end

@interface ZLHorizontalScroller : UIView

@property (nonatomic,weak) id<ZLHorizontalScrollerDelegate> delegate;
- (void)reload;
@end
