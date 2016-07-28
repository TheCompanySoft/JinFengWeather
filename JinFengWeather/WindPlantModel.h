//
//  WindPlantModel.h
//  JinFengWeather
//
//  Created by Goldwind on 16/2/22.
//  Copyright © 2016年 HKSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WindPlantModel : NSObject
/**
 *  日期时间
 */
@property (nonatomic,copy)NSString *DataDateTime;
/**
 *  发布时刻
 */
@property (nonatomic,copy)NSString *IssueDate;
/**
 *  气压
 */
@property (nonatomic,copy)NSString *PSFC;
/**
 *  2米高相对湿度
 */
@property (nonatomic,copy)NSString *RH2m;
/**
 *  2米气温
 */
@property (nonatomic,copy)NSString *Td2m;
/**
 *  前1小时累计降雨量
 */
@property (nonatomic,copy)NSString *rain;
/**
 *  前12小时累计降雨量
 */
@property (nonatomic,copy)NSString *rain12;
/**
 *  前1小时累计降雪量
 */
@property (nonatomic,copy)NSString *snow;
/**
 *  前12小时累计降雪量
 */
@property (nonatomic,copy)NSString *snow12;
/**
 *  风向
 */
@property (nonatomic,copy)NSString *wdir;
/**
 *  风向类型（中文）
 */
@property (nonatomic,copy)NSString *wdir_cn;
/**
 *  风向类型（英文）
 */
@property (nonatomic,copy)NSString *wdir_en;
/**
 *  天气类型
 */
@property (nonatomic,copy)NSString *wea_types;
/**
 *  风速
 */
@property (nonatomic,copy)NSString *WindSpeed;
/**
 *  风速等级
 */
@property (nonatomic,copy)NSString *wspd_gread;
/**
 *  潮位
 */
@property (nonatomic,copy)NSString *SeaLevel;
/**
 *  浪高
 */
@property (nonatomic,copy)NSString *WaveHeight;
/**
 *  海温
 */
@property (nonatomic,copy)NSString *SeaTemperature;

-(instancetype)setWindPlantDataForNeed:(WindPlantModel *)windPlantModel;

@end
