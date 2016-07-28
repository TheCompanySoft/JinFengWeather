//
//  RegistSecondViewController.h
//  JinFengWeather
//
//  Created by huake on 15/10/8.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RegistSecondViewdelegate <NSObject>
//代理实现按钮的方法
-(void)regestdelegate;
-(void)regestprotocdelegate;

@end
@interface RegistSecondView : UIView
@property(nonatomic,strong)NSString*phonenum;
@property(nonatomic,assign)id delegate;

@end
