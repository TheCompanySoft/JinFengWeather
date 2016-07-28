//
//  SideBarMenuViewController.m
//  JinFengWeather
//
//  Created by huake on 15/9/16.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//


#define kMenuFullWidth 340.0f
#define kMenuDisplayedWidth 280.0f
#define kMenuOverlayWidth (kMenuFullWidth - kMenuDisplayedWidth)
#define kMenuBounceOffset 10.0f
#define kMenuBounceDuration 0.3f
#define kMenuSlideDuration 0.3f

#import "SideBarMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SideBarMenuViewController

- (void)dealloc
{
   // NSLog(@"SideBarMenuViewController dealloc");
    [_leftViewController release];
    [_rightViewController release];
    [_middleViewController release];
    [super dealloc];
}

//初始化方法
- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self) {
        _middleViewController=[rootViewController retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setRootViewController:_middleViewController];
    //如果tapGesture为nil的情况下 初始化一个点击手势tap 该手势调用tap:方法 并把手势tap添加到self.view上
    if (!tapGesture) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.delegate = self;
        [self.view addGestureRecognizer:tap];
        [tap setEnabled:NO];
        tapGesture=tap;
        [tap release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    if (rootViewController) {
        //如果_middleViewController存在 把_middleViewController的view从父视图移除 把_middleViewController释放置空 并把rootViewController负值给_middleViewController
        if (_middleViewController) {
            _middleViewController=[rootViewController retain];
        }
        
        //将rootViewController的view添加到self.view上
        CGRect frame = [[UIScreen mainScreen] bounds];
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
            frame.size.height = frame.size.height;
        } else {
            frame.size.height = frame.size.height-20;
        }
        
        UIView *view = rootViewController.view;
        view.frame = frame;
        [self.view addSubview:view];
    }
    [self resetNavButtons];
}

- (void)setRightViewController:(UIViewController *)rightViewController
{
    if (_rightViewController != rightViewController) {
        [_rightViewController release];
        _rightViewController = nil;
        _rightViewController = [rightViewController retain];
    }
    menuFlags.canShowRight = (_rightViewController != nil);
}

- (void)setLeftViewController:(UIViewController *)leftViewController
{
    if (_leftViewController != leftViewController) {
        [_leftViewController release];
        _leftViewController = nil;
        _leftViewController = [leftViewController retain];
    }
    menuFlags.canShowLeft = (_leftViewController != nil);
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
   // NSLog(@"tap");
    [tapGesture setEnabled:NO];
    [self showMiddleViewController:YES];
}

//展示中间视图的方法
- (void)showMiddleViewController:(BOOL)animated
{
    //点击手势tapGesture设置为不可以点击
    [tapGesture setEnabled:NO];
    //_middleViewController.view设置为用户可以点击
    _middleViewController.view.userInteractionEnabled = YES;
    //将_middleViewController.view.frame的origin.x设置为0
    CGRect frame = _middleViewController.view.frame;
    frame.origin.x = 0.0f;
    //初始化一个BOOL类型的enabled 如果视图可以执行动画则enabled设置为YES否则为NO
    BOOL enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        //如果animated为NO则 视图不可以执行动画
        [UIView setAnimationsEnabled:NO];
    }
    //0.3秒的时间 执行动画 使_middleViewController.view回到中间的位置
    [UIView animateWithDuration:0.3f animations:^{
        _middleViewController.view.frame = frame;
    //动画结束后 _leftViewController.view从父视图移除 _rightViewController.view从父视图移除
    } completion:^(BOOL finished) {
        if (finished) {
            if (_leftViewController && _leftViewController.view.superview) {
                [_leftViewController.view removeFromSuperview];
            }
            if (_rightViewController && _rightViewController.view.superview) {
                [_rightViewController.view removeFromSuperview];
            }
            //showingLeftView showingRightView 都设置为NO 调用showShadow：方法隐藏阴影效果
            menuFlags.showingLeftView = NO;
            menuFlags.showingRightView = NO;
            [self showShadow:NO];
        }
    }];
    //如果animated为NO 则视图设置为初始状态enabled
    if (!animated) {
        [UIView setAnimationsEnabled:enabled];
    }
}

