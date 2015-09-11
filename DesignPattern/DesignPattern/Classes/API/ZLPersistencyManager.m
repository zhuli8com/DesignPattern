//
//  ZLPersistencyManager.m
//  DesignPattern
//
//  Created by account on 15/9/10.
//  Copyright (c) 2015年 zhuli8. All rights reserved.
//

#import "ZLPersistencyManager.h"

@interface ZLPersistencyManager ()
@property (nonatomic,strong) NSMutableArray *albums;
@end

@implementation ZLPersistencyManager

- (NSArray *)getAlbums{
    return self.albums;
}

- (void)addAlbums:(ZLAlbum *)album atIndex:(NSInteger)index{
    if (self.albums.count>=index) {
        [self.albums insertObject:album atIndex:index];
    }else{
        [self.albums addObject:album];
    }
}

- (void)deleteAlbumAtIndex:(NSInteger)index{
    [self.albums removeObjectAtIndex:index];
}

- (void)saveImage:(UIImage *)image filename:(NSString *)filename{
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:filename atomically:YES];
}

-(UIImage *)getImage:(NSString *)filename{
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSData *data = [NSData dataWithContentsOfFile:filename];
    return [UIImage imageWithData:data];
}

#pragma mark - getters and setters
- (NSMutableArray *)albums{
    if (_albums==nil) {
        _albums=[NSMutableArray array];
        _albums=[NSMutableArray arrayWithArray:@[
                                                 [[ZLAlbum alloc] initWithTitle:@"Best of Bowie" artist:@"David Bowie" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_david%20bowie_best%20of%20bowie.png" year:@"1992"],
                                                 [[ZLAlbum alloc] initWithTitle:@"It's My Life" artist:@"No Doubt" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_no%20doubt_its%20my%20life%20%20bathwater.png" year:@"2003"],
                                                 [[ZLAlbum alloc] initWithTitle:@"Nothing Like The Sun" artist:@"Sting" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_sting_nothing%20like%20the%20sun.png" year:@"1999"],
                                                 [[ZLAlbum alloc] initWithTitle:@"Staring at the Sun" artist:@"U2" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_u2_staring%20at%20the%20sun.png" year:@"2000"],
                                                 [[ZLAlbum alloc] initWithTitle:@"American Pie" artist:@"Madonna" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_madonna_american%20pie.png" year:@"2000"]
                                                 ]];
    }
    return _albums;
}
@end
