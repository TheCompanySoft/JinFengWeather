//
//  LoginGoViewController.m
//  JinFengWeather
//
//  Created by Goldwind on 16/3/1.
//  Copyright © 2016年 HKSoft. All rights reserved.
//

#import "LoginGoViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "UserPlantModel.h"

#import "SideBarMenuViewController.h"
#import "HomeViewController.h"
#import "LeftViewController.h"

#define K_VIEW_FRAME (self.view.frame.size)
#define K_USER_DEAFULT ([NSUserDefaults standardUserDefaults])
#define K_USER_MESSAGE @"UserWindPlant"

@interface LoginGoViewController ()<UITextFieldDelegate>{
    UITextField *_userName;
    UITextField *_passWord;
    UIButton *_loginButton;
    UISwitch *_remeberUser;
    
    SideBarMenuViewController *_sideBarMenuVC;
}

@end

@implementation LoginGoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

-(NSMutableArray *)userDataArray{
    if (_userDataArray == nil) {
        _userDataArray = [[NSMutableArray alloc]init];
    }
    return _userDataArray;
}


-(void)createUI{
    UIImageView *backGroudView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UserLoginBackGround"]];
    backGroudView.frame = self.view.bounds;
    backGroudView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:backGroudView atIndex:0];
    
    UIImage *logoImage = [UIImage imageNamed:@"about_logo.png"];
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((K_VIEW_FRAME.width-101)/2, 80, 101, 77)];
    logoImageView.image = logoImage;
    [self.view addSubview:logoImageView];
    
    UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 205, 60, 20)];
    userLabel.text = @"用户名:";
    userLabel.textColor = [UIColor whiteColor];
    userLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:userLabel];
    
    _userName = [[UITextField alloc]initWithFrame:CGRectMake(20+userLabel.frame.size.width, 200, K_VIEW_FRAME.width - userLabel.frame.size.width - 40, 30)];
    _userName.placeholder = @" 请输入用户名";
    _userName.backgroundColor = [UIColor whiteColor];
    _userName.clearButtonMode = UITextFieldViewModeAlways;
    _userName.borderStyle = UITextBorderStyleRoundedRect;
    _userName.delegate = self;
    [self.view addSubview:_userName];
    
    UILabel *passWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 255, 60, 20)];
    passWordLabel.text = @"密码:";
    passWordLabel.textColor = [UIColor whiteColor];
    passWordLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:passWordLabel];
    
    _passWord = [[UITextField alloc]initWithFrame:CGRectMake(20+userLabel.frame.size.width, 250, K_VIEW_FRAME.width - userLabel.frame.size.width - 40, 30)];
    _passWord.placeholder = @" 请输入密码";
    _passWord.backgroundColor = [UIColor whiteColor];
    _passWord.secureTextEntry = YES;
    _passWord.clearButtonMode = UITextFieldViewModeAlways;
    _passWord.borderStyle = UITextBorderStyleRoundedRect;
    _passWord.delegate = self;
    [self.view addSubview:_passWord];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _loginButton.frame = CGRectMake((K_VIEW_FRAME.width - 300)/2, 400, 300, 40);
    _loginButton.backgroundColor = [UIColor colorWithRed:0.00f green:0.69f blue:0.92f alpha:1.00f];
    _loginButton.layer.cornerRadius = 5;
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
}

-(void)login:(UIButton *)buttton{
//    [K_USER_DEAFULT removeObjectForKey:@"UserWindPlant"];
//    if ([_userName.text isEqualToString:@""]||[_passWord.text isEqualToString:@""]) {
//        [self setAlertWithString:@"用户名或密码不能为空"];
//    }else{
//        NSDictionary *dict = @{@"name":_userName.text,@"password":_passWord.text};
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        [manager POST:@"http://54.223.190.36:8092/api/Users/Login" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            if (self.userDataArray.count>0) {
//                [self.userDataArray removeAllObjects];
//            }
//            NSArray *rootArray = responseObject;
//            if (rootArray.count == 0) {
//                [self setAlertWithString:@"用户不存在请联系管理员"];
//            }else{
//                NSDictionary *rootDic = [rootArray objectAtIndex:0];
//                NSMutableArray *WfRightArray = [rootDic objectForKey:@"WfRightsObj"];
//                for (NSDictionary *dic in WfRightArray) {
//                    UserPlantModel *userPlantModel = [UserPlantModel objectWithKeyValues:dic];
//                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userPlantModel];
//                    [self.userDataArray addObject:data];
//                }
//                NSArray *userArray = [NSArray arrayWithArray:self.userDataArray];
//                [K_USER_DEAFULT setValue:userArray forKey:K_USER_MESSAGE];
//                [K_USER_DEAFULT synchronize];
                [self pushHomeContorller];
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [self setAlertWithString:@"请检查网络设置"];
//        }];
//    }
}

-(void)setAlertWithString:(NSString *)alertString{
    UIAlertController *noneAlert = [UIAlertController alertControllerWithTitle:nil message:alertString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [noneAlert addAction:cancel];
    [self presentViewController:noneAlert animated:YES completion:nil];
}


-(void)pushHomeContorller{
    HomeViewController *viewController = [[HomeViewController alloc] init];
    _sideBarMenuVC = [[SideBarMenuViewController alloc] initWithRootViewController:viewController];
    //设定_sideBarMenuVC的左侧栏
    LeftViewController *leftViewController= [[LeftViewController alloc] init];
    leftViewController.sideBarMenuVC = _sideBarMenuVC;
    _sideBarMenuVC.leftViewController = leftViewController;
    
   
    //leftViewController展示主视图
    [leftViewController showViewControllerWithSection:0 Index:1];
    
    //[leftViewController showViewControllerWithSection:1 Index:1];
//    self.window.rootViewController = _sideBarMenuVC;
    [self presentViewController:_sideBarMenuVC animated:YES completion:^{
        
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
