//
//  AppDelegate.m
//  JinFengWeather
//5679327067e58e0472001395
//  Created by huake on 15/9/16.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
#import "AppDelegate.h"
#import "SideBarMenuViewController.h"
#import "HomeViewController.h"
#import "LeftViewController.h"
#import "UMSocial.h"
 #import "UMSocialWechatHandler.h"
#import "WXApi.h"

#import "LoginGoViewController.h"
//#import "BaiduMobStat.h"
@interface AppDelegate ()
{
    SideBarMenuViewController *_sideBarMenuVC;
}
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //UMkey
    [UMSocialData setAppKey:@"5679327067e58e0472001395"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxe3a66b205d7f605f" appSecret:@"3574e34ccd72b9f5966239695ea3cd03" url:@"http://www.umeng.com/social"];
     [WXApi registerApp:@"wxe3a66b205d7f605f" withDescription:@"weixin"];
    
    //下面是百度统计的内容。
//    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
//    
//    statTracker.enableExceptionLog = NO; // 是否允许截获并发送崩溃信息，请设置YES或者NO
//    
//    statTracker.channelId = @"ReplaceMeWithYourChannel";//设置您的app的发布渠道
//    
//    statTracker.logStrategy = BaiduMobStatLogStrategyCustom;//根据开发者设定的时间间隔接口发送 也可以使用启动时发送策略
//    
//    statTracker.logSendInterval = 1;  //为1时表示发送日志的时间间隔为1小时
//    
//    statTracker.logSendWifiOnly = YES; //是否仅在WIfi情况下发送日志数据
//    statTracker.enableDebugOn = YES;
//    statTracker.sessionResumeInterval = 1;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
//    
//    // statTracker.shortAppVersion  = IosAppVersion; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
//    
//    [statTracker startWithAppId:@"3136aa1670"];//设置您在mtj网站上添加的app的appkey这是聚乐网的。
//    
    // Override point for customization after application launch.
    
    
//    HomeViewController *viewController = [[HomeViewController alloc] init];
//    _sideBarMenuVC = [[SideBarMenuViewController alloc] initWithRootViewController:viewController];
//    //设定_sideBarMenuVC的左侧栏
//    LeftViewController *leftViewController= [[LeftViewController alloc] init];
//    leftViewController.sideBarMenuVC = _sideBarMenuVC;
//    _sideBarMenuVC.leftViewController = leftViewController;
//    //leftViewController展示主视图
//    [leftViewController showViewControllerWithSection:0 Index:1];
//    //[leftViewController showViewControllerWithSection:1 Index:1];
//    self.window.rootViewController = _sideBarMenuVC;
    
    self.window.rootViewController = [[LoginGoViewController alloc]init];
    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
   
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
 
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
  
}
- (void)applicationWillTerminate:(UIApplication *)application {
 
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}@end
