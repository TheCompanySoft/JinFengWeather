//
//  HuView.h
//  弧形进度条
//
//  Created by clare on 15/12/8.
//  Copyright © 2015年 zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HuView : UIView
/**
 *  直接根据数字显示风力数值
 */
@property(nonatomic,assign)float num;
//@property(nonatomic,strong)UILabel *numLabel;
//@property(nonatomic,strong)NSTimer *timer;

-(void)getWindSpeedFromNum:(float)num;

@end
