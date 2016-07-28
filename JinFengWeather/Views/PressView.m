//
//  MyView.m
//  我的View折线图
//
//  Created by huake on 15/10/2.
//  Copyright (c) 2015年 HKSoft. All rights reserved.

/**
 * 压力
 *
 *  @return 从HomeVC界面获取湿度的数据组，将时间切换的对应的唯一标示传过来在对数组中的数据进行相应的处理
 */
#import "PressView.h"
#import "BFHChart.h"
#import "Header.h"
@interface PressView ()<UUChartDataSource>
{
    BFHChart *chartView;
    NSMutableArray *_ary;
    NSMutableArray *_ary1;
    NSString *_dateStr;
}
@end

@implementation PressView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _ary=[NSMutableArray array];
        _ary1=[NSMutableArray array];
        _a=0;
        
    }
    return self;
}
-(void)setA:(int)a{
    _a=a;
    //添加内容视图
    [self  configUI];
}
//获取数据
-(void)initWith:(NSMutableArray*)array  andDateArray:(NSMutableArray *)dateArray andHourArray:(NSMutableArray *)hourArray{
    
    self.array=array;
    self.dataArray=dateArray;
    self.hourArray = hourArray;
    
    [self  configUI];
    
}
//图表展示
- (void)configUI
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    chartView = [[BFHChart alloc]initwithUUChartDataFrame:AdaptCGRectMake(0, 0, 320, 568/2-50)
                                               withSource:self
                                                withStyle:UUChartLineStyle];
    if (self.array.count>0) {
        [chartView showInView:self];
    }else{
        
    }

}
- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    if (xTitles.count!=0) {
        [xTitles removeAllObjects];
    }else if (xTitles.count==0){
        xTitles = self.hourArray;
    }
    return xTitles;
    
}
#pragma mark - @required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(BFHChart *)chart
{
    return [self getXTitles:(int)_ary.count];
    
    
    
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(BFHChart *)chart
{
    
    _a = 0;
    
    
    
    if (_ary!=nil||_ary1!=nil) {
        [_ary removeAllObjects];
        [_ary1 removeAllObjects];
    }
    if (_a==0) {
        for (NSString *str in self.array) {
            NSString *DataStr = [NSString stringWithFormat:@"%@hPa",str];
            [_ary addObject:DataStr];
        }
        [_ary1 addObjectsFromArray:self.dataArray];
    }
    
    return @[_ary,_ary1];
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(BFHChart *)chart
{
    return @[[UIColor colorWithRed:5/255.0 green:251/255.0 blue:250/255.0 alpha:1],[UIColor colorWithRed:235/255.0 green:247/251.0 blue:37/255.0 alpha:1],[UIColor blueColor]];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(BFHChart *)chart
{
    return CGRangeMake(1300, 700);
    
}
#pragma mark 折线图专享功能

#pragma mark - FYChartViewDataSource

//数量的值数
- (NSInteger)numberOfValueItemCountInChartView:(BFHChart *)chartView;
{
    //值得数目
    return _ary.count;
}





@end
