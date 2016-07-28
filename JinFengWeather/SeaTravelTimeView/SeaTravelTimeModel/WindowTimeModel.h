//
//  WindowTimeModel.h
//  tableview
//
//  Created by Goldwind on 16/2/19.
//  Copyright © 2016年 Goldwind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "TimeRangeModel.h"

@interface WindowTimeModel : NSObject<MJKeyValue>

/**
 *  数据获取的日期
 */
@property (nonatomic,strong)NSString *Date;

/**
 *  日期内出行时间模型
 */
@property (nonatomic,strong)NSArray *WindowTimeRange;

@end
