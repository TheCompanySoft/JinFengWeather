//
//  Moretimeview.h
//  JinFengWeather
//
//  Created by huake on 15/10/30.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol Moretimeviewdelegate <NSObject>
//代理实现按钮的方法
-(void)moretime:(UIButton*)sender;

@end
@interface MoretimeChangeview : UIView
@property(nonatomic,assign)id delegate;
//存放按钮
@property(nonatomic ,strong)NSMutableArray *buttons;
@property(nonatomic ,strong)UIButton *temp;
@end
