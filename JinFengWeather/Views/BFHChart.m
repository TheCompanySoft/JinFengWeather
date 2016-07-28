//
//  UUChart.m
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//
#import "BFHChart.h"

@interface BFHChart ()

@property (strong, nonatomic) BFHLineChart * lineChart;

@property (strong, nonatomic) BFHBarChart * barChart;

@property (assign, nonatomic) id<UUChartDataSource> dataSource;

@end

@implementation BFHChart

-(id)initwithUUChartDataFrame:(CGRect)rect withSource:(id<UUChartDataSource>)dataSource withStyle:(UUChartStyle)style{
    self.dataSource = dataSource;
    self.chartStyle = style;
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor grayColor];
        self.clipsToBounds = NO;
    }
    return self;
}

-(void)setUpChart{
    //线形图
	if (self.chartStyle == UUChartLineStyle) {
        if(!_lineChart){
            _lineChart = [[BFHLineChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:_lineChart];
        }
        //选择显示范围
        if ([self.dataSource respondsToSelector:@selector(UUChartChooseRangeInLineChart:)]) {
            [_lineChart setChooseRange:[self.dataSource UUChartChooseRangeInLineChart:self]];
        }
        //显示颜色
        if ([self.dataSource respondsToSelector:@selector(UUChart_ColorArray:)]) {
            [_lineChart setColors:[self.dataSource UUChart_ColorArray:self]];
        }
        [_lineChart setYValues:[self.dataSource UUChart_yValueArray:self]];
		[_lineChart setXLabels:[self.dataSource UUChart_xLableArray:self]];
		[_lineChart strokeChart];
        
	}else if (self.chartStyle == UUChartBarStyle){
        //柱状图
        //代理方法的调用
        if (!_barChart) {
            _barChart = [[BFHBarChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:_barChart];
        }
        if ([self.dataSource respondsToSelector:@selector(UUChartChooseRangeInLineChart:)]) {
            [_barChart setChooseRange:[self.dataSource UUChartChooseRangeInLineChart:self]];
        }
        if ([self.dataSource respondsToSelector:@selector(UUChart_ColorArray:)]) {
            [_barChart setColors:[self.dataSource UUChart_ColorArray:self]];
        }
		[_barChart setYValues:[self.dataSource UUChart_yValueArray:self]];
       
      //  [_barChart setYValues1:[self.dataSource UUChart_yValueArray1:self]];
        
		[_barChart setXLabels:[self.dataSource UUChart_xLableArray:self]];
        
        [_barChart strokeChart];
	}
}
//图表展示
- (void)showInView:(UIView *)view
{
    [self setUpChart];
    [view addSubview:self];
}

-(void)strokeChart
{
	[self setUpChart];
	
}



@end
