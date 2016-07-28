//
//  FirstSectionViewCell.h
//  JinFengWeather
//
//  Created by huake on 15/10/26.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuView.h"

@class DayArrayinfo;
@class WeatherInfo;
@protocol FirstSectionViewdelegate <NSObject>
-(void)warninfoViewdelegate;

@end
@interface FirstSectionViewCell : UITableViewCell
@property(nonatomic,assign)id delegate;
@property(nonatomic,strong)UILabel *dateLabel;
/**
 *  修改为实时时间
 */
@property(nonatomic,strong)UILabel *timeLabel;
/**
 *  实时时间图  暂无
 */
@property(nonatomic,strong)UIImageView *timeView;

@property(nonatomic,strong)UIImageView *weatherView;
@property(nonatomic,strong)UIImageView *temputerView;
@property(nonatomic,strong)UILabel *weatherLabel;
@property(nonatomic,strong)UILabel *temputerLabel;
@property(nonatomic,strong)UIImageView *windView;

@property(nonatomic,strong)UILabel *windLabel;
@property(nonatomic,strong)UIImageView *iamge2;
@property(nonatomic,strong)UIButton *warnBtn;
@property(nonatomic,strong)UIView *windliView;

/**
 *  弧形表盘
 */
@property(nonatomic,strong)HuView *windChartView;
/**
 *  风速label
 */
@property(nonatomic,strong)UILabel *windSpeedLabel;
/**
 *  风级label
 */
@property(nonatomic,strong)UILabel *windGradeLabel;
/**
 *  指南针风向view
 */
@property(nonatomic,strong)UIImageView *windDirView;



@property(nonatomic,strong)UILabel *fengliLabel;
@property(nonatomic,strong)UIView*windxiangView;
@property(nonatomic,assign)float i;

@property(nonatomic,assign)int j;

-(void)setContentFirstrow:(NSMutableArray *)dataArray WithFlag:(int)flag;
@end
