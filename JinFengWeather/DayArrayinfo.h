//
//  DayArrayinfo.h
//  网络请求—AFNetworking
//
//  Created by huake on 15/9/28.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DayArrayinfo : NSObject

/**
 *预测时间(NSString)
 */
@property (nonatomic,strong)NSString *times;
/**
 *天气类型(NSString)
 */
@property (nonatomic,strong)NSString *wea_types;
/**
 *2米高气温
 */
@property (nonatomic,strong)NSString *Td2m;
/**
 *地表温度
 */
@property (nonatomic,strong)NSString *TSK;
/**
 *风速等级
 */
@property (nonatomic,strong)NSString *wspd_gread;
/**
 *风向类型（中文）(NSString)
 */
@property (nonatomic,strong)NSString *wdir_cn;
/**
 *风向类型（英文）(NSString)
 */
@property (nonatomic,strong)NSString *wdir_en;
/**
 *风速 m/s
 */
@property (nonatomic,strong)NSString *wspd;
/**
 *风向
 */
@property (nonatomic,strong)NSString *wdir;
/**
 *累计降雨量
 */
@property (nonatomic,strong)NSString *rain;
/**
 *累积降雪量
 */
@property (nonatomic,strong)NSString *snow;
/**
 *2米高相对湿度
 */
@property (nonatomic,strong)NSString *RH2m;
/**
 *气压
 */
@property (nonatomic,strong)NSString *PSFC;
/**
 *12小时降雨量
 */
@property (nonatomic,strong)NSString *rain12;
/**
 *12小时降雪量
 */
@property (nonatomic,strong)NSString *snow12;

/**
 *
 */
-(instancetype)setDataForNeed:(DayArrayinfo *)daymodel;

@end
