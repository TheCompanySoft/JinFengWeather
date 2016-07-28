
////NSString *urlStr1=@"http://54.223.190.36:8085/api/LandWeathers/110115112000/1/2015-10-08/1/App";
//  ViewController.m
//  JinFengWeather
//1手机号登录
//2
//  Created by huake on 15/9/16.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//主界面
#import "HomeViewController.h"
#import "Header.h"
#import "WarninfoViewController.h"
#import "UIUtils.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Simple.h"
#import "RainView.h"
#import "HumidityView.h"
#import "SnowView.h"
#import "PressView.h"

#import "SeaLevelView.h"
#import "WaveHeightView.h"

#import "SeaTarvelView.h"
#import "WindPlantModel.h"
#import "UserPlantModel.h"

#import "DayArrayinfo.h"
#import "FirstSectionViewCell.h"
#import "MainChartViewCell.h"
#import "DropdownCell.h"
#import "MoretimeChangeview.h"
#import "FirstSectionView.h"
#import "MoreparameterSectionView.h"
#import "LastSectionView.h"
#import "LoginViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "Cityweatherinfo.h"
#import "FMDB.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "MJRefresh.h"
#import "MJExtension.h"


static NSString *frep = @"1";
static NSString *_plantCode = @"";
static NSString *_WfId = @"";
#define K_USER_DEAFULT ([NSUserDefaults standardUserDefaults])
#define K_USER_MESSAGE @"UserWindPlant"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,Moretimeviewdelegate,First1SectionViewdelegate,SecondSectionViewdelegate,Moretimeviewdelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    
    MBProgressHUD *_HUD;//提示
    NSString *filePath;//文件的路径
    HumidityView *_humidityView;//湿度
    NSMutableArray *_humidArray;//存湿度值
    SnowView*_snowView;//雪
    NSMutableArray *_snowArray;//存降雪量
    RainView*_rainView;//雨
    NSMutableArray *_rainArray;//存降雨量
    PressView*_pressureView;//气压
    NSMutableArray *_pressArray;//存压力值
    
    
    SeaLevelView *_seaLevelView;//潮位
    NSMutableArray *_seaLevelArray;//存储潮位数据
    WaveHeightView *_waveHeightView;//浪高
    NSMutableArray *_waveHeightArray;//存储浪高数据
    
    //WeatherInfo *_weatherinfo;//天气对象
    UIImageView *_imagelocView;//导航栏定位图标
    UITableView *_tableView;//承载主界面各个模块
    BOOL isresponse;//下拉cell按钮状态
    DayArrayinfo *_dayinfo;//一天数据对象
    NSUserDefaults*_cityCodedefault;//城市code
    NSMutableArray *_dayInfoArray;//内部存每一天对象96
    NSMutableArray *_datedateArray;//存数据对应的相应的时间Y-M-D-h-m-s
    NSMutableArray *_dateArray;//存数据对应时间的截取M-D
    
    NSMutableArray *_hourArray;//存储小时的数组h 作为绘图类的横坐标
    
    DropdownCell*_midViewcell;//主界面下拉的cell
    MoretimeChangeview*_moretimeview;//时间切换视图
    UIAlertView *alert1;//提醒当前网络
    UIImage *_image3;//定位图标图片
    BMKMapManager *_manger;//地图
    NSUserDefaults *_defaultsloc;//存储定位城市的信息
    UIAlertView *_alert;//15天数据加载提醒
    NSFileManager *_manger1;//数据本地存储
    NSArray *titleAndCodeArray;//存城市名和相应的经纬度
    
    NSMutableArray *_dataArray;//现在数据存储数组
    
    NSMutableArray *_windPlantArray;//用来存储风电场数据
    
    
    NSMutableArray *_snow12Array;//12小时降雪量
    NSMutableArray *_rain12Array;//12小时降雨量
    
    int _flag;//
    
    NSString *_loadWindPlant;
}
@property(nonatomic ,strong)UILabel *citylabel;//导航栏显示城市名
@property(nonatomic ,strong)UIView *bgView;//湿度，雨，雪，气压视图的背景视图
@property(nonatomic ,strong)NSString*currentTime;//当前加载数据时间
@property(nonatomic ,assign)int daycount;//要加载数据的天数
@property(nonatomic ,strong)MoreparameterSectionView *sectionView;//风车旋转所在的Section的子视图
@property(nonatomic ,strong)FirstSectionView *firstSectionview;// 添加折线图的线的对应线条的颜色
@property(nonatomic ,strong)LastSectionView *threeView;//最后一个Section线条的颜色所在View
@property(nonatomic ,strong)MainChartViewCell *mainChartcell;//双曲线所在的cell
@property(nonatomic ,strong)FirstSectionViewCell*firstcell;//基本天气数据显示
@property(nonatomic,strong)BMKLocationService *locationSevice;//百度地图定位
@property(nonatomic,strong)BMKGeoCodeSearch *getCodeSearch;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;

@property (nonatomic,strong)SeaTarvelView *seaTravelView;//海上安全出行时间view

@end
@implementation HomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //一天数据对象数组
    _dayInfoArray=[NSMutableArray array];
    //存日期数据
    _datedateArray=[NSMutableArray array];
    //湿度
    _humidArray=[NSMutableArray array];
    
    //浪高
    _seaLevelArray = [NSMutableArray array];
    //潮位
    _waveHeightArray = [NSMutableArray array];
    
    //降雪
    _snowArray=[NSMutableArray array];
    
    _snow12Array = [NSMutableArray array];
    //降雨
    _rainArray=[NSMutableArray array];
    
    _rain12Array = [NSMutableArray array];
    //压力数组
    _pressArray=[NSMutableArray array];
    //存数据对应的相应的时间M-D
    _dateArray=[NSMutableArray array];
    
    //存储相应的小时 h
    _hourArray = [NSMutableArray array];
    
    _dataArray = [NSMutableArray array];
    
    _windPlantArray = [NSMutableArray array];
    
    
    NSDate*todayDate = [NSDate date];
    NSDateFormatter  * newFormatter2 = [[NSDateFormatter alloc] init];
    //设置时间显示格式
    [newFormatter2 setDateFormat:@"YYYY-MM-dd"];
    _currentTime=[newFormatter2 stringFromDate:todayDate];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"headbg@2x"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    //把状态栏设置为白色
    [self setStatusBarColor];
    //设定导航栏
    [self setNavigationBar];
    
    //添加主页视图
    [self addContentView];
    //添加更多时间的选择
    [self addMoretimeView];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //可以用alloc 方法代替
    titleAndCodeArray = [user arrayForKey:@"cityName1"];
    if (titleAndCodeArray.count>0) {
        titleAndCodeArray=nil;
        [self getbackData];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cityName1"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else{
        //定位
        [self localMyCity];
    }
}

