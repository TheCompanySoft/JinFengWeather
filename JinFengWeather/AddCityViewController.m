//
//  AddCityViewController.m
//  JinFengWeather
//
//  Created by huake on 15/9/16.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "AddCityViewController.h"
#import "LeftViewController.h"
#import "SetLocationViewController.h"
#import "LoginViewController.h"
#import "Header.h"
#import "Cityweatherinfo.h"
#import "FMDB.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "HomeViewController.h"
#import "SideBarMenuViewController.h"
#import "LeftViewController.h"
#import "UIUtils.h"
#import "CollectionViewCell.h"


static NSString *cellIdentifier = @"cellIdentifier";

#pragma mark ----搜索代理
@interface AddCityViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating>
{
    HomeViewController *viewController;
    UIView *subViewOfHotCity;
    UIView *subViewOfSearch;
    UITableView *_tableView;
    SideBarMenuViewController *_sideBarMenuVC;
    LeftViewController *leftViewController;
    Cityweatherinfo *_cityWeatherinfo;
    UIImageView *_imageView;
    
    UITextField *textfield;
    
}
@property (nonatomic,strong)UICollectionView *collectView;

@end

@implementation AddCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    数据下载
    [self dbDataImport];
    
    //    背景图
    [self addhomebackgroundView];
    //设置navigationBar
    [self setnavigationbar];
    //    添加热门城市及定位入口
    [self addSubViewOfHotCity];
    //    添加搜索城市列表
    [self addSubViewOfSearchCity];
    //    添加搜索框
    [self addfindTextField];
}
- (void)dbDataImport1{
    NSString*dbPath=[[NSBundle mainBundle]pathForResource:@"city" ofType:@"db"];
    FMDatabase* database = [ FMDatabase databaseWithPath: dbPath ];
    if ( ![ database open ] )
    {
        return;
    }
    // 查找表 hotcity
    FMResultSet *resultSet = [ database executeQuery: @"select * from hotcity" ];
    
    _hotCityList = [NSMutableArray array];
    // 逐行读取数据
    while ( [ resultSet next ] )
    {
#warning 修改热门城市读取
        // 对应字段来取数据
        NSString *name = [ resultSet stringForColumn: @"name" ];
        NSString *latitude = [ resultSet stringForColumn: @"latitude" ];
        NSString *longitude = [resultSet stringForColumn:@"longitude"];
        
        NSDictionary *dic = @{@"name":name,@"latitude":latitude,@"longitude":longitude};
        
        [_hotCityList addObject:dic];
    }
    
    _heightArray = [self.hotCityList copy];
    
    
    [ database close ];
}

