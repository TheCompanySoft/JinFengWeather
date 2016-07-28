//
//  WarninfoViewController.h
//  JinFengWeather
//
//  Created by huake on 15/9/18.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarninfoViewController : UIViewController
/**
 *  记录flag判定为那个数据请求方式
 */
@property (nonatomic,assign)int flag;
/**
 *  存储预警信息数组
 */
@property (nonatomic,strong)NSMutableArray *warningDataArray;



@end
