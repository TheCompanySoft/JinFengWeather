//
//  MidViewCell.h
//  JinFengWeather
//
//  Created by huake on 15/10/26.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropdownCell : UITableViewCell
//下拉cell获取天气的对象
-(void)getcontent:(NSMutableArray *)dataArray WithFlag:(int)flag;
@end