- (void)dbDataImport{
    NSString*dbPath=[[NSBundle mainBundle]pathForResource:@"city" ofType:@"db"];
    FMDatabase* database = [ FMDatabase databaseWithPath: dbPath ];
    if ( ![ database open ] )
    {
        return;
    }
    // 查找表 city
    FMResultSet *resultSet = [ database executeQuery: @"select * from city" ];
    self.dataList = [NSMutableArray array];
    // 逐行读取数据
    while ([ resultSet next ])
    {
#warning 修改数据库读取字段 添加所属城市
        // 对应字段来取数据
        NSString *city = [ resultSet stringForColumn: @"name" ];
        NSString *latitude = [ resultSet stringForColumn: @"latitude" ];
        NSString *longitude = [resultSet stringForColumn:@"longitude"];
        NSString *area = [resultSet stringForColumn:@"pname"];
        
        city = [city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        latitude = [latitude stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        longitude = [longitude stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        area = [area stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //        拼接一起传
        NSString *cityAndlati = [city stringByAppendingFormat:@"-%@-%@-%@",latitude,longitude,area];
        [self.dataList addObject:cityAndlati];
        //NSLog(@"~~~~~~~~~~%@",cityAndlati);
    }
    
    [ database close ];
}

- (void)setnavigationbar{
    self.title=@"添加城市";
    self.navigationController.navigationBar.barTintColor=[UIColor clearColor];
    //设置navigationBar的属性
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                                      }];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"headbg@2x"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    //返回按钮2
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"goback@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(add )];
    //设置按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem= backItem;
    
}

- (void)addSubViewOfHotCity{
    subViewOfHotCity = [[UIView alloc]initWithFrame:AdaptCGRectMake(0, 64+75, 320, 429)];
    [self.view addSubview:subViewOfHotCity];
    //    热门城市和线
    [self addwarnLable];
    [self dbDataImport1];
    //    热门城市列表
    [self addColectionView];
    //    添加全国定位
    [self addCountLocation];
}

- (void)addSubViewOfSearchCity{
    
    
    _tableView = [[UITableView alloc]initWithFrame:AdaptCGRectMake(10, 64+25, 300, 344)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.cornerRadius = 20;
    _tableView.layer.masksToBounds = YES;
    
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorColor=[UIColor clearColor];
    
    //    UIImageView *imageview= [[UIImageView alloc]initWithFrame:self.view.frame];
    //    [imageview setImage:[UIImage imageNamed:@"background_images@2x.jpg"]];
    //    [_tableView addSubview:imageview];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}
//首页背景图片
-(void)addhomebackgroundView{
    UIImageView *imageview= [[UIImageView alloc]initWithFrame:self.view.frame];
    [imageview setImage:[UIImage imageNamed:@"background_images1@2x.jpg"]];
    [self.view addSubview:imageview];
    
}
-(void)addfindTextField{
    UIImage *iconimage=[UIImage imageNamed:@"search_btn@2x"];
    UIImageView *iconView=[[UIImageView alloc]initWithImage:iconimage];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    
    _searchController.searchBar.barTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"headbg@2x"]];
    _searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    _searchController.searchBar.frame = AdaptCGRectMake(10,20+64,300, 44);
    for (UIView *subview in [[_searchController.searchBar.subviews lastObject] subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            textfield = (UITextField*)subview;
            
            textfield.placeholder = @"请输入城市的名字";
            textfield.backgroundColor=[UIColor clearColor];
            textfield.tintColor=[UIColor whiteColor];
            textfield.textColor=[UIColor whiteColor];
            textfield.leftView=iconView;
            textfield.leftView.frame=AdaptCGRectMake(10, 25, 20, 20);
            textfield.leftViewMode = UITextFieldViewModeAlways;
            textfield.keyboardType=UIKeyboardTypeDefault;
            textfield.clearButtonMode=UITextFieldViewModeAlways;
            
        }
    }
    
    //    [_tableView.tableHeaderView addSubview:bgimage];
    self.searchController.searchBar.layer.cornerRadius = 20;
    self.searchController.searchBar.layer.masksToBounds = YES;
    
    
    _tableView.tableHeaderView = self.searchController.searchBar;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
           return 44*[UIUtils getWindowHeight]/568;
   
}

//设置区域
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor=[UIColor lightGrayColor];
        if (self.searchList.count != 0) {
            _tableView.frame = AdaptCGRectMake(10, 64+25, 300, ([self.searchList count]+1)*44);
           
        }
        [subViewOfHotCity removeFromSuperview];
        return [self.searchList count];
        
    }else{
        [self.view addSubview:subViewOfHotCity];
        _tableView.separatorColor=[UIColor clearColor];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.frame = AdaptCGRectMake(10, 64+25, 300, 44);
        
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    viewController = [[HomeViewController alloc] init];
    leftViewController= [[LeftViewController alloc] init];
    _sideBarMenuVC = [[SideBarMenuViewController alloc] initWithRootViewController:viewController];
    //设定_sideBarMenuVC的左侧栏
    leftViewController.sideBarMenuVC = _sideBarMenuVC;
    _sideBarMenuVC.leftViewController = leftViewController;
    [leftViewController showViewControllerWithSection:0 Index:1];
    
    
#pragma mark ---Model将搜索城市传到主页，侧拉菜单
    _cityWeatherinfo = [[Cityweatherinfo alloc] init];
    NSArray *array = [self.searchList[indexPath.row] componentsSeparatedByString:@"-"];
    _cityWeatherinfo.name= [array objectAtIndex:0];
    _cityWeatherinfo.cityWeidu =[array objectAtIndex:1];
    _cityWeatherinfo.cityJingdu = [array objectAtIndex:2];
    
    //NSLog(@"%@____%@____%@",_cityWeatherinfo.name,_cityWeatherinfo.cityWeidu,_cityWeatherinfo.cityJingdu);
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults removeObjectForKey:@"cityName1"];
    [accountDefaults setObject:array forKey:@"cityName1"];
#pragma mark  ----这里建议同步存储到磁盘中，但是不是必须的
    [accountDefaults synchronize];
#pragma mark ----11.发布通知:加载搜索城市数据对象
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"searchcityweatherinfo" object: _cityWeatherinfo]];
    
    if (indexPath.section == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self presentViewController:_sideBarMenuVC animated:YES completion:nil];
    }
    [self.view endEditing:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *flag=@"cellFlag";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    if (self.searchController.active) {
#pragma mark ----搜索结果显示  添加所属城市
        NSArray *array = [self.searchList[indexPath.row] componentsSeparatedByString:@"-"];
        cell.textLabel.textColor = [UIColor whiteColor];
        NSString *searchResult = [NSString stringWithFormat:@"%@,%@",[array objectAtIndex:0],[array objectAtIndex:3]];
        searchResult = [searchResult stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        [cell.textLabel setText:searchResult];
    }else{
        //  _collectView.userInteractionEnabled=YES;
    }
    cell.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    
    
    return cell;
}



#pragma mark ----数据更新
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
#pragma mark ——搜索精确点
    NSString *cccc;
    if ([searchString length] >= 2) {
        cccc = [searchString substringToIndex:[searchString length] - 1];
        
    }else if ([searchString length] == 1 ){
        cccc = searchString;
    }
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", cccc];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [[self.dataList filteredArrayUsingPredicate:preicate] mutableCopy];
    //NSLog(@"%@",self.searchList);
    //刷新表格
    [_tableView reloadData];
}
#pragma mark ----搜索Begin
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [_searchController.searchBar setShowsCancelButton:NO animated:NO];
    for(id cc in [_searchController.searchBar subviews])
    {
        if([cc isKindOfClass:[UIView class]])
        {
            UIView *btn = (UIView *)cc;
            
            btn.backgroundColor = [UIColor redColor];
        }
    }
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    
}

