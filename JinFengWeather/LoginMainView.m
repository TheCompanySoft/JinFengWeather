//
//  LoginMainView.m
//  JinFengWeather
//
//  Created by huake on 15/9/17.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "LoginMainView.h"
#import "UIUtils.h"
#import "Header.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Simple.h"
@interface LoginMainView ()<UITextFieldDelegate>
{
    UIButton * _backBtn;
    UIImageView *_bgimageView;
    UIButton *_photoBtn;
    UITextField *_phonenumField;
    UITextField *_passWordField;
    UIButton *_LoginBtn;
    //注册按钮
    UIButton *_RegistrationBtn;
    UILabel * _loglabel;
    //第三方登录按钮
    UIButton *_weixinButton;
    UIButton *_sinaButton;
    UIButton *_qqButton;
    UIAlertView *successAlertView;
    MBProgressHUD *_HUD;//提示
}@end

@implementation LoginMainView
-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        //添加内容视图
        [self addContentView];
        
    }
    return self;
}
//添加内容视图
-(void)addContentView{
    [self addBgViewAndphotoView];
    [self setPutinView];
    [self setLoginBtn];
    [self setRegistrationBtn];
    [self addThildLogLable];
    [self addThildLogBtn];
}

//添加背景图和头像
-(void)addBgViewAndphotoView{
    
    _bgimageView =[[UIImageView alloc]initWithFrame:self.frame];
    UIImage *bgImage = [UIImage imageNamed:@"loginBackground@2x.jpg"];
    [_bgimageView setImage:bgImage];
    _bgimageView.userInteractionEnabled =YES;
    [self addSubview:_bgimageView];
    UIImage *backBtnImage =[UIImage imageNamed:@"goback@2x"];
    _backBtn =[[UIButton alloc]initWithFrame:AdaptCGRectMake(15, 25, backBtnImage.size.width, backBtnImage.size.height)];
    [_backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_bgimageView addSubview:_backBtn];
    //头像
    [self addSubview:self.portraitImageView];
}
//头像
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        UIImage *photoImage=[UIImage imageNamed:@"headImg@2x.png"];
        _portraitImageView = [[UIImageView alloc] initWithFrame:AdaptCGRectMake(0, 0, photoImage.size.width, photoImage.size.height)];
        _portraitImageView.center=CGPointMake([UIUtils getWindowWidth]/2, _portraitImageView.frame.size.height/3*4);
        [_portraitImageView setImage:photoImage];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _portraitImageView.layer.shadowOpacity = 0.5;
        _portraitImageView.layer.shadowRadius = 2.0;
        _portraitImageView.userInteractionEnabled = YES;
        //        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        //  [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}
//设置输入界面
-(void)setPutinView{
    UIImage *userimage =[UIImage imageNamed:@"userName@2x"];
    UIImageView *phoneimageView =[[UIImageView alloc]initWithFrame:AdaptCGRectMake(20, 200,userimage.size.width, userimage.size.height)];
    [phoneimageView setImage:userimage];
    [_bgimageView addSubview:phoneimageView];
    
    _phonenumField = [[UITextField alloc] initWithFrame:AdaptCGRectMake(CGRectGetMaxX(phoneimageView.frame)+3,195, 250, 30)];
    _phonenumField.textColor=[UIColor whiteColor];
    _phonenumField.tintColor=[UIColor whiteColor];
    _phonenumField.keyboardType = UIKeyboardTypeNumberPad;
    _phonenumField.placeholder = @" 请输入您的手机号";
    [_phonenumField setFont:[UIFont systemFontOfSize:16]];
    _phonenumField.returnKeyType = UIReturnKeyDone;
    [_bgimageView addSubview:_phonenumField];
    //添加名字输入框下横线
    UIView *nameLine = [[UIView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(_phonenumField.frame)+1,[UIUtils getWindowWidth]-30, 1)];
    [nameLine setBackgroundColor:[UIColor whiteColor]];
    [_bgimageView addSubview:nameLine];
    
    UIImage *passWordimage =[UIImage imageNamed:@"userPassword@1X"];
    
    UIImageView *passWordimageView =[[UIImageView alloc]initWithFrame:AdaptCGRectMake(20, 245, passWordimage.size.width/2, passWordimage.size.height/2)];
    [passWordimageView setImage:passWordimage];
    [_bgimageView addSubview:passWordimageView];
    _passWordField = [[UITextField alloc] initWithFrame:AdaptCGRectMake(CGRectGetMaxX(passWordimageView.frame)+3, 240, 160, 30)];
    _passWordField.secureTextEntry = YES;
    _passWordField .keyboardType = UIKeyboardTypeDefault;
    _passWordField.textColor=[UIColor whiteColor];
    _passWordField.tintColor=[UIColor whiteColor];
    _passWordField .placeholder = @" 请输入您的密码";
    [ _passWordField  setFont:[UIFont systemFontOfSize:16]];
    _passWordField .returnKeyType = UIReturnKeyDone;
    _passWordField.delegate =self;
    [_bgimageView addSubview: _passWordField];
    
    //添加名字输入框下横线
    UIView *passwordLine = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_passWordField.frame)+1,[UIUtils getWindowWidth]-30, 1)];
    [passwordLine setBackgroundColor:[UIColor whiteColor]];
    [_bgimageView addSubview:passwordLine];
    UIButton * missPasswordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    missPasswordBtn.frame =CGRectMake(CGRectGetMaxX(_passWordField.frame)+20,CGRectGetMaxY(_phonenumField.frame)+20, 100, 30);
    [missPasswordBtn setTitle: @"忘记密码?"forState:UIControlStateNormal];
    missPasswordBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [missPasswordBtn addTarget:self action:@selector(missPassWord) forControlEvents:UIControlEventTouchUpInside];
    [_bgimageView addSubview:missPasswordBtn];
    
}
//添加登录按钮
-(void)setLoginBtn
{
    UIImage *camerImage=[UIImage imageNamed:@"loginButton1@2x"];
    _LoginBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _LoginBtn.frame=AdaptCGRectMake(25,310, 120, 30);
    NSLog(@"%lf----%lf",camerImage.size.width,camerImage.size.height);
    [_LoginBtn addTarget:self action:@selector(logIn:) forControlEvents:UIControlEventTouchUpInside];
    
    [ _LoginBtn setBackgroundImage:camerImage forState:UIControlStateNormal];
    [_bgimageView addSubview:_LoginBtn];
}

