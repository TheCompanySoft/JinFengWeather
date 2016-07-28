//
//  MissCodeViewController.m
//  JinFengWeather
//
//  Created by huake on 15/9/17.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//忘记密码

#import "MissCodeViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "ChangeCodeView.h"
#import "UIUtils.h"
#import "LoginViewController.h"
@interface MissCodeViewController ()<UITextFieldDelegate,MiscodeViewdelegate>
{
    UITextField * _putInphoneNumfield;//输入手机号
    UITextField * _checkNumfield;//输入验证码的文本
    UIButton    * _nextButton;//下一步按钮
    UIButton * _getCheckNum;//获取验证码按钮
    ChangeCodeView *_changeCodeview;//修改视图
     LoginViewController *_loginVC;//登录界面
}
@property(nonatomic,strong)NSString*code;//验证码
@end

@implementation MissCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    //设置navigationBar
    [self setnavigationbar];
    //添加内容视图
    [self addContentView];
}
//设置navigationBar
-(void)setnavigationbar{
    
    self.title=@"忘记密码";
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:41/255.0 green:147/255.0 blue:209/255.0 alpha:1.0];
    //设置navigationBar的属性
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]
                                                                      }];
    
    //返回按钮2
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"goback@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(add )];
    //设置按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem= backItem;
    
}
//添加内容视图
- (void)addContentView
{
    //注册用户图片
    UIImage *userimage =[UIImage imageNamed:@"regi_userTel@2x"];
    UIImageView *phoneimageView =[[UIImageView alloc]initWithFrame:CGRectMake(20, 100, userimage.size.width*1.5, userimage.size.height*1.5)];
    [phoneimageView setImage:userimage];
    [self.view addSubview:phoneimageView];
    //输入手机号文本
    _putInphoneNumfield = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneimageView.frame)+10, 100, [UIUtils getWindowWidth]-30, 30)];
    
    _putInphoneNumfield.keyboardType = UIKeyboardTypeNumberPad;
    _putInphoneNumfield.placeholder = @"请输入您的手机号";
    [_putInphoneNumfield becomeFirstResponder];
    [_putInphoneNumfield setFont:[UIFont systemFontOfSize:16]];
    _putInphoneNumfield.returnKeyType = UIReturnKeyDone;
    //
    [self.view addSubview:_putInphoneNumfield];
    //添加名字输入框下横线
    UIView *nameLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_putInphoneNumfield.frame), _putInphoneNumfield.frame.size.width, 1)];
    [nameLine setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:nameLine];
    
    //密码标示图片
    UIImage *passWordimage =[UIImage imageNamed:@"regi_userCode@2x"];
    
    UIImageView *passWordimageView =[[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_putInphoneNumfield.frame)+25, passWordimage.size.width*1.5, passWordimage.size.height*1.5)];
    [passWordimageView setImage:passWordimage];
    [self.view addSubview:passWordimageView];
    
    _checkNumfield = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passWordimageView.frame)+10, CGRectGetMaxY(_putInphoneNumfield.frame)+20, [UIUtils getWindowWidth]-140, 30)];
    _checkNumfield .keyboardType = UIKeyboardTypeDefault;
    _checkNumfield .placeholder = @"请输入验证码";
    [ _checkNumfield  setFont:[UIFont systemFontOfSize:16]];
    _checkNumfield .returnKeyType = UIReturnKeyDone;
    _checkNumfield.delegate=self;
    [self.view addSubview: _checkNumfield ];
    
    
    UIView *passwordLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_checkNumfield.frame)+5, _checkNumfield.frame.size.width, 1)];
    [passwordLine setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:passwordLine];
    
    _getCheckNum=[UIButton buttonWithType:UIButtonTypeCustom];
    _getCheckNum.frame =CGRectMake(CGRectGetMaxX(_checkNumfield.frame)-30,CGRectGetMaxY(_putInphoneNumfield.frame)+20, 100, 35);
    _getCheckNum.backgroundColor = [UIColor colorWithRed:41/255.0 green:147/255.0 blue:209/255.0 alpha:1.0];
    [_getCheckNum setTitle: @"获取验证码"forState:UIControlStateNormal];
    _getCheckNum.titleLabel.font=[UIFont systemFontOfSize:16];
    [_getCheckNum addTarget:self action:@selector(getCheckNum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getCheckNum];
    
    _nextButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image =[UIImage imageNamed:@"regi_nextButton@2x"];
    //下一步按钮
    _nextButton.frame =CGRectMake(20, CGRectGetMaxY(_getCheckNum.frame)+50, [UIUtils getWindowWidth]-40, 40);
    [_nextButton setBackgroundImage:image forState:UIControlStateNormal];
    _nextButton.layer.cornerRadius=20;
    
    _nextButton.layer.masksToBounds=YES;
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextregist) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setTintColor:[UIColor whiteColor]];
    _nextButton.titleLabel.font=[UIFont systemFontOfSize:20];
    [self.view addSubview:_nextButton];
    
}


