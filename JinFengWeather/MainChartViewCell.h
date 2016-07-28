//
//  MainChartViewCell.h
//  JinFengWeather
//
//  Created by huake on 15/10/26.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  WeatherInfo;
@interface MainChartViewCell : UITableViewCell
@property(nonatomic,assign)int a;
//从主界面获取天气数据
-(void)getcontent:(NSMutableArray *)dataArray WithFlag:(int)flag;
@end
