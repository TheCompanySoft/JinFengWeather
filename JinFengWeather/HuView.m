//
//  HuView.m
//  弧形进度条
//
//  Created by clare on 15/12/8.
//  Copyright © 2015年 zhou. All rights reserved.
//

#import "HuView.h"
#import "UIUtils.h"

@implementation HuView

- (void)drawRect:(CGRect)rect {
    //    仪表盘底部
    drawHu1();
    //    仪表盘进度
    [self drawHu2];
}

//选中线
-(void)drawHu2
{
    //1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //1.1 设置线条的宽度
    CGContextSetLineWidth(ctx, 10);
    //1.2 设置线条的起始点样式
    CGContextSetLineCap(ctx,kCGLineCapButt);
    //1.3  虚实切换 ，实线5虚线10
    CGFloat length[] = {1,2};
    CGContextSetLineDash(ctx, 0, length, 2);
    //1.4 设置颜色
    [[UIColor greenColor] set];
    
    
    CGFloat end = -5*M_PI_4+(6*M_PI_4*_num/30);
    
    //锚点    半径
    CGContextAddArc(ctx, 75*[UIUtils getWindowWidth]/320 , 75*[UIUtils getWindowWidth]/320, 80, -5*M_PI_4, end , 0);
    
    //3.绘制
    CGContextStrokePath(ctx);
    
}


//未选中
void drawHu1()
{
    //1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //1.1 设置线条的宽度
    CGContextSetLineWidth(ctx, 10);
    //1.2 设置线条的起始点样式
    CGContextSetLineCap(ctx,kCGLineCapButt);
    //1.3  虚实切换 ，实线5虚线10
    CGFloat length[] = {1,2};
    CGContextSetLineDash(ctx, 0, length, 2);
    //1.4 设置颜色
    [[UIColor whiteColor] set];
    //2.设置路径
    CGContextAddArc(ctx, 75*[UIUtils getWindowWidth]/320 , 75*[UIUtils getWindowWidth]/320, 80, -5*M_PI_4, M_PI_4, 0);
    //3.绘制
    CGContextStrokePath(ctx);
    
}



-(void)getWindSpeedFromNum:(float)num{
    _num = num;
    [self setNeedsDisplay];
}

@end
