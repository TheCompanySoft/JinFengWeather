//
//  ViewController.h
//  JinFengWeather
//
//  Created by huake on 15/9/16.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "LeftViewController.h"
#import "Header.h"
#import "UIUtils.h"
#import "LeftViewCell.h"
#import "SideBarMenuViewController.h"
#import "HomeViewController.h"
#import "AddCityViewController.h"
#import "PersoninfoViewController.h"
#import "ContactusViewController.h"
#import "WarninfoViewController.h"
#import "AboutusViewController.h"
#import "LoginViewController.h"
#import "Cityweatherinfo.h"
#import "UserPlantModel.h"

#define K_USER_DEAFULT ([NSUserDefaults standardUserDefaults])
#define K_USER_MESSAGE @"UserWindPlant"

@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSString *_filePath;
    UITableView *_tableView;
    NSArray *_cellInfoArray;
    
    HomeViewController *viewController;
    UINavigationController *_navViewController;
    UIImageView *_bgleftImageView;
    UIView *_editTileOpaqueView;//背影
    UIView *_bottomView;
    UIView*av;
    
    NSMutableArray *cityInfoMutableArray;
    NSArray *cityInfoNSArray;
    Cityweatherinfo *_cityWeatherinfo;
    
    NSMutableArray *_keyArray;//存储索引值的可变数组
    NSUserDefaults *_accountDefaults;
    
}
@end

@implementation LeftViewController
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//
//
//    [[BaiduMobStat defaultStat] pageviewStartWithName:@"设置"];
//
//}
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//
//    [[BaiduMobStat defaultStat] pageviewEndWithName:@"设置"];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载数据
    [self loadData];
    //    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_images@2x.jpg"]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self addhomebackgroundView];
    [self addCityBtn];
    //初始化文件路径
    [self initFilePath];
    
    //加载city数据
    [self loadSelfData];
    
    
    [self addTableView];
    
    
}
//加载数据
- (void)loadData
{
//    _cellInfoArray = @[
//                       @{@"image":[UIImage imageNamed:@"userinfo@2x"],
//                         @"text":@"个人信息"},
//                       @{@"image":[UIImage imageNamed:@"contact_us@2x"],
//                         @"text":@"联系我们"},
//                       @{@"image":[UIImage imageNamed:@"early_warning@2x"],
//                         @"text":@"预警信息"},
//                       @{@"image":[UIImage imageNamed:@"about_us@2x"],
//                         @"text":@"关于我们"},
//                       ];
    
    _cellInfoArray = @[
                       @{@"image":[UIImage imageNamed:@"early_warning@2x"],
                         @"text":@"预警信息"},
                       @{@"image":[UIImage imageNamed:@"about_us@2x"],
                         @"text":@"关于我们"},
                       ];
}
#pragma mark
//加载数据
- (void)loadSelfData
{
    if (_cityinfoArray == nil) {
        _cityinfoArray = [[NSMutableArray alloc]initWithCapacity:20];
    }
    
    //判断filePath是否存在
    NSFileManager *manager=[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:_filePath])
    {
        //解档
        _cityinfoArray = [NSKeyedUnarchiver unarchiveObjectWithFile:_filePath];
        
        //初始化_personDictionary
        [self initPersonDictionary];
        
    } else {
#warning 建议修改部分
//        [self initPersonDictionary];
        
        [self loadLoginUserPlantData];
    }
}

-(void)loadLoginUserPlantData{
    NSArray *userArray = [K_USER_DEAFULT objectForKey:K_USER_MESSAGE];
    for (NSData *userData in userArray) {
        UserPlantModel *userPlantModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        Cityweatherinfo *windPlantModel = [[Cityweatherinfo alloc]init];
        windPlantModel.name = userPlantModel.WfName;
        windPlantModel.cityWeidu = userPlantModel.WfX;
        windPlantModel.cityJingdu = userPlantModel.WfY;
        windPlantModel.flag = [userPlantModel.WfType intValue];
        windPlantModel.WfId = userPlantModel.WfId;
        windPlantModel.WfCode = userPlantModel.WfCode;
        [_cityinfoArray addObject:windPlantModel];
    }
    cityInfoNSArray = [_cityinfoArray copy];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    _filePath = [docPath stringByAppendingPathComponent:@"city.archiver"];
    [NSKeyedArchiver archiveRootObject:_cityinfoArray toFile:_filePath];
}

