//
//  Header.h
//  适配
//
//  Created by huake on 15/9/19.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#define DEFAULT_WIDTH 320
#define DEFAULT_HEIGHT 568
#import "UIResponder+Adapt.h"


@implementation UIResponder (Adapt)
//基于320 569 适配封装
CGRect AdaptCGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect sreenBounds = [UIScreen mainScreen].bounds;
    CGFloat scaleW,scaleH;
    if (sreenBounds.size.height > 480) {
        scaleW  = sreenBounds.size.width/DEFAULT_WIDTH;
        scaleH  = sreenBounds.size.height/DEFAULT_HEIGHT;
    }
    else {
        
        scaleW  = scaleH  = 1.0;
    }
    return CGRectMake(x*scaleW, y*scaleH, width *scaleW, height*scaleH);
}

@end
