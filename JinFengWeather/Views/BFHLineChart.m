//
//  UULineChart.m
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "BFHLineChart.h"
#import "BFHColor.h"
#import "BFHChartLabel.h"

#import "UIUtils.h"
#import "Header.h"
#import "UIUtils.h"


#define UULabelHeight    10

@interface BFHLineChart ()<UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    BFHChartLabel * _label;
    UIView *_lineView;
    
}
@property(nonatomic,assign)float labelsize;
@property(nonatomic,assign)float a;
@property(nonatomic,strong)NSArray *labelsArray;
@property(nonatomic,strong)NSArray *dateArray;
@property(nonatomic ,strong)UILabel*windSu;
@property(nonatomic ,strong)UILabel*dateLabel;
@property(nonatomic,assign)float max;
@end
@implementation BFHLineChart {
    NSHashTable *_chartLabelsForX;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _yValues=[NSArray array];
        _dateArray=[NSArray array];
        self.clipsToBounds = YES;
        //添加滚动视图
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,[UIUtils getWindowWidth], frame.size.height)];
        myScrollView.bounces=NO;
        myScrollView.delegate=self;
        myScrollView.showsHorizontalScrollIndicator = NO;
        
        [self addSubview:myScrollView];
        
        _lineView = [[UIView alloc] initWithFrame:AdaptCGRectMake(0,0,320/5,568/2-50)];
        _windSu=[[UILabel alloc]init];
        _windSu.font=[UIFont systemFontOfSize:10];
        _windSu.layer.cornerRadius=4;
        _windSu.layer.masksToBounds=YES;
        
        _windSu.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.2];
        _windSu.textAlignment=NSTextAlignmentCenter;
        _windSu.textColor=[UIColor colorWithRed:5/255.0 green:251/255.0 blue:250/255.0 alpha:1];
        [_lineView addSubview:_windSu];
        
        _dateLabel=[[UILabel alloc]init];
        _dateLabel.font=[UIFont systemFontOfSize:10];
        _dateLabel.layer.cornerRadius=4;
        _dateLabel.layer.masksToBounds=YES;
        
        _dateLabel.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.2];
        _dateLabel.textAlignment=NSTextAlignmentCenter;
        _dateLabel.textColor=[UIColor yellowColor];
        [_lineView addSubview:_dateLabel];
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(_lineView.frame.size.width/2, 0, 1.5*[UIUtils getWindowWidth]/320, [UIUtils getWindowHeight]/2-60*[UIUtils getWindowHeight]/568)];
        view.backgroundColor=[UIColor colorWithWhite:1 alpha:0.8];
        [_lineView addSubview:view];
        _lineView.backgroundColor = [UIColor clearColor];
        [self addSubview:_lineView];
    }
    return self;
}

//设置y值
-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues ;
    [self setYLabels:yValues];
    if (yValues.count==2) {
        
        _dateArray=yValues[1];
        
        NSString *strd=[NSString stringWithFormat:@"%@日",[_dateArray objectAtIndex:0]];
        _dateLabel.text=strd;
        CGSize sizeThatFit1=[_dateLabel sizeThatFits:CGSizeZero];
        //重新指定frame
        _dateLabel.frame=AdaptCGRectMake(35,15,sizeThatFit1.width, 10);
    }
    NSArray *array = _yValues[0];
    NSString *str=[NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
    
//    if ([str intValue]<100) {
//        NSString *strrr=[NSString stringWithFormat:@"%@%",str];
//        _windSu.text=strrr;
//        
//    }else{
//        NSString *strrr=[NSString stringWithFormat:@"%@hPa",str];
//        _windSu.text=strrr;
//        
//    }
    _windSu.text=str;
    CGSize sizeThatFit=[_windSu sizeThatFits:CGSizeZero];
    //重新指定frame
    _windSu.frame=AdaptCGRectMake(35, 2, sizeThatFit.width, 10);
}

//添加y轴的label
-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 10000;
    
    if (self.showRange) {
        _yValueMin = min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }
    
    _level = (_yValueMax-_yValueMin)/6.0;
    
    CGFloat chartCavanHeight = [UIUtils getWindowHeight]/2-75*[UIUtils getWindowHeight]/568;
    CGFloat levelHeight = chartCavanHeight/6.0;
    
    for (int i=0; i<7; i++) {
        //y轴label
        BFHChartLabel * label = [[BFHChartLabel alloc] initWithFrame:CGRectMake(5*[UIUtils getWindowWidth]/320,chartCavanHeight-i*levelHeight,30*[UIUtils getWindowWidth]/320, 20*[UIUtils getWindowHeight]/568)];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:11];
        label.backgroundColor=[UIColor clearColor];
        
        if (i!=0) {
            
            label.text = [NSString stringWithFormat:@"%d",(int)(_level * i+_yValueMin)];
            
        }
        [self addSubview:label];
    }
}