//定位当前城市
-(void)localMyCity{
    _manger =[[BMKMapManager alloc]init];
    [_manger start:@"0swB9YTsIV9wGHAGt4ZP2kut" generalDelegate:self];
    self.locationSevice=[[BMKLocationService alloc]init];
    self.locationSevice.delegate=self;
    [self.locationSevice startUserLocationService];
    [BMKLocationService setLocationDistanceFilter:10];
    self.getCodeSearch=[[BMKGeoCodeSearch alloc]init];
    self.getCodeSearch.delegate=self;
//    _citylabel.text=@"定位中";
    
    
    
    NSArray *userArray = [K_USER_DEAFULT objectForKey:K_USER_MESSAGE];
    UserPlantModel *userPlantModel = [NSKeyedUnarchiver unarchiveObjectWithData:userArray[0]];
    [self loadDataFromWindPlantWithPlantCode:userPlantModel.WfCode WithFlag:[userPlantModel.WfType intValue]];
    self.citylabel.text = userPlantModel.WfName;
    CGSize sizeThatFit=[_citylabel sizeThatFits:CGSizeZero];
    _citylabel.frame=CGRectMake(10,10,sizeThatFit.width, 30);
    self.citylabel.center=CGPointMake(self.view.center.x+10*[UIUtils getWindowWidth]/320,20);
    [self.navigationController.navigationBar addSubview:_citylabel];
    _imagelocView.frame=CGRectMake(CGRectGetMinX(_citylabel.frame)-_image3.size.width-4*[UIUtils getWindowWidth]/320, 10, _image3.size.width,_image3.size.height);
    [self.navigationController.navigationBar addSubview:_imagelocView];
}

#pragma mark BMKGeoCodeSearch的代理方法
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    BMKReverseGeoCodeOption *reverseOption =[[BMKReverseGeoCodeOption alloc]init];
    reverseOption.reverseGeoPoint=userLocation.location.coordinate;
    [self.getCodeSearch reverseGeoCode:reverseOption];
}
#pragma mark BMKGeoCodeSearch的代理方法
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
//    self.citylabel.text= result.addressDetail.city;
    
    // NSLog(@"%@",self.citylabel.text);
    _cityCodedefault = [NSUserDefaults standardUserDefaults];
    [_cityCodedefault setObject:self.citylabel.text forKey:@"citynameloc"];
    self.citylabel.textAlignment=NSTextAlignmentCenter;
    
    CGSize sizeThatFit=[self.citylabel sizeThatFits:CGSizeZero];
    self.citylabel.frame=CGRectMake(10,10,sizeThatFit.width, 30);
    self.citylabel.center=CGPointMake(self.view.center.x+10*[UIUtils getWindowWidth]/320,20);
    _imagelocView.frame=CGRectMake(CGRectGetMinX(self.citylabel.frame)-_image3.size.width-4*[UIUtils getWindowWidth]/320, 10, _image3.size.width,_image3.size.height);
    self.citylabel.textAlignment=NSTextAlignmentCenter;
    [self.navigationController.navigationBar addSubview:_imagelocView];
    //[self dbDataImport:result.addressDetail.city];
    
//    NSString *latitude = [NSString stringWithFormat:@"%lf",result.location.latitude];
//    NSString *longitude = [NSString stringWithFormat:@"%lf",result.location.longitude];
//    [self loadDateLatitude:latitude andLongitude:longitude];
    
#warning 定位城市存储
//    NSMutableArray *arrayy=[NSMutableArray array];
//    [arrayy addObject:result.addressDetail.city];
//    [arrayy addObject:latitude];
//    [arrayy addObject:longitude];
//    
//    
//    _defaultsloc = [NSUserDefaults standardUserDefaults];
//    [_defaultsloc setObject:arrayy forKey:@"location"];
//    [_defaultsloc synchronize];
    
    
    
    
    [_manger stop];
    
}




//定位失败调用
- (void)didFailToLocateUserWithError:(NSError *)error
{
//    self.citylabel.text=@"定位失败";
    self.citylabel.textAlignment=NSTextAlignmentCenter;
    
    _cityCodedefault = [NSUserDefaults standardUserDefaults];
    [_cityCodedefault setObject:@"1" forKey:@"latitude"];
    [_cityCodedefault setObject:@"1" forKey:@"longitude"];
    [_defaultsloc setObject:self.citylabel.text forKey:@"location"];
}
//把状态栏设置为白色
- (void)setStatusBarColor
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
//设定导航栏
- (void)setNavigationBar
{
    self.navigationController.navigationBar.barTintColor=[UIColor clearColor];
    _image3=[UIImage imageNamed:@"landmark@2x"];
    _imagelocView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.citylabel.frame)-_image3.size.width, 10, _image3.size.width,_image3.size.height)];
    [_imagelocView setImage:_image3];
    self.citylabel=[[UILabel alloc]init];
    self.citylabel.textColor=[UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.citylabel];
    //设置navigationbar的title颜色
    NSDictionary *dictionary = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dictionary];
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"time@2x"] forState:UIControlStateNormal];
    [btn setFrame:AdaptCGRectMake(0, 0, 25, 25)];
    [btn addTarget:self action:@selector(addmoretime) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem= backItem;
    
}
//添加内容视图
-(void)addContentView{
    isresponse=YES;
    //首页背景图片
    [self addhomebackgroundView];
    //添加TableView
    [self addtableView];
    //添加表视图
    [self addlastrowChartView];
    //风车所在的Section
    if (_sectionView==nil) {
        _sectionView=[[MoreparameterSectionView alloc]init];
    }
    _sectionView.delegate=self;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[paths objectAtIndex:0];
    filePath=[docPath stringByAppendingPathComponent:@"Test.plist"];
    _daycount=3;
    _manger1= [NSFileManager defaultManager];
    if ([_manger1 fileExistsAtPath:filePath]) {
        
    }
}
//通知提示获取更多数据
-(void)sayHi:(NSNotification *)noti
{
//    _alert=[[UIAlertView alloc]initWithTitle:@"获取15天数据" message:@"数据量较大建议在WiFi环境下使用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//    _alert.delegate=self;
//    [_alert show];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"addcityfromleftview" object:@"leftcity"];
    _alert.delegate=nil;
}

