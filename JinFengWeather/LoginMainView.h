//
//  LoginMainView.h
//  JinFengWeather
//
//  Created by huake on 15/9/17.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//登录界面的视图

#import <UIKit/UIKit.h>
@protocol LoginMainViewdelegate <NSObject>
//代理方法
-(void)loginMainViewphotoGet;
-(void)loginMainViewlogIn;
-(void)loginMainViewregistration;

//- (void)loginMainViewsinaButtonPress;
//- (void)loginMainViewqqButtonPress;

- (void)loginMainViewweixinButtonPress;
-(void)loginMainViewmissPassWord;
-(void)loginMainViewback;
@end
@interface LoginMainView : UIView
@property (nonatomic,assign) id delegate;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong)NSString *phoneStr;
@end





