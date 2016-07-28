//
//  WindPlantModel.m
//  JinFengWeather
//
//  Created by Goldwind on 16/2/22.
//  Copyright © 2016年 HKSoft. All rights reserved.
//

#import "WindPlantModel.h"
static float tmp;
@implementation WindPlantModel

-(instancetype)setWindPlantDataForNeed:(WindPlantModel *)windPlantModel{
    if (windPlantModel.Td2m == nil) {
        windPlantModel.DataDateTime = @"2000-00-00 00:00:00";
        windPlantModel.wdir = @"0.00";
        windPlantModel.wdir_cn = @"北";
        windPlantModel.wdir_en = @"N";
        windPlantModel.wea_types = @"晴";
        windPlantModel.wspd_gread = @"0";
        windPlantModel.Td2m = @"0.00";
        windPlantModel.WindSpeed = @"0.00";
        windPlantModel.RH2m = @"0.00";
        windPlantModel.PSFC = @"0.00";
        windPlantModel.SeaLevel = @"0.00";
        windPlantModel.WaveHeight = @"0.00";
        windPlantModel.rain = @"0.00";
        windPlantModel.rain12 = @"0.00";
        windPlantModel.snow = @"0.00";
        windPlantModel.snow12 = @"0.00";
    }
    tmp = [windPlantModel.Td2m floatValue];
    windPlantModel.Td2m = [NSString stringWithFormat:@"%0.2f",tmp];
    
    tmp = [windPlantModel.WindSpeed floatValue];
    windPlantModel.WindSpeed = [NSString stringWithFormat:@"%0.2f",tmp];
    
    tmp = [windPlantModel.RH2m floatValue];
    windPlantModel.RH2m = [NSString stringWithFormat:@"%0.2f",tmp];
    
    tmp = [windPlantModel.PSFC floatValue];
    windPlantModel.PSFC = [NSString stringWithFormat:@"%0.2f",tmp];
    
    tmp = [windPlantModel.SeaLevel floatValue];
    windPlantModel.SeaLevel = [NSString stringWithFormat:@"%0.2f",tmp];
    
    tmp = [windPlantModel.WaveHeight floatValue];
    windPlantModel.WaveHeight = [NSString stringWithFormat:@"%0.2f",tmp];
    
    if (windPlantModel.rain.length > 5) {
        tmp = [windPlantModel.rain floatValue];
        windPlantModel.rain = [NSString stringWithFormat:@"%0.2f",tmp];
    }
    
    if (windPlantModel.rain12.length > 5) {
        tmp = [windPlantModel.rain12 floatValue];
        windPlantModel.rain12 = [NSString stringWithFormat:@"%0.2f",tmp];
    }
    
    if (windPlantModel.snow.length > 5) {
        tmp = [windPlantModel.snow floatValue];
        windPlantModel.snow = [NSString stringWithFormat:@"%0.2f",tmp];
    }
    
    if (windPlantModel.snow12.length > 5) {
        tmp = [windPlantModel.snow12 floatValue];
        windPlantModel.snow12 = [NSString stringWithFormat:@"%0.2f",tmp];
    }
    return windPlantModel;
}

@end