////加载15天的数据
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//
//    if (buttonIndex==0) {
//        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//        NSString *str=[defaults objectForKey:@"isLogin"];
//        if ([str isEqualToString:@"1"]) {
//         _daycount=15;
//            NSUserDefaults*accountDefaults = [NSUserDefaults standardUserDefaults];
//            NSString *citycodedefault = [accountDefaults objectForKey:@"citycodedefault"];
//        [self loadDate:citycodedefault];
//        }else{
//        [_manger stop];
//        LoginViewController*loginC=[[LoginViewController alloc]init];
//            [self presentViewController:loginC animated:YES completion:nil];
//
//        }
//    }
//}
//////获取添加城市信息
#pragma mark --获取添加城市信息
-(void)getbackData{
    //  -------------------------赋值方法-------------------
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //可以用alloc 方法代替
    titleAndCodeArray = [user arrayForKey:@"cityName1"];
    self.citylabel.text = [titleAndCodeArray objectAtIndex:0];
    self.citylabel.textAlignment=NSTextAlignmentCenter;
    _cityCodedefault = [NSUserDefaults standardUserDefaults];
    
#warning citynameloc?
    
    [_cityCodedefault setObject:self.citylabel.text forKey:@"citynameloc"];
    CGSize sizeThatFit=[self.citylabel sizeThatFits:CGSizeZero];
    self.citylabel.frame=CGRectMake(10,10,sizeThatFit.width, 30);
    self.citylabel.center=CGPointMake(self.view.center.x+10*[UIUtils getWindowWidth]/320,20);
    _imagelocView.frame=CGRectMake(CGRectGetMinX(self.citylabel.frame)-_image3.size.width-4*[UIUtils getWindowWidth]/320, 10, _image3.size.width,_image3.size.height);
    [self.navigationController.navigationBar addSubview:_imagelocView];
    
    NSString *latigude= [titleAndCodeArray objectAtIndex:1];
    
    NSString *longitude = [titleAndCodeArray objectAtIndex:2];
    
    //    if ([_manger1 fileExistsAtPath:filePath]) {
    //        NSDictionary *dic=[[NSDictionary alloc]initWithContentsOfFile:filePath];
    //    for (NSString*strkey in [dic allKeys]) {
    //            NSMutableDictionary *dicd=[dic objectForKey:strkey];
    //            NSString *strdatetime=[dicd objectForKey:@"BeginDate"];
    NSDate*todayDate = [NSDate date];
    NSDateFormatter  * newFormatter2 = [[NSDateFormatter alloc] init];
    //设置时区
    NSTimeZone*timeZone = [NSTimeZone localTimeZone];
    [newFormatter2 setTimeZone:timeZone];
    //设置时间显示格式
    [newFormatter2 setDateFormat:@"YYYY-MM-dd"];
    _currentTime=[newFormatter2 stringFromDate:todayDate];
    
    
    if (latigude == nil) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前城市没有数据" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //跳到主界面加载数据
        [self loadDateLatitude:latigude andLongitude:longitude];
    }
    //    }
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:@"givemessage" object:nil];
}
//
#pragma mark ----添加城市
//执行从左侧列表点击获取的城市
- (void)addCityFromLeftViewAndOther:(NSNotification *)text{
    NSArray *cityInfoArr = [NSArray arrayWithObjects:text.userInfo[@"leftcity"], nil];
    if (self.title!=nil) {
        self.title=nil;
    }
    for (Cityweatherinfo *info in cityInfoArr) {
        if (info.name == nil) {
            self.citylabel.text=@"";
        }else {
            self.citylabel.text=@"";
            [_manger stop];
            self.citylabel.text = info.name;
            _cityCodedefault = [NSUserDefaults standardUserDefaults];
            [_cityCodedefault setObject:self.citylabel.text forKey:@"citynameloc"];
            self.citylabel.textAlignment=NSTextAlignmentCenter;
            
            CGSize sizeThatFit=[self.citylabel sizeThatFits:CGSizeZero];
            
            self.citylabel.frame=CGRectMake(10,10,sizeThatFit.width, 30);
            self.citylabel.center=CGPointMake(self.view.center.x+10*[UIUtils getWindowWidth]/320,20);
            
            _imagelocView.frame=CGRectMake(CGRectGetMinX(self.citylabel.frame)-_image3.size.width-4*[UIUtils getWindowWidth]/320, 10, _image3.size.width,_image3.size.height);
            
            [self.navigationController.navigationBar addSubview:_imagelocView];
            
            _WfId = info.WfId;
            if (info.flag == 0) {
                [self loadDateLatitude:info.cityWeidu andLongitude:info.cityJingdu];
            }else{
                [self loadDataFromWindPlantWithPlantCode:info.WfCode WithFlag:info.flag];
            }
            
        }
    }
    
}


-(void)addCityFromBMK:(NSNotification *)weatherModel{
    Cityweatherinfo *weatherInfo = (Cityweatherinfo *)weatherModel;
    if (weatherInfo.name == nil) {
        self.citylabel.text=@"";
    }else{
        self.citylabel.text=@"";
        [_manger stop];
        self.citylabel.text = weatherInfo.name;
        _cityCodedefault = [NSUserDefaults standardUserDefaults];
        [_cityCodedefault setObject:self.citylabel.text forKey:@"citynameloc"];
        self.citylabel.textAlignment=NSTextAlignmentCenter;
        
        CGSize sizeThatFit=[self.citylabel sizeThatFits:CGSizeZero];
        
        self.citylabel.frame=CGRectMake(10,10,sizeThatFit.width, 30);
        self.citylabel.center=CGPointMake(self.view.center.x+10*[UIUtils getWindowWidth]/320,20);
        
        _imagelocView.frame=CGRectMake(CGRectGetMinX(self.citylabel.frame)-_image3.size.width-4*[UIUtils getWindowWidth]/320, 10, _image3.size.width,_image3.size.height);
        
        [self.navigationController.navigationBar addSubview:_imagelocView];
        
        
        [self loadDateLatitude:weatherInfo.cityWeidu andLongitude:weatherInfo.cityJingdu];
    }
}


