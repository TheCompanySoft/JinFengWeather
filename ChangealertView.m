//
//  ChangealertView.m
//  自学BMK
//
//  Created by huake on 15/10/20.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "ChangealertView.h"
#import "Header.h"
@interface ChangealertView()<UITextFieldDelegate>

@property (nonatomic, strong) UIView * horizontalSeparator;
@property (nonatomic, strong) UIView * verticalSeparator;
@end
@implementation ChangealertView
-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        //添加内容视图
        [self addContentView];
        self.backgroundColor=[UIColor colorWithRed:253.0/255 green:253.0/25 blue:253.0/25 alpha:0.95];
    }
    return self;
}
//添加内容视图
-(void)addContentView{
    //Set up Seperator
    
    //初始化线条
    self.horizontalSeparator = [[UIView alloc] initWithFrame:CGRectZero];
    self.verticalSeparator = [[UIView alloc] initWithFrame:CGRectZero];
    self.endAdressTF=[[UITextField alloc]initWithFrame:AdaptCGRectMake(15,10,220,30)];
    self.endAdressTF.backgroundColor=[UIColor whiteColor];
    self.endAdressTF.layer.borderColor=[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:202/255.0].CGColor;
    [self.endAdressTF becomeFirstResponder];
    self.endAdressTF.delegate=self;
    self.endAdressTF.layer.borderWidth=0.5;
    self.endAdressTF.font=[UIFont systemFontOfSize:14];
    self.endAdressTF.placeholder=@"请输入地址名称";
    [self addSubview:self.endAdressTF];
    //添加相应的label
    UILabel *alertlable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(15, 52,100, 30)];
    alertlable.backgroundColor=[UIColor clearColor];
    alertlable.text=@"关注风速区间:";
    alertlable.font=[UIFont systemFontOfSize:12];
    alertlable.adjustsFontSizeToFitWidth=YES;
    alertlable.textAlignment=NSTextAlignmentCenter;
    alertlable.textColor=[UIColor grayColor];
    [self addSubview:alertlable];
    
    UILabel *alertlable1=[[UILabel alloc]initWithFrame:AdaptCGRectMake(15, 94,100, 30)];
    alertlable1.backgroundColor=[UIColor clearColor];
    alertlable1.text=@"关注风速区间:";
    alertlable1.font=[UIFont systemFontOfSize:12];
    alertlable1.adjustsFontSizeToFitWidth=YES;
    alertlable1.textAlignment=NSTextAlignmentCenter;
    alertlable1.textColor=[UIColor grayColor];
    [self addSubview:alertlable1];
    
    //添加相应的文本
    _leftCityTF=[[UITextField alloc]initWithFrame:AdaptCGRectMake(120, 52,90, 30)];
    _leftCityTF.layer.borderColor=[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:202/255.0].CGColor;
    _leftCityTF.layer.borderWidth=0.5;
    _leftCityTF.backgroundColor=[UIColor whiteColor];
    _leftCityTF.delegate=self;
    _leftCityTF.font=[UIFont systemFontOfSize:14];
    _leftCityTF.placeholder=@"可选填，上限";
    _leftCityTF.adjustsFontSizeToFitWidth=YES;
    [self addSubview:_leftCityTF];
    _rightCityTF=[[UITextField alloc]initWithFrame:AdaptCGRectMake(120, 94,90, 30)];
    _rightCityTF.placeholder=@"可选填，下限";
    _rightCityTF.adjustsFontSizeToFitWidth=YES;
    _rightCityTF.delegate=self;
    _rightCityTF.font=[UIFont systemFontOfSize:14];
    _rightCityTF.backgroundColor=[UIColor whiteColor];
    _rightCityTF.layer.borderColor=[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:202/255.0].CGColor;
    _rightCityTF.layer.borderWidth=0.5;
    [self addSubview:_rightCityTF];
    UILabel *rightLabel=[[UILabel alloc]initWithFrame:AdaptCGRectMake(210, 60,25,20)];
    rightLabel.adjustsFontSizeToFitWidth=YES;
    rightLabel.backgroundColor=[UIColor clearColor];
    rightLabel.text=@"m/s";
    rightLabel.textColor=[UIColor grayColor];
    [self addSubview:rightLabel];
    UILabel *leftLabel=[[UILabel alloc]initWithFrame:AdaptCGRectMake(210, 100,25,20)];
    leftLabel.adjustsFontSizeToFitWidth=YES;
    leftLabel.backgroundColor=[UIColor clearColor];
    leftLabel.text=@"m/s";
    leftLabel.textColor=[UIColor grayColor];
    [self addSubview:leftLabel];
    //按钮便线
    self.horizontalSeparator=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 135, 250, 0.5)];
    self.horizontalSeparator.backgroundColor=[UIColor colorWithRed:196.0/255 green:196.0/255 blue:201.0/255 alpha:1.0];
    self.verticalSeparator=[[UIView alloc]initWithFrame:AdaptCGRectMake(125,135,0.5, 46)];
    self.verticalSeparator.backgroundColor=[UIColor colorWithRed:196.0/255 green:196.0/255 blue:201.0/255 alpha:1.0];
    
    [self addSubview:self.verticalSeparator];
    [self addSubview:self.horizontalSeparator];
    //添加路线规划按钮
    UIButton *btn5=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn5 addTarget:self action:@selector(updateSaveAction) forControlEvents:UIControlEventTouchUpInside];
    btn5.frame=AdaptCGRectMake(15,138,100,38);
    [btn5 setTitle:@"修改" forState:UIControlStateNormal];
    [btn5 setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self addSubview:btn5];
    
    //添加路线规划按钮
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 addTarget:self action:@selector(updateCancelAction) forControlEvents:UIControlEventTouchUpInside];
    btn2.frame=AdaptCGRectMake(135,138,100,38);
    [btn2 setTitle:@"取消" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self addSubview:btn2];
    
}
/////取消显示更新view