//添加注册按钮
-(void)setRegistrationBtn
{
    UIImage *libraryImage=[UIImage imageNamed:@"regiButton1@2x"];
    _RegistrationBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _RegistrationBtn.frame=AdaptCGRectMake(175, 310, 120, 30);
    
    [_RegistrationBtn setBackgroundImage:libraryImage forState:UIControlStateNormal];
    [_RegistrationBtn addTarget:self action:@selector(registration) forControlEvents:UIControlEventTouchUpInside];
    [_bgimageView addSubview:_RegistrationBtn];
    
}

//第三方登录提示
-(void)addThildLogLable{
    
    _loglabel =[[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(_RegistrationBtn.frame)+50, [UIUtils getWindowWidth]-80, 30)];
    [_loglabel setText:@"----使用第三方账号登录----"];
    _loglabel.font=[UIFont systemFontOfSize:18];
    _loglabel.textColor=[UIColor whiteColor];
    _loglabel.textAlignment=NSTextAlignmentCenter;
    [_bgimageView addSubview:_loglabel];
    
}
//添加第三方登录按钮
-(void)addThildLogBtn{
    
    //按钮的图片
    UIImage *cityButtonImageNormal = [UIImage imageNamed:@"Share_WeiXin2@2x"];
    UIImage *cityButtonImageSelected = [UIImage imageNamed:@"Share_WeiXin2@2x"];
    //    UIImage *sinaButtonImageNormal = [UIImage imageNamed:@"Share_Sina1@2x"];
    //    UIImage *sinaButtonImageSelected = [UIImage imageNamed:@"Share_Sina1@2x"];
    //
    //    UIImage *qqButtonImageNormal = [UIImage imageNamed:@"Share_qq2@2x"];
    //    UIImage *qqButtonImageSelected = [UIImage imageNamed:@"Share_qq2@2x"];
    
    //按钮调用的方法
    //    SEL sinaActions = @selector(sinaButtonPress);
    //    SEL qqActions = @selector(qqButtonPress);
    SEL weixinActions = @selector(weixinButtonPress);
    
    //按钮的frame
    //    CGRect sinaButtonRect=AdaptCGRectMake(135,450 ,sinaButtonImageNormal.size.width, sinaButtonImageNormal.size.height);
    //    CGRect qqButtonRect=AdaptCGRectMake(210,450 , qqButtonImageNormal.size.width, qqButtonImageNormal.size.height);
    
    CGRect weixinButtonRect=AdaptCGRectMake((320-cityButtonImageNormal.size.width)/2,450 , cityButtonImageNormal.size.width, cityButtonImageNormal.size.height);
    
    NSLog(@"%f",self.frame.size.width);
    //微信按钮
    _weixinButton = [self buttonInitWithFrame:weixinButtonRect imageNormal:cityButtonImageNormal imageSelected:cityButtonImageSelected isSelected:YES callBackActions:weixinActions];
    [_bgimageView addSubview:_weixinButton];
    //    //新浪
    //    _sinaButton = [self buttonInitWithFrame:sinaButtonRect imageNormal:sinaButtonImageNormal imageSelected:sinaButtonImageSelected isSelected:NO callBackActions:sinaActions];
    //    [_bgimageView addSubview:_sinaButton];
    //    //QQ登录
    //    _qqButton = [self buttonInitWithFrame:qqButtonRect imageNormal:qqButtonImageNormal imageSelected:qqButtonImageSelected isSelected:NO callBackActions:qqActions];
    //    [_bgimageView addSubview:_qqButton];
    
    
}
//生成按钮的方法
- (UIButton *)buttonInitWithFrame:(CGRect)frame imageNormal:(UIImage *)imageNormal imageSelected:(UIImage *)imageSelected isSelected:(BOOL)isSelected callBackActions:(SEL)actions
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:imageSelected forState:UIControlStateSelected];
    [button addTarget:self action:actions forControlEvents:UIControlEventTouchUpInside];
    //button.adjustsImageWhenHighlighted = NO;
    button.selected = isSelected;
    return button;
}
#pragma mark 按钮的点击方法
-(void)editPortrait{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(loginMainViewphotoGet)]) {
        [self.delegate loginMainViewphotoGet];
    }
}
-(void)downloadImage{
    
}
//登录按钮
-(void)logIn:(id)sender{
    
    [_passWordField resignFirstResponder];
    
    UIButton *but = sender;
    if (_phonenumField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else if (_passWordField.text.length == 0){
        //提示框
        UIAlertView *failureAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您输入的密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [failureAlertView show];
        
        
    }else {
        _HUD=[MBProgressHUD show:MBProgressHUDModeIndeterminate message:@"登录中..." customView:self];
        [self performSelectorInBackground:@selector(downloadImage) withObject:nil];
        NSString *str=[NSString stringWithFormat:@"http://weather.huakesoft.com/api/checkname?name=%@",_phonenumField.text];
        NSString *htmlString=[NSString stringWithContentsOfURL:[NSURL URLWithString: str] encoding: NSUTF8StringEncoding error:nil];
        
        if([htmlString isEqualToString:@"2"]){
            [_HUD hide:YES afterDelay:0.0f];
            
            UIAlertView *failureAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该用户不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [failureAlertView show];
            
        }else{
            
            NSDictionary *dic = @{@"username":_phonenumField.text,@"password":_passWordField.text,@"phone":_phonenumField.text};
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
            [manager POST:@"http://weather.huakesoft.com/api/login?" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"sfvsvsf----%@",responseObject);
                but.enabled = YES;
                [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"2" object:responseObject]];
                NSString *isenable = [responseObject objectForKey:@"id"];
                if (![isenable isEqualToString:@""]&&[[operation.responseObject objectForKey:@"password"] isEqualToString:_passWordField.text]&&([[operation.responseObject objectForKey:@"username"] isEqualToString:_phonenumField.text] ||[[operation.responseObject objectForKey:@"phone"] isEqualToString:_phonenumField.text])){
                    
                    //登录成功记录登录状态本地
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    [defaults setObject:[responseObject objectForKey:@"id"] forKey:@"useId"];
                    
                    [defaults setObject:[responseObject objectForKey:@"phone"] forKey:@"myphone"];
                    [defaults setObject:[responseObject objectForKey:@"password"] forKey:@"mypassword"];
                    [defaults setObject:[responseObject objectForKey:@"username"] forKey:@"myname"];
                    [defaults setObject:[responseObject objectForKey:@"headicon"] forKey:@"headicon"];
                    [defaults setObject:[responseObject objectForKey:@"email"] forKey:@"emal"];
                    [defaults setObject:@"1" forKey:@"isLogin"];
                    [defaults synchronize];
                    
                    self.phoneStr=_passWordField.text;
                    [_passWordField resignFirstResponder];
                    [_HUD hide:YES afterDelay:0.3f];
                    NSTimer *timer;
                    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doTime) userInfo:nil repeats:NO];
                    
                } else{
                    
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [_HUD hide:YES afterDelay:0.0f];
                
                UIAlertView *failureAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络和密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [failureAlertView show];
            }];
            
        }
    }
    
}
//提醒视图消失的时间
-(void)doTime

