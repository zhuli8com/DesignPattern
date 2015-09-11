//
//  ZLAlbum.h
//  DesignPattern
//  音乐库专辑模型类
//  Created by account on 15/9/10.
//  Copyright (c) 2015年 zhuli8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLAlbum : NSObject <NSCoding>

//希望对象创建以后不要再修改属性，所以此处设置为readonly
@property (nonatomic,strong,readonly) NSString *title;/**<专辑名*/
@property (nonatomic,strong,readonly) NSString *artist;/**<艺术家*/
@property (nonatomic,strong,readonly) NSString *genre;/**<流派*/
@property (nonatomic,strong,readonly) NSString *coverUrl;/**<专辑封面URL*/
@property (nonatomic,strong,readonly) NSString *year;/**<年份*/

- (instancetype)initWithTitle:(NSString *)title artist:(NSString *)artist coverUrl:(NSString *)coverUrl year:(NSString *)year;
@end
