//
//  ZLAlbum+ZLTableRepresentation.h
//  DesignPattern
//
//  Created by account on 15/9/10.
//  Copyright (c) 2015年 zhuli8. All rights reserved.
//

#import "ZLAlbum.h"

@interface ZLAlbum (ZLTableRepresentation)

//注意在方法开头有一个tr_前缀，它是类别TableRepresentation的缩写。再一次，这种约定也可以阻止和其它的方法冲突。
- (NSDictionary *)tr_tableRepresentation;
@end
