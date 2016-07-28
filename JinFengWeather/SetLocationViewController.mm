//
//  SetLocationViewController.m
//  JinFengWeather
//
//  Created by huake on 15/9/21.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//


#import "SetLocationViewController.h"
#import "Header.h"
#import "UIUtils.h"
#import <BaiduMapAPI/BMapKit.h>
#import "PromptInfo.h"
#import "HKalertView.h"
#import "ChangealertView.h"
#import "AddanchorView.h"
#import "LeftViewController.h"
#import "Cityweatherinfo.h"
#import "SideBarMenuViewController.h"
#import "HomeViewController.h"
#define INDEX_TAG_DIS   1000

@interface MyFavoriteAnnotation : BMKPointAnnotation

@property (nonatomic, assign) NSInteger favIndex;
/**
 *  收藏点信息类
 */
@property (nonatomic, strong) BMKFavPoiInfo *favPoiInfo;

@end
@implementation MyFavoriteAnnotation

@synthesize favIndex = _favIndex;
@synthesize favPoiInfo = _favPoiInfo;

@end

@interface SetLocationViewController ()<BMKGeneralDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,HKalertViewdelegate,AddanchorViewdelegate>{
    /**
     *  收藏点管理类
     */
    BMKFavPoiManager *_favManager;
    CLLocationCoordinate2D _coor;
    NSMutableArray *_favPoiInfos;
    NSInteger _curFavIndex;
    /**
     *  点击按钮添加锚点类
     */
    AddanchorView*_addDefineCity;
    /**
     *  长按手势添加按钮类
     */
    HKalertView *_addTapView;
    /**
     *  修改锚点类
     */
    ChangealertView*_updateView;
    UITextField*_leftCityTF;
    UITextField*_rightCityTF;
    /**
     *  主引擎类
     */
    BMKMapManager *manger;
    LeftViewController *leftViewController;
    SideBarMenuViewController *_sideBarMenuVC;
    HomeViewController *viewController;
    
    Cityweatherinfo *_cityWeatherinfo;
    
    NSDictionary *defineDic;
    UIView*_bgview;
    UIAlertView *alert;
    
}
@property(nonatomic,strong)BMKMapView*mapView;
//声明定位服务对象（负责定位）
@property(nonatomic,strong)BMKLocationService *locationSevice;
@property(nonatomic,strong)NSString*citycode;
@end

@implementation SetLocationViewController
//-(void)dealloc{
//    
//    _mapView=nil;
//    _favManager = nil;
//    self.locationSevice.delegate=nil
//    ;
//    _mapView.delegate = nil;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制位置";
    _bgview =[[UIView alloc]initWithFrame:self.view.frame];
    _bgview.backgroundColor=[UIColor colorWithWhite:0 alpha:0.4];;
    [self setnavigationbar];
    _addDefineCity=[[AddanchorView alloc]initWithFrame:CGRectMake(35.0*[UIUtils getWindowWidth]/320, 90.0*[UIUtils getWindowHeight]/568,250.0*[UIUtils getWindowWidth]/320,280.0*[UIUtils getWindowHeight]/568)];
    _addDefineCity.layer.shadowColor=[UIColor grayColor].CGColor;
    _addDefineCity.layer.shadowOffset=CGSizeMake(1, 1);
    
    _addDefineCity.layer.cornerRadius=8;
    _addDefineCity.delegate=self;
    
    _addTapView=[[HKalertView alloc]initWithFrame:CGRectMake(35.0*[UIUtils getWindowWidth]/320, 100.0*[UIUtils getWindowHeight]/568, 250.0*[UIUtils getWindowWidth]/320,180.0*[UIUtils getWindowHeight]/568)];
    _addTapView.layer.cornerRadius=8;
    _addTapView.layer.shadowColor=[UIColor grayColor].CGColor;
    _addTapView.layer.shadowOffset=CGSizeMake(1, 1);
    self.view.backgroundColor=[UIColor whiteColor];
    //百度地图起动主引擎类（必须启动）
    //因为百度的搜索引擎使用c++所以工程中至少有一个.mm后缀
    manger=[[BMKMapManager alloc]init];
    //启动引擎
    [manger start:@"0swB9YTsIV9wGHAGt4ZP2kut" generalDelegate:self];
    //搭建UI
    [self addUISubView];
    //查看全部
    [self hiddenKeyBoard];
    NSArray *favPois = [_favManager getAllFavPois];
    if (favPois == nil) {
        return;
    }
    [_favPoiInfos removeAllObjects];
    [_favPoiInfos addObjectsFromArray:favPois];
    [self updateMapAnnotations];
    
}
//设置navigationBar
-(void)setnavigationbar{
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:41/255.0 green:147/255.0 blue:209/255.0 alpha:1.0];
    //设置navigationBar的属性
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17]
                                                                      }];
    //返回按钮2
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"goback@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(BackPreviousPage)];
    //设置按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem= backItem;
    
}


