//
//  UserPlantModel.h
//  LoginText
//
//  Created by Goldwind on 16/3/3.
//  Copyright © 2016年 Goldwind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPlantModel : NSObject<NSCoding>
/**
 *  风场ID
 */
@property (nonatomic,copy)NSString *WfId;
/**
 *  风场名
 */
@property (nonatomic,copy)NSString *WfName;
/**
 *  风场code 例:rudong
 */
@property (nonatomic,copy)NSString *WfCode;
/**
 *  风场纬度
 */
@property (nonatomic,copy)NSString *WfX;
/**
 *  风场经度
 */
@property (nonatomic,copy)NSString *WfY;
/**
 *  风场类型(1:海上风电场 2:陆上风电场)
 */
@property (nonatomic,copy)NSString *WfType;

@end