-(void)getCheckNum{
    
    NSString *str=[NSString stringWithFormat:@"http://weather.huakesoft.com/api/checkname?name=%@",_putInphoneNumfield.text];
    
    NSString *htmlString=[NSString stringWithContentsOfURL:[NSURL URLWithString: str] encoding: NSUTF8StringEncoding error:nil];
  
    if(htmlString==nil){
        UIAlertView *failureAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查当前网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [failureAlertView show];
        
        
    }else{
    if([htmlString isEqualToString:@"2"]){
        UIAlertView *failureAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入手机号不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [failureAlertView show];
        
        
    }else{

    
    if (_putInphoneNumfield.text.length != 0) {
        //倒计时
        __block int timeout=20; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [_getCheckNum setTitle:@"发送验证码" forState:UIControlStateNormal];
                    _getCheckNum.userInteractionEnabled = YES;
                    [_getCheckNum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                });
            }else{
                //            int minutes = timeout / 60;
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [_getCheckNum setTitle:[NSString
                                            stringWithFormat:@"%@秒后可重新获取",strTime] forState:UIControlStateNormal];
                    _getCheckNum.titleLabel.adjustsFontSizeToFitWidth=YES;
                    _getCheckNum.userInteractionEnabled = NO;
                    [_getCheckNum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                });
                timeout--;
                
            }
        });
        dispatch_resume(_timer);
        
        
    }
   
    BOOL isPhoneNumber = [self isMobilePhoneNumber:_putInphoneNumfield.text];
    if (!isPhoneNumber) {
    }else
    {
        //向服务器请求验证码
        NSString *urlString=[NSString stringWithFormat:@"http://weather.huakesoft.com/api/sendcode?phone=%@",_putInphoneNumfield.text];
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            self.code=[responseObject objectForKey:@"randomcode"];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
        }];
        
    }
   
    }
        
    }
}
//检验是否是手机号
-(BOOL)isMobilePhoneNumber:(NSString *)mobile{
    if (mobile.length<11) {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}
-(void)nextregist{
    
    NSString *str=[NSString stringWithFormat:@"%@",self.code];
    
    if (str.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请获取手机验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        if ([str isEqualToString: _checkNumfield.text]) {
            for (UIView*view in [self.view subviews]) {
                [view removeFromSuperview];
            }
            _changeCodeview =[[ChangeCodeView alloc]initWithFrame:self.view.frame];
            _changeCodeview.delegate=self;
            _changeCodeview.phonenum=_putInphoneNumfield.text;
            [self.view addSubview:_changeCodeview];
        }else{
            //提示框
            UIAlertView *failureAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的验证码有误请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [failureAlertView show];
            
        }
        
    }
    
}
-(void)add{
    if ([_putInphoneNumfield becomeFirstResponder]) {
        [_putInphoneNumfield resignFirstResponder];
    }
    if ([_checkNumfield becomeFirstResponder]) {
        [_checkNumfield resignFirstResponder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark LostCodeFistViewdelegate

-(void)miscodedelegate{
    [self add];
}


//点击屏幕键盘消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
