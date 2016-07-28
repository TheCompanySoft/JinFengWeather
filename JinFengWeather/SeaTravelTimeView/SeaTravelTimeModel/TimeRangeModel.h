//
//  TimeRangeModel.h
//  tableview
//
//  Created by Goldwind on 16/2/19.
//  Copyright © 2016年 Goldwind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeRangeModel : NSObject

/**
 *  安全出行开始时间
 */
@property (nonatomic,strong) NSString *BeginTime;

/**
 *  安全出行结束时间
 */
@property (nonatomic,strong) NSString *EndTime;

@end
