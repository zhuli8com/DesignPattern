//
//  ZLHTTPClient.h
//  DesignPattern
//
//  Created by account on 15/9/10.
//  Copyright (c) 2015年 zhuli8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZLHTTPClient : NSObject

- (instancetype)getRequest:(NSString *)url;
- (instancetype)postRequest:(NSString *)url body:(NSString *)body;
- (UIImage *)downloadImage:(NSString *)url;
@end