//获取请求数据 并添加flag参数 判断数据模型
-(void)getDate:(NSMutableArray *)dataArray WithFlag:(int)flag{
    NSLog(@"############%ld",dataArray.count);
    //清空数组
    if (_dayInfoArray.count>0) {
        [_dayInfoArray removeAllObjects];
    }
    if (!_dayInfoArray) {
        _dayInfoArray = [[NSMutableArray alloc] init];
    }
    //移除数组中的参数
    if (_humidArray.count>0) {
        [_humidArray removeAllObjects];
        [_pressArray removeAllObjects];
        [_datedateArray removeAllObjects];
        [_rainArray removeAllObjects];
        [_rain12Array removeAllObjects];
        
        [_dayInfoArray removeAllObjects];
        
        [_snowArray removeAllObjects];
        [_snow12Array removeAllObjects];
        
        [_dateArray removeAllObjects];
        
        [_hourArray removeAllObjects];
        
        [_seaLevelArray removeAllObjects];
        [_waveHeightArray removeAllObjects];
    }
#pragma mark --数据模型判断
    if (flag == 0) {
        //判断选择温度等button 添加几个
        if (_sectionView != nil) {
            for (UIView *view in _sectionView.subviews) {
                [view removeFromSuperview];
            }
        }
        [_sectionView addContentViewWithFlag:flag];
        
        //
        if (!_bgView) {
            _bgView=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 270)];
            _bgView.backgroundColor=[UIColor clearColor];
        }
        
        if (_bgView.subviews.count>0) {
            for (UIView *subView in _bgView.subviews) {
                [subView removeFromSuperview];
            }
        }
        
        UIView *colView1=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320,568/2-50)];
        colView1.backgroundColor=[UIColor colorWithWhite:0 alpha:0.12];
        [_bgView addSubview:colView1];
        
        
        _humidityView=[[HumidityView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
        [_bgView addSubview:_humidityView];
        _snowView=[[SnowView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
        _rainView=[[RainView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
        _pressureView=[[PressView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
        
        
        //获取3天或者15天得数据
        for (DayArrayinfo* dayinfo in dataArray ) {
            
            [_humidArray addObject:dayinfo.RH2m];
            [_pressArray addObject:dayinfo.PSFC];
            [_snowArray addObject:dayinfo.snow];
            [_snow12Array addObject:dayinfo.snow12];
            
            [_rainArray addObject:dayinfo.rain];
            [_rain12Array addObject:dayinfo.rain12];
            
            [_dayInfoArray addObject:dayinfo];
            [_datedateArray addObject:dayinfo.times];
        }
        
#pragma 时间显示修改
        for (int i=0; i<_datedateArray.count; i++) {
            NSString *str=_datedateArray[i];
            NSString *strr=[str substringWithRange:NSMakeRange(4, 4)];
            NSMutableString *timeStr = [NSMutableString stringWithFormat:@"%@",strr];
            [timeStr insertString:@"-" atIndex:2];
            [_dateArray addObject:timeStr];
            //_dateArray 为M-D
            //_datedateArray 为Y-M-D-h-m-s
            
        }
        //hourArray 显示的时间格式为 h:00
        for (NSString *timeStr in _datedateArray) {
            NSString *hourStr = [timeStr substringWithRange:NSMakeRange(8, 2)];
            [_hourArray addObject:[NSString stringWithFormat:@"%@:00",hourStr]];
        }
    }else if (flag != 0){
        if (_sectionView != nil) {
            for (UIView *view in _sectionView.subviews) {
                [view removeFromSuperview];
            }
        }
        [_sectionView addContentViewWithFlag:flag];
        
        if (!_bgView) {
            _bgView=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 270)];
            _bgView.backgroundColor=[UIColor clearColor];
        }

        
        if (_bgView.subviews.count>0) {
            for (UIView *subView in _bgView.subviews) {
                [subView removeFromSuperview];
            }
        }
        
        UIView *colView1=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320,568/2-50)];
        colView1.backgroundColor=[UIColor colorWithWhite:0 alpha:0.12];
        [_bgView addSubview:colView1];
        
        _humidityView=[[HumidityView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
        _snowView=[[SnowView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
        _rainView=[[RainView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
        _pressureView=[[PressView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
        if (flag == 1) {
            _seaLevelView = [[SeaLevelView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
            _waveHeightView = [[WaveHeightView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
            [_bgView addSubview:_waveHeightView];
        }else{
            [_bgView addSubview:_humidityView];
        }
        
        
        
        
        for (WindPlantModel* windPlantModel in dataArray ) {
            
            [_humidArray addObject:windPlantModel.RH2m];
            [_pressArray addObject:windPlantModel.PSFC];
            [_snowArray addObject:windPlantModel.snow];
            [_snow12Array addObject:windPlantModel.snow12];
            
            [_rainArray addObject:windPlantModel.rain];
            [_rain12Array addObject:windPlantModel.rain12];
            
            [_datedateArray addObject:windPlantModel.DataDateTime];
            if (flag == 1) {
                [_seaLevelArray addObject:windPlantModel.SeaLevel];
                [_waveHeightArray addObject:windPlantModel.WaveHeight];
            }
        }
        for (int i=0; i<_datedateArray.count; i++) {
            NSString *str=_datedateArray[i];
            NSString *strr=[str substringWithRange:NSMakeRange(5, 5)];
            [_dateArray addObject:strr];
            //_dateArray 为M-D
            //_datedateArray 为Y-M-D h-m-s
        }
        //hourArray 显示的时间格式为 h:mm
        for (NSString *timeStr in _datedateArray) {
            NSString *hourStr = [timeStr substringWithRange:NSMakeRange(11, 5)];
            [_hourArray addObject:hourStr];
        }
        
        if (flag == 1) {
            [_seaLevelView initWith:_seaLevelArray andDateArray:_dateArray andHourArray:_hourArray];
            [_waveHeightView initWith:_waveHeightArray andDateArray:_dateArray andHourArray:_hourArray];
        }
        
    }
    
    if (_humidArray.count==0) {
        
        UIAlertView *alert2=[[UIAlertView alloc]initWithTitle:@"提示" message:@"该城市没有数据" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert2 show];
    }
    
    [_humidityView initWith:_humidArray andDateArray:_dateArray andHourArray:_hourArray];
    
    [_pressureView initWith:_pressArray andDateArray:_dateArray andHourArray:_hourArray];
    
    [_snowView initWith:_snowArray and:_dateArray andSnow12Array:_snow12Array andHourArray:_hourArray];
    
    [_rainView initWith:_rainArray and:_dateArray andRain12Array:_rain12Array andHourArray:_hourArray];
    if (flag == 1) {
        if (_waveHeightArray.count>0) {
            _sectionView.strValue = _waveHeightArray[0];
            _sectionView.marklabel.text = @"浪高";
            _sectionView.images=[UIImage imageNamed:@"waveheight_ico.png"];
            _sectionView.imageView.frame=AdaptCGRectMake(14, 75,33,33);
            _sectionView.imageView.image=_sectionView.images ;
            _sectionView.percentLabel.text = [NSString stringWithFormat:@"%@m",_waveHeightArray[0]];
            
            NSLog(@"%ld",_bgView.subviews.count);
            
        }else{
            _sectionView.strValue = @"无数据";
        }
    }else{
        if (_humidArray.count>0) {
            NSString *str = @"%";
            _sectionView.strValue= [NSString stringWithFormat:@"%@%@",_humidArray[0],str];
            _sectionView.marklabel.text = @"湿度";
            
             NSLog(@"%ld",_bgView.subviews.count);
        }else{
            _sectionView.strValue=@"无数据";
        }
    }
    [self.mainChartcell getcontent:dataArray WithFlag:flag];
    [self.firstcell setContentFirstrow:dataArray WithFlag:flag];
    
    [_tableView reloadData];
}
//首页背景图片
-(void)addhomebackgroundView{
    
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:self.view.frame];
    [imageview setImage:[UIImage imageNamed:@"background_images1@2x.jpg"]];
    [self.view addSubview:imageview];
}
//添加TableView
-(void)addtableView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIUtils getWindowWidth], [UIUtils getWindowHeight]) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.showsVerticalScrollIndicator =NO;
    [_tableView headerBeginRefreshing];
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight=0;
    //_tableView.bounces=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(refresh)];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeViewhidden)];
    [_tableView addGestureRecognizer:tap];
}

-(void)refresh{
    //
    NSUserDefaults*accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *latitude = [accountDefaults objectForKey:@"latitude"];
    NSString *longitude = [accountDefaults objectForKey:@"longitude"];
//    if (longitude.length>0) {
////        [self loadDateLatitude:latitude andLongitude:longitude];
//        [self loadDataFromWindPlantWithPlantCode:@"" WithFlag:_flag];
//    }else{
//        
//    }
    if (_flag == 0) {
        [self loadDateLatitude:latitude andLongitude:longitude];
    }else{
        [self loadDataFromWindPlantWithPlantCode:_plantCode WithFlag:_flag];
    }
    
    //数据刷新延迟
    [NSThread sleepForTimeInterval:0.1f];
    NSLog(@"数据刷新");
    //(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [_tableView headerEndRefreshing];
    
}

//添加更多时间的选择
-(void)addMoretimeView{
    _moretimeview=[[MoretimeChangeview alloc]initWithFrame:AdaptCGRectMake(30, 0, 260, 120)];
    _moretimeview.layer.cornerRadius=5;
    _moretimeview.backgroundColor=[UIColor colorWithWhite:0.2 alpha:0.7];
    _moretimeview.hidden=YES;
    _moretimeview.delegate=self;
    _moretimeview.center=self.view.center;
    [self.view addSubview:_moretimeview];
}
#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellid=@"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.backgroundColor =[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //每个小时
    
    if (indexPath.section == 0){
        if (indexPath.row==0) {
            if (!_firstcell) {
                [self firstcellrow];
            }
            return _firstcell;
        }
        else if (indexPath.row==1){
            if (!_mainChartcell) {
                [self maincellrow];
            }
            return _mainChartcell;
        }
    }else if (indexPath.section == 1){//返回可点击 数据显示列表
        _midViewcell=(DropdownCell*)[tableView dequeueReusableCellWithIdentifier:nil];
        if (_midViewcell == nil) {
            _midViewcell = [[DropdownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
#warning  修改数据传输    添加海上数据传输
        if (_flag == 0) {//根据风电场不同 添加不同的数据
            [_midViewcell getcontent:_dataArray WithFlag:_flag];
        }else{
            [_midViewcell getcontent:_windPlantArray WithFlag:_flag];
        }
        _midViewcell.selectionStyle=NO;
        _midViewcell.backgroundColor=[UIColor clearColor];
        return _midViewcell;
    }else if (_flag == 1){//当为海上风电场时 多一个section
        if (indexPath.section == 2) {//返回海上安全出行时间
            [self addSeaTravelTimeView];
            [cell addSubview:self.seaTravelView];
            return cell;
        }else if (indexPath.section == 3){//返回温度湿度等
            [cell addSubview:self.bgView];
            return cell;
        }
    }else{//当不是海上风电场时
        if (indexPath.section == 2) {
            [cell addSubview:self.bgView];//只返回温度湿度
            return cell;
        }
    }
    return cell;
}
//湿度，雨，雪，气压视图的背景视图
#pragma mark colview为蒙版
-(UIView*)bgView{
    if (!_bgView) {
        _bgView=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 270)];
        _bgView.backgroundColor=[UIColor clearColor];
//        UIView *colView1=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320,568/2-50)];
//        colView1.backgroundColor=[UIColor colorWithWhite:0 alpha:0.12];
//        [_bgView addSubview:colView1];
//        [_bgView addSubview:_humidityView];
    }
    return _bgView;
}

//第一个cell
-(void)firstcellrow{
    static NSString *firstSectionViewCell=@"firstSectionViewCell";
    _firstcell = [[FirstSectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstSectionViewCell];
    _firstcell.selectionStyle=NO;
    _firstcell.delegate=self;
    _firstcell.backgroundColor=[UIColor clearColor];
}
//双曲线cell
-(MainChartViewCell*)mainChartcell{
    
    if (!_mainChartcell) {
        [self maincellrow];
    }
    return _mainChartcell;
}
//双曲线所在的cell
-(void)maincellrow{
    static NSString *mainChartViewCell=@"mainChartViewCell";
    
    _mainChartcell = [[MainChartViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainChartViewCell];
    _mainChartcell.selectionStyle=NO;
    _mainChartcell.backgroundColor=[UIColor colorWithWhite:0 alpha:0.12];
    
}

//添加海上出行时间view
-(void)addSeaTravelTimeView{
    if (self.seaTravelView == nil) {
        self.seaTravelView = [[SeaTarvelView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        UIView *colView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.seaTravelView.frame.size.width,self.seaTravelView.frame.size.height)];
        colView1.backgroundColor=[UIColor colorWithWhite:0 alpha:0.12];
        [self.seaTravelView addSubview:colView1];
    }
}


//添加最后表示图
-(void)addlastrowChartView{
//    _humidityView=[[HumidityView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
//    [_bgView addSubview:_humidityView];
//    _snowView=[[SnowView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
//    _rainView=[[RainView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
//    _pressureView=[[PressView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
//    
//#warning 需优化
//    _seaLevelView = [[SeaLevelView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
//    _waveHeightView = [[WaveHeightView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 410)];
//    
    
}
//section的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_flag == 1) {
        return 4;
    }else{
        return 3;
    }
    
}
//每一个Section中的cell数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }
    
    
    if (_flag == 1) {
        if (section== 2) {
            return 1;
        }
        if (section == 3) {
            return 1;
        }
    }else{
        if (section == 2) {
            return 1;
        }
    }
    
    
    
    if (section==1) {
        if (isresponse==NO)
        {
            return 1;
            isresponse=YES;
        }
    }else{
        return 0;
        isresponse=NO;
    }
    
    return 0;
}
#pragma mark UITableViewDelegate
//section的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    } if (section==1) {
        return [UIUtils getWindowHeight]/142*11;
    }else if (_flag == 1){
        if(section == 2){
            return 0;
        }else{
            return [UIUtils getWindowHeight]/10*3-30*[UIUtils getWindowHeight]/568;
        }
    }else{
        return [UIUtils getWindowHeight]/10*3-30*[UIUtils getWindowHeight]/568;
    }
}
//对应cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return [UIUtils getWindowHeight]/2-50;
    }else if (indexPath.section==1){
        return [UIUtils getWindowHeight]/3.341;
    }else if (_flag == 1){
        if(indexPath.section == 2){
            return 200;
        }else{
            return [UIUtils getWindowHeight]/2+30*[UIUtils getWindowHeight]/568;
        }
    }else{
        return [UIUtils getWindowHeight]/2+30*[UIUtils getWindowHeight]/568;
    }
}
//Section
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc] init];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    if (section==1)
    {
        return self.firstSectionview;
    }
    else if (_flag == 1){
        if (section== 3){
            return  self.sectionView;
        }
    }else if (section==2){
        return  self.sectionView;
    }
    return sectionView;
}
//tableView的第一
-(FirstSectionView*)firstSectionview{
    if(!_firstSectionview) {
        _firstSectionview=[[FirstSectionView alloc]init];
        _firstSectionview.delegate=self;
    }
    return _firstSectionview;
}
//降雨量，降雪，气压，湿度的承接View
-(LastSectionView*)threeView{
    if (!_threeView) {
        _threeView=[[LastSectionView alloc]initWithFrame:AdaptCGRectMake(0, 568/2-50,320,50)];
        _threeView.backgroundColor=[UIColor clearColor];
    }
    return _threeView;
}
//隐藏时间选择按钮
-(void)addmoretime{
    _moretimeview.hidden=NO;
}
#pragma mark 按钮方法
//更多时间
-(void)clickBtn:(UIButton*)sender{
    //[[BaiduMobStat defaultStat] logEvent:@"event" eventLabel:@"move"];
    //1小时
    if (sender.tag==0) {
        frep = @"1";
        [self refresh];
    }else if (sender.tag==1) {
        //3小时
        frep = @"3";
        [self refresh];
    }else if (sender.tag==2) {
        // 6小时
        frep = @"6";
        [self refresh];
    }else if (sender.tag==3) {
        //12小时
        frep = @"12";
        [self refresh];
    }
    _moretimeview.hidden=YES;
}
//按钮Midcell方法
-(void)doButton
{
    if (isresponse)
    {
        isresponse=NO;
        
    }
    else
    {
        isresponse=YES;
    }
    [_tableView reloadData];
}
//预警信息界面
-(void)warning{
    WarninfoViewController *addCityController =[[WarninfoViewController alloc]init];
    addCityController.modalTransitionStyle=2;
    UINavigationController *nav2 =[[UINavigationController alloc]initWithRootViewController:addCityController];
    [self presentViewController:nav2 animated:YES completion:nil];
    
}
//用来进行天气信息的切换
-(void)changed:(UIButton *)button{
    for(UIView *view in [_bgView subviews])
    {
        [view removeFromSuperview];
    }
    NSString *str1;
    NSString *str11;
    NSString *strrsonw=@"mm/h";
    NSString *strrsonw1=@"mm/12h";
    UIView *colView=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320,568/2-50)];
    switch (button.tag) {
            case 0:
            _sectionView.marklabel.text = @"浪高";
            str1=@"m";
            if (_waveHeightView.array.count>0) {
                
                str11=[NSString stringWithFormat:@"%@%@",_waveHeightView.array[0],str1];
                _sectionView.percentLabel.text=str11;
            }else{
                _sectionView.percentLabel.text=@"无数据";
            }
            _sectionView.images=[UIImage imageNamed:@"waveheight_ico.png"];
            _sectionView.imageView.frame=AdaptCGRectMake(14, 75,33,33);
            _sectionView.percentLabel.frame= AdaptCGRectMake(CGRectGetMaxX(_sectionView.imageView.frame)+10, 63,150, 70);
            _sectionView.imageView.image=_sectionView.images ;
            colView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.12];
            [_bgView addSubview:colView];
            [_bgView addSubview:_waveHeightView];
            break;
            case 1:
            _sectionView.marklabel.text = @"潮位";
            str1=@"cm";
            if (_seaLevelView.array.count>0) {
                
                str11=[NSString stringWithFormat:@"%@%@",_seaLevelView.array[0],str1];
                _sectionView.percentLabel.text=str11;
            }else{
                _sectionView.percentLabel.text=@"无数据";
            }
            _sectionView.images=[UIImage imageNamed:@"sealevel_ico.png"];
            _sectionView.imageView.frame=AdaptCGRectMake(12, 83,33,33);
            _sectionView.percentLabel.frame= AdaptCGRectMake(CGRectGetMaxX(_sectionView.imageView.frame)+10, 63,150, 70);
            _sectionView.imageView.image=_sectionView.images ;
            colView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.12];
            [_bgView addSubview:colView];
            [_bgView addSubview:_seaLevelView];
            break;
            //湿度
        case 2:
            _sectionView.marklabel.text=@"湿度";
            str1=@"%";
            if (_humidityView.array.count>0) {
                
                str11=[NSString stringWithFormat:@"%@%@",_humidityView.array[0],str1];
                _sectionView.percentLabel.text=str11;
            }else{
                _sectionView.percentLabel.text=@"无数据";
            }
            _sectionView.images=[UIImage imageNamed:@"water@2x"];
            _sectionView.imageView.frame=AdaptCGRectMake(12, 83,_sectionView.images.size.width,_sectionView.images.size.height);
            _sectionView.percentLabel.frame= AdaptCGRectMake(CGRectGetMaxX(_sectionView.imageView.frame)+10, 63,150, 70);
            _sectionView.imageView.image=_sectionView.images ;
            colView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.12];
            [_bgView addSubview:colView];
            [_bgView addSubview:_humidityView];
            break;
            //降雪量
        case 3:
            _sectionView.marklabel.text=@"降雪量";
            if (_snowArray.count>0) {
                str11=[NSString stringWithFormat:@"%@%@\n%@%@",_snowArray[0],strrsonw,_snowArray[12],strrsonw1];
                
            }else{
                str11=[NSString stringWithFormat:@"无数据%@\n无数据%@",strrsonw,strrsonw1];
            }
            _sectionView.percentLabel.text=str11;
            _sectionView.images=[UIImage imageNamed:@"snow@2x"];
            _sectionView.imageView.frame=AdaptCGRectMake(12, 83,_sectionView.images.size.width,_sectionView.images.size.height);
            _sectionView.percentLabel.frame= AdaptCGRectMake(CGRectGetMaxX(_sectionView.imageView.frame)+10, 63,150, 70);
            _sectionView.imageView.image=_sectionView.images ;
            colView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.12];
            [_bgView addSubview:colView];
            [_snowView addSubview:self.threeView];
            [_bgView addSubview:_snowView];
            
            break;
            //降雨量
        case 4:
            _sectionView.marklabel.text=@"降雨量";
            if (_rainArray.count>0) {
                str11=[NSString stringWithFormat:@"%@%@\n%@%@",_rainArray[0],strrsonw,_rainArray[12],strrsonw1];
                
            }else{
                str11=[NSString stringWithFormat:@"无数据%@\n无数据%@",strrsonw,strrsonw1];
                
            }
            _sectionView.percentLabel.text=str11;
            
            _sectionView.images=[UIImage imageNamed:@"rainfall@2x"];
            _sectionView.imageView.frame=AdaptCGRectMake(12, 83,_sectionView.images.size.width,_sectionView.images.size.height);
            _sectionView.percentLabel.frame= AdaptCGRectMake(CGRectGetMaxX(_sectionView.imageView.frame)+10, 63,150, 70);
            _sectionView.imageView.image=_sectionView.images;
            [_rainView addSubview:self.threeView];
            colView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.12];
            [_bgView addSubview:colView];
            [_bgView addSubview:_rainView];
            
            break;
            //气压
        case 5:
            _sectionView.marklabel.text=@"气压";
            str1=@"hPa";
            if (_pressArray.count>0) {
                str11=[NSString stringWithFormat:@"%@%@",_pressArray[0],str1];
                
            }else{
                str11=[NSString stringWithFormat:@"无数据%@",str1];
                
            }
            _sectionView.percentLabel.text= str11;
            _sectionView.images=[UIImage imageNamed:@"temperature@2x"];
            _sectionView.percentLabel.frame= AdaptCGRectMake(CGRectGetMaxX(_sectionView.imageView.frame)+8, 63,150, 70);
            _sectionView.imageView.frame=AdaptCGRectMake(12, 83,_sectionView.images.size.width,_sectionView.images.size.height);
            _sectionView.imageView.image=_sectionView.images;
            colView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.12];
            [_bgView addSubview:colView];
            [_bgView addSubview:_pressureView];
            break;
        default:
            break;
    }
    //按钮的动态效果
    if (!button.selected) {
        [UIView animateWithDuration:0.2 animations:^{
            button.transform =CGAffineTransformScale(button.transform, 0.7, 0.7);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                button.transform =CGAffineTransformScale(button.transform, 1/0.6, 1/0.6);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    button.transform =CGAffineTransformScale(button.transform, 1/0.7*0.6, 1/0.7*0.6);
                }];
            }];
        }];
    }
    //实现按钮响应状态
    for (UIButton *temp in _sectionView.buttons) {
        if (temp.selected && temp !=button) {
            temp.selected =NO;
        }
    }
    button.selected =YES;
}
#pragma WarninfoViewdelegate
-(void)warninfoViewdelegate{
    [self warning];
}
-(void)timeViewhidden{
    _moretimeview.hidden=YES;
}
#pragma Moretimeviewdelegate
-(void)moretime:(UIButton *)sender{
    [self clickBtn:sender];
}
#pragma mark FirstsectionViewDelegate
-(void)firseSectiondelegate{
    [self doButton];
}
#pragma mark SecondsectionViewDelegate
-(void)secondSection:(UIButton *)sender{
    [self changed:sender];
}
- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *str=[defaults objectForKey:@"latitude"];
    if(str.length>0){
        [defaults removeObjectForKey:@"latitude"];
        [defaults removeObjectForKey:@"longitude"];
    }
