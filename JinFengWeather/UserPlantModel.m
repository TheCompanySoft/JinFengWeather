//
//  UserPlantModel.m
//  LoginText
//
//  Created by Goldwind on 16/3/3.
//  Copyright © 2016年 Goldwind. All rights reserved.
//

#import "UserPlantModel.h"

@implementation UserPlantModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.WfCode forKey:@"WfCode"];
    [aCoder encodeObject:self.WfId forKey:@"WfId"];
    [aCoder encodeObject:self.WfName forKey:@"WfName"];
    [aCoder encodeObject:self.WfType forKey:@"WfType"];
    [aCoder encodeObject:self.WfX forKey:@"WfX"];
    [aCoder encodeObject:self.WfY forKey:@"WfY"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.WfCode = [aDecoder decodeObjectForKey:@"WfCode"];
        self.WfId = [aDecoder decodeObjectForKey:@"WfId"];
        self.WfName = [aDecoder decodeObjectForKey:@"WfName"];
        self.WfType = [aDecoder decodeObjectForKey:@"WfType"];
        self.WfX = [aDecoder decodeObjectForKey:@"WfX"];
        self.WfY = [aDecoder decodeObjectForKey:@"WfY"];
    }
    return self;
}

@end
