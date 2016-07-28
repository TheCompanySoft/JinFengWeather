//
//  AddCityViewController.h
//  JinFengWeather
//
//  Created by huake on 15/9/16.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCityViewController : UIViewController

@property (nonatomic,retain)NSMutableArray *cityArray;

#pragma mark ----搜索
@property (nonatomic, strong) UISearchController *searchController;

@property (strong,nonatomic) NSMutableArray  *searchList;
@property (strong,nonatomic) NSMutableArray *dataList;


@property(nonatomic,copy)UILabel *lable;
@property(nonatomic,assign)int selectIndex;

@property (strong,nonatomic) NSMutableArray *hotCityList;
@property(nonatomic,retain)NSArray *heightArray;

@end

@interface BMKFavPoiInfo : NSObject


@end