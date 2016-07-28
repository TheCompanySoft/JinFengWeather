//
//  FirstSectionView.m
//  JinFengWeather
//
//  Created by huake on 15/11/7.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
/**
 *  添加折线图的线的对应线条的颜色
 *
 *  @return 
 */

#import "FirstSectionView.h"
#import "Header.h"
#import "UIUtils.h"
@interface FirstSectionView ()
{
}
@end

@implementation FirstSectionView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addContentView];
    }
    return self;
}
/**
 *  添加内容视图
 */
-(void)addContentView{
    //温度线的样式
    UIView *blueView =[[UIView alloc]initWithFrame:AdaptCGRectMake(60, 20, 25, 2)];
    blueView.backgroundColor=[UIColor colorWithRed:5/255.0 green:251/255.0 blue:250/255.0 alpha:1];
    [self addSubview:blueView];
    UILabel* blueLable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(93, 13, 50, 25)];
    blueLable.text=@"温度";
    blueLable.font=[UIFont systemFontOfSize:15];
    blueLable.textColor=[UIColor whiteColor];
    [self addSubview:blueLable];
    //风速线的样式
    UIView *yellowView =[[UIView alloc]initWithFrame:AdaptCGRectMake(138, 20, 25, 2)];
    yellowView.backgroundColor=[UIColor colorWithRed:235/255.0 green:247/255.0 blue:37/255.0 alpha:1];
    [self addSubview:yellowView];
    UILabel* yellowLable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(169, 13, 50, 25)];
    yellowLable.text=@"风速";
    yellowLable.font=[UIFont systemFontOfSize:15];
    yellowLable.textColor=[UIColor whiteColor];
    [self addSubview:yellowLable];
    //下拉cell的按钮
    UIButton *moreBtn =[[UIButton alloc]initWithFrame:AdaptCGRectMake(280, 15, 18, 18)];
    [moreBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateSelected];
    moreBtn.selected = NO;
    [moreBtn addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreBtn];
}
//按钮方法
-(void)doButton:(UIButton*)btn{
    btn.selected = !btn.selected;
    if (self.delegate &&[self.delegate respondsToSelector:@selector(firseSectiondelegate)]) {
        [self.delegate firseSectiondelegate];
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
