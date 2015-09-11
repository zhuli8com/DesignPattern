//
//  ZLHTTPClient.m
//  DesignPattern
//
//  Created by account on 15/9/10.
//  Copyright (c) 2015年 zhuli8. All rights reserved.
//

#import "ZLHTTPClient.h"

@implementation ZLHTTPClient
/**
 *  HTTP 客户端实际上不会真正的和一个服务器交互，它在这里仅仅是用来演示外观模式的使用。
 */
- (instancetype)getRequest:(NSString *)url{
    return nil;
}

- (instancetype)postRequest:(NSString *)url body:(NSString *)body{
    return nil;
}

- (UIImage *)downloadImage:(NSString *)url{
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    return [UIImage imageWithData:data];
}
@end