//搭建UI
-(void)addUISubView{
    //1.添加地图
    self.mapView=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 64.0, self.view.frame.size.width, self.view.frame.size.height-150.0*[UIUtils getWindowHeight]/568)];
    //设置当前类为mapView的代理对象
    self.mapView.showMapScaleBar = YES;
    self.mapView.delegate = self;
    //自定义比例尺的位置
    self.mapView.mapScaleBarPosition = CGPointMake(10.0*[UIUtils getWindowWidth]/320, _mapView.frame.size.height - 50.0*[UIUtils getWindowHeight]/568);
    [self.view addSubview:self.mapView];
    // 地图界面下的视图
    UIView *mapbottomview=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mapView.frame),self.view.frame.size.width , 150.0*[UIUtils getWindowHeight]/568)];
    mapbottomview.backgroundColor=[UIColor whiteColor];
    UILabel *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(25.0*[UIUtils getWindowWidth]/320,10.0*[UIUtils getWindowHeight]/568,40.0*[UIUtils getWindowWidth]/320,30.0*[UIUtils getWindowHeight]/568)];
    leftLabel.backgroundColor=[UIColor whiteColor];
    leftLabel.text=@"经度:";
    leftLabel.font=[UIFont systemFontOfSize:12];
    [mapbottomview addSubview:leftLabel];
    //设置导航控制器的BarButton
    _leftCityTF=[[UITextField alloc]initWithFrame:CGRectMake(60.0*[UIUtils getWindowWidth]/320, 10.0*[UIUtils getWindowHeight]/568,90.0*[UIUtils getWindowWidth]/320, 25.0*[UIUtils getWindowHeight]/568)];
    _leftCityTF.adjustsFontSizeToFitWidth=YES;
    
    _leftCityTF.font=[UIFont systemFontOfSize:12];
    _leftCityTF.layer.borderColor=[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:202/255.0].CGColor;
    _leftCityTF.userInteractionEnabled=NO;
    _leftCityTF.layer.borderWidth=0.5;
    UILabel *rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(170.0*[UIUtils getWindowWidth]/320,10.0*[UIUtils getWindowHeight]/568,40.0*[UIUtils getWindowWidth]/320,30.0*[UIUtils getWindowHeight]/568)];
    rightLabel.backgroundColor=[UIColor whiteColor];
    rightLabel.text=@"纬度:";
    rightLabel.font=[UIFont systemFontOfSize:12];
    [mapbottomview addSubview:rightLabel];
    _rightCityTF=[[UITextField alloc]initWithFrame:CGRectMake(200.0*[UIUtils getWindowWidth]/320, 10.0*[UIUtils getWindowHeight]/568,90.0*[UIUtils getWindowWidth]/320  , 25.0*[UIUtils getWindowHeight]/568)];
    
    _rightCityTF.layer.borderColor=[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:202/255.0].CGColor;
    _rightCityTF.userInteractionEnabled=NO;
    _rightCityTF.layer.borderWidth=0.5;
    _rightCityTF.adjustsFontSizeToFitWidth=YES;
    _rightCityTF.font=[UIFont systemFontOfSize:12];
    //底视图添加锚点按钮
    UIButton *botbtb=[UIButton buttonWithType:UIButtonTypeCustom];
    botbtb.frame=CGRectMake(15.0*[UIUtils getWindowWidth]/320, 45.0*[UIUtils getWindowHeight]/568, self.view.frame.size.width-30.0*[UIUtils getWindowWidth]/320,35.0*[UIUtils getWindowHeight]/568);
    botbtb.backgroundColor=[UIColor colorWithRed:41/255.0 green:147/255.0 blue:209/255.0 alpha:1.0];
    [botbtb setTitle:@"根据经纬度添加锚点" forState:UIControlStateNormal];
    botbtb.layer.cornerRadius=2;
    botbtb.titleLabel.font=[UIFont systemFontOfSize:14];
    [botbtb addTarget:self action:@selector(addVeiw) forControlEvents:UIControlEventTouchUpInside];
    botbtb.titleLabel.textAlignment=NSTextAlignmentCenter;
    [mapbottomview addSubview:botbtb];
    [mapbottomview addSubview:_leftCityTF];
    [mapbottomview addSubview:_rightCityTF];
    [self.view addSubview:mapbottomview];
    //定位
    self.locationSevice = [[BMKLocationService alloc]init];
    self.locationSevice.delegate=self;
    //1.开启地位服务
    [self.locationSevice startUserLocationService];
    //2.在地图上显示用户位置
    //self.mapView.showsUserLocation=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
    tap.cancelsTouchesInView = NO;//添加自定义手势时，需设置，否则影响地图的操作
    tap.delaysTouchesEnded = NO;//添加自定义手势时，需设置，否则影响地图的操作
    [self.view addGestureRecognizer:tap];
    //修改已经添加的锚点
    _updateView=[[ChangealertView alloc]initWithFrame:CGRectMake(35.0*[UIUtils getWindowWidth]/320, 100.0*[UIUtils getWindowHeight]/568, 250.0*[UIUtils getWindowWidth]/320,180.0*[UIUtils getWindowHeight]/568)];
    _updateView.layer.cornerRadius=8;
    _updateView.delegate=self;
    _updateView.layer.shadowColor=[UIColor grayColor].CGColor;
    _updateView.layer.shadowOffset=CGSizeMake(1, 1);
    _favManager = [[BMKFavPoiManager alloc] init];
    _favPoiInfos = [NSMutableArray array];
    
    
}
//地图底视图按钮添加锚点的方法
-(void)addVeiw{
    _addDefineCity.leftCityTF1.text = _leftCityTF.text;
    _addDefineCity.rightCityTF1.text = _rightCityTF.text;
    
    [_addTapView removeFromSuperview];
    [self.view addSubview:_bgview];
    [_bgview addSubview:_addDefineCity];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_addTapView removeFromSuperview];
    [_addDefineCity removeFromSuperview];
    [_updateView removeFromSuperview];
    
    [_mapView viewWillDisappear];
    
    self.mapView.delegate = nil;
    if (self.locationSevice) {
        [self.locationSevice stopUserLocationService];
        self.locationSevice.delegate = nil;
    }
    _mapView=nil;
    _favManager = nil;
}


