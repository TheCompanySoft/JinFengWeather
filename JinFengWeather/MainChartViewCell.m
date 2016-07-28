//
//  MainChartViewCell.m
//  JinFengWeather
//
//  Created by huake on 15/10/26.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "MainChartViewCell.h"
#import "MainFifteenminutesChart.h"
#import "MainOnehoursChart.h"
#import "MainThreehoursChart.h"
#import "MainTwelvehoursChart.h"
#import "UIUtils.h"
#import "DayArrayinfo.h"

#import "WindPlantModel.h"

#import "BFHChartCell.h"
@interface MainChartViewCell ()<GLLineChartViewDataSource,GLLineChartViewDataSource1,GLLineChartViewDataSource2,GLLineChartViewDataSource3>
{
    //15
    MainFifteenminutesChart *_oneChart;
    //1小时
    MainOnehoursChart*_twoChart;
    //3小时
    MainThreehoursChart*_ThreeChart;
    //12小时
    MainTwelvehoursChart*_fourChart;
    //温度数组
    NSMutableArray *_temArray;
    //风力数组
    NSMutableArray *_windArray;
    //数据点对象
    HFHChartDomain *chartDomain ;
    NSMutableArray *_points;
    //时间
    NSMutableArray *_datedateArray;
    NSMutableArray *_dateArray;
    