//获取本地存储的风电位置 是删除重复的位置
- (void)initPersonDictionary
{
    cityInfoMutableArray = [NSMutableArray array];
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    
//    if (_cityinfoArray.count == 0) {
//        Cityweatherinfo *windPlantSea = [[Cityweatherinfo alloc]init];
//        windPlantSea.name = @"金风如东风电场";
//        windPlantSea.flag = 2;
//        [_cityinfoArray addObject:windPlantSea];
//        Cityweatherinfo *windPlantLand = [[Cityweatherinfo alloc]init];
//        windPlantLand.name = @"金风如东海上风电场";
//        windPlantLand.flag = 1;
//        [_cityinfoArray addObject:windPlantLand];
//    }
    
    for (Cityweatherinfo *cityinfo in _cityinfoArray) {
        [categoryArray addObject:cityinfo];
    }
    
    for (unsigned i = 0; i < [categoryArray count]; i++){
        if ([cityInfoMutableArray containsObject:[categoryArray objectAtIndex:i]] == NO){
            [cityInfoMutableArray addObject:[categoryArray objectAtIndex:i]];
        }
    }
    cityInfoNSArray = [cityInfoMutableArray copy];
}


//初始化文件路径
- (void)initFilePath
{
    //初始化文件存储路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    _filePath = [docPath stringByAppendingPathComponent:@"city.archiver"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hotcityweatherinfo" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchcityweatherinfo" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"definecityfrommap" object:nil];
#pragma mark ----2&&22 接收通知添加城市
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCityWeatherInfo:) name:@"hotcityweatherinfo" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCityWeatherInfo:) name:@"searchcityweatherinfo" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCityWeatherInfo:) name:@"definecityfrommap" object:nil];
}