/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
   // NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 //处理方向变更信息
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
   // NSLog(@"heading is %@",userLocation.heading);
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView updateLocationData:userLocation];
}


/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
  //  NSLog(@"stop locate");
}
/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
  //  NSLog(@"location error");
}

/****************************************/
///保存更新
- (void)updateSaveAction:(id)sender {
    if (_updateView.endAdressTF.text.length == 0) {
        [PromptInfo showText:@"请输入名称"];
        return;
    }
    BMKFavPoiInfo *favInfo = [_favPoiInfos objectAtIndex:_curFavIndex];
    float a=[_updateView.leftCityTF.text floatValue];
    float b=[_updateView.rightCityTF.text floatValue];
    if (b<=a) {
        NSString*limitStr2=[NSString stringWithFormat:@"%@-%@",_updateView.leftCityTF.text,_updateView.rightCityTF.text];
        favInfo.cityName=limitStr2;
    }else{
        [PromptInfo showText:@"输入的上限数据不能小于下限"];
        return;
        
    }

    favInfo.poiName = _updateView.endAdressTF.text;
    BOOL res = [_favManager updateFavPoi:favInfo.favId favPoiInfo:favInfo];
    if (res) {
        [PromptInfo showText:@"修改成功"];
        [self cancelUpdateView];
        [self updateMapAnnotations];
    } else {
        [PromptInfo showText:@"修改失败"];
    }
    
    
}
//修改取消
- (void)updateCancelAction:(id)sender {
    [self cancelUpdateView];
}
///取消显示更新view
- (void)cancelUpdateView {
    
    [_updateView.endAdressTF resignFirstResponder];
    _updateView.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)hiddenKeyBoard {
    for (UIView*view in [self.view subviews]) {
        [view endEditing:YES];
    }
    
}
#pragma mark - BMKMapViewDelegate
/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    _coor = coordinate;
#pragma mark ----点击获取经纬度
    _leftCityTF.text=[NSString stringWithFormat:@"%lf", coordinate.longitude];
    _rightCityTF.text=[NSString stringWithFormat:@"%lf", coordinate.latitude];
    
    _addDefineCity.leftCityTF1.text = _leftCityTF.text;
    _addDefineCity.rightCityTF1.text = _rightCityTF.text;
    
    [self hiddenKeyBoard];
}

///更新地图标注
- (void)updateMapAnnotations {
    [_mapView removeAnnotations:_mapView.annotations];
    NSInteger index = 0;
    NSMutableArray *annos = [NSMutableArray array];
    for (BMKFavPoiInfo *info in _favPoiInfos) {
        MyFavoriteAnnotation *favAnnotation = [[MyFavoriteAnnotation alloc] init];
        favAnnotation.title = info.poiName;
        favAnnotation.coordinate = info.pt;
        favAnnotation.favPoiInfo = info;
        favAnnotation.favIndex = index;
        
        [annos addObject:favAnnotation];
        index++;
    }
    [_mapView addAnnotations:annos];
    [_mapView showAnnotations:annos animated:YES];
}
/**
 *双击地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回双击处坐标点的经纬度
 */
-(void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi {
    [self hiddenKeyBoard];
}
/**
 *长按地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回长按事件坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate {
  //  NSLog(@"-----------%f",coordinate.longitude);
    _addTapView.leftCityTF.text=@"";
    _addTapView.rightCityTF.text=@"";
    _addTapView.startAdressTF.text=@"";
#pragma mark ----长按弹出添加对话框
    _addTapView.delegate=self;
    [self.view addSubview:_bgview];
    [_bgview addSubview:_addTapView];
    _coor = coordinate;
    _leftCityTF.text=[NSString stringWithFormat:@"%lf", coordinate.longitude];
    _rightCityTF.text=[NSString stringWithFormat:@"%lf", coordinate.latitude];
    
}
// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"FavPoiMark"];
    // 设置颜色
    annotationView.pinColor = BMKPinAnnotationColorPurple;
    // 从天上掉下效果
    annotationView.animatesDrop = NO;
    // 设置可拖拽
    annotationView.draggable = YES;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    annotationView.annotation = annotation;
    // 设置位置
    
    MyFavoriteAnnotation *myAnotation = (MyFavoriteAnnotation *)annotation;
    ///添加更新按钮
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    updateButton.frame = CGRectMake(10, 0, 32, 41);
    [updateButton setTitle:@"详细" forState:UIControlStateNormal];
    [updateButton addTarget:self action:@selector(updateAction:) forControlEvents:UIControlEventTouchUpInside];
    updateButton.tag = myAnotation.favIndex + INDEX_TAG_DIS;
  
    annotationView.leftCalloutAccessoryView.frame=CGRectMake(0, 100, 100, 100);
    ///添加删除按钮
    UIButton *delButton = [UIButton buttonWithType:UIButtonTypeSystem];
    delButton.frame = CGRectMake(10, 0, 32, 41);
    [delButton setTitle:@"删除" forState:UIControlStateNormal];
    [delButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
      annotationView.leftCalloutAccessoryView = delButton;
    delButton.tag = myAnotation.favIndex + INDEX_TAG_DIS;
    annotationView.rightCalloutAccessoryView = updateButton;
    
    return annotationView;
}

///点击paopao更新按钮
- (void)updateAction:(id)sender {
    
    [self.view addSubview:_bgview];
    [_bgview addSubview:_updateView];
    
    UIButton *button = (UIButton*)sender;
    _curFavIndex = button.tag - INDEX_TAG_DIS;
    if (_curFavIndex < _favPoiInfos.count) {
        BMKFavPoiInfo *favInfo = [_favPoiInfos objectAtIndex:_curFavIndex];
        _updateView.endAdressTF.text = favInfo.poiName;
        NSArray *array=[favInfo.cityName componentsSeparatedByString:@"-"];
        _updateView.leftCityTF.text=array[0];
        _updateView.rightCityTF.text=array[1];
        [_updateView.endAdressTF becomeFirstResponder];
        _updateView.hidden = NO;
    }
}
///点击paopao删除按钮
- (void)deleteAction:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSInteger favIndex = button.tag - INDEX_TAG_DIS;
    if (favIndex < _favPoiInfos.count) {
        BMKFavPoiInfo *favInfo = [_favPoiInfos objectAtIndex:favIndex];
        if ([_favManager deleteFavPoi:favInfo.favId]) {
            [_favPoiInfos removeObjectAtIndex:favIndex];
            [self updateMapAnnotations];
            [PromptInfo showText:@"删除成功"];
            
#pragma ----删除成功后,删除相应的数据
            defineDic = nil;
            
            return;
        }
    }
    [PromptInfo showText:@"删除失败"];
}
#pragma mark HKdelegate
- (void)cancelviewdelegate{
    [_bgview removeFromSuperview];
    [self cancelview];
}
- (void)saveActiondelegate{
    [_bgview removeFromSuperview];
    [self saveAction];
}
#pragma mark Changedelegate
- (void)cancelChangeviewdelegate{
    [_bgview removeFromSuperview];
    [self updateCancelAction];
    
}
- (void)saveActionChangedelegate{
    [_bgview removeFromSuperview];
    [self updateSaveAction];
    
}
#pragma mark AddanchorViewdelegate
- (void)cancelanchorviewdelegate{
    [_bgview removeFromSuperview];
    [self cancelanchorview];
}
- (void)saveanchorActiondelegate{
    [_bgview removeFromSuperview];
    [self saveanchorAction];
}
///取消显示更新_addDefineCity
- (void)cancelanchorview {
    [_addDefineCity removeFromSuperview];
    [_bgview removeFromSuperview];
}

#pragma mark  -----自定义经纬度添加
- (void)saveanchorAction{
    [self hiddenKeyBoard];
    [_addTapView removeFromSuperview];
    [_addDefineCity removeFromSuperview];
    CGFloat lat = [_addDefineCity.leftCityTF1.text doubleValue];
    CGFloat longi = [_addDefineCity.rightCityTF1.text doubleValue];
    
    if (_addDefineCity.startAdressTF1.text.length == 0) {
        [PromptInfo showText:@"请输入名字"];
        return;
    }
    if (lat == 0 && longi == 0) {
        [PromptInfo showText:@"请获取经纬度"];
        return;
    }
    BMKFavPoiInfo *poiInfo = [[BMKFavPoiInfo alloc] init];
    
    _coor.latitude = lat;
    _coor.longitude = longi;
    
    poiInfo.pt = _coor;
    if (_addDefineCity.leftCityTF.text.length!=0&&_addDefineCity.rightCityTF.text.length!=0) {
        float a=[_addDefineCity.leftCityTF.text floatValue];
        float b=[_addDefineCity.rightCityTF.text floatValue];
        if (b<=a) {
#pragma mark 经纬度 赋给城市名？？
            NSString*limitStr2=[NSString stringWithFormat:@"%@-%@",_addDefineCity.leftCityTF.text,_addDefineCity.rightCityTF.text];
            poiInfo.cityName=limitStr2;
        }else{
            [PromptInfo showText:@"输入的上限数据不能小于下限"];
            return;
         
        }
    }
    //输入地址名 赋值给poi名称
    poiInfo.poiName = _addDefineCity.startAdressTF1.text;
    NSArray *favPois = [_favManager getAllFavPois];
    if (favPois == nil) {
        return;
    }
    [_favPoiInfos removeAllObjects];
    [_favPoiInfos addObjectsFromArray:favPois];
    [self updateMapAnnotations];
    NSInteger res = [_favManager addFavPoi:poiInfo];
    NSLog(@"NSInteger  %ld",res);
    
    if (res == 1) {
        [PromptInfo showText:@"保存成功"];
        
        defineDic = @{@"name":_addDefineCity.startAdressTF1.text,@"longitude":_addDefineCity.leftCityTF1.text,@"Latitude":_addDefineCity.rightCityTF1.text};
        
//        [self requestDataAndReturnCode:_addDefineCity.leftCityTF1.text add:_addDefineCity.rightCityTF1.text andName:_addDefineCity.startAdressTF1.text];
        [self JumpToHomeView];
        
        
    } else {
        [PromptInfo showText:@"保存失败"];
    }
    [_addTapView removeFromSuperview];
    [_addDefineCity removeFromSuperview];
}
//取消显示更新view
- (void)cancelview {
    [_addTapView removeFromSuperview];
}

#pragma mark ----收藏点
- (void)saveAction{
    [self hiddenKeyBoard];
    [_addTapView removeFromSuperview];
    if (_addTapView.startAdressTF.text.length == 0) {
        [PromptInfo showText:@"请输入名称"];
        return;
    }
    if (_coor.latitude == 0 && _coor.longitude == 0) {
        [PromptInfo showText:@"请获取经纬度"];
        return;
    }
    BMKFavPoiInfo *poiInfo = [[BMKFavPoiInfo alloc] init];
    
    poiInfo.pt = _coor;
   
        float a=[_addTapView.leftCityTF.text floatValue];
        float b=[_addTapView.rightCityTF.text floatValue];
        if (a>=b) {
            NSString*limitStr=[NSString stringWithFormat:@"%@-%@",_addTapView.leftCityTF.text,_addTapView.rightCityTF.text];
            poiInfo.cityName=limitStr;
        }else{
            [PromptInfo showText:@"输入的上限数据不能小于下限"];
            return;
           
        }

    
    poiInfo.poiName = _addTapView.startAdressTF.text;
    NSInteger res = [_favManager addFavPoi:poiInfo];
    if (res == 1) {
        [PromptInfo showText:@"保存成功"];
        defineDic = @{@"name":_addTapView.startAdressTF.text,@"longitude":_leftCityTF.text,@"Latitude":_rightCityTF.text};
//        //上传经纬度
//        [self requestDataAndReturnCode:_leftCityTF.text add:_rightCityTF.text andName:_addTapView.startAdressTF.text];
        [self JumpToHomeView];
       
        
    } else {
        [PromptInfo showText:@"保存失败"];
    }
    NSArray *favPois = [_favManager getAllFavPois];
    if (favPois == nil) {
        return;
    }
    [_favPoiInfos removeAllObjects];
    [_favPoiInfos addObjectsFromArray:favPois];
   // NSLog(@"poiInfopoiInfo%@",_favPoiInfos);
    [_addTapView removeFromSuperview];
    [self updateMapAnnotations];
    
}
#pragma mark ----保存更新
- (void)updateSaveAction {
    if (_updateView.endAdressTF.text.length == 0) {
        [PromptInfo showText:@"请输入名称"];
        return;
    }
    BMKFavPoiInfo *favInfo = [_favPoiInfos objectAtIndex:_curFavIndex];
    favInfo.poiName = _updateView.endAdressTF.text;
    
   
        float a=[_updateView.leftCityTF.text floatValue];
        float b=[_updateView.rightCityTF.text floatValue];
        if (b<=a) {
            NSString*limitStr1=[NSString stringWithFormat:@"%@-%@",_updateView.leftCityTF.text,_updateView.rightCityTF.text];
                favInfo.cityName=limitStr1;
        }else{
            [PromptInfo showText:@"输入的上限数据不能小于下限"];
            return;
           
        }
    
    
    BOOL res = [_favManager updateFavPoi:favInfo.favId favPoiInfo:favInfo];
    //更新
    if (res) {
        [PromptInfo showText:@"更新成功"];
        [self cancelUpdateView];
        [self updateMapAnnotations];
            defineDic = @{@"name":_updateView.endAdressTF.text,@"longitude":_leftCityTF.text,@"Latitude":_rightCityTF.text};
        //上传经纬度
//        [self requestDataAndReturnCode:_leftCityTF.text add:_rightCityTF.text andName:_updateView.endAdressTF.text];
        
        [self JumpToHomeView];
        
        
    } else {
        [PromptInfo showText:@"更新失败"];
    }
    [_updateView removeFromSuperview];
#pragma mark ----判断是否一样，一样的话不跳转
}

//#pragma mark ----上传经纬度
//- (void)requestDataAndReturnCode:(NSString*)longitude add:(NSString*)Latitude andName:(NSString*)name{
    /**
     1.获取位置code------------
     接口：http://weather.huakesoft.com/api/getcode
     参数：	longitude	//经度
     Latitude	//纬度
     返回：	point对象
     2.上传位置经纬度------------
     接口：http://weather.huakesoft.com/api/addpoint
     参数：	name
     longitude	//经度
     Latitude	//纬度
     返回：	point对象
     */
//    NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
//    NSString *userid=[defaults objectForKey:@"useId"];
//    NSDictionary *dicjwD=@{@"name":name,@"longitude":longitude,@"Latitude":Latitude,@"uid":userid};
//    
//    // NSDictionary *dicjwD;
//    NSString *urlstr = @"http://weather.huakesoft.com/api/addpoint?";
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    [manager POST:urlstr parameters:dicjwD constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *JSONString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSDictionary *dic= [self dictionaryWithJsonString:JSONString];
//        NSString *str=[dic objectForKey:@"latitude"];
//        NSString *str11=[dic objectForKey:@"longitude"];
//        NSDictionary *dicjwD1=@{@"longitude":str11,@"latitude":str};
//        //获取添加城市的citycode
//        NSString *ue=@"http://weather.huakesoft.com/api/getcode?";
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        [manager POST:ue parameters:dicjwD1 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSString *JSONString1 = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSDictionary *dic1= [self dictionaryWithJsonString:JSONString1];
//            self.citycode=[dic1 objectForKey:@"code"];
//             NSLog(@"rgesrgs----%@",[dic1 objectForKey:@"code"]);
//           [self JumpToHomeView];
//           
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             [PromptInfo showText:@"请检查当前网络"];
//        }];
//       
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//           [PromptInfo showText:@"请检查当前网络"];
//    }];
    
//}
//json数据处理
//- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
//    if (jsonString == nil) {
//        return nil;
//    }
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers
//        error:&err];
//    if(err) {
//        return nil;
//    }
//    return dic;
//}
#pragma mark ----转到主页 并进行网络请求
- (void)JumpToHomeView{
    [manger stop];
    // NSString *array = [[defineDic objectForKey:@"name"] stringByAppendingFormat:@"-"];
    
    if ([defineDic objectForKey:@"name"]==nil) {
            }else{
        _cityWeatherinfo = [[Cityweatherinfo alloc] init];
        
        _cityWeatherinfo.name= [defineDic objectForKey:@"name"];
                _cityWeatherinfo.cityJingdu = [defineDic objectForKey:@"longitude"];
                _cityWeatherinfo.cityWeidu = [defineDic objectForKey:@"Latitude"];
               
//                if (self.citycode.length==0) {
//                   _cityWeatherinfo.cityCode = @"";
//                }else{
//                 _cityWeatherinfo.cityCode = self.citycode;
//                }
                _cityWeatherinfo.cityCode = @"1";
        
        NSArray *arr = @[_cityWeatherinfo.name,_cityWeatherinfo.cityWeidu,_cityWeatherinfo.cityJingdu];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
                [accountDefaults removeObjectForKey:@"cityName1"];
        [accountDefaults setObject:arr forKey:@"cityName1"];
#pragma mark  ----这里建议同步存储到磁盘中，但是不是必须的
        [accountDefaults synchronize];
#pragma mark ----11.发布通知:加载搜索城市数据对象
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"definecityfrommap" object:_cityWeatherinfo]];
    }

    leftViewController= [[LeftViewController alloc] init];
    viewController = [[HomeViewController alloc] init];
    
    _sideBarMenuVC = [[SideBarMenuViewController alloc] initWithRootViewController:viewController];
    //设定_sideBarMenuVC的左侧栏
    leftViewController.sideBarMenuVC = _sideBarMenuVC;
    _sideBarMenuVC.leftViewController = leftViewController;
    //leftViewController展示主视图
    [leftViewController showViewControllerWithSection:0 Index:1];
    [self presentViewController:_sideBarMenuVC animated:YES completion:nil];
    
}
#pragma mark --返回按钮
-(void)BackPreviousPage{
    [_mapView viewWillDisappear];
    
    [_addTapView removeFromSuperview];
    [_addDefineCity removeFromSuperview];
    [_updateView removeFromSuperview];
    
    self.mapView.delegate = nil;
    if (self.locationSevice) {
        [self.locationSevice stopUserLocationService];
        self.locationSevice.delegate = nil;
    }
    _mapView=nil;
    _favManager = nil;
    
    [manger stop];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)updateCancelAction{
    [self cancelUpdateView];
}

@end
