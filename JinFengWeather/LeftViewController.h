//
//  ViewController.h
//  JinFengWeather
//
//  Created by huake on 15/9/16.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//
#import <UIKit/UIKit.h>
@class SideBarMenuViewController;
@class Cityweatherinfo;
@interface LeftViewController : UIViewController

@property (nonatomic, retain)NSMutableArray *cityinfoArray;
@property (nonatomic, assign) SideBarMenuViewController *sideBarMenuVC;

//展示相应的controller
- (void)showViewControllerWithSection:(int)section Index:(int)row;
-(void)saveCityinfo:(Cityweatherinfo *)cityinfo;

-(void)loadLoginUserPlantData;

@end
