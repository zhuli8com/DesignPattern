//
//  ZLAlbum+ZLTableRepresentation.m
//  DesignPattern
//
//  Created by account on 15/9/10.
//  Copyright (c) 2015年 zhuli8. All rights reserved.
//

#import "ZLAlbum+ZLTableRepresentation.h"

@implementation ZLAlbum (ZLTableRepresentation)
#pragma mark - getters and setters
- (NSDictionary *)tr_tableRepresentation{
    return @{@"titles":@[@"Artist", @"Album", @"Genre", @"Year"],
             @"values":@[self.artist, self.title, self.genre, self.year]};
}
@end
