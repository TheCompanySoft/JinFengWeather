//
//  Cityweatherinfo.m
//  JinFengWeather
//
//  Created by huake on 15/10/28.
// Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "Cityweatherinfo.h"

@implementation Cityweatherinfo
//读取实例变量，并把这些数据写到coder中去。序列化数据
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.cityCode forKey:@"cityCode"];
    [aCoder encodeObject:self.cityJingdu forKey:@"cityJingdu"];
    [aCoder encodeObject:self.cityWeidu forKey:@"cityWeidu"];
    [aCoder encodeInt:self.index forKey:@"index"];
    
    [aCoder encodeObject:self.WfCode forKey:@"WindCode"];
    [aCoder encodeObject:self.WfId forKey:@"WindId"];
    [aCoder encodeInt:self.flag forKey:@"flag"];
}
// 从coder中读取数据，保存到相应的变量中，即反序列化数据
- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self setName:[aDecoder decodeObjectForKey:@"name"]];
    [self setIndex:[aDecoder decodeIntForKey:@"index"]];
    
    [self setFlag:[aDecoder decodeIntForKey:@"flag"]];
    [self setWfCode:[aDecoder decodeObjectForKey:@"WindCode"]];
    [self setWfId:[aDecoder decodeObjectForKey:@"WindId"]];
    
    [self setCityJingdu:[aDecoder decodeObjectForKey:@"cityJingdu"]];
    [self setCityWeidu:[aDecoder decodeObjectForKey:@"cityWeidu"]];
    [self setCityCode:[aDecoder decodeObjectForKey:@"cityCode"]];
    return self;
}

@end
