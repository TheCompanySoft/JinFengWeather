//
//  SecondSectionView.m
//  JinFengWeather
//
//  Created by huake on 15/11/7.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//此View就是风车旋转所在的Section的子视图

#import "MoreparameterSectionView.h"
#import "Header.h"
#import "UIUtils.h"
#import "WindmillView.h"

@interface MoreparameterSectionView (){
    int _a;//用来记录是否为 海上风电场
}
@property(nonatomic ,strong)WindmillView *fengView;
@end
@implementation MoreparameterSectionView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        //添加内容视图
//        [self addContentView];
    }
    return self;
}
/**
 *  添加内容视图
 */
-(void)addContentViewWithFlag:(int)flag{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sayHi:) name:@"str12" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addStr:) name:@"addStr" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sayHi1:) name:@"str1234" object:nil];
    UIView *hhView=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 2, 320, 55)];
    hhView.backgroundColor= [UIColor colorWithWhite:0 alpha:0.12];
    [self addSubview:hhView];
    self.buttons =[NSMutableArray array];
  _iconArray=@[@"waveheight.png",@"btn_sealevel.png",@"btn_humidity@2x",@"btn_snowfall@2x",@"btn_rainfall@2x",@"btn_temperature@2x",@"waveheight_on.png",@"btn_sealevel_on.png",@"btn_humidity_on@2x",@"btn_snow_on@2x",@"btn_rainfall_on@2x",@"btn_temperature_on@2x"];
    _marklabel=[[UILabel alloc]initWithFrame:AdaptCGRectMake(12, 15, 80, 35)];
    _marklabel.text=@"湿度";
    _marklabel.font=[UIFont systemFontOfSize:18];
    _marklabel.textColor=[UIColor whiteColor];
    [self addSubview:_marklabel];
    if (flag == 1) {
        _a = 0;
    }else{
        _a = 2;
    }
    for (int i =_a; i<6; i++) {
        _temp =[UIButton buttonWithType:UIButtonTypeCustom];
        _temp.frame =AdaptCGRectMake(80+320/8*i,12,35,35);
        if (i==_a) {
            _temp.selected=YES;
        }
        [_temp setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[_iconArray objectAtIndex:i]]] forState:UIControlStateNormal];
        [_temp setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[_iconArray objectAtIndex:i+6]]] forState:UIControlStateSelected];
        _temp.tag=i;
        [_temp addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_temp];
        [self.buttons addObject:_temp];
       
    }
     _images =[UIImage imageNamed:@"water@2x"];
    _imageView =[[UIImageView alloc]initWithFrame:AdaptCGRectMake(12, 83,_images.size.width,_images.size.height)];
    [_imageView setImage:_images];
    [self addSubview:_imageView];
    _percentLabel =[[UILabel alloc]initWithFrame:AdaptCGRectMake(CGRectGetMaxX(_imageView.frame)+10, 63,150, 70)];
   
    _percentLabel.font=[UIFont systemFontOfSize:16];
    _percentLabel.adjustsFontSizeToFitWidth=YES;
    _percentLabel.numberOfLines=2;
    _percentLabel.text=@"无数据";
    _percentLabel.textColor=[UIColor whiteColor];
    [self addSubview:_percentLabel];
    [self addSubview:self.fengView];
   
}
//百分数
-(void)setStrValue:(NSString *)strValue{
//    NSString *str=@"%";
//    NSString *strr1=[NSString stringWithFormat:@"%@%@",strValue,str];
 _percentLabel.text=strValue;
    
}
//获取通知传的参数
-(void)addStr:(NSNotification *)noti
{
   // NSLog(@"noti.objectnoti.object%@",noti.object);
_percentLabel.text=[noti.object objectForKey:@"3"];


}
//获取通知传的参数
-(void)sayHi:(NSNotification *)noti
{
  
//    NSString *str1=@"%";
//    NSString *str=[NSString stringWithFormat:@"%@%@",noti.object,str1];
    NSString *str = [NSString stringWithFormat:@"%@",noti.object];
  _percentLabel.text=str;
    
}
//获取通知传的参数
-(void)sayHi1:(NSNotification *)noti
{
        NSString *str3=@"hPa";
        NSString *sty=[NSString stringWithFormat:@"%@%@",noti.object,str3];
        _percentLabel.text=sty;
        _percentLabel.adjustsFontSizeToFitWidth=YES;
    
}
//释放通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"str12" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"str1234" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addStr" object:nil];
    
}
/**
 *  在section上添加旋转风车
 *
 *  @return 风车view
 */
-(WindmillView*)fengView{
    if (!_fengView) {
        _fengView=[[WindmillView alloc]initWithFrame:AdaptCGRectMake(230, 60,50, 60)];
        _fengView.backgroundColor=[UIColor clearColor];
    }
    return _fengView;
}
//四个按钮调用的方法（代理执行）
-(void)doButton:(UIButton*)btn{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(secondSection:)]) {
        [self.delegate secondSection:btn];
    }
    
}

@end
