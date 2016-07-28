//
//  AboutusViewController.m
//  JinFengWeather
//
//  Created by huake on 15/9/18.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//企业介绍

#import "AboutusViewController.h"

#define K_VIEW_FRAME (self.view.frame.size)

@interface AboutusViewController ()

@end

@implementation AboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"关于我们";
    self.view.backgroundColor =[UIColor whiteColor];
    //设置navigationBar
    [self setnavigationbar];
    
    [self setUI];
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

-(void)setUI{
    UIImage *logoImage = [UIImage imageNamed:@"about_logo.png"];
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((K_VIEW_FRAME.width-101)/2, 80, 101, 77)];
    logoImageView.image = logoImage;
    [self.view addSubview:logoImageView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(10, 165, (K_VIEW_FRAME.width-20), 90)];
    topView.layer.borderWidth = 1;
    topView.layer.borderColor = [[UIColor grayColor]CGColor];
    topView.layer.cornerRadius = 10;
    
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 160, 30)];
    versionLabel.text = @"应用程序版本：";
    versionLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:versionLabel];
    
    UILabel *versionTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(versionLabel.frame.size.width - 10, 10, (topView.frame.size.width-versionLabel.frame.size.width), 30)];
    versionTextLabel.textAlignment = NSTextAlignmentRight;
    versionTextLabel.font = [UIFont systemFontOfSize:15];
    versionTextLabel.text = [[UIDevice currentDevice]systemVersion];
    [topView addSubview:versionTextLabel];
    
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, (topView.frame.size.width-20), 30)];
    codeLabel.text = @"内部代码：";
    codeLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:codeLabel];
    
    UILabel *codeTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(codeLabel.frame.size.width - 10, 50, (topView.frame.size.width-codeLabel.frame.size.width), 30)];
    codeTextLabel.textAlignment = NSTextAlignmentRight;
    codeTextLabel.font = [UIFont systemFontOfSize:15];
    codeTextLabel.text = @"0";
    [topView addSubview:codeTextLabel];
    
    [self.view addSubview:topView];
    
    
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(10, 265, (K_VIEW_FRAME.width-20), 210)];
    bottomView.layer.borderWidth = 1;
    bottomView.layer.borderColor = [UIColor grayColor].CGColor;
    bottomView.layer.cornerRadius = 10;
    
    UILabel *copyrightLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    copyrightLabel.text = @"版权所有：";
    copyrightLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:copyrightLabel];
    
    UILabel *copyrightTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(copyrightLabel.frame.size.width - 10, 10, (bottomView.frame.size.width-copyrightLabel.frame.size.width), 30)];
    copyrightTextLabel.textAlignment = NSTextAlignmentRight;
    copyrightTextLabel.font = [UIFont systemFontOfSize:15];
    copyrightTextLabel.text = @"北京博风慧能软件有限公司";
    [bottomView addSubview:copyrightTextLabel];
    
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 100, 30)];
    addressLabel.text = @"地址：";
    addressLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:addressLabel];
    
    UILabel *addressTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(addressLabel.frame.size.width - 10, 50, (bottomView.frame.size.width-addressLabel.frame.size.width), 30)];
    addressTextLabel.textAlignment = NSTextAlignmentRight;
    addressTextLabel.font = [UIFont systemFontOfSize:15];
    addressTextLabel.text = @"北京经济技术开发区康定街19号";
    [bottomView addSubview:addressTextLabel];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 100, 30)];
    phoneLabel.text = @"电话：";
    phoneLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:phoneLabel];
    
    UILabel *phoneTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(phoneLabel.frame.size.width - 10, 90, (bottomView.frame.size.width-phoneLabel.frame.size.width), 30)];
    phoneTextLabel.textAlignment = NSTextAlignmentRight;
    phoneTextLabel.font = [UIFont systemFontOfSize:15];
    phoneTextLabel.text = @"+86-(0)10-67812810";
    [bottomView addSubview:phoneTextLabel];
    
    UILabel *faxLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 130, 100, 30)];
    faxLabel.text = @"传真：";
    faxLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:faxLabel];
    
    UILabel *faxTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(faxLabel.frame.size.width - 10, 130, (bottomView.frame.size.width-faxLabel.frame.size.width), 30)];
    faxTextLabel.textAlignment = NSTextAlignmentRight;
    faxTextLabel.font = [UIFont systemFontOfSize:15];
    faxTextLabel.text = @"+86-(0)10-67511880";
    [bottomView addSubview:faxTextLabel];
    
    UILabel *postcodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 100, 30)];
    postcodeLabel.text = @"邮编：";
    postcodeLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:postcodeLabel];
    
    UILabel *postcodeTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(postcodeLabel.frame.size.width - 10, 170, (bottomView.frame.size.width-postcodeLabel.frame.size.width), 30)];
    postcodeTextLabel.textAlignment = NSTextAlignmentRight;
    postcodeTextLabel.font = [UIFont systemFontOfSize:15];
    postcodeTextLabel.text = @"100176";
    [bottomView addSubview:postcodeTextLabel];
    
    [self.view addSubview:bottomView];
    
}




-(void)add{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
