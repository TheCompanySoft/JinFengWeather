//
//  SeaTravelModel.h
//  tableview
//
//  Created by Goldwind on 16/2/19.
//  Copyright © 2016年 Goldwind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "WindowTimeModel.h"

@interface SeaTravelModel : NSObject<MJKeyValue>

/**
 *  船只名称
 */
@property (nonatomic,strong)NSString *TransportationName;

/**
 *  预测的出行日期 与日期内的安全出行时间
 */
@property (nonatomic,strong)NSMutableArray *WindowTime;

@end
