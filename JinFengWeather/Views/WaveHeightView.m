//
//  WaveHeightView.m
//  JinFengWeather
//
//  Created by Goldwind on 16/2/25.
//  Copyright © 2016年 HKSoft. All rights reserved.
//

#import "WaveHeightView.h"

#import "BFHChart.h"

#import "Header.h"

@interface WaveHeightView ()<UUChartDataSource>
{
    BFHChart *chartView;
    NSMutableArray *_ary;//
    NSMutableArray *_ary1;//存储X轴坐标
    NSString *_dateStr;
}
@end

@implementation WaveHeightView
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
//初始化
-(void)initWith:(NSMutableArray*)array  andDateArray:(NSMutableArray *)dateArray andHourArray:(NSMutableArray *)hourArray{
    
    self.array=array;//传过来的显示数据值  即湿度
    
    self.dataArray= dateArray;//以前代码命名问题  修改过的日期 02/16
    
    self.hourArray = hourArray;//未修改的全部时间 截取小时  20160216000000
    
    
    //NSLog(@"%@##%@##%@",array[0],dateArray[0],hourArray[0]);
    [self  configUI];
    
}
//切换时间选择
-(void)setA:(int)a{
    
    _a=a;
    //添加内容视图
    [self  configUI];
}
//展示图表
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
        //        for (NSString *timeStr in self.hourArray) {
        //            NSString *hourStr = [timeStr substringWithRange:NSMakeRange(8, 2)];
        //            [xTitles addObject:[NSString stringWithFormat:@"%@:00",hourStr]];
        //        }
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
    if (_ary!=nil||_ary1!=nil) {
        [_ary removeAllObjects];
        [_ary1 removeAllObjects];
    }
    
    _a = 0;
    
    if (_a==0) {
        for (NSString *str in self.array) {
            NSString *DataStr = [NSString stringWithFormat:@"%@m",str];
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
    return CGRangeMake(14, 0);
}
#pragma mark - FYChartViewDataSource

//数量的值数
- (NSInteger)numberOfValueItemCountInChartView:(BFHChart *)chartView;
{
    //值得数目
    return _ary.count;
}

@end
