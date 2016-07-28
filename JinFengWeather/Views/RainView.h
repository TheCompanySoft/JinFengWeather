//
//  MyView2.h
//  我的View折线图
//
//  Created by huake on 15/10/2.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RainView : UIView
@property(nonatomic,assign)int a;
@property(nonatomic,strong)NSMutableArray*array;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)NSMutableArray *rain12Array;
@property (nonatomic,strong)NSMutableArray *hourArray;


//获取数据
-(void)initWith:(NSMutableArray*)array and:(NSMutableArray*)dateArray andRain12Array:(NSMutableArray *)rain12Array andHourArray:(NSMutableArray *)hourArray;
@end
