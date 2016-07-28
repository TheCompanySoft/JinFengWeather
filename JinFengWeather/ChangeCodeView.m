//
//  ChangeCodeViewController.m
//  JinFengWeather
//
//  Created by huake on 15/9/17.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//修改密码

#import "ChangeCodeView.h"
//#import "LostCodeSecondView.h"
#import "UIUtils.h"
#import "AFHTTPRequestOperationManager.h"
#import "LoginViewController.h"
@interface ChangeCodeView ()<UITextFieldDelegate>
{
    UITextField * _putinCodefield;
    UITextField * _putinsecondCodefield;
    UIButton    * _overButton;//结束按钮
    LoginViewController *_loginVC;
    UIAlertView *_alertview;
}
@end

@implementation ChangeCodeView
-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        //添加内容视图
        self.backgroundColor=[UIColor whiteColor];
        //添加内容视图
        [self addContentView];
        
    }
    return self;
}

//添加内容视图
- (void)addContentView
{
    UIImage *passWordimage =[UIImage imageNamed:@"regi_userPassword@2x"];
    
    UIImageView *passWordimageView =[[UIImageView alloc]initWithFrame:CGRectMake(20,100, 20,20)];
    [passWordimageView setImage:passWordimage];
    [self addSubview:passWordimageView];
    
    _putinCodefield = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passWordimageView.frame)+10, 100, [UIUtils getWindowWidth]-30, 30)];
    _putinCodefield .keyboardType = UIKeyboardTypeDefault;
    _putinCodefield .placeholder = @"请输入密码";
    [_putinCodefield  setFont:[UIFont systemFontOfSize:16]];
    _putinCodefield .returnKeyType = UIReturnKeyDone;
    _putinCodefield.secureTextEntry = YES;
    [self addSubview: _putinCodefield ];
    UIView *passwordLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_putinCodefield.frame)+5, _putinCodefield.frame.size.width, 1)];
    [passwordLine setBackgroundColor:[UIColor grayColor]];
    [self addSubview:passwordLine];
    
    UIImageView *passWordsecondimageView =[[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_putinCodefield.frame)+25, 20,20)];
    [passWordsecondimageView setImage:passWordimage];
    [self addSubview:passWordsecondimageView];
    
    _putinsecondCodefield = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passWordsecondimageView.frame)+10, CGRectGetMaxY(_putinCodefield.frame)+20,[UIUtils getWindowWidth]-30, 30)];
    _putinsecondCodefield.secureTextEntry = YES;
    _putinsecondCodefield .keyboardType = UIKeyboardTypeDefault;
    _putinsecondCodefield .placeholder = @"请再次输入密码";
    [_putinsecondCodefield  setFont:[UIFont systemFontOfSize:16]];
    _putinsecondCodefield.delegate =self;
    _putinsecondCodefield .returnKeyType = UIReturnKeyDone;
    
    [self addSubview: _putinsecondCodefield];
    UIView *passwordsecondLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_putinsecondCodefield.frame)+5, _putinsecondCodefield.frame.size.width, 1)];
    [passwordsecondLine setBackgroundColor:[UIColor grayColor]];
    [self addSubview:passwordsecondLine];
    //确定按钮
    _overButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image =[UIImage imageNamed:@"regi_nextButton@2x"];
    _overButton.frame =CGRectMake(20, CGRectGetMaxY(passwordsecondLine.frame)+40, [UIUtils getWindowWidth]-40, 40);
    _overButton.layer.cornerRadius=20;
    
    _overButton.layer.masksToBounds=YES;
    [_overButton setBackgroundImage:image forState:UIControlStateNormal];
    [_overButton setTitle:@"完成" forState:UIControlStateNormal];
    [_overButton addTarget:self action:@selector(overregist) forControlEvents:UIControlEventTouchUpInside];
     _overButton.userInteractionEnabled=YES;
    [_overButton setTintColor:[UIColor whiteColor]];
    _overButton.titleLabel.font=[UIFont systemFontOfSize:20];
    [self addSubview:_overButton];
    
    
}

-(void)overregist{
    _overButton.userInteractionEnabled=NO;
    if (_putinCodefield.text.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else if([_putinCodefield.text isEqualToString:_putinsecondCodefield.text]) {
        NSDictionary *dic = @{@"phone":self.phonenum,@"password":_putinCodefield.text};
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [manager GET:@"http://weather.huakesoft.com/api/updatepassword" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = responseObject;
         
            NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            if (result ==nil) {
                UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"操作失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertview show];
                
            }else if (result !=nil){
               
                //进行页面跳转
                _alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改密码成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                [NSTimer scheduledTimerWithTimeInterval:1.5f
                                                 target:self
                                               selector:@selector(dismissAlertView:)
                                               userInfo:nil
                                                repeats:NO];
                [_alertview show];
                
                
            }
            _overButton.userInteractionEnabled=YES;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        }];
        
        
    }else{
        //提示框
        UIAlertView *failureAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [failureAlertView show];
        
    }
    
}
- (void)dismissAlertView:(NSTimer*)timer {
   
    [_putinCodefield resignFirstResponder];
    [_putinsecondCodefield resignFirstResponder];
    [_alertview dismissWithClickedButtonIndex:0 animated:YES];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(miscodedelegate)]) {
        [self.delegate miscodedelegate];
    }
    
}
//点击屏幕键盘消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
    
}



@end
