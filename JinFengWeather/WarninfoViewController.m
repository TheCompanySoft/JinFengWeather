//
//  WarninfoViewController.m
//  JinFengWeather
//
//  Created by huake on 15/9/18.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "WarninfoViewController.h"
#import "UIUtils.h"
#import "Header.h"
#import "AFNetworking.h"
#import "WarningModel.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Simple.h"
#import "WarningTableViewCell.h"

@interface WarninfoViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSString *_loadStr;
    
    UITableView *_warningTableView;
    
    MBProgressHUD *_HUD;
}
@end

@implementation WarninfoViewController

-(NSMutableArray *)warningDataArray{
    if (_warningDataArray == nil) {
        _warningDataArray = [[NSMutableArray alloc]init];
    }
    return _warningDataArray;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"预警信息";
    //设置navigationBar
    [self setnavigationbar];
    
    [self createTableView];
    
    [self loadWarningWithFlag];
}


-(void)loadWarningWithFlag{
    _HUD=[MBProgressHUD show:MBProgressHUDModeIndeterminate message:@"加载预警信息..." customView:self.view];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *flagStr = [user objectForKey:@"flag"];
    NSArray *loadArray = [flagStr componentsSeparatedByString:@"_"];
    _flag = [[loadArray objectAtIndex:0] intValue];
    if (_flag == 0) {
        _loadStr = [NSString stringWithFormat:@"http://54.223.190.36:8092/api/LatLonWeather/%@/%@/Warning/PerDay",[loadArray objectAtIndex:1],[loadArray objectAtIndex:2]];
    }else{
        _loadStr = [NSString stringWithFormat:@"http://54.223.190.36:8092/api/PublicWeather/%@/Warning",[loadArray objectAtIndex:3]];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:_loadStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *rootArray = responseObject;
        for (NSMutableDictionary *dict in rootArray) {
            if (dict == nil) {
                
            }else{
                NSArray *keys = [dict allKeys];
                for (NSString *key in keys) {
                    if ([key isEqualToString:@"times"]) {
                        
                    }else{
                        WarningModel *warnModel = [WarningModel objectWithKeyValues:[dict objectForKey:key]];
                        [self.warningDataArray addObject:warnModel];
                    }
                }
            }
        }
        [_warningTableView reloadData];
        [_HUD hide:YES afterDelay:0.3f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"没有获取到预警信息");
        [_HUD hide:YES afterDelay:0.0f];
        UIAlertView *warnAlert = [[UIAlertView alloc]initWithTitle:nil message:@"预警信息获取失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [warnAlert show];
        
    }];
    
}

-(void)createTableView{
    _warningTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    UIImageView *backGroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_images1@2x.jpg"]];
    _warningTableView.backgroundView = backGroundView;
    _warningTableView.dataSource = self;
    _warningTableView.delegate = self;
    _warningTableView.showsVerticalScrollIndicator = NO;
    _warningTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _warningTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_warningTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",self.warningDataArray.count);
    return self.warningDataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Identifier";
    WarningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WarningTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    WarningModel *warnModel = self.warningDataArray[indexPath.row];
    cell.warnLabel.text = warnModel.AllInfo;
    UIColor *color = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.12];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = color;
    cell.backgroundColor = [UIColor clearColor];
    cell.warnView.image = [UIImage imageNamed:[NSString stringWithFormat:@"warning_%@",warnModel.Level]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
-(void)add{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
