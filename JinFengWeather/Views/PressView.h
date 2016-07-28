//
//  MyView3.h
//  我的View折线图
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PressView : UIView
@property(nonatomic,assign)int a;
@property(nonatomic,strong)NSMutableArray*array;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)NSMutableArray *hourArray;

-(void)initWith:(NSMutableArray*)array andDateArray:(NSMutableArray*)dateArray andHourArray:(NSMutableArray *)hourArray;

@end
