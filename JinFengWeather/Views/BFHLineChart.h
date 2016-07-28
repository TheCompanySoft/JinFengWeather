//
//  UULineChart.h
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BFHColor.h"

@interface BFHLineChart : UIView
@property (nonatomic,assign) id delegate;

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;

/**
 *  存储数据 和日期的数组
 */
@property (strong, nonatomic) NSArray * yValues;

@property (nonatomic, strong) NSArray * colors;
@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) CGFloat level;
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) CGFloat yValueMax;

@property (nonatomic, assign) CGRange markRange;

@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, assign) BOOL showRange;


-(void)strokeChart;

- (NSArray *)chartLabelsForX;

@end
