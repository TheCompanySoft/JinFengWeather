//
//  UUChart.h
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFHChart.h"
#import "BFHColor.h"
#import "BFHLineChart.h"
#import "BFHBarChart.h"
//类型
typedef enum {
	UUChartLineStyle,
	UUChartBarStyle
} UUChartStyle;


@class BFHChart;
@protocol UUChartDataSource <NSObject>
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(BFHChart *)chart;
//数值多重数组
- (NSArray *)UUChart_yValueArray:(BFHChart *)chart;
//数值多重数组
//- (NSArray *)UUChart_yValueArray1:(UUChart1 *)chart;
@optional


//颜色数组
- (NSArray *)UUChart_ColorArray:(BFHChart *)chart;

//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(BFHChart *)chart;

#pragma mark 折线图专享功能

//判断显示横线条
- (BOOL)UUChart:(BFHChart *)chart ShowHorizonLineAtIndex:(NSInteger)index;

@end


@interface BFHChart : UIView

//是否自动显示范围
@property (nonatomic, assign) BOOL showRange;

@property (assign) UUChartStyle chartStyle;

-(id)initwithUUChartDataFrame:(CGRect)rect withSource:(id<UUChartDataSource>)dataSource withStyle:(UUChartStyle)style;
//展示视图
- (void)showInView:(UIView *)view;
//绘表
-(void)strokeChart;

@end
