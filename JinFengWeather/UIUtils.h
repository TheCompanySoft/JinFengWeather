//
//  ViewController.h
//  JinFengWeather
//
//  Created by huake on 15/9/16.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIUtils : NSObject

//宽
+ (CGFloat)getWindowWidth;
//高
+ (CGFloat)getWindowHeight;
//判断一个字符串是否为空 或者 只含有空格
+ (BOOL)isBlankString:(NSString *)string;

@end
