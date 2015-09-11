//
//  ZLPersistencyManager.h
//  DesignPattern
//
//  Created by account on 15/9/10.
//  Copyright (c) 2015年 zhuli8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZLAlbum.h"

@interface ZLPersistencyManager : NSObject

- (NSArray *)getAlbums;
- (void)addAlbums:(ZLAlbum *)album atIndex:(NSInteger)index;
- (void)deleteAlbumAtIndex:(NSInteger)index;

- (void)saveImage:(UIImage*)image filename:(NSString*)filename;

- (UIImage*)getImage:(NSString*)filename;
@end