#pragma mark ----注册通知
    //左侧通知的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCityFromLeftViewAndOther:) name:@"addcityfromleftview" object:@"leftcity"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCityFromBMK:) name:@"definecityfrommap" object:nil];
    
    //滚动到三天时的登录判断观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sayHi:) name:@"log" object:nil];
}
//释放移除
-(void)viewDidDisappear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"definecityfrommap" object:nil];
    
    //移除到三天时的登录判断观察者
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"log" object:nil];
    //左侧通知的观察者
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"addcityfromleftview" object:@"leftcity"];
    if (titleAndCodeArray.count>0) {
        titleAndCodeArray =nil;
    }
    //地图定位代理取消
    self.locationSevice.delegate=nil;
    self.getCodeSearch.delegate=nil;
    
}



#pragma mark - UITableView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //取消向上滑动到达底部橡皮筋效果
    float offset = _tableView.contentOffset.y;
    
    if (offset >435) {
        _tableView.bounces=NO;
    }else{
        _tableView.bounces=YES;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//加载数据
-(void)loadDateLatitude:(NSString*)latitude andLongitude:(NSString *)longitude{
    
    _flag = 0;
    
    _defaultsloc = [NSUserDefaults standardUserDefaults];
    [_defaultsloc removeObjectForKey:@"flag"];
    NSString *loadStr = [NSString stringWithFormat:@"%d_%@_%@_0",_flag,latitude,longitude];
    [_defaultsloc setObject:loadStr forKey:@"flag"];
    
    NSLog(@"%@~~~%@",latitude,longitude);
    _cityCodedefault = [NSUserDefaults standardUserDefaults];
    [_cityCodedefault setObject:latitude forKey:@"latitude"];
    [_cityCodedefault setObject:longitude forKey:@"longitude"];
    
    
//    NSDate*todayDate = [NSDate date];
//    NSDateFormatter  * newFormatter2 = [[NSDateFormatter alloc] init];
//    //设置时间显示格式
//    [newFormatter2 setDateFormat:@"YYYY-MM-dd"];
//    _currentTime=[newFormatter2 stringFromDate:todayDate];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"h"];
    frep = [frep stringByTrimmingCharactersInSet:set];
    frep = [NSString stringWithFormat:@"%@h",frep];
    //显示提示
    _HUD=[MBProgressHUD show:MBProgressHUDModeIndeterminate message:@"加载中..." customView:self.view];
    NSString *urlStr1=@"http://54.223.190.36:8092/api/LatLonWeather/";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/%@",urlStr1,latitude,longitude,frep];
    
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSLog(@"%@",urlStr);
    self.manager = [AFHTTPRequestOperationManager manager];
    
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if (_dataArray.count > 0) {
            [_dataArray removeAllObjects];
        }
        NSArray *rootArray = responseObject;
        for (NSDictionary *dict in rootArray) {
            DayArrayinfo *daymodel = [DayArrayinfo objectWithKeyValues:dict];
            [_dataArray addObject:[daymodel setDataForNeed:daymodel]];
        }
        
        [self getDate:_dataArray WithFlag:_flag];
        
        //隐藏HUD
        
        [_tableView reloadData];
        [_HUD hide:YES afterDelay:0.3f];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [_HUD hide:YES afterDelay:0.0f];
        alert1=[[UIAlertView alloc]initWithTitle:nil message:@"请检查当前网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert1 show];
        NSTimer *timer;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doTime) userInfo:nil repeats:NO];
    }];
    
}

