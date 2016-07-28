//
//  MyView.m
//  我的View折线图
//
//  Created by huake on 15/10/2.
//  Copyright (c) 2015年 HKSoft. All rights reserved.

/**
 * //雨
 *
 *  @return 从HomeVC界面获取湿度的数据组，将时间切换的对应的唯一标示传过来在对数组中的数据进行相应的处理
 */
#import "RainView.h"
#import "BFHChart.h"

#import "Header.h"
@interface RainView ()<UUChartDataSource>
{
 
    BFHChart *chartView;
    NSMutableArray *_ary12;
     NSMutableArray *_ary1;
     NSMutableArray *_ary13;
}
@end

@implementation RainView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        _ary1=[NSMutableArray array];
        _ary12=[NSMutableArray array];
        _ary13=[NSMutableArray array];
        _a=0;
        
    }
    return self;
}
//获取数据
-(void)initWith:(NSMutableArray*)array and:(NSMutableArray*)dateArray andRain12Array:(NSMutableArray *)rain12Array andHourArray:(NSMutableArray *)hourArray{
    
    _ary1=array;
    _ary13=dateArray;
    _ary12 = rain12Array;
    
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
    
    
    chartView = [[BFHChart alloc]initwithUUChartDataFrame:AdaptCGRectMake(0, 0, 320,568/2-50)
                                              withSource:self
                                               withStyle:UUChartBarStyle];
    [chartView showInView:self];
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
    
    return [self getXTitles:(int)_ary1.count];
    
    
}

-(void)setA:(int)a{
    
    _a=a;
    //添加内容视图
    [self  configUI];
}

//数值多重数组
- (NSArray *)UUChart_yValueArray:(BFHChart *)chart
{
//    if (_ary1.count>0) {
//        [_ary1 removeAllObjects];
//        [_ary12 removeAllObjects];
//        [_ary13 removeAllObjects];
//    }
//    if (self.array.count==0) {
//        
//        for (int i=0; i<30;i++) {
//            [_ary1 addObject:@"0"];
//            [_ary13 addObject:@"0"];
//            int j=i+48;
//            if (j<self.array.count) {
//                [_ary12 addObject:@"0"];
//            }
//            
//        }
//    }else{
//        //15分钟
//    if (_a==0) {
//        for (int i=0; i<self.array.count; i++) {
//            
//            [_ary1 addObject:[self.array objectAtIndex:i]];
//            [_ary13 addObject:[self.dataArray objectAtIndex:i]];
//            int j=i+48;
//            if (j<self.array.count) {
//                [_ary12 addObject:[self.array objectAtIndex:j]];
//            }
//            
//            
//        }
//        
//    }else if(_a==1){
//        //1小时
//        for (int i=0; i<self.array.count; i++) {
//            if (i%4==0) {
//                [_ary1 addObject:[self.array objectAtIndex:i]];
//                [_ary13 addObject:[self.dataArray objectAtIndex:i]];
//                int j=i+48;
//                if (j<self.array.count) {
//                    [_ary12 addObject:[self.array objectAtIndex:j]];
//                }
//            }
//
//            }
//            
//    }else if(_a==2){
//        //3小时
//        for (int i=0; i<self.array.count; i++) {
//            if (i%12==0) {
//                [_ary1 addObject:[self.array objectAtIndex:i]];
//                [_ary13 addObject:[self.dataArray objectAtIndex:i]];
//                int j=i+48;
//                if (j<self.array.count) {
//                    [_ary12 addObject:[self.array objectAtIndex:j]];
//                }
//            }
//            
//                   }
//    }
//    else {
//        //12小时
//        for (int i=0; i<self.array.count; i++) {
//            if (i%48==0) {
//                [_ary1 addObject:[self.array objectAtIndex:i]];
//                [_ary13 addObject:[self.dataArray objectAtIndex:i]];
//                int j=i+48;
//                if (j<self.array.count) {
//                    [_ary12 addObject:[self.array objectAtIndex:j]];
//                }
//            }
//}
//    }
//    }
//    //当数据数量小于7时，添加对象实现滚动效果
//    if (_ary1.count<7) {
//        for (int i=7; i<10; i++) {
//            [_ary1 addObject:@"0"];
//            
//            [_ary13 addObject:@"0"];
//        }
//    }
//    for (; _ary12.count<=_ary1.count; ) {
//        [_ary12 addObject:@"0"];
//    }
    
    return @[_ary1,_ary12,_ary13];
    
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
    
        return CGRangeMake(150, 0);
    
}


#pragma mark - FYChartViewDataSource

//数量的值数
- (NSInteger)numberOfValueItemCountInChartView:(BFHChart *)chartView;
{
    //值得数目
    return _ary1.count;
}



@end
