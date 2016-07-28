//
//  ViewController.h
//  JinFengWeather
//
//  Created by huake on 15/9/16.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideBarMenuViewController : UIViewController <UIGestureRecognizerDelegate> {
    UITapGestureRecognizer *tapGesture;//点击手势
    struct {
        unsigned int respondsToWillShowViewController:1;
        unsigned int showingLeftView:1;
        unsigned int showingRightView:1;
        unsigned int canShowRight:1;
        unsigned int canShowLeft:1;
    } menuFlags;//结构体menuFlags
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UIViewController *leftViewController;
@property (nonatomic, retain) UIViewController *rightViewController;
@property (nonatomic, retain) UIViewController *middleViewController;

//初始化SideBarMenuViewController对象的方法
-(id)initWithRootViewController:(UIViewController *)rootViewController;
//设置根视图的方法
-(void)setRootViewController:(UIViewController *)rootViewController animated:(BOOL)animated;

@end

//声明代理SideBarMenuViewControllerDelegate
@protocol SideBarMenuViewControllerDelegate <NSObject>

-(void)menuController:(SideBarMenuViewController *)menuController willShowViewController:(UIViewController *)viewController;

@end