//展示左视图的方法
- (void)showLeftViewController:(BOOL)animated
{
    //如果canShowLeft为NO 则return
    if (!menuFlags.canShowLeft) {
        return;
    }
    //如果_rightViewController存在 并且_rightViewController.view.superview也存在 则把_rightViewController.view从父类移除 并且showingRightView设置为NO
    if (_rightViewController && _rightViewController.view.superview) {
        [_rightViewController.view removeFromSuperview];
        menuFlags.showingRightView = NO;
    }
    //如果respondsToWillShowViewController为YES 则_delegate调用代理方法 展示self.leftViewController
    if (menuFlags.respondsToWillShowViewController) {
        [_delegate menuController:self willShowViewController:self.leftViewController];
    }
    
    menuFlags.showingLeftView = YES;
    //展示_middleViewController.view.layer的阴影效果
    [self showShadow:YES];
    
    //将self.leftViewController.view插入到self.view的index为0的位置
    UIView *view = self.leftViewController.view;
    CGRect frame = self.view.bounds;
    view.frame = frame;
    [self.view insertSubview:view atIndex:0];
    
    //设置self.leftViewController.view显示后 _middleViewController.view的frame
    frame = _middleViewController.view.frame;
    frame.origin.x = CGRectGetMaxX(view.frame)-(kMenuFullWidth - kMenuDisplayedWidth);
    //初始化一个BOOL类型的enabled 如果视图可以执行动画则enabled设置为YES 否则为NO
    BOOL enabled = [UIView areAnimationsEnabled];
    //如果animated为NO 则视图不可以执行动画
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    //_middleViewController.view设置为用户不可以点击
    _middleViewController.view.userInteractionEnabled = NO;
    //0.3秒执行动画_middleViewController.view向右移动 动画结束后tapGesture手势设置为可以点击
    [UIView animateWithDuration:0.3f animations:^{
        _middleViewController.view.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [tapGesture setEnabled:YES];
        }
    }];
    //如果animated为NO 则视图设置为初始状态enabled
    if (!animated) {
        [UIView setAnimationsEnabled:enabled];
    }
}

//展示右视图的方法
- (void)showRightViewController:(BOOL)animated
{
    //如果canShowRight为NO则return
    if (!menuFlags.canShowRight) {
        return;
    }
    //如果_leftViewController存在 并且_leftViewController.view.superview也存在 则把_leftViewController.view从父视图移除 并且showingLeftView设置为NO
    if (_leftViewController && _leftViewController.view.superview) {
        [_leftViewController.view removeFromSuperview];
        menuFlags.showingLeftView = NO;
    }
    //如果respondsToWillShowViewController为YES 则_delegate调用代理方法 展示rightViewController
    if (menuFlags.respondsToWillShowViewController) {
        [_delegate menuController:self willShowViewController:self.rightViewController];
    }
    menuFlags.showingRightView=YES;
    [self showShadow:YES];
    //把self.rightViewController.view插入到self.view的index为0的位置
    UIView *view = self.rightViewController.view;
    CGRect frame = self.view.bounds;
    view.frame = frame;
    [self.view insertSubview:view atIndex:0];
    
    //设置self.rightViewController.view显示后
    frame = _middleViewController.view.frame;
    frame.origin.x = -(frame.size.width - kMenuOverlayWidth);
    BOOL enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    _middleViewController.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _middleViewController.view.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [tapGesture setEnabled:YES];
        }
    }];
    //如果animated为NO 则视图设置为初始状态enabled
    if (!animated) {
        [UIView setAnimationsEnabled:enabled];
    }
}

//设置阴影效果_middleViewController.view.layer的阴影效果
- (void)showShadow:(BOOL)isShadow
{
    if (!_middleViewController) {
        return;
    }
    _middleViewController.view.layer.shadowOpacity = isShadow ? 0.8f : 0.0f;
    if (isShadow) {
        _middleViewController.view.layer.cornerRadius = 4.0f;
        _middleViewController.view.layer.shadowOffset = CGSizeZero;
        _middleViewController.view.layer.shadowRadius = 4.0f;
        _middleViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    }
}

