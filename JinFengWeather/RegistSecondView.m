//
//  RegistSecondViewController.m
//  JinFengWeather
//
//  Created by huake on 15/10/8.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//注册2

#import "RegistSecondView.h"
#import "UIUtils.h"
#import "AFHTTPRequestOperationManager.h"
#import "LoginViewController.h"
#import "ProtocalViewController.h"
@interface RegistSecondView ()<UITextFieldDelegate>
{
    UITextField * _userNamefield;
    UITextField * _putinCodefield;
    UITextField * _putinsecondCodefield;
    UIButton    * _overButton;//结束按钮
  
    UIAlertView *_alertview;
}
@end

@implementation RegistSecondView
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
    UIImage *userimage =[UIImage imageNamed:@"regi_userName@2x"];
    UIImageView *phoneimageView =[[UIImageView alloc]initWithFrame:CGRectMake(20, 100, userimage.size.width*1.5,userimage.size.height*1.5)];
    [phoneimageView setImage:userimage];
    [self addSubview:phoneimageView];
    
    _userNamefield = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneimageView.frame)+10, 100, [UIUtils getWindowWidth]-30, 30)];
    
    _userNamefield.keyboardType = UIKeyboardTypeNumberPad;
    _userNamefield.placeholder = @"请输入用户名";
    [_userNamefield setFont:[UIFont systemFontOfSize:16]];
    _userNamefield.returnKeyType = UIReturnKeyDone;
    
    [self addSubview:_userNamefield];
    //添加名字输入框下横线
    UIView *nameLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_userNamefield.frame), _userNamefield.frame.size.width, 1)];
    [nameLine setBackgroundColor:[UIColor grayColor]];
    [self addSubview:nameLine];
    
    
    UIImage *passWordimage =[UIImage imageNamed:@"regi_userPassword@2x"];
    
    UIImageView *passWordimageView =[[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_userNamefield.frame)+25, passWordimage.size.width*1.5,passWordimage.size.height*1.5)];
    [passWordimageView setImage:passWordimage];
    [self addSubview:passWordimageView];
    
    _putinCodefield = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passWordimageView.frame)+10, CGRectGetMaxY(_userNamefield.frame)+20,[UIUtils getWindowWidth]-30, 30)];
    
    _putinCodefield .keyboardType = UIKeyboardTypeDefault;
    _putinCodefield .placeholder = @"请输入密码";
    _putinCodefield.secureTextEntry = YES;
    [_putinCodefield  setFont:[UIFont systemFontOfSize:16]];
    _putinCodefield .returnKeyType = UIReturnKeyDone;
    
    [self addSubview: _putinCodefield ];
    UIView *passwordLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_putinCodefield.frame)+5, _putinCodefield.frame.size.width, 1)];
    [passwordLine setBackgroundColor:[UIColor grayColor]];
    [self addSubview:passwordLine];
    
    UIImageView *passWordsecondimageView =[[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_putinCodefield.frame)+25, passWordimage.size.width*1.5,passWordimage.size.height*1.5)];
    [passWordsecondimageView setImage:passWordimage];
    [self addSubview:passWordsecondimageView];
    
    _putinsecondCodefield = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passWordsecondimageView.frame)+10, CGRectGetMaxY(_putinCodefield.frame)+20,[UIUtils getWindowWidth]-30, 30)];
    
    _putinsecondCodefield .keyboardType = UIKeyboardTypeDefault;
    _putinsecondCodefield .placeholder = @"请再次输入密码";
    [_putinsecondCodefield  setFont:[UIFont systemFontOfSize:16]];
    _putinsecondCodefield.delegate =self;
    _putinsecondCodefield.secureTextEntry = YES;
    _putinsecondCodefield .returnKeyType = UIReturnKeyDone;
    
    [self addSubview: _putinsecondCodefield];
    UIView *passwordsecondLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_putinsecondCodefield.frame)+5, _putinsecondCodefield.frame.size.width, 1)];
    [passwordsecondLine setBackgroundColor:[UIColor grayColor]];
    [self addSubview:passwordsecondLine];
    _overButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image =[UIImage imageNamed:@"regi_nextButton@2x"];
    _overButton.frame =CGRectMake(20, CGRectGetMaxY(passwordsecondLine.frame)+40, [UIUtils getWindowWidth]-40, 40);
    _overButton.userInteractionEnabled=YES;
    _overButton.layer.cornerRadius=20;
    _overButton.layer.masksToBounds=YES;
    [_overButton setBackgroundImage:image forState:UIControlStateNormal];
    [_overButton setTitle:@"完成" forState:UIControlStateNormal];
    [_overButton addTarget:self action:@selector(overregist) forControlEvents:UIControlEventTouchUpInside];
    [_overButton setTintColor:[UIColor whiteColor]];
    _overButton.titleLabel.font=[UIFont systemFontOfSize:20];
    [self addSubview:_overButton];
    
    UILabel *readLabel =[[UILabel alloc]initWithFrame:CGRectMake([UIUtils getWindowWidth]/3, CGRectGetMaxY(_overButton.frame)+20, 40, 30)];
    readLabel.text=@"阅读";
    readLabel.textAlignment=NSTextAlignmentRight;
    readLabel.font=[UIFont systemFontOfSize:15];
    readLabel.textColor =[UIColor grayColor];
    [self addSubview:readLabel];
    
    UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [serviceBtn setTitle:@"服务协议" forState:UIControlStateNormal];
    serviceBtn.frame =CGRectMake(CGRectGetMaxX(readLabel.frame)-10, CGRectGetMaxY(_overButton.frame)+20, 100, 30);
    [serviceBtn setTitleColor:[UIColor colorWithRed:41/255.0 green:147/255.0 blue:209/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    serviceBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [serviceBtn addTarget:self action:@selector(service) forControlEvents:UIControlEventTouchUpInside];
    serviceBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
    [self addSubview:serviceBtn];
}
-(void)service{
   // NSLog(@"服务协议");
    if (self.delegate &&[self.delegate respondsToSelector:@selector(regestprotocdelegate)]) {
        [self.delegate regestprotocdelegate];
    }

}
-(void)overregist{
    //NSLog(@"注册完成");
    _overButton.userInteractionEnabled=NO;
    if (_userNamefield.text.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        if (_putinCodefield.text.length==0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else if([_putinCodefield.text isEqualToString:_putinsecondCodefield.text]) {
            NSDictionary *dic = @{@"username":_userNamefield.text,@"password":_putinCodefield.text,@" ":self.phonenum};
            AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
            [manager GET:@"http://weather.huakesoft.com/api/register" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
              //  NSLog(@"-----%@-----",responseObject);
                NSDictionary *dic = responseObject;
                NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                if (result ==nil) {
                    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"操作失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertview show];
                }else if (result !=nil){
    
                   
                    //进行页面跳转
                    _alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                                     target:self
                                                   selector:@selector(dismissAlertView:)
                                                   userInfo:nil
                                                    repeats:NO];
                    [_alertview show];
                   // NSLog(@"注册成功");
                    
                    
                }
                _overButton.userInteractionEnabled=YES;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              //  NSLog(@"%@",error);
            }];
            
            
        }else{
            //提示框
            UIAlertView *failureAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [failureAlertView show];
            
        }
        
    }
    

    
}

- (void)dismissAlertView:(NSTimer*)timer {
   
    [_userNamefield resignFirstResponder];
    [_putinCodefield resignFirstResponder];
    [_putinsecondCodefield resignFirstResponder];
    
   [_alertview dismissWithClickedButtonIndex:0 animated:YES];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(regestdelegate)]) {
        [self.delegate regestdelegate];
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
