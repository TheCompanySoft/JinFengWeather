//
//  DayArrayinfo.h
//  网络请求—AFNetworking
//
//  Created by huake on 15/9/28.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//collectionview的cell
#import "BFHChartCell.h"
#import "BFHChartCellLayer.h"
#import "UIUtils.h"
#import "HFHChartDomain.h"
#import "Header.h"
@interface BFHChartCell ()
{
       BOOL *_isShowingHead;
  }
@end

@implementation BFHChartCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setXlabel];
        [self yellowview];
    }
    return self;
}
//x轴
-(void)setXlabel
{
    for (UIView *view in [self subviews]) {
        [view resignFirstResponder];
    }
    if (!_xlabel) {
        _xlabel=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.frame)-10*[UIUtils getWindowHeight]/568,[UIUtils getWindowWidth]/5 ,10*[UIUtils getWindowHeight]/568)];
        _xlabel.backgroundColor=[UIColor clearColor];
        _xlabel.textColor=[UIColor whiteColor];
        _xlabel.font=[UIFont systemFontOfSize:12];
        _xlabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_xlabel];
    }
   //预警黄线
    if (!_yellowview) {
        _yellowview= [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMinY(_xlabel.frame)-4*[UIUtils getWindowHeight]/568,[UIUtils getWindowWidth]/5,4*[UIUtils getWindowHeight]/568)];
        [self addSubview:_yellowview];
    }
    
 

}

+(Class)layerClass
{
    return [BFHChartCellLayer class];
}
-(BFHChartCellLayer*)selfLayer
{
    return (BFHChartCellLayer*)self.layer;
}
//显示线条的样式
-(void)setChartLine:(GLChartLine)chartLine oldChartLine:(GLChartLine)oldChartLine showStart:(BOOL)showStart showEnd:(BOOL)showEnd
{
    BFHChartCellLayer *layer  = [self selfLayer];
    [layer setLineColor:[[UIColor whiteColor] CGColor]];
    [layer setTargetChartLine:chartLine targetOldChartLine:oldChartLine  animate:YES];
    //开始
    [layer setShowStart:showStart];
    //结束
    [layer setShowEnd:showEnd];
    [layer setNeedsDisplay];
}


-(void)prepareForReuse
{
    [super prepareForReuse];
    [[self selfLayer] setTargetChartLine:GLChartLineMake(0, 0, 0)  targetOldChartLine:GLChartLineMake(0, 0, 0)  animate:NO];
}


@end
