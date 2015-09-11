//
//  ZLAlbumView.m
//  DesignPattern
//
//  Created by account on 15/9/10.
//  Copyright (c) 2015年 zhuli8. All rights reserved.
//

#import "ZLAlbumView.h"

@interface ZLAlbumView ()

@property (nonatomic,strong) UIImageView *imageView;/**<专辑封面图*/
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;/**<通过旋转来指示封面图正在下载的指示器*/
@property (nonatomic,assign) CGRect tempSize;
@end

@implementation ZLAlbumView

#pragma mark - life cycles
- (instancetype)initWithFrame:(CGRect)frame albumCover:(NSString *)albumCover{
    if (self=[super init]) {
        self.tempSize=frame;
        
        self.backgroundColor=[UIColor blackColor];
        [self addSubview:self.imageView];
        [self addSubview:self.indicatorView];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kZLDownloadImageNotification object:self userInfo:@{@"imageView":self.imageView,@"coverUrl":albumCover}];
    }
    return self;
}

- (void)dealloc{
    [self.imageView removeObserver:self forKeyPath:@"image"];
}

#pragma mark - private methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"image"]) {
        [self.indicatorView stopAnimating];
    }
}

#pragma mark - getters and setters
- (UIImageView *)imageView{
    if (!_imageView) {
        //5像素的margin
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.tempSize.size.width-10, self.tempSize.size.height-10)];
        [_imageView addObserver:self forKeyPath:@"image" options:0 context:nil];
    }
    return _imageView;
}

- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView=[[UIActivityIndicatorView alloc] init];
        _indicatorView.center=self.imageView.center;
        _indicatorView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
        [_indicatorView startAnimating];//用KVO进行停止
    }
    return _indicatorView;
}
@end
