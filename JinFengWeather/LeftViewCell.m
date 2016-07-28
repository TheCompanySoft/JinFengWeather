//
//  LeftViewCell.m
//  JinFengWeather
//
//  Created by huake on 15/9/16.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

//设置界面的cell

#import "LeftViewCell.h"
#import "UIUtils.h"
#import "Header.h"
@interface LeftViewCell ()

@end

@implementation LeftViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加内容视图
        [self addContentView];
    }
    return self;
}

//添加内容视图
- (void)addContentView
{
    
    
//    //设定被选中的背景视图
    UIView *cellBackGroundViewHighlight = [[UIView alloc] init];
    cellBackGroundViewHighlight.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"headbg@2x"]];
    self.selectedBackgroundView = cellBackGroundViewHighlight;
    UIImage *image = [UIImage imageNamed:@"weather_a@2x"];
//    
    //初始化菜单图标头_imageView
    _imageView1 = [[UIImageView alloc] initWithFrame:AdaptCGRectMake(10, 15, image.size.width, image.size.height)];
    
    //    _imageView1.backgroundColor = [UIColor redColor];
    [self addSubview:_imageView1];
    
    //初始化城市名lable
    _label = [[UILabel alloc] initWithFrame:AdaptCGRectMake(60,13,65, 30)];
    _label.backgroundColor=[UIColor clearColor];
    _label.textColor = [UIColor whiteColor];
    _label.font=[UIFont systemFontOfSize:15];
   
    _label.textColor=[UIColor whiteColor];
    //    右边
    _rightlabel =[[UILabel alloc]initWithFrame:AdaptCGRectMake(208, 15, 45,25)];
    _rightlabel.textAlignment=NSTextAlignmentCenter;
    _rightlabel.font=[UIFont systemFontOfSize:15];
    _rightlabel.textColor=[UIColor whiteColor];
    [self addSubview:_rightlabel];
    
    //    预警
    _warningView =[[UIImageView alloc]initWithFrame:AdaptCGRectMake(180, 15,20, 20)];
    
    // 箭头
    _moveView =[[UIImageView alloc]init];
    [self addSubview:_moveView];
    //定位图标
    [self addSubview:_label];
    
   
}
//设置内容视图显示内容
- (void)setContentView:(NSDictionary *)dictionary
{
    UIImage *imageView=dictionary[@"image"];
    _imageView1.frame=AdaptCGRectMake(15, 20, imageView.size.width, imageView.size.height);
    _imageView1.center=CGPointMake(_imageView1.center.x,self.center.y+5);
    [_imageView1 setImage:imageView];
    _label.center=CGPointMake(_label.center.x, _imageView1.center.y);
    [_label setText:dictionary[@"text"]];
}

@end