#pragma mark --风电场数据获取
-(void)loadDataFromWindPlantWithPlantCode:(NSString *)plantCode WithFlag:(int)flag{
    _flag = flag;
    _plantCode = plantCode;
    _defaultsloc = [NSUserDefaults standardUserDefaults];
    [_defaultsloc removeObjectForKey:@"flag"];
    NSString *loadStr = [NSString stringWithFormat:@"%d_0_0_%@",_flag,_WfId];
    [_defaultsloc setObject:loadStr forKey:@"flag"];
    
    //显示提示
    _HUD=[MBProgressHUD show:MBProgressHUDModeIndeterminate message:@"加载海上风电场中..." customView:self.view];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"h"];
    frep = [frep stringByTrimmingCharactersInSet:set];
    if (flag == 1) {
        NSString *loadWindStr = [NSString stringWithFormat:@"http://54.223.190.36:8092/api/PublicWeather/%@/%@/3/%@",plantCode,_currentTime,frep];
        _loadWindPlant = loadWindStr;
    }else{
        NSString *loadWindStr = [NSString stringWithFormat:@"http://54.223.190.36:8092/api/PublicWeather/%@/%@/3/%@/Land",plantCode,_currentTime,frep];
        _loadWindPlant = loadWindStr;
    }
    
    self.manager = [AFHTTPRequestOperationManager manager];
    [self.manager GET:_loadWindPlant parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_windPlantArray.count > 0) {
            [_windPlantArray removeAllObjects];
        }
        NSMutableArray *rootArray = responseObject;
        for (NSDictionary *dict in rootArray) {
            WindPlantModel  *windPlantModel = [WindPlantModel objectWithKeyValues:dict];
            [_windPlantArray addObject:[windPlantModel setWindPlantDataForNeed:windPlantModel]];
        }
        [self getDate:_windPlantArray WithFlag:_flag];
        [_tableView reloadData];
        [_HUD hide:YES afterDelay:0.3f];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES afterDelay:0.0f];
        alert1=[[UIAlertView alloc]initWithTitle:nil message:@"请检查当前网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert1 show];
        NSTimer *timer;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doTime) userInfo:nil repeats:NO];
        
    }];
}



//延时提醒
-(void)doTime
{
    //alert过1秒自动消失
    [alert1 dismissWithClickedButtonIndex:0 animated:NO];
    
}
@end
