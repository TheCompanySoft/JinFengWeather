//
//  UUBar.m
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//柱状图
#import "BFHBar.h"
#import "BFHColor.h"
#import "UIUtils.h"
@implementation BFHBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
		_chartLine = [CAShapeLayer layer];
		_chartLine.lineCap = kCALineCapSquare;
		_chartLine.fillColor   = [[UIColor clearColor] CGColor];
		_chartLine.lineWidth   = self.frame.size.width;
		_chartLine.strokeEnd   = 0.0;
		self.clipsToBounds = YES;
		[self.layer addSublayer:_chartLine];
		self.layer.cornerRadius = 2.0;
     }
    return self;
}
//设置柱状图的样式
-(void)setGrade:(float)grade
{
    if (grade==0)
    return;
  
	_grade = grade;
	UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:CGPointMake(self.frame.size.width/3.2, self.frame.size.height+30)];
	[progressline addLineToPoint:CGPointMake(self.frame.size.width/3.2, (1 - grade) * self.frame.size.height+15*[UIUtils getWindowHeight]/568)];
    [progressline setLineWidth:100.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
	_chartLine.path = progressline.CGPath;
    
	if (_barColor) {
		_chartLine.strokeColor = [_barColor CGColor];
	}else{
		_chartLine.strokeColor = [[UIColor greenColor] CGColor];
	}
    _chartLine.strokeEnd = 2.0;
}

- (void)drawRect:(CGRect)rect
{
	//Draw BG
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);

	CGContextFillRect(context, rect);
    
}


@end
