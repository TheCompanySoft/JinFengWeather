//
//  DayArrayinfo.h
//  网络请求—AFNetworking
//
//  Created by huake on 15/9/28.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//绘制折线图

#import "BFHChartCellLayer.h"
 #import <UIKit/UIKit.h>
@interface BFHChartCellLayer()
{
    NSDate *_startDate;
    GLChartLine _targetChartLine;
    GLChartLine _startChartLine;
    GLChartLine _oldTargetChartLine;
    GLChartLine _oldStartChartLine;
}
@end

@implementation BFHChartCellLayer
@synthesize chartLine;
@synthesize lineColor;
@synthesize showStart;
@synthesize showEnd;
@synthesize oldChartLine;
-(void)setTargetChartLine:(GLChartLine)achartLine  targetOldChartLine:(GLChartLine)aoldChartLine animate:(BOOL)animate
{
    
    
//    if(animate && (chartLine.startPoint != 0 || chartLine.endPoint != 0 || chartLine.mainPoint !=0) ){
//        _targetChartLine = achartLine;
//        _startChartLine = chartLine;
//        _startDate = [NSDate date];
//        _oldTargetChartLine = aoldChartLine;
//        _oldStartChartLine =oldChartLine;
//        
//        CADisplayLink *_display =[CADisplayLink displayLinkWithTarget:self selector:@selector(animateChartLine:)];
//        [_display addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//    }else{
        chartLine = achartLine;
        oldChartLine = aoldChartLine;
        [self setNeedsDisplay];
    //}

    
}
//绘制线条和数据点
-(void)drawInContext:(CGContextRef)ctx
{
  
    CGSize size = self.bounds.size;
    CGContextSetStrokeColorWithColor(ctx,  [UIColor colorWithRed:5/255.0 green:251/255.0 blue:250/255.0 alpha:1].CGColor);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 1.8);
  CGFloat mainY =oldChartLine.mainPoint;
    if(showStart){
    CGFloat startY = oldChartLine.startPoint;
        startY =  startY - (mainY-startY)/size.width*2;
        CGContextMoveToPoint(ctx, -1,startY);
        CGContextAddLineToPoint(ctx, size.width/2,mainY);
    }else{
       CGContextMoveToPoint(ctx, size.width/2, mainY);
          }
    if(showEnd){
        CGFloat endY  = oldChartLine.endPoint;
        endY = endY - (mainY - endY)/size.width*2;
        CGContextAddLineToPoint(ctx, size.width+1, endY);
    }
    CGContextStrokePath(ctx);
    CGContextSaveGState(ctx);
  CGPoint mainCenter = CGPointMake(size.width/2, mainY);
 
   
    CGSize smallCenterSize =  CGSizeMake(8, 8);
    CGRect smallCircle =  CGRectMake(mainCenter.x-smallCenterSize.width/2, mainCenter.y - smallCenterSize.height/2, smallCenterSize.width, smallCenterSize.height);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:5/255.0 green:251/255.0 blue:250/255.0 alpha:1] CGColor]);
    CGContextAddEllipseInRect(ctx, smallCircle);
    CGContextFillPath(ctx);
    CGContextSaveGState(ctx);
    
    CGSize size1 = self.bounds.size;
    CGContextSetStrokeColorWithColor(ctx,  [UIColor colorWithRed:235/255.0 green:247/255.0 blue:37/255.0 alpha:1].CGColor);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx,1.8);
    CGFloat mainY1 =chartLine.mainPoint;
    if(showStart){
        CGFloat startY1 = chartLine.startPoint;
        startY1 =  startY1 - (mainY1-startY1)/size1.width*2;
        CGContextMoveToPoint(ctx, -1,startY1);
        CGContextAddLineToPoint(ctx, size1.width/2,mainY1);
    }else{
       
          CGContextMoveToPoint(ctx, size1.width/2, mainY1);
    }
    if(showEnd){
                CGFloat endY1  = chartLine.endPoint;
                endY1 = endY1 - (mainY1 - endY1)/size1.width*2;
                CGContextAddLineToPoint(ctx, size1.width+1, endY1);
    }
    CGContextStrokePath(ctx);
    CGContextSaveGState(ctx);
    CGPoint mainCenter1 = CGPointMake(size1.width/2, mainY1);
    
    CGSize centerSize1 =  CGSizeMake(8, 8);
    CGRect bigCircle1 =  CGRectMake(mainCenter1.x-centerSize1.width/2, mainCenter1.y - centerSize1.height/2, centerSize1.width, centerSize1.height);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:235/255.0 green:247/255.0 blue:37/255.0 alpha:1 ] CGColor]);
    CGContextAddEllipseInRect(ctx, bigCircle1);
    CGContextFillPath(ctx);
    CGContextSaveGState(ctx);
    
}
+(BOOL)needsDisplayForKey:(NSString *)key
{
    if( [key isEqualToString:@"chartLine"]){
        return YES;
    }else{
        return [super needsDisplayForKey:key];
    }
}

//-(void)animateChartLine:(CADisplayLink *)sender
//{
//    NSTimeInterval timeDuration = 0.3;//300毫秒
//    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:_startDate];
//    if(duration >= timeDuration){
//        chartLine = _targetChartLine;
//        oldChartLine = _oldTargetChartLine;
//        [self setNeedsDisplay];
//        [sender invalidate];
//        return;
//    }
//    CGFloat nowStart = _startChartLine.startPoint + (duration/timeDuration)*(_targetChartLine.startPoint - _startChartLine.startPoint);
//    CGFloat nowMain = _startChartLine.mainPoint + (duration/timeDuration)*(_targetChartLine.mainPoint - _startChartLine.mainPoint);
//    CGFloat endMain = _startChartLine.endPoint + (duration/timeDuration)*(_targetChartLine.endPoint - _startChartLine.endPoint);
//    chartLine = GLChartLineMake(nowStart, nowMain, endMain);
//    
//    CGFloat oldNowStart = _oldStartChartLine.startPoint + (duration/timeDuration)*(_oldTargetChartLine.startPoint - _oldStartChartLine.startPoint);
//    CGFloat oldNowMain = _oldStartChartLine.mainPoint + (duration/timeDuration)*(_oldTargetChartLine.mainPoint - _oldStartChartLine.mainPoint);
//    CGFloat oldEndMain = _oldStartChartLine.endPoint + (duration/timeDuration)*(_oldTargetChartLine.endPoint - _oldStartChartLine.endPoint);
//    oldChartLine = GLChartLineMake(oldNowStart, oldNowMain, oldEndMain);
//    
//    [self setNeedsDisplay];
//}


@end
