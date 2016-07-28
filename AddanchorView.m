//
//  AddanchorView.m
//  自学BMK
//
//  Created by huake on 15/10/29.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "AddanchorView.h"
#import "Header.h"
@interface AddanchorView()<UITextFieldDelegate>

@property (nonatomic, strong) UIView * horizontalSeparator;
@property (nonatomic, strong) UIView * verticalSeparator;
@end
@implementation AddanchorView
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
    self.horizontalSeparator = [[UIView alloc] initWithFrame:CGRectZero];
    self.verticalSeparator = [[UIView alloc] initWithFrame:CGRectZero];
    UILabel *leftLabel1=[[UILabel alloc]initWithFrame:AdaptCGRectMake(10, 20,80, 25)];
    leftLabel1.backgroundColor=[UIColor clearColor];
    leftLabel1.adjustsFontSizeToFitWidth=YES;
    leftLabel1.text=@"请输入经度:";
    leftLabel1.font=[UIFont systemFontOfSize:13];
    leftLabel1.textColor=[UIColor grayColor];
    [self addSubview:leftLabel1];
    //添加对应的文本视图和label
    _leftCityTF1=[[UITextField alloc]initWithFrame:AdaptCGRectMake(90, 15,150,30)];
    _leftCityTF1.adjustsFontSizeToFitWidth=YES;
    _leftCityTF1.layer.borderColor=[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:202/255.0].CGColor;
    _leftCityTF1.layer.borderWidth=0.5;
    _leftCityTF1.delegate=self;
    _leftCityTF1.placeholder=@"请输入经度";
    [_leftCityTF1 becomeFirstResponder];
    _leftCityTF1.font=[UIFont systemFontOfSize:14];
    _leftCityTF1.returnKeyType=UIReturnKeyDefault;
    
    _leftCityTF1.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    _leftCityTF1.backgroundColor=[UIColor whiteColor];
    [self addSubview:_leftCityTF1];
  
    UILabel *rightLabel1=[[UILabel alloc]initWithFrame:AdaptCGRectMake(10, 65,80, 25)];
    rightLabel1.backgroundColor=[UIColor clearColor];
    rightLabel1.adjustsFontSizeToFitWidth=YES;
    rightLabel1.text=@"请输入纬度:";
    rightLabel1.font=[UIFont systemFontOfSize:13];
    rightLabel1.textColor=[UIColor grayColor];
    [self addSubview:rightLabel1];
    
    _rightCityTF1=[[UITextField alloc]initWithFrame:AdaptCGRectMake(90,60,150, 30)];
    _rightCityTF1.tag = 222;
    _rightCityTF1.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    _rightCityTF1.delegate=self;
    _rightCityTF1.placeholder=@"请输入纬度";
    _rightCityTF1.font=[UIFont systemFontOfSize:14];
    _rightCityTF1.returnKeyType=UIReturnKeyDefault;
    _rightCityTF1.layer.borderColor=[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:202/255.0].CGColor;
    _rightCityTF1.layer.borderWidth=0.5;
    _rightCityTF1.adjustsFontSizeToFitWidth=YES;
    _rightCityTF1.backgroundColor=[UIColor whiteColor];
    [self addSubview:_rightCityTF1];
    
    UILabel *rightLabel2=[[UILabel alloc]initWithFrame:AdaptCGRectMake(10,105,100, 30)];
    rightLabel2.backgroundColor=[UIColor clearColor];
    rightLabel2.adjustsFontSizeToFitWidth=YES;
    rightLabel2.text=@"请输入名称:";
    rightLabel2.font=[UIFont systemFontOfSize:13];
    rightLabel2.textColor=[UIColor grayColor];
    [self addSubview:rightLabel2];
    
    _startAdressTF1=[[UITextField alloc]initWithFrame:AdaptCGRectMake(90,105,150,30)];
    _startAdressTF1.adjustsFontSizeToFitWidth=YES;
    _startAdressTF1.layer.borderColor=[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:202/255.0].CGColor;
    _startAdressTF1.layer.borderWidth=0.5;
    _startAdressTF1.delegate=self;
    _startAdressTF1.backgroundColor=[UIColor whiteColor];
    _startAdressTF1.tag = 333;
    _startAdressTF1.returnKeyType=UIReturnKeyDefault;
    _startAdressTF1.placeholder=@"请输入地址名称";
    
    _startAdressTF1.font=[UIFont systemFontOfSize:14];
    _startAdressTF1.keyboardType=UIKeyboardTypeDefault;
    [self addSubview:_startAdressTF1];
    
    UILabel *alertlable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(10, 150,100, 30)];
    alertlable.backgroundColor=[UIColor clearColor];
    alertlable.text=@"关注风速区间:";
    alertlable.adjustsFontSizeToFitWidth=YES;
    alertlable.textAlignment=NSTextAlignmentCenter;
    alertlable.font=[UIFont systemFontOfSize:13];
    alertlable.textColor=[UIColor grayColor];
    [self addSubview:alertlable];
    
    UILabel *alertlable1=[[UILabel alloc]initWithFrame:AdaptCGRectMake(10, 190,100, 30)];
    alertlable1.backgroundColor=[UIColor clearColor];
    alertlable1.text=@"关注风速区间:";
    alertlable1.adjustsFontSizeToFitWidth=YES;
    alertlable1.font=[UIFont systemFontOfSize:13];
    alertlable1.textAlignment=NSTextAlignmentCenter;
    alertlable1.textColor=[UIColor grayColor];
    [self addSubview:alertlable1];
    
    _leftCityTF =[[UITextField alloc]initWithFrame:AdaptCGRectMake(115,150,95, 30)];
    _leftCityTF.layer.borderColor=[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:202/255.0].CGColor;
    _leftCityTF.layer.borderWidth=0.5;
    _leftCityTF.backgroundColor=[UIColor whiteColor];
    _leftCityTF.placeholder=@"可选填，上限";
    _leftCityTF.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    
    _leftCityTF.font=[UIFont systemFontOfSize:14];
    _leftCityTF.delegate=self;
    _leftCityTF.returnKeyType=UIReturnKeyDefault;
    _leftCityTF.adjustsFontSizeToFitWidth=YES;
    [self addSubview:_leftCityTF];
    _rightCityTF=[[UITextField alloc]initWithFrame:AdaptCGRectMake(115, 190,95, 30)];
    _rightCityTF.placeholder=@"可选填，下限";
    _rightCityTF.font=[UIFont systemFontOfSize:14];
    
    _rightCityTF.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    _rightCityTF.adjustsFontSizeToFitWidth=YES;
    _rightCityTF.returnKeyType=UIReturnKeyDefault
    ;
    _rightCityTF.delegate=self;
    _rightCityTF.layer.borderColor=[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:202/255.0].CGColor;
    _rightCityTF.layer.borderWidth=0.5;
    _rightCityTF.backgroundColor=[UIColor whiteColor];
    [self addSubview:_rightCityTF];
    UILabel *rightLabel=[[UILabel alloc]initWithFrame:AdaptCGRectMake(215, 155,25,20)];
    rightLabel.adjustsFontSizeToFitWidth=YES;
    rightLabel.backgroundColor=[UIColor clearColor];
    rightLabel.text=@"m/s";
    rightLabel.textColor=[UIColor grayColor];
    rightLabel.font=[UIFont systemFontOfSize:11];
    [self addSubview:rightLabel];
    UILabel *leftLabel=[[UILabel alloc]initWithFrame:AdaptCGRectMake(215,195,25,20)];
    leftLabel.adjustsFontSizeToFitWidth=YES;
    leftLabel.font=[UIFont systemFontOfSize:11];
    leftLabel.backgroundColor=[UIColor clearColor];
    leftLabel.text=@"m/s";
    leftLabel.textColor=[UIColor grayColor];
    [self addSubview:leftLabel];
    //按钮分割线
    self.horizontalSeparator=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 234, 250, 0.5)];
    
    self.horizontalSeparator.backgroundColor=[UIColor colorWithRed:196.0/255 green:196.0/255 blue:201.0/255 alpha:1.0];
    self.verticalSeparator=[[UIView alloc]initWithFrame:AdaptCGRectMake(125,235,0.5, 44)];
    self.verticalSeparator.backgroundColor=[UIColor colorWithRed:196.0/255 green:196.0/255 blue:201.0/255 alpha:1.0];
    
    [self addSubview:self.verticalSeparator];
    [self addSubview:self.horizontalSeparator];

    //添加路线规划按钮
    UIButton *btn5=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn5 addTarget:self action:@selector(cancelview) forControlEvents:UIControlEventTouchUpInside];
    btn5.frame=AdaptCGRectMake(15,240,100,35);
    [btn5 setTitle:@"取消" forState:UIControlStateNormal];
    [btn5 setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];

    [self addSubview:btn5];
    
    //添加路线规划按钮
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    btn2.frame=AdaptCGRectMake(135,240,100,35);
    [btn2 setTitle:@"保存" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];

    [self addSubview:btn2];
    
}

- (void)cancelview{
    _startAdressTF1.delegate=nil;
    if (self.delegate &&[self.delegate respondsToSelector:@selector(cancelanchorviewdelegate)]) {
        [self.delegate cancelanchorviewdelegate];
    }
    
}
- (void)saveAction{
    _startAdressTF1.delegate=nil;
    if (self.delegate &&[self.delegate respondsToSelector:@selector(saveanchorActiondelegate)]) {
        [self.delegate saveanchorActiondelegate];
    }
    
    
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
    
}


@end
