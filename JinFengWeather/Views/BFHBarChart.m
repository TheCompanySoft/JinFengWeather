//
//  UUBarChart.m
//  JinFengWeather
//
//  Created by huake on 15/10/3.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "BFHBarChart.h"
#import "BFHChartLabel.h"
#import "BFHBar.h"
#import "UIUtils.h"
#import "Header.h"

@interface BFHBarChart ()<UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    CGFloat _level;
    UIView *_lineView;
}
@property(nonatomic ,strong)UILabel*windSu;
@property(nonatomic ,strong)UILabel*windSu1;
@property(nonatomic ,strong)UILabel*windSu2;
@property(nonatomic,assign)float max;
@property(nonatomic,assign)double a;

@end

@implementation BFHBarChart {
    NSHashTable *_chartLabelsForX;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
         //添加滚动视图
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIUtils getWindowWidth], frame.size.height)];
        myScrollView.bounces=NO;
        myScrollView.delegate=self;
        myScrollView.showsHorizontalScrollIndicator =NO;
        
        //添加线的背景
        _lineView = [[UIView alloc] initWithFrame:AdaptCGRectMake(0,0,320/6,568/2-70)] ;
        
        _windSu=[[UILabel alloc]init];
        _windSu.layer.cornerRadius=4;
        _windSu.layer.masksToBounds=YES;
        _windSu.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.2];
        _windSu.font=[UIFont systemFontOfSize:10];
        _windSu.textAlignment=NSTextAlignmentCenter;
        _windSu.textColor=[UIColor colorWithRed:5/255.0 green:251/255.0 blue:250/255.0 alpha:1];
        [_lineView addSubview:_windSu];
        _windSu1=[[UILabel alloc]init];
        _windSu1.font=[UIFont systemFontOfSize:10];
        _windSu1.layer.cornerRadius=4;
        _windSu1.layer.masksToBounds=YES;
        _windSu1.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.2];
        _windSu1.textAlignment=NSTextAlignmentCenter;
        _windSu1.textColor=[UIColor yellowColor];
        [_lineView addSubview:_windSu1];
        _windSu2=[[UILabel alloc]init];
        _windSu2.font=[UIFont systemFontOfSize:10];
        _windSu2.layer.cornerRadius=4;
        _windSu2.layer.masksToBounds=YES;
        _windSu2.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.2];
        _windSu2.textAlignment=NSTextAlignmentCenter;
        _windSu2.textColor=[UIColor yellowColor];
        [_lineView addSubview:_windSu2];
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(20*[UIUtils getWindowWidth]/320, 0, 1.5*[UIUtils getWindowWidth]/320, [UIUtils getWindowHeight]/2-70*[UIUtils getWindowHeight]/568)];
        view.backgroundColor=[UIColor colorWithWhite:1 alpha:0.8];
        [_lineView addSubview:view];
        [self addSubview:_lineView];
    }
    return self;
}
//添加y轴的label
-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000;
    if (self.showRange) {
        _yValueMin = (int)min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }
    
    _level = _yValueMax /6.0;
    CGFloat chartCavanHeight = self.frame.size.height - 25*[UIUtils getWindowHeight]/568;
    CGFloat levelHeight = (chartCavanHeight-50) /6.0;
    
    for (int i=0; i<7; i++) {
        BFHChartLabel * label = [[BFHChartLabel alloc] initWithFrame:CGRectMake(4.0*[UIUtils getWindowWidth]/320,chartCavanHeight-i*(levelHeight+0.2*i)-10, 30*[UIUtils getWindowWidth]/320, 20*[UIUtils getWindowHeight]/568)];
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:11];
        if (i!=0) {
            label.text = [NSString stringWithFormat:@"%d",(int)_level * i];
        }
        
        [self addSubview:label];
    }
}
//添加x轴的label
-(void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    _xLabels = xLabels;
    NSInteger num;
    if (xLabels.count>=8) {
        num = 6;
    }else if (xLabels.count<=4){
        num = 4;
    }
    _xLabelWidth = myScrollView.frame.size.width/num;
    for (int i=0; i<xLabels.count; i++) {
        NSString *labelText = xLabels[i];
        BFHChartLabel * label = [[BFHChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth, self.frame.size.height- 6*[UIUtils getWindowHeight]/568-3, _xLabelWidth, 9*[UIUtils getWindowHeight]/568)];
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont systemFontOfSize:12];
        NSString*str=@"      ";
        label.text =[NSString stringWithFormat:@"%@%@",str,labelText];
        label.textAlignment=NSTextAlignmentLeft;
        [myScrollView addSubview:label];
        [_chartLabelsForX addObject:label];
    }
    
    _max = ([xLabels count])*_xLabelWidth ;
    [self addSubview:myScrollView];
    if (myScrollView.frame.size.width < _max-10) {
        myScrollView.contentSize = CGSizeMake(_max, self.frame.size.height);
    }
}
//获取参数
-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
    NSArray*array1=_yValues[0];
    NSArray*array2=_yValues[1];
    NSArray*array3=_yValues[2];
    if (array1.count>0) {
        NSString *strrr=[NSString stringWithFormat:@"%@mm/h",[array1 objectAtIndex:0]];
        NSString *strrr2=[NSString stringWithFormat:@"%@mm/12h",[array2 objectAtIndex:0]];
        NSString *str3=[NSString stringWithFormat:@"%@日",[array3 objectAtIndex:0]];
        _windSu.text=strrr;
        _windSu1.text=strrr2;
        _windSu2.text=str3;
    }
     CGSize sizeThatFit=[_windSu sizeThatFits:CGSizeZero];
    _windSu.frame=AdaptCGRectMake(25, 2, sizeThatFit.width, 10);
    CGSize sizeThatFit1=[_windSu1 sizeThatFits:CGSizeZero];
    _windSu1.frame=AdaptCGRectMake(25, 15, sizeThatFit1.width, 10);
    CGSize sizeThatFit2=[_windSu2 sizeThatFits:CGSizeZero];
    _windSu2.frame=AdaptCGRectMake(25, 28, sizeThatFit2.width, 10);
}
//滚动传值
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint point=scrollView.contentOffset;
   
    CGRect frame = _lineView.frame;
    
    _a=5*_xLabelWidth*point.x/(_max-[UIUtils getWindowWidth]);
    
    double gv=5*_xLabelWidth/((_max-_xLabelWidth)/_xLabelWidth);
    int index=_a/gv;
 
    NSArray*array1=_yValues[0];
    NSArray*array2=_yValues[1];
    NSArray*array3=_yValues[2];
    NSString *strrr=[NSString stringWithFormat:@"%@mm/h",[array1 objectAtIndex:index]];
    NSString *strrr2=[NSString stringWithFormat:@"%@mm/12h",[array2 objectAtIndex:index]];
    NSString *str31=[NSString stringWithFormat:@"%@日",[array3 objectAtIndex:index]];
    _windSu.text=strrr;
    _windSu1.text=strrr2;
    _windSu2.text=str31;
    //根据字的长度改变宽度
    CGSize sizeThatFit=[_windSu sizeThatFits:CGSizeZero];
    CGSize sizeThatFit1=[_windSu1 sizeThatFits:CGSizeZero];
    CGSize sizeThatFit2=[_windSu2 sizeThatFits:CGSizeZero];
    if ((int)_a>150) {
        
        _windSu.frame=AdaptCGRectMake(sizeThatFit.width*-1+20,2, sizeThatFit.width,10);
        
        _windSu1.frame=AdaptCGRectMake(sizeThatFit1.width*-1+20,15, sizeThatFit1.width, 10);
        _windSu2.frame=AdaptCGRectMake(sizeThatFit2.width*-1+20,28, sizeThatFit2.width, 10);
    }else {
        
        _windSu.frame=AdaptCGRectMake(25, 2, sizeThatFit.width, 10);
        _windSu1.frame=AdaptCGRectMake(25, 15, sizeThatFit1.width, 10);
        _windSu2.frame=AdaptCGRectMake(25, 28, sizeThatFit2.width, 10);
        
    }
    
    NSString *addStr=[NSString stringWithFormat:@"%@\n%@",strrr,strrr2];
    NSDictionary *dic=@{@"1":[array1 objectAtIndex:index],@"2":[array2 objectAtIndex:index],@"3":addStr};
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addStr" object:dic];
  //  NSString *strindex=[NSString stringWithFormat:@"%d",index];
      //  [[NSNotificationCenter defaultCenter]postNotificationName:@"addindex" object:strindex];
    //NSLog(@"_yValues_yValues%@",strindex);
    frame.origin.x=_a;
    _lineView.frame=frame;

    if(index==71&&array1.count==72){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"log" object:nil];
    }
    if(index==287&&array1.count==288){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"log" object:nil];
    }
    if(index==23&&array1.count==24){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"log" object:nil];
    }
    
    [self addSubview:_lineView];
    if (point.x<0) {
        [self addSubview:_lineView];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"log" object:nil];
    
}

-(void)setColors:(NSArray *)colors
{
    _colors = colors;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

-(void)strokeChart
{
    CGFloat chartCavanHeight = self.frame.size.height - 60*[UIUtils getWindowHeight]/568;
    for (int i=0; i<_yValues.count; i++) {
        if (i==2)
            return;
        NSArray *childAry = _yValues[i];
        for (int j=0; j<childAry.count; j++) {
            NSString *valueString = childAry[j];
            //默认0显示
            float value = [valueString floatValue]+_yValueMax/25;
            float grade = ((float)value-_yValueMin) / ((float)_yValueMax-_yValueMin);
            //设置bar的参数
            BFHBar * bar = [[BFHBar alloc] initWithFrame:CGRectMake(18+(j+(_yValues.count==1?2:0.02))*_xLabelWidth+i*_xLabelWidth * 0.35, 46*[UIUtils getWindowHeight]/568, _xLabelWidth * (_yValues.count==1?0.4:0.35), chartCavanHeight)];
            //颜色
            bar.barColor = [_colors objectAtIndex:i];
            bar.grade = grade;
            [myScrollView addSubview:bar];
        }
    }
}
//返回数组数据
- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

@end