#pragma mark ----搜索End
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    return YES;
}


#pragma mark ----collectionView点击跳转 代理
-(void)selectcelldelegate{
    [self JumpToHomeView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];

    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}
//点击屏幕键盘消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [textfield resignFirstResponder];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
    
}

#pragma mark ----返回上页面
-(void)add{
    //    []
    
    [self dismissViewControllerAnimated:YES completion:nil];
    // [self JumpToHomeView];
}

-(void)addCityViewlocationCity{
    
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    NSString *str=[defaults objectForKey:@"isLogin"];
//    if ([str isEqualToString:@"1"]) {
//        SetLocationViewController *addCityController =[[SetLocationViewController alloc]init];
//        addCityController.modalTransitionStyle=2;
//        UINavigationController *nav2 =[[UINavigationController alloc]initWithRootViewController:addCityController];
//        [self presentViewController:nav2 animated:YES completion:nil];
//    }else{
//        LoginViewController *loginVC=[[LoginViewController alloc]init];
//        [self presentViewController:loginVC animated:YES completion:nil];
//        
//    }
    SetLocationViewController *addCityController =[[SetLocationViewController alloc]init];
    addCityController.modalTransitionStyle=2;
    UINavigationController *nav2 =[[UINavigationController alloc]initWithRootViewController:addCityController];
    [self presentViewController:nav2 animated:YES completion:nil];
    
}



-(void)addwarnLable{
    UILabel *lable =[[UILabel alloc]initWithFrame:AdaptCGRectMake(20, 0,80, 30)];
    lable.text=@"热门城市";
    
    lable.textColor=[UIColor whiteColor];
    lable.font=[UIFont systemFontOfSize:18];
    [subViewOfHotCity addSubview:lable];
    UIView *lineView=[[UIView alloc]initWithFrame:AdaptCGRectMake(15, 38, 290, 1)];
    lineView.backgroundColor=[UIColor whiteColor];
    [subViewOfHotCity addSubview:lineView];
    
}

