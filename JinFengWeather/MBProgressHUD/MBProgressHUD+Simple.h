//
//  MBProgressHUD+Simple.h
//  网络请求—AFNetworking
//
//  Created by huake on 15/11/21.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Simple)
+ (MBProgressHUD *) show:(MBProgressHUDMode )_mode message:(NSString *)_message customView:(id)_customView;

@end