{
    //alert过1秒自动消失
    [successAlertView dismissWithClickedButtonIndex:0 animated:NO];
    [self alertViewDismiss];
    
}
-(void)alertViewDismiss{
    // 登录成功 登录界面消失
    if (self.delegate &&[self.delegate respondsToSelector:@selector(loginMainViewlogIn)]) {
        [self.delegate loginMainViewlogIn];
    }
}
-(void)registration{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(loginMainViewregistration)]) {
        [self.delegate loginMainViewregistration];
    }
}
//- (void)sinaButtonPress
//{
//    if (self.delegate &&[self.delegate respondsToSelector:@selector(loginMainViewsinaButtonPress)]) {
//        [self.delegate loginMainViewsinaButtonPress];
//    }
//}
//
//- (void)qqButtonPress
//{
//    if (self.delegate &&[self.delegate respondsToSelector:@selector(loginMainViewqqButtonPress)]) {
//        [self.delegate loginMainViewqqButtonPress];
//    }
//}

- (void)weixinButtonPress
{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(loginMainViewweixinButtonPress)]) {
        [self.delegate loginMainViewweixinButtonPress];
    }
}

-(void)missPassWord{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(loginMainViewmissPassWord)]) {
        [self.delegate loginMainViewmissPassWord];
    }
}
-(void)back{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(loginMainViewback)]) {
        [self.delegate loginMainViewback];
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