//x轴
-(void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    //label的数量
    _xLabels = xLabels;
    
    CGFloat num;
    num=5;
    
    _xLabelWidth = myScrollView.frame.size.width/ num;
    //x轴label的
    for (int i=0; i<xLabels.count; i++) {
        
        NSString *labelText = xLabels[i];
        _label = [[BFHChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth, self.frame.size.height- UULabelHeight, _xLabelWidth, UULabelHeight)];
        _label.text = labelText;
        _label.font=[UIFont systemFontOfSize:12];
        
        _label.textColor=[UIColor whiteColor];
        [myScrollView addSubview:_label];
        
        _label.backgroundColor=[UIColor clearColor];
        [_chartLabelsForX addObject:_label];
        
    }
    _max = [xLabels count]*_xLabelWidth;
    if (myScrollView.frame.size.width < _max-10) {
        myScrollView.contentSize = CGSizeMake(_max, self.frame.size.height);
    }
}
//滚动传值
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint point=scrollView.contentOffset;
    
    CGRect frame = _lineView.frame;
    
    _a=4*_xLabelWidth*point.x/(_max-[UIUtils getWindowWidth]);
    
    double gv=4*_xLabelWidth/((_max-_xLabelWidth)/_xLabelWidth);
    
    int index=_a/gv;
    if (_yValues.count==2) {
        CGSize sizeThatFit=[_dateLabel sizeThatFits:CGSizeZero];
        NSArray *arrdate=_yValues[1];
        if ((int)_a>150) {
            _dateLabel.frame=AdaptCGRectMake( sizeThatFit.width*-1+30, 15, sizeThatFit.width, 10);
        }else {
            
            _dateLabel.frame=AdaptCGRectMake(35,15, sizeThatFit.width, 10);
            
        }
        NSString *strsdate=[NSString stringWithFormat:@"%@日",[arrdate objectAtIndex:index]];
        _dateLabel.text=strsdate;
        
    }
    //根据字的长度改变宽度
    CGSize sizeThatFit=[_windSu sizeThatFits:CGSizeZero];
    if ((int)_a>150) {
        _windSu.frame=AdaptCGRectMake( sizeThatFit.width*-1+30, 2, sizeThatFit.width, 10);
    }else {
        _windSu.frame=AdaptCGRectMake(35, 2, sizeThatFit.width, 10);
    }
    
    _labelsArray=_yValues[0];
    //NSString *str2=@"%";
    NSString *strs=[NSString stringWithFormat:@"%@",[_labelsArray objectAtIndex:0]];
    _windSu.text=strs;
    
    NSString *str1=[NSString stringWithFormat:@"%@",[_labelsArray objectAtIndex:index]];
//    if ([strs intValue]<100) {
//        NSString *sty=[NSString stringWithFormat:@"%@%@",str1,str2];
//        _windSu.text=sty;
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"str12" object:str1];
//        
//    }else{
//        NSString *str3=@"hPa";
//        NSString *sty=[NSString stringWithFormat:@"%@%@",str1,str3];
//        _windSu.text=sty;
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"str1234" object:str1];
//    }
    _windSu.text = str1;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"str12" object:str1];
    
    if((index==71&&_labelsArray.count==72)||(index==287&&_labelsArray.count==288)||(index==23&&_labelsArray.count==24)||(index==5&&_labelsArray.count==6)){
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"log" object:nil];
    }
    
    
    frame.origin.x=_a;
    _lineView.frame=frame;
    _lineView.backgroundColor=[UIColor clearColor];
    [self addSubview:_lineView];
    if (point.x<0) {
        [self addSubview:_lineView];
    }
    
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"log" object:nil];
    
}
//设置颜色
-(void)setColors:(NSArray *)colors
{
    _colors = colors;
}
//范围
- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}


//绘表
-(void)strokeChart
{
    for (int i=0; i<_yValues.count; i++) {
        NSArray *childAry = _yValues[0];
        
        if (childAry.count==0) {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSInteger max_i;
        NSInteger min_i;
        
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[0] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor  = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth  = 1.8;
        _chartLine.strokeEnd  = 0.0;
        [self.layer addSublayer:_chartLine];
        [myScrollView.layer addSublayer:_chartLine];
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition = ( _xLabelWidth/2.0);
        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
        
        
        BOOL isShowMaxAndMinPoint = YES;
        [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)
                 index:i
                isShow:isShowMaxAndMinPoint
                 value:firstValue];
        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        NSInteger index = 0;
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                [progressline addLineToPoint:point];
                
                BOOL isShowMaxAndMinPoint = YES;
                
                
                [progressline moveToPoint:point];
                [self addPoint:point
                         index:i
                        isShow:isShowMaxAndMinPoint
                         value:[valueString floatValue]];
                
            }
            index += 1;
        }
        
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:0] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:0] CGColor];
        }else{
            _chartLine.strokeColor = [[UIColor whiteColor] CGColor];
        }
        
        _chartLine.strokeEnd = 1.0;
    }
}
//添加点视图
- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,8, 8)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius =4.5;
    view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:[UIColor greenColor].CGColor;
    
    if (isHollow) {
        view.backgroundColor = [UIColor colorWithRed:5/255.0 green:251/255.0 blue:250/255.0 alpha:1];
    }else{
        view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:[UIColor colorWithRed:5/255.0 green:251/255.0 blue:250/255.0 alpha:1];
    }
    [myScrollView addSubview:view];
}
//返回数组数据
- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

@end
