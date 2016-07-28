//
//  UUBarChart.h
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//柱状图的绘制

#import <UIKit/UIKit.h>
#import "BFHColor.h"

@interface BFHBarChart : UIView

/**
 * This method will call and troke the line in animation
 */

-(void)strokeChart;

@property (strong,nonatomic) NSArray * xLabels;

@property (strong,nonatomic) NSArray * yLabels;

@property (strong,nonatomic) NSArray * yValues;
//@property (strong,nonatomic) NSArray * yValues1;

@property (nonatomic) CGFloat xLabelWidth;

@property (nonatomic) float yValueMax;
@property (nonatomic) float yValueMin;

@property (nonatomic, assign) BOOL showRange;

@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, strong) NSArray * colors;

- (NSArray *)chartLabelsForX;

@end
