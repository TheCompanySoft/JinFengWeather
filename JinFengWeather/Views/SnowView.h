//
//  MyView1.h
//  我的View折线图
//
//  Created by huake on 15/10/2.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnowView : UIView
@property(nonatomic,assign)int a;
@property(nonatomic,strong)NSMutableArray*array;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)NSMutableArray *snow12Array;
@property (nonatomic,strong)NSMutableArray *hourArray;

-(void)initWith:(NSMutableArray*)array and:(NSMutableArray*)dateArray andSnow12Array:(NSMutableArray *)snow12Array andHourArray:(NSMutableArray *)hourArray;
@end
