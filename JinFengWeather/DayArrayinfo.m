//
//  DayArrayinfo.m
//  网络请求—AFNetworking
//
//  Created by huake on 15/9/28.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import "DayArrayinfo.h"

static float tmp;

@implementation DayArrayinfo

-(instancetype)setDataForNeed:(DayArrayinfo *)daymodel{
    
    tmp = [daymodel.Td2m floatValue];
    daymodel.Td2m = [NSString stringWithFormat:@"%0.2f",tmp];
    
    tmp = [daymodel.wspd floatValue];
    daymodel.wspd = [NSString stringWithFormat:@"%0.2f",tmp];
    
    tmp = [daymodel.RH2m floatValue];
    daymodel.RH2m = [NSString stringWithFormat:@"%0.2f",tmp];
    
    tmp = [daymodel.PSFC floatValue];
    daymodel.PSFC = [NSString stringWithFormat:@"%0.2f",tmp];
    
    if (daymodel.rain.length > 5) {
        tmp = [daymodel.rain floatValue];
        daymodel.rain = [NSString stringWithFormat:@"%0.2f",tmp];
    }
    
    if (daymodel.rain12.length > 5) {
        tmp = [daymodel.rain12 floatValue];
        daymodel.rain12 = [NSString stringWithFormat:@"%0.2f",tmp];
    }
    
    if (daymodel.snow.length > 5) {
        tmp = [daymodel.snow floatValue];
        daymodel.snow = [NSString stringWithFormat:@"%0.2f",tmp];
    }
    
    if (daymodel.snow12.length > 5) {
        tmp = [daymodel.snow12 floatValue];
        daymodel.snow12 = [NSString stringWithFormat:@"%0.2f",tmp];
    }
    
    return daymodel;
}

@end
