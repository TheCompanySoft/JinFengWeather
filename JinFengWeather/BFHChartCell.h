//
//  DayArrayinfo.h
//  网络请求—AFNetworking
//
//  Created by huake on 15/9/28.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFHChartCellLayer.h"
#import "HFHChartDomain.h"
#define degreesToRadians(x) (M_PI*(x)/180.0)
#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width

@interface BFHChartCell : UICollectionViewCell
//显示线条
-(void)setChartLine:(GLChartLine)chartLine oldChartLine:(GLChartLine)oldChartLine showStart:(BOOL)showStart showEnd:(BOOL)showEnd;
//x轴时间显示的label
@property(nonatomic,strong)UILabel*xlabel;
//预警显示的黄色线
@property(nonatomic ,strong)UIView*yellowview;

@end