- (void)addCityWeatherInfo:(NSNotification *)noti{
    Cityweatherinfo *weatherInfo = noti.object;
    
    NSLog(@"%@!!!!!%@",weatherInfo.name,weatherInfo.cityWeidu);
    
    NSArray *array = [_cityinfoArray mutableCopy];
    //删除重复添加城市
    for (Cityweatherinfo *www in array) {
        if ([www.name isEqual:weatherInfo.name]) {
            [_cityinfoArray removeObject:www];
        }
    }
    
    [_cityinfoArray addObject:noti.object];
    
    [self initPersonDictionary];
    [_tableView reloadData];
    //归档
    BOOL flag = [NSKeyedArchiver archiveRootObject:_cityinfoArray toFile:_filePath];
    if (flag) {
        //        NSLog(@"归档成功");
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hotcityweatherinfo" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"searchcityweatherinfo" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"definecityfrommap" object:nil];
}
//首页背景图片
-(void)addhomebackgroundView{
    
    _bgleftImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [_bgleftImageView setImage:[UIImage imageNamed:@"leftbg@2x.jpg"]];
    [self.view addSubview:_bgleftImageView];
    
}
//添加设置界面tableVeiw
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, [UIUtils getWindowWidth]-60, [UIUtils getWindowHeight]-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorColor=[UIColor whiteColor];
    _tableView.allowsSelectionDuringEditing = YES;
    //_tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    //默认_tableView的第一行定位
//    NSIndexPath *selectedIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//    [_tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
}
//添加城市的按钮
-(void)addCityBtn{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake([UIUtils getWindowWidth]/7*5-13*[UIUtils getWindowWidth]/320,22,45*[UIUtils getWindowWidth]/320, 35)];
    [btn setImage:[UIImage imageNamed:@"add@2x"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(addCity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
//添加城市界面跳转方法
-(void)addCity{
    AddCityViewController *addCityController = [[AddCityViewController alloc]init];
    addCityController.modalTransitionStyle=2;
    //    右侧城市传过去
    addCityController.cityArray = cityInfoMutableArray;
    //    NSLog(@"addCityController.cityArray%@",addCityController.cityArray);
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:addCityController];
    
    [_sideBarMenuVC presentViewController:nav animated:YES completion:nil];
}
//展示相应的controller
- (void)showViewControllerWithSection:(int)section Index:(int)row
{
    if (section==0) {
        viewController = [[HomeViewController alloc] init];
        _cityWeatherinfo = [[Cityweatherinfo alloc] init];
        
            Cityweatherinfo *cityInfo = cityInfoNSArray[row];
            if (cityInfo.flag == 0) {
                _cityWeatherinfo.name = cityInfo.name;
                _cityWeatherinfo.cityWeidu = cityInfo.cityWeidu;
                _cityWeatherinfo.cityJingdu = cityInfo.cityJingdu;
            }else{
                _cityWeatherinfo.name = cityInfo.name;
                _cityWeatherinfo.WfCode = cityInfo.WfCode;
                _cityWeatherinfo.WfId = cityInfo.WfId;
                _cityWeatherinfo.flag = cityInfo.flag;
            }
#pragma mark--从左侧列表获得城市名称和经纬度
            NSLog(@"%@___%@___%@",_cityWeatherinfo.name,_cityWeatherinfo.cityJingdu,_cityWeatherinfo.cityWeidu);
            
            if (!_navViewController) {
                _navViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
            }
        
        
        NSDictionary *dic = @{@"leftcity":_cityWeatherinfo};
#pragma mark ----1.发布通知:加载左侧城市数据对象
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"addcityfromleftview" object:@"leftcity"userInfo:dic]];
        [_sideBarMenuVC setRootViewController:_navViewController animated:YES];
    }else{
        switch (row) {
//            case 0:
//            {
//                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//                NSString *str=[defaults objectForKey:@"isLogin"];
//                if ([str isEqualToString:@"1"]) {
//                    PersoninfoViewController *addCityController =[[PersoninfoViewController alloc]init];
//                    addCityController.modalTransitionStyle=0;
//                    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:addCityController];
//                    [_sideBarMenuVC presentViewController:nav animated:YES completion:nil];
//                }else{
//                    LoginViewController*loginVC=[[LoginViewController alloc]init];
//                    loginVC.modalTransitionStyle=0;
//                    
//                    [_sideBarMenuVC presentViewController:loginVC animated:YES completion:nil];
//                }
//            }
//                break;
//            case 1:
//            {
//                ContactusViewController *addCityController =[[ContactusViewController alloc]init];
//                addCityController.modalTransitionStyle=0;
//                UINavigationController *nav1 =[[UINavigationController alloc]initWithRootViewController:addCityController];
//                [_sideBarMenuVC presentViewController:nav1 animated:YES completion:nil];
//            }
//                
//                break;
            case 0:
            {
                WarninfoViewController *addCityController =[[WarninfoViewController alloc]init];
                addCityController.modalTransitionStyle=0;
                UINavigationController *nav2 =[[UINavigationController alloc]initWithRootViewController:addCityController];
                [_sideBarMenuVC presentViewController:nav2 animated:YES completion:nil];
            }
                break;
            case 1:
            {
                AboutusViewController *addCityController =[[AboutusViewController alloc]init];
                addCityController.modalTransitionStyle=0;
                UINavigationController *nav3 =[[UINavigationController alloc]initWithRootViewController:addCityController];
                [_sideBarMenuVC presentViewController:nav3 animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark ----删除数据
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            Cityweatherinfo *cityinfo=_cityinfoArray[indexPath.row];
            [_cityinfoArray removeObject:cityinfo];
#pragma mark  ----删除重复风电位置
            [self initPersonDictionary];
            [_tableView reloadData];
            //归档
            //[self archive];
            BOOL flag = [NSKeyedArchiver archiveRootObject:_cityinfoArray toFile:_filePath];
            if (flag) {
                //  NSLog(@"归档成功");
            }
            //删除后回到主界面
            //[self showViewControllerWithSection:0 Index:0];
        }
        
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 15;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIUtils getWindowHeight]/11.5;
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0){
        //NSLog(@"%ld",cityInfoNSArray.count);
        return  cityInfoNSArray.count;
    }else{
        return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    LeftViewCell *cell = (LeftViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[LeftViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section==0) {
        NSArray *weatherImgStr = @[@"weather_a@2x",@"weather_b@2x",@"weather_c@2x",@"weather_d@2x"];

            cell.imageView1.image = [UIImage imageNamed:weatherImgStr[arc4random()%3]];
            Cityweatherinfo *cityInfo = cityInfoNSArray[indexPath.row];
            cell.label.text = cityInfo.name;
            
            //            //自适应宽度
            //            CGSize sizeThatFit=[cell.label sizeThatFits:CGSizeZero];
            //重新指定frame
            cell.label.frame=AdaptCGRectMake(60, 13, 150,30);
//        }
        
        [cell addSubview:cell.imageView1];
#pragma mark ----公共部分
        [cell addSubview:cell.label];

        [cell addSubview:cell.warningView];
    }
#pragma mark ----菜单下部
    else
    {
        
        UIImage *moveinimage=[UIImage imageNamed:@"right_icon@2x"];
        cell.moveView=[[UIImageView alloc]initWithImage:moveinimage];
        cell.moveView.frame=AdaptCGRectMake(240, 16, moveinimage.size.width, moveinimage.size.height);
        [cell addSubview:cell.moveView];
        NSDictionary *cellInfo = _cellInfoArray[indexPath.row];
        [cell setContentView:cellInfo];
        
    }
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
//添加城市可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return YES;
    }else{
        return NO;
    }
    
    
}
#pragma mark UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section==0) {
        av=[[UIView alloc]init];
        av.backgroundColor=[UIColor blackColor];
        av.alpha=0.2;
    }
    else{
        av=[[UIView alloc]initWithFrame:CGRectMake(15, 0, 290, 0.1)];
        av.backgroundColor=[UIColor whiteColor];
        av.alpha=0.2;
    }
    return av;
    
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)saveCityinfo:(Cityweatherinfo *)cityinfo{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        [self showViewControllerWithSection:0 Index:(int)indexPath.row];
    }else {
        [self showViewControllerWithSection:1 Index:(int)indexPath.row];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
