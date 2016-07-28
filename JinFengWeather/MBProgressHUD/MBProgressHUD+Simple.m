//
//  MBProgressHUD+Simple.m
//  网络请求—AFNetworking
//
//  Created by huake on 15/11/21.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import "MBProgressHUD+Simple.h"

@implementation MBProgressHUD (Simple)
#pragma mark HUD
//展示HUD
+ (MBProgressHUD *)show:(MBProgressHUDMode )_mode message:(NSString *)_message customView:(id)_customView
{
    MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:_customView];
    [_customView addSubview:HUD];
    HUD.mode=_mode;
    HUD.customView = _customView;
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.labelText = _message;
    [HUD show:YES];
    return HUD;
}


@end
