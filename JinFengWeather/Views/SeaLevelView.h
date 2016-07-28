//
//  SeaLevelView.h
//  JinFengWeather
//
//  Created by Goldwind on 16/2/25.
//  Copyright © 2016年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeaLevelView : UIView
@property(nonatomic,assign)int a;
@property(nonatomic,strong)NSMutableArray*array;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)NSMutableArray *hourArray;

-(void)initWith:(NSMutableArray*)array andDateArray:(NSMutableArray*)dateArray andHourArray:(NSMutableArray *)hourArray;
@end