////保存方法
//- (void)saveAction
//{
//    self.rightCityTF.delegate=nil;
//    if (self.delegate &&[self.delegate respondsToSelector:@selector(saveActiondelegate)]) {
//        [self.delegate saveActiondelegate];
//        
//    }
//    
//}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    
    return YES;
    
}

////添加内容视图
//-(void)addContentView{
//    //Set up Seperator
//    self.horizontalSeparator = [[UIView alloc] initWithFrame:CGRectZero];
//    self.verticalSeparator = [[UIView alloc] initWithFrame:CGRectZero];
//    UILabel *alertlable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(0, 5,240, 35)];
//   alertlable.backgroundColor=[UIColor clearColor];
//    alertlable.text=@"修改定制";
//     alertlable.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
//    alertlable.textAlignment=NSTextAlignmentCenter;
//   
//    [self addSubview:alertlable];
//    
//    //添加相应的文本
//    self.endAdressTF=[[UITextField alloc]initWithFrame:AdaptCGRectMake(10,50,220,30)];
//    self.endAdressTF.delegate=self;
//    [self.endAdressTF becomeFirstResponder];
//    self.endAdressTF.layer.borderColor=[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:202/255.0].CGColor;
//    self.endAdressTF.layer.borderWidth=0.5;
//    self.endAdressTF.backgroundColor=[UIColor whiteColor];
//    self.endAdressTF.placeholder=@"城市名";
//    //初始化按钮边缘线
//    self.horizontalSeparator=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 93, 240, 0.5)];
//    
//    self.horizontalSeparator.backgroundColor=[UIColor colorWithRed:196.0/255 green:196.0/255 blue:201.0/255 alpha:1.0];
//    self.verticalSeparator=[[UIView alloc]initWithFrame:AdaptCGRectMake(125, 94,0.5, 46)];
//    self.verticalSeparator.backgroundColor=[UIColor colorWithRed:196.0/255 green:196.0/255 blue:201.0/255 alpha:1.0];
//    [self addSubview:self.verticalSeparator];
//    [self addSubview:self.horizontalSeparator];
//    //添加按钮
//    UIButton *btn3=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btn3 addTarget:self action:@selector(updateCancelAction) forControlEvents:UIControlEventTouchUpInside];
//    btn3.frame=AdaptCGRectMake(10,100,100,35);
//    [btn3 setTitle:@"取消" forState:UIControlStateNormal];
//   [btn3 setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
//    [self addSubview:btn3];
//    UIButton *btn4=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btn4 addTarget:self action:@selector(updateSaveAction) forControlEvents:UIControlEventTouchUpInside];
//    btn4.frame=AdaptCGRectMake(130,100,100,35);
//    [btn4 setTitle:@"确定" forState:UIControlStateNormal];
//    [btn4 setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
//    [self addSubview:btn4];
//    [self addSubview:self.endAdressTF];
//}
////更新方法删除
-(void)updateCancelAction{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(cancelChangeviewdelegate)]) {
        [self.delegate cancelChangeviewdelegate];
    }
}
////更新修改
-(void)updateSaveAction{
    _endAdressTF.delegate=self;
     _leftCityTF.delegate=self;
    _rightCityTF.delegate=nil;
    if (self.delegate &&[self.delegate respondsToSelector:@selector(saveActionChangedelegate)]) {
        [self.delegate saveActionChangedelegate];
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
