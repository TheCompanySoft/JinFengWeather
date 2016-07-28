//
//  WarningModel.h
//  JinFengWeather
//
//  Created by Goldwind on 16/2/29.
//  Copyright © 2016年 HKSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WarningModel : NSObject

/**
 *  预警描述信息
 */
@property (nonatomic,copy)NSString *AllInfo;
/**
 *  预警结束时间
 */
@property (nonatomic,copy)NSString *EndTime;
/**
 *  预警等级
 */
@property (nonatomic,copy)NSString *Level;
/**
 *  预警开始时间
 */
@property (nonatomic,copy)NSString *StartTime;
/**
 *  预警防范措施
 */
@property (nonatomic,copy)NSString *Tip;

@end