//设置tabBar 或者 navigationBar
- (void)resetNavButtons
{
    if (!_middleViewController) {
        return;
    }
    
    UIViewController *topController = nil;
    if ([_middleViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)_middleViewController;
        if ([[navigationController viewControllers] count] > 0) {
            topController = [[navigationController viewControllers] objectAtIndex:0];
        }
    }

    if (menuFlags.canShowLeft) {
        UIImage *buttonImageNormal = [UIImage imageNamed:@"setup@2x"];
        UIImage *buttonImageHighlight = [UIImage imageNamed:@"setup@3x"];
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(-20.0f, 0.0f, buttonImageNormal.size.width, buttonImageNormal.size.height)];
        [leftButton setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
        [leftButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
        [leftButton addTarget:self action:@selector(navShowLeft:) forControlEvents:UIControlEventTouchUpInside];
        //用leftButton初始化按钮leftBarButton
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        [leftButton release];
        topController.navigationItem.leftBarButtonItem = leftBarButton;
        [leftButton release];
       
    } else {
        topController.navigationItem.leftBarButtonItem = nil;
    }
    if (menuFlags.canShowRight) {
        topController.navigationItem.rightBarButtonItem = nil;
    }
}

//设置根视图的方法
- (void)setRootViewController:(UIViewController *)rootViewController animated:(BOOL)animated
{
    //如果rootViewController为nil的情况下
    if (!rootViewController) {
        return;
    }
    
    //如果正在显示左视图
    if (menuFlags.showingLeftView) {
        //程序开始忽略所有交互动作
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        //初始化一个SideBarMenuViewController对象sideBarMenuViewController 并且用self负值
        __block SideBarMenuViewController *sideBarMenuViewController = self;
        //初始化一个UIViewController对象middleViewController 并且用_middleViewController负值
        __block UIViewController *middleViewController = _middleViewController;
        //初始化一个frame 这个frame的x为320
        CGRect frame = middleViewController.view.frame;
        frame.origin.x = middleViewController.view.bounds.size.width;
        //将middleViewController.view.frame设置成frame
        [UIView animateWithDuration:0.1f animations:^{
            middleViewController.view.frame = frame;
        } completion:^(BOOL finished) {
            if (finished) {
                //程序结束忽略所有交互动作
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                //sideBarMenuViewController调用setRootViewController方法 把rootViewController设置为根视图
                [sideBarMenuViewController setRootViewController:rootViewController];
                //将_middleViewController.view.frame设置成frame
                _middleViewController.view.frame = frame;
                //sideBarMenuViewController调用showMiddleViewController方法 展示出中间视图
                [sideBarMenuViewController showMiddleViewController:animated];
            }
        }];
    } else {
        //self调用setRootViewController方法 把rootViewController设置为根视图
        [self setRootViewController:rootViewController];
        //self调用showMiddleViewController方法 展示出中间视图
        [self showMiddleViewController:animated];
    }
}

//点击tabBar左边按钮 展示左视图 加动画效果
- (void)tabshowLeft:(id)sender
{
  //  NSLog(@"点击tabBar左边按钮 展示左边栏");
    [self showLeftViewController:YES];
}
//点击navBar左边按钮 展示左视图 加动画效果
- (void)navShowLeft:(id)sender
{
    
//NSLog(@"点击navBar左边按钮 展示左边栏");
    [self showLeftViewController:YES];
}

//展示右视图 加动画效果
- (void)showRight:(id)sender
{
    [self showRightViewController:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{    
    //如果为点击手势tapGesture
    if (gestureRecognizer == tapGesture) {
        if (_middleViewController && (menuFlags.showingRightView || menuFlags.showingLeftView)) {
            //设置可点击的范围
            return CGRectContainsPoint(_middleViewController.view.frame, [gestureRecognizer locationInView:self.view]);
        }
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer == tapGesture) {
        return YES;
    }
    return NO;
}

@end
