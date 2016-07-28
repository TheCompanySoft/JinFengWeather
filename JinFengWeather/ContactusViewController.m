//
//  ContactusViewController.m
//  JinFengWeather
//
//  Created by huake on 15/9/18.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//联系我们，输入内容，和手机号

#import "ContactusViewController.h"
#import "Header.h"
#import "UIUtils.h"
#import "AFHTTPRequestOperationManager.h"
#import "PlaceholderTextView.h"
@interface ContactusViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    UIButton *_cancelButton;
    UIButton *_saveButton;
    UITextField*textfield;
    PlaceholderTextView *view;
    UIAlertView *alert1;
}
@end
@implementation ContactusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
     self.title =@"联系我们";
    self.view.backgroundColor =[UIColor whiteColor];
    //设置navigationBar
    [self setnavigationbar];
    //添加内容视图
    [self addContent];
}
//设置navigationBar
-(void)setnavigationbar{
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:41/255.0 green:147/255.0 blue:209/255.0 alpha:1.0];
    //设置navigationBar的属性
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                                      }];
    
    //返回按钮2
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"goback@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(add )];
    //设置按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem= backItem;
}
-(void)addContent{
    textfield=[[UITextField alloc]initWithFrame:AdaptCGRectMake(15, 220, 200, 40)];
    textfield.placeholder=@"请留下您的联系方式";
    textfield.layer.cornerRadius=4.0f;
    textfield.borderStyle=UITextBorderStyleRoundedRect;
    textfield.font=[UIFont systemFontOfSize:16];
    textfield.delegate=self;
    textfield.keyboardType = UIKeyboardTypeNamePhonePad;
    textfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    [self.view addSubview:textfield];
    
    view=[[PlaceholderTextView alloc] initWithFrame:AdaptCGRectMake(14, 75, 290, 130)];
    view.placeholder=@"请留下您的建议,让我们可以做的更好！";
    view.font=[UIFont boldSystemFontOfSize:17];
    view.layer.borderWidth=0.5;
    view.layer.cornerRadius=4.0f;
    view.delegate=self;
    [view becomeFirstResponder];
    view.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.view addSubview:view];
    
    _saveButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_saveButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.userInteractionEnabled=YES;
    [_saveButton setFrame:AdaptCGRectMake(225, 220, 80, 40)];
    [_saveButton setBackgroundColor:[UIColor colorWithRed:41/255.0 green:147/255.0 blue:209/255.0 alpha:1.0]];
    _saveButton.layer.cornerRadius= 4.0f;
    [_saveButton setTitle:@"发送" forState:UIControlStateNormal];
    _saveButton.showsTouchWhenHighlighted=YES;
    [self.view addSubview:_saveButton];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [view resignFirstResponder];
        return NO;
    }
    return YES;
}
// 点击键盘上的return或者done时，隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textfield resignFirstResponder];
    return YES;
}
-(void)sendMessage{
    _saveButton.userInteractionEnabled=NO;
    [textfield resignFirstResponder];
    BOOL isPhoneNumber = [self isMobilePhoneNumber:textfield.text];
    if ([view.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的建议" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else if (!isPhoneNumber) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else{
        
        NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
        NSString *userid=[defaults objectForKey:@"useId"];
        if (userid.length==0) {
            userid=@"1";
        }
        NSDictionary *dic = @{@"phone":textfield.text,@"content":view.text,@"uid":userid};
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [manager POST:@"http://weather.huakesoft.com/api/joinus?" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
            alert1=[[UIAlertView alloc]initWithTitle:nil message:@"发送成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert1 show];
            NSTimer *timer;
            timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(doTime) userInfo:nil repeats:NO];
            _saveButton.userInteractionEnabled=YES;

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          _saveButton.userInteractionEnabled=YES;
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查当前网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}
-(void)doTime

{
    alert1.delegate=self;
    //alert过1秒自动消失
    [alert1 dismissWithClickedButtonIndex:0 animated:NO];
    
    
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

-(void)add{
    if ([view becomeFirstResponder]) {
        [view resignFirstResponder];
    }
    if ([textfield becomeFirstResponder]) {
        [textfield resignFirstResponder];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
