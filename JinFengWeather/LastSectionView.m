//
//  ThreeSectionView.m
//  JinFengWeather
//
//  Created by huake on 15/11/7.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//最后一个Section线条的颜色

#import "LastSectionView.h"
#import "UIUtils.h"
#import "Header.h"
@interface LastSectionView ()
{
    UIView *_blueView;
    UILabel* _blueLable;
    UIView *_yellowView;
    UILabel* _yellowLable;
}

@end

@implementation LastSectionView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addContentView];
    }
   
    return self;
}
//添加内容视图
-(void)addContentView{
    //蓝色
    _blueView =[[UIView alloc]initWithFrame:AdaptCGRectMake(60,20, 25, 2)];
    _blueView.backgroundColor=[UIColor colorWithRed:5/255.0 green:251/255.0 blue:250/255.0 alpha:1];
    _blueLable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(93, 10, 50, 25)];
    _blueLable.text=@"1h";
    _blueLable.textColor=[UIColor whiteColor];
    _blueLable.font=[UIFont systemFontOfSize:15];
    //黄色
    _yellowView =[[UIView alloc]initWithFrame:AdaptCGRectMake(138, 20, 25, 2)];
    _yellowView.backgroundColor=[UIColor colorWithRed:235/255.0 green:247/255.0 blue:37/255.0 alpha:1];
    _yellowLable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(169,10, 50, 25)];
    _yellowLable.font=[UIFont systemFontOfSize:15];
    _yellowLable.text=@"12h";
    _yellowLable.textColor=[UIColor whiteColor];
    [self addSubview:_blueView];
    [self addSubview:_yellowView];
    [self addSubview:_blueLable];
    [self addSubview:_yellowLable];
}

@end
