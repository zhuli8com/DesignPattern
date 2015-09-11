//
//  ZLLibraryAPI.m
//  DesignPattern
//
//  Created by account on 15/9/10.
//  Copyright (c) 2015年 zhuli8. All rights reserved.
//

#import "ZLLibraryAPI.h"
#import "ZLPersistencyManager.h"
#import "ZLHTTPClient.h"

@interface ZLLibraryAPI ()
@property (nonatomic,strong) ZLPersistencyManager *persistencyManager;
@property (nonatomic,strong) ZLHTTPClient *httpClient;
@property (nonatomic,assign) BOOL isOnline;/**<服务器中任何专辑数据的改变是否应该更新，例如增加或者删除专辑。HTTP 客户端实际上不会真正的和一个服务器交互，它在这里仅仅是用来演示门面模式的使用，所以isOnline将总是NO*/
@end

@implementation ZLLibraryAPI

- (instancetype)init{
    if (self=[super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadImage:) name:kZLDownloadImageNotification object:nil];
    }
    return self;
}

/**
 *  downloadImage方法是通过通知被执行的，所以通知对象会当作参数传递。UIImageView和图片URL都会从通知中获取。
 */
- (void)downloadImage:(NSNotification *)notification{
    UIImageView *imageView=notification.userInfo[@"imageView"];
    NSString *coverUrl=notification.userInfo[@"coverUrl"];
    
    //如果图片已经被下载过了，直接从PersistencyManager方法获取。
    imageView.image=[self.persistencyManager getImage:[coverUrl lastPathComponent]];
    if (imageView.image==nil) {//如果图片还没有被下载，通过HTTPClient去获取它。
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image=[self.httpClient downloadImage:coverUrl];
            
            dispatch_sync(dispatch_get_main_queue(), ^{//当图片下载的时候，将它显示在UIImageView中，同时使用PersistencyManager保存到本地。
                imageView.image=image;
                [self.persistencyManager saveImage:image filename:coverUrl.lastPathComponent];
            });
        });
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sharedInstance{
    //声明一个静态变量去保存类的实例，确保它在类中的全局可用性。
    static ZLLibraryAPI *instance=nil;
    //声明一个静态变量确保初始化代码只执行一次
    static dispatch_once_t onceToken;
    //一旦类已经被初始化，初始化永远不会再被调用
    dispatch_once(&onceToken, ^{
        instance=[[self alloc] init];
    });
    return instance;
}

- (NSArray *)getAlbums{
    return [self.persistencyManager getAlbums];
}

/**
 *  这个类首先更新本地的数据，然后如果有网络连接，它更新远程服务器。这就是外观模式的强大之处。当某些外部的类增加一个新的专辑的时候，它不知道也不需要知道背后的复杂性。
 */
- (void)addAlbums:(ZLAlbum *)album atIndex:(NSInteger)index{
    [self.persistencyManager addAlbums:album atIndex:index];
    
    if (self.isOnline) {
        [self.httpClient postRequest:@"/api/addAlbum" body:album.description];
    }
}

- (void)deleteAlbumAtIndex:(NSInteger)index{
    [self.persistencyManager deleteAlbumAtIndex:index];
    
    if (self.isOnline) {
        [self.httpClient postRequest:@"/api/deleteAlum" body:@(index).description];
    }
}

#pragma mark - getters and setters
- (ZLPersistencyManager *)persistencyManager{
    if (_persistencyManager==nil) {
        _persistencyManager=[[ZLPersistencyManager alloc] init];
    }
    return _persistencyManager;
}

- (ZLHTTPClient *)httpClient{
    if (!_httpClient) {
        _httpClient=[[ZLHTTPClient alloc] init];
    }
    return _httpClient;
}
@end
