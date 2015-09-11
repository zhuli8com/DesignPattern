//
//  ZLAlbum.m
//  DesignPattern
//
//  Created by account on 15/9/10.
//  Copyright (c) 2015年 zhuli8. All rights reserved.
//

#import "ZLAlbum.h"
#import <objc/runtime.h>

@implementation ZLAlbum

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    unsigned int outCount=0;
    objc_property_t *properties= class_copyPropertyList([self class], &outCount);
    for (int i=0; i<outCount; i++) {
        objc_property_t property=properties[i];
        
        const char *name=property_getName(property);
        
        [aCoder encodeObject:self forKey:[NSString stringWithUTF8String:name]];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder{

    if (self=[super init]) {
        _year = [aDecoder decodeObjectForKey:@"year"];
        _title = [aDecoder decodeObjectForKey:@"album"];
        _artist = [aDecoder decodeObjectForKey:@"artist"];
        _coverUrl = [aDecoder decodeObjectForKey:@"cover_url"];
        _genre = [aDecoder decodeObjectForKey:@"genre"];
    }
    return self;
}

/**
 *  根据指定的参数实例化对象，由于对应的属性为只读属性没有生成setter方法，所以应该使用实例变量来进行赋值
 */
- (instancetype)initWithTitle:(NSString *)title artist:(NSString *)artist coverUrl:(NSString *)coverUrl year:(NSString *)year{
    if (self=[super init]) {
        //self.title=title;//error:只读属性
        _title=title;
        _artist=artist;
        _coverUrl=coverUrl;
        _year=year;
        _genre=@"流行";
    }
    return self;
}
@end
