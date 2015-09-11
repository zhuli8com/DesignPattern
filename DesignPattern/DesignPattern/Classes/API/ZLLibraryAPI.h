//
//  ZLLibraryAPI.h
//  DesignPattern
//
//  Created by account on 15/9/10.
//  Copyright (c) 2015年 zhuli8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLAlbum.h"

@interface ZLLibraryAPI : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)getAlbums;
- (void)addAlbums:(ZLAlbum *)album atIndex:(NSInteger)index;
- (void)deleteAlbumAtIndex:(NSInteger)index;
@end
