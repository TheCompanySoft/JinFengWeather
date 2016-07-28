//
//  LeftViewCell.h
//  JinFengWeather
//
//  Created by huake on 15/9/16.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewCell : UITableViewCell

//设置内容视图显示内容
- (void)setContentView:(NSDictionary *)dictionary;
@property(nonatomic,strong)UILabel *rightlabel;
@property(nonatomic,strong)UIImageView*warningView;
@property(nonatomic,strong)UIImageView*moveView;

@property (nonatomic,strong)UILabel *label;

@property (nonatomic,strong)UIImageView *imageView1;


@end