    NSMutableArray *_hourArray;
}
@end
@implementation MainChartViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _points = [[NSMutableArray alloc] init];
        self.backgroundColor=[UIColor clearColor];
        _temArray=[NSMutableArray array];
        _windArray=[NSMutableArray array];
        _datedateArray=[NSMutableArray array];
        _dateArray=[NSMutableArray array];
        
        _hourArray =[NSMutableArray array];
        [self addContentVew];
    }
    return self;
}
//初始化图表视图所在的View
-(void)addContentVew{
    //15分钟
    if (_oneChart) {
        [_oneChart removeFromSuperview];
    
    }//1小时
    if (_twoChart) {
        [_twoChart removeFromSuperview];
        
    }
    //3小时
    if (_ThreeChart) {
        [_ThreeChart removeFromSuperview];
        
    }
    //12小时
    if (_fourChart) {
        [_fourChart removeFromSuperview];
        
    }
     //15分钟
    _oneChart=[[MainFifteenminutesChart alloc]initWithFrame:CGRectMake(0, 0, [UIUtils getWindowWidth], [UIUtils getWindowHeight]/2-50)];
    _oneChart.dataSource=self;
//1小时
    _twoChart=[[MainOnehoursChart alloc]initWithFrame:CGRectMake(0, 0, [UIUtils getWindowWidth], [UIUtils getWindowHeight]/2-50)];
    
    _twoChart.dataSource=self;
    //3小时
    _ThreeChart=[[MainThreehoursChart alloc]initWithFrame:CGRectMake(0, 0, [UIUtils getWindowWidth], [UIUtils getWindowHeight]/2-50)];
    _ThreeChart.dataSource=self;
    //12小时
    _fourChart=[[MainTwelvehoursChart alloc]initWithFrame:CGRectMake(0, 0, [UIUtils getWindowWidth], [UIUtils getWindowHeight]/2-50)];
    _fourChart.dataSource=self;
}
//获取数据
-(void)getcontent:(NSMutableArray *)dataArray WithFlag:(int)flag{
   //清空数组
    if (_points.count>0) {
        for(UIView *view in [self subviews])
        {
            [view removeFromSuperview];
        }
        [_points removeAllObjects];
        [_windArray removeAllObjects];
        [_dateArray removeAllObjects];
        [_temArray removeAllObjects];
        [_datedateArray removeAllObjects];
        
        [_hourArray removeAllObjects];
        //去除已经绘制的视图防止视图重复
        for (UIView *view in [_twoChart subviews]) {
            [view removeFromSuperview];
        }
        for (UIView *view in [_oneChart subviews]) {
            [view removeFromSuperview];
        }
        for (UIView *view in [_ThreeChart subviews]) {
            [view removeFromSuperview];
        }
        for (UIView *view in [_fourChart subviews]) {
            [view removeFromSuperview];
        }
        
    }
     chartDomain =[[HFHChartDomain alloc] init];
    if (flag == 0) {
        //遍历数据
        for (DayArrayinfo*dainfo in dataArray) {
            [_windArray addObject:dainfo.wspd];
            [_temArray addObject:dainfo.Td2m];//传输为两米高气温
            [_datedateArray addObject:dainfo.times];
            
            chartDomain.nowPercent = [dainfo.wspd floatValue];
            NSString*str=[NSString stringWithFormat:@"%.2f",fabs([dainfo.Td2m floatValue])];
            chartDomain.oldPercent = [str floatValue];
            [_points addObject:chartDomain];
            
        }
#pragma mark--处理不同的日期显示
        for (int i=0; i<_datedateArray.count; i++) {
            NSString *str=_datedateArray[i];
            NSString *strr=[str substringWithRange:NSMakeRange(4, 4)];
            NSMutableString *timeStr = [NSMutableString stringWithFormat:@"%@",strr];
            [timeStr insertString:@"-" atIndex:2];
            
            NSString *std=[NSString stringWithFormat:@"%@日",timeStr];
            [_dateArray addObject:std];
        }
        
        for (NSString *timeStr in _datedateArray) {
            NSString *hourStr = [timeStr substringWithRange:NSMakeRange(8, 2)];
            [_hourArray addObject:[NSString stringWithFormat:@"%@:00",hourStr]];
        }
        
    }else if (flag !=0){
        for (WindPlantModel *windPlantModel in dataArray) {
            [_windArray addObject:windPlantModel.WindSpeed];
            [_temArray addObject:windPlantModel.Td2m];//传输为两米高气温
            [_datedateArray addObject:windPlantModel.DataDateTime];
            
            chartDomain.nowPercent = [windPlantModel.WindSpeed floatValue];
            NSString*str=[NSString stringWithFormat:@"%.2f",fabs([windPlantModel.Td2m floatValue])];
            chartDomain.oldPercent = [str floatValue];
            [_points addObject:chartDomain];
        }
        
        for (int i=0; i<_datedateArray.count; i++) {
            NSString *str=_datedateArray[i];
            NSString *strr=[str substringWithRange:NSMakeRange(5, 5)];
            NSString *std=[NSString stringWithFormat:@"%@日",strr];
            [_dateArray addObject:std];
        }
        
        for (NSString *timeStr in _datedateArray) {
            NSString *hourStr = [timeStr substringWithRange:NSMakeRange(11, 5)];
            [_hourArray addObject:hourStr];
        }
    }
    
    
    if (_points !=NULL) {
        [_points removeAllObjects];
    }
    for (int i=0; i<_windArray.count; i++) {
            chartDomain =[[HFHChartDomain alloc] init];
            chartDomain.nowPercent = [_windArray[i] floatValue];
            NSString*str=[NSString stringWithFormat:@"%.2f",fabs([_temArray[i] floatValue])];
            chartDomain.oldPercent = [str floatValue];
            [_points addObject:chartDomain];
    }
    //刷新
    [_oneChart reloadData];
    //初始化视图1小时视图
    [self addSubview:_oneChart];
    //数组调用
    [_oneChart initWith:_windArray and:_temArray and:_dateArray andHourArray:_hourArray];
    
//    [_twoChart initWith:_windArray and:_temArray and:_dateArray];
//    [_ThreeChart initWith:_windArray and:_temArray and:_dateArray];
//    [_fourChart initWith:_windArray and:_temArray and:_dateArray];
    
}
//通过时间切换参数a来实现不同界面的展示
-(void)setA:(int)a{
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    if (_points !=NULL) {
        [_points removeAllObjects];
    }
//有数据
    
    if (_temArray.count>0) {
        for (int i=0; i<_windArray.count; i++) {
            chartDomain =[[HFHChartDomain alloc] init];
            chartDomain.nowPercent = [_windArray[i] floatValue];
            NSString*str=[NSString stringWithFormat:@"%.2f",fabs([_temArray[i] floatValue])];
            chartDomain.oldPercent = [str floatValue];
            [_points addObject:chartDomain];
        }
        
        [_oneChart reloadData];
        [self addSubview:_oneChart];
    }else{
        //没有数据时提示
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前没有数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.delegate=self;
        [alert show];
    }
    
}
#pragma mark datasource
//collection的cell的数量
-(NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return _points.count;
}
//获取数据对象
-(HFHChartDomain*)chartDomainOfIndex:(NSIndexPath*)indexPath
{
    return [_points objectAtIndex:indexPath.item];
}
- (void)awakeFromNib {
    // Initialization code
}
//cell的状态
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
