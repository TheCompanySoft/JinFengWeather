//
//  Cityweatherinfo.h
//  JinFengWeather
//
//  Created by huake on 15/10/28.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cityweatherinfo : NSObject<NSCoding>
//名字
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int index;
//经度
@property (nonatomic, copy) NSString *cityJingdu;

//纬度
@property (nonatomic, copy) NSString *cityWeidu;


//城市的citycode
@property (nonatomic, copy) NSString *cityCode;

/**
 *  判断数据源
 */
@property (nonatomic,assign)int flag;
/**
 *  风场code 例:rudong
 */
@property (nonatomic,copy)NSString *WfCode;
/**
 *  风场ID
 */
@property (nonatomic,copy)NSString *WfId;


@end