-(void)addColectionView{
    UICollectionViewLayout *new = [[UICollectionViewFlowLayout alloc]init];
    _collectView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:new];
    _collectView.bounces=NO;
    
    _collectView.delegate = self;
    _collectView.dataSource = self;
    _collectView.scrollEnabled = YES;
    _collectView.frame = AdaptCGRectMake(0, 38, 320, 290);
    [subViewOfHotCity addSubview:_collectView];
    
    
    _collectView.backgroundColor=[UIColor clearColor];
    
    [_collectView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
#pragma mark ----城市去重
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //
    //    });
    
}
//选中后状态
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    防止多次点击
    [collectionView setUserInteractionEnabled:NO];
    [collectionView performSelector:@selector(setUserInteractionEnabled:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5f];
    _searchController.view.userInteractionEnabled=NO;
#pragma 热门城市点击传值修改
    _cityWeatherinfo = [[Cityweatherinfo alloc] init];
    _cityWeatherinfo.index=(int)indexPath.row;
    _cityWeatherinfo.name=_heightArray[indexPath.row][@"name"];
    _cityWeatherinfo.cityWeidu = _heightArray[indexPath.row][@"latitude"];
    _cityWeatherinfo.cityJingdu = _heightArray[indexPath.row][@"longitude"];
    
    NSArray *array = @[_heightArray[indexPath.row][@"name"],_heightArray[indexPath.row][@"latitude"],_heightArray[indexPath.row][@"longitude"]];
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults removeObjectForKey:@"cityName1"];
    [accountDefaults setObject:array forKey:@"cityName1"];
#pragma mark  ----这里建议同步存储到磁盘中，但是不是必须的
    [accountDefaults synchronize];
    
#pragma mark ----1.发布通知:加载热门城市数据对象
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"hotcityweatherinfo" object: _cityWeatherinfo]];
    //添加按钮
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIImage *image =[UIImage imageNamed:@"right_btn@2x"];
    _imageView =[[UIImageView alloc]initWithFrame:AdaptCGRectMake(58, 5, image.size.width, image.size.height)];
    [_imageView setImage:image];
    [cell addSubview:_imageView];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"givemessage" object:nil];
    //跳到主界面
    [self JumpToHomeView];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//items高度
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _heightArray.count;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_searchController isActive]) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark ----给cell赋值
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionViews cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionViewCell *cell = (CollectionViewCell *)[collectionViews dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
    cell.lable.frame = AdaptCGRectMake(10, 0, 50, 30);
    cell.lable.text = _heightArray[indexPath.item][@"name"];
    cell.lable.textColor=[UIColor whiteColor];
    cell.lable.adjustsFontSizeToFitWidth=YES;
    
    NSMutableArray *indexArr = [NSMutableArray array];
#warning 
    for (Cityweatherinfo *weatherInfo in _cityArray) {
//        NSArray *arr = [str componentsSeparatedByString:@"-"];
//        [indexArr addObject:[arr objectAtIndex:0]];
        [indexArr addObject:weatherInfo.name];
    }
    for (NSString *str in indexArr) {
        if ([cell.lable.text isEqual:str]) {
            UIImage *image =[UIImage imageNamed:@"right_btn@2x"];
            //加载图片
            cell.imageView.frame=AdaptCGRectMake(58,5, image.size.width,image.size.height);
            cell.imageView.image = image;
            
        }
    }
    return cell;
}


#pragma mark UICollectionViewDelegateFlowLayout
//定义每个UICollectionViewcell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((subViewOfHotCity.frame.size.width-20*4)/3,35);
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInset=UIEdgeInsetsMake(15, 25, 5, 5);
    return edgeInset;
}

//添加全国定位按钮
-(void)addCountLocation{
    UIButton *locationBtn =[[UIButton alloc]initWithFrame:AdaptCGRectMake(15, 345, 290, 35)];
    locationBtn.backgroundColor=[UIColor colorWithWhite:0 alpha:0.15];
    
    [locationBtn addTarget:self action:@selector(addCityViewlocationCity) forControlEvents:UIControlEventTouchUpInside];
    
    [subViewOfHotCity addSubview:locationBtn];
    //设置背景图片
    UIImage *loca=[UIImage imageNamed:@"location@2x"];
    UIImageView *localView=[[UIImageView alloc]initWithFrame:AdaptCGRectMake(100, 10, loca.size.width, loca.size.height)];
    [localView setImage:loca];
    [locationBtn addSubview:localView];
    UILabel *lable =[[UILabel alloc]initWithFrame:AdaptCGRectMake(125,2,80, 30)];
    lable.text=@"全国定位";
    lable.textColor=[UIColor whiteColor];
    
    [locationBtn  addSubview:lable];
    
}

#pragma mark ----转到主页
- (void)JumpToHomeView{
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
