//
//  ChangeCodeViewController.h
//  JinFengWeather
//
//  Created by huake on 15/9/17.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MiscodeViewdelegate <NSObject>
//代理实现按钮的方法
-(void)miscodedelegate;


@end
@interface ChangeCodeView : UIView
@property(nonatomic,strong)NSString*phonenum;
@property (nonatomic,assign) id delegate;
@end
