//
//  ZLHorizontalScroller.m
//  DesignPattern
//
//  Created by account on 15/9/10.
//  Copyright (c) 2015年 zhuli8. All rights reserved.
//

#import "ZLHorizontalScroller.h"

#define VIEW_PADDING 10  
#define VIEW_DIMENSIONS 100  
#define VIEWS_OFFSET 100  

@interface ZLHorizontalScroller () <UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scroller;
@end

@implementation ZLHorizontalScroller

#pragma mark - life cycles 
/**
 *  当数据已经发生改变的时候，你要执行reload方法。当增加HorizontalScroller到另外一个视图的时候，你也需要调用reload方法。增加下面的代码来实现后面一种场景。
 didMoveToSuperview方法会在视图被增加到另外一个视图作为子视图的时候调用，这正式重新加载滚动视图的最佳时机。
 */
- (void)didMoveToSuperview{
    [self reload];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.scroller];
    }
    return self;
}

- (void)reload{
    //如果没有委托，那么不需要做任何事情，仅仅返回即可。
    if (!self.delegate) {
        return;
    }
    
    //移除之前添加到滚动视图的子视图
    [self.scroller.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    //所有的视图的位置从给定的偏移量开始。当前的偏移量是100，它可以通过改变文件头部的#DEFINE来很容易的调整。
    CGFloat xValue=VIEWS_OFFSET;
    for (int i=0; i<[self.delegate numberOfViewsForHorizontalScroller:self]; i++) {
        //HorizontalScroller每次从委托请求视图对象，并且根据预先设置的边框来水平的放置这些视图。
        xValue+=VIEW_PADDING;
        UIView *view=[self.delegate horizontalScroller:self viewAtIndex:i];
        view.frame=CGRectMake(xValue, VIEW_PADDING, VIEW_DIMENSIONS, VIEW_DIMENSIONS);
        [self.scroller addSubview:view];
        
        xValue+=VIEW_DIMENSIONS+VIEW_PADDING;
    }
    
    //一旦所有视图都设置好了以后，设置UIScrollerView的内容偏移（contentOffset）以便用户可以滚动的查看所有的专辑封面。
    [self.scroller setContentSize:CGSizeMake(xValue+VIEWS_OFFSET, self.frame.size.height)];
    
    //HorizontalScroller检测是否委托实现了initialViewIndexForHorizontalScroller:方法，这个检测是需要的，因为这个方法是可选的。如果委托没有实现这个方法，0就是缺省值。最后设置滚动视图为协议规定的初始化视图的中间。
    if ([self.delegate respondsToSelector:@selector(initialViewIndexForHorizontalScroller:)]) {
        NSInteger initialView=[self.delegate initialViewIndexForHorizontalScroller:self];
        [self.scroller setContentOffset:CGPointMake(initialView*(VIEW_DIMENSIONS+(2*VIEW_PADDING)), 0) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self centerCurrentView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self centerCurrentView];
}

#pragma mark -getters and setters
- (UIScrollView *)scroller{
    if (!_scroller) {
        _scroller=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scroller.delegate=self;
        UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapped:)];
        [_scroller addGestureRecognizer:tapGestureRecognizer];
    }
    return _scroller;
}

#pragma mark - private methods
- (void)scrollerTapped:(UITapGestureRecognizer *)gesture{
    CGPoint location=[gesture locationInView:gesture.view];
    
    for (int index=0;index<[self.delegate numberOfViewsForHorizontalScroller:self];index++) {
        UIView *view=self.scroller.subviews[index];
        if (CGRectContainsPoint(view.frame, location)) {
            [self.delegate horizontalScroller:self clickedViewAtIndex:index];
            [self.scroller setContentOffset:CGPointMake(view.frame.origin.x-self.frame.size.width/2+view.frame.size.width/2, 0) animated:YES];
            break;
        }
    }
}

- (void)centerCurrentView{
    int xFinal = self.scroller.contentOffset.x + (VIEWS_OFFSET/2) + VIEW_PADDING;
    int viewIndex = xFinal / (VIEW_DIMENSIONS+(2*VIEW_PADDING));
    xFinal = viewIndex * (VIEW_DIMENSIONS+(2*VIEW_PADDING));
    [self.scroller setContentOffset:CGPointMake(xFinal,0) animated:YES];
    //一当子视图被置中，你将需要将这种变化通知委托
    [self.delegate horizontalScroller:self clickedViewAtIndex:viewIndex];
}

@end
