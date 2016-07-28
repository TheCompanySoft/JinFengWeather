
//
//  FirstSectionViewCell.m
//  JinFengWeather
//
//  Created by huake on 15/10/26.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//tableView第一个cell，预警信息当前都没有数据

#import "FirstSectionViewCell.h"
#import "Header.h"
#import "UIUtils.h"
#import "DayArrayinfo.h"
#import "WindPlantModel.h"

@interface FirstSectionViewCell ()
{
  
    NSMutableArray *_temArray;
    NSMutableArray *_windArray;
    NSMutableArray *_winddircnArray;
    NSMutableArray *_weathertypeArray;
    NSMutableArray *_winddirenArray;
    
    NSMutableArray *_windGradeArray;//风级数组
    
     NSMutableArray *_arraybx;
     NSMutableArray *_datetimearray;
     NSMutableArray *_arrayhl;
     NSMutableArray *_arrayfog;
     NSMutableArray *_arrayfire;
    NSMutableArray *_arrayforst;
     NSMutableArray *_arraygalewind;
     NSMutableArray *_arrayhail;
    NSMutableArray *_arrayhaze;
     NSMutableArray *_arraytem;
    NSMutableArray *_arrayroad;
    NSMutableArray *_arraysandstorm;
    NSMutableArray *_arraytthunderbolt;
    
    NSMutableArray *_arraythunderstormgale;
    NSMutableArray *_arraytorrentialrain;
    NSMutableArray *_arraytyphoon;
    NSString* _curtime;
    //警告数组
    NSMutableArray*_warnArray;
     NSMutableArray*_headArray;
    //时间的形式
    NSDateFormatter  *_newFormatter1;//HH:mm
    NSDateFormatter  *_newFormatter2;//YYYY-MM-dd
    NSDateFormatter  *_newFormatter;//YYYY年MM月dd日

    NSTimeZone *_timeZone;//时间
    NSDate *_todayDate;//当前time
    
    HuView *_windChartView;
}



@end
@implementation FirstSectionViewCell
//自定义Cell的方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        //风级
        _windGradeArray = [NSMutableArray array];
        
        //温度
        _temArray=[NSMutableArray array];
        //风
        _windArray=[NSMutableArray array];
        //风向
        _winddircnArray=[NSMutableArray array];
        //天气的样式
        _weathertypeArray=[NSMutableArray array];
        _winddirenArray=[NSMutableArray array];
        //时间
        _datetimearray=[NSMutableArray array];
        //预警
        _arraybx=[NSMutableArray array];
        //暴风
        _arrayhl=[NSMutableArray array];
        //雾
        _arrayfog=[NSMutableArray array];
        //火
        _arrayfire=[NSMutableArray array];
        //森林
        _arrayforst=[NSMutableArray array];
        //风
        _arraygalewind=[NSMutableArray array];
        //冰雹
        _arrayhail=[NSMutableArray array];
        _arrayhaze=[NSMutableArray array];
        //温度
        _arraytem=[NSMutableArray array];
        //路
        _arrayroad=[NSMutableArray array];
        //沙尘暴
        _arraysandstorm=[NSMutableArray array];
        _arraytthunderbolt=[NSMutableArray array];
        //大暴风
        _arraythunderstormgale=[NSMutableArray array];
        //雨
        _arraytorrentialrain=[NSMutableArray array];
        //台风
        _arraytyphoon=[NSMutableArray array];
        //添加内容视图
        [self addContentView];
       
    }
    return self;
}
//添加内容视图
-(void)addContentView{

    //现在的时间todayDate
    _todayDate = [NSDate date];
    _newFormatter1 = [[NSDateFormatter alloc] init];
    _newFormatter = [[NSDateFormatter alloc] init];
   _newFormatter2 = [[NSDateFormatter alloc] init];
    //设置时区
    _timeZone = [NSTimeZone localTimeZone];
     [_newFormatter setTimeZone:_timeZone];
     //[_newFormatter1 setTimeZone:_timeZone];
     [_newFormatter2 setTimeZone:_timeZone];
    //设置时间显示格式
    [_newFormatter setDateFormat:@"YY-MM-dd HH:mm"];
    //[_newFormatter1 setDateFormat:@"HH:mm"];
    [_newFormatter2 setDateFormat:@"YYYY-MM-dd"];
  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
    //用制定格式将时间声称字符串
    NSString *diff = [_newFormatter stringFromDate:_todayDate];
    //NSString *diff1 = [_newFormatter1 stringFromDate:_todayDate];
    _curtime=[_newFormatter2 stringFromDate:_todayDate];
    _dateLabel =[[UILabel alloc]initWithFrame:AdaptCGRectMake(15, 14,110, 30)];
    _dateLabel.text=diff;
    _dateLabel.adjustsFontSizeToFitWidth=YES;
    _dateLabel.textColor=[UIColor whiteColor];
    
    
    _timeLabel =[[UILabel alloc]initWithFrame:AdaptCGRectMake(60, 55.5,100, 30)];
    //_timeLabel.text=diff1;
    _timeLabel.font=[UIFont systemFontOfSize:16];
    _timeLabel.textColor=[UIColor whiteColor];
    _timeLabel.text = @"暂无数据";
    
    _timeView = [[UIImageView alloc]initWithFrame:AdaptCGRectMake(15, 55.5, 32, 32)];
    [_timeView setImage:[UIImage imageNamed:@"time_cur.png"]];
    
    
    _weatherView=[[UIImageView alloc]initWithFrame:AdaptCGRectMake(15, 98, 32, 32)];
    [_weatherView setImage:[UIImage imageNamed:@"weather@2x"]];
    _weatherLabel =[[UILabel alloc]initWithFrame:AdaptCGRectMake(60, 102,100, 30)];
    _weatherLabel.font=[UIFont systemFontOfSize:16];
    _weatherLabel.text=@"暂无数据";
    _weatherLabel.textColor=[UIColor whiteColor];
    
    _temputerView=[[UIImageView alloc]initWithFrame:AdaptCGRectMake(15, 140.5, 32, 32)];
    [_temputerView setImage:[UIImage imageNamed:@"temper@2x"]];
    _temputerLabel =[[UILabel alloc]initWithFrame:AdaptCGRectMake(60, 144.5,100, 30)];
    _temputerLabel.font=[UIFont systemFontOfSize:16];
    _temputerLabel.textColor=[UIColor whiteColor];
    _temputerLabel.text=@"暂无数据";
    _windView=[[UIImageView alloc]initWithFrame:AdaptCGRectMake(15, 183, 32, 32)];
    [_windView setImage:[UIImage imageNamed:@"wind@2x"]];
    _windLabel =[[UILabel alloc]initWithFrame:AdaptCGRectMake(60, 187,100, 30)];
    _windLabel.font=[UIFont systemFontOfSize:16];
    _windLabel.textColor=[UIColor whiteColor];
    _windLabel.text=@"暂无数据";
   
//    _turnLabel =[[UILabel alloc]initWithFrame:AdaptCGRectMake(202, 185,100, 30)];
//    _turnLabel.text=@"WS-70";
//    _turnLabel.font=[UIFont systemFontOfSize:16];
//    _turnLabel.textColor=[UIColor whiteColor];
//    _turnView=[[UIImageView alloc]initWithFrame:AdaptCGRectMake(170, 65, 120, 120)];
//    [_turnView setImage:[UIImage imageNamed:@"turntable@2x"]];
    
    _windSpeedLabel = [[UILabel alloc]initWithFrame:AdaptCGRectMake(46, 55, 60, 20)];
    _windSpeedLabel.font = [UIFont systemFontOfSize:15];
    _windSpeedLabel.textColor = [UIColor greenColor];
    _windSpeedLabel.textAlignment = NSTextAlignmentCenter;
    _windSpeedLabel.text = @"暂无数据";
    
    _windGradeLabel = [[UILabel alloc]initWithFrame:AdaptCGRectMake(46, 30, 60, 20)];
    _windGradeLabel.font = [UIFont systemFontOfSize:15];
    _windGradeLabel.textColor = [UIColor whiteColor];
    _windGradeLabel.textAlignment = NSTextAlignmentCenter;
    _windGradeLabel.text = @"暂无数据";
    
    _windDirView = [[UIImageView alloc]initWithFrame:AdaptCGRectMake(55, 80, 40, 40)];
    _windDirView.backgroundColor = [UIColor clearColor];
    _windDirView.image = [UIImage imageNamed:@"wind_dir.png"];
    
    _warnBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _warnBtn.frame=AdaptCGRectMake(280, 30,20, 20);
//    //风力转盘
    _windliView=[[UIView alloc]initWithFrame:AdaptCGRectMake(65, 65, 10, 80)];
    _windliView.backgroundColor=[UIColor clearColor];
    UIImageView *iamge1=[[UIImageView  alloc]initWithFrame:AdaptCGRectMake(1, 48, 8,9)];
    [iamge1 setImage:[UIImage imageNamed:@"big_pointer@2x"]];
    _windliView.layer.position=CGPointMake(75*[UIUtils getWindowWidth]/320,75*[UIUtils getWindowWidth]/320);
    _windliView.layer.anchorPoint=CGPointMake(0.5, 0);
//    _i=1;
//    //风力转动大小，大于0小于30正常，大于30的部分风力图标指向30
    if ( (_i>=0)||_i<=40) {
        if (_i>30) {
            _i=30;
        }
        _windliView.layer.transform=CATransform3DMakeRotation(M_PI/4+M_PI/20*_i, 0, 0, 1);
    }
    [self setValueFX];
//    //风向标的位置，这里使用锚点
    _windxiangView.layer.position=CGPointMake(20*[UIUtils getWindowWidth]/320,20*[UIUtils getWindowWidth]/320);
    [self.windDirView addSubview:_windxiangView];
    
//    [_turnView addSubview:_windxiangView];
    [_windliView addSubview:iamge1];
//    [_turnView addSubview:_windliView];
    
    self.windChartView = [[HuView alloc]initWithFrame:AdaptCGRectMake(170, 65, 160, 160)];
    self.windChartView.backgroundColor = [UIColor clearColor];
    
    //[self.windChartView addSubview:_windliView];
    [self.windChartView addSubview:_windSpeedLabel];
    [self.windChartView addSubview:_windGradeLabel];
    [self.windChartView addSubview:_windDirView];
    
    [self addSubview:self.windChartView];
    
    [_warnBtn setBackgroundImage:[UIImage imageNamed:@"warning_3"] forState:UIControlStateNormal];
    [_warnBtn setBackgroundImage:[UIImage imageNamed:@"warning_3"] forState:UIControlStateHighlighted];
    [_warnBtn addTarget:self action:@selector(warning) forControlEvents:UIControlEventTouchUpInside];
    _fengliLabel =[[UILabel alloc]initWithFrame:AdaptCGRectMake(40,42,40, 20)];
    _fengliLabel.font=[UIFont systemFontOfSize:16];
    _fengliLabel.text=@"";
    _fengliLabel.textAlignment=NSTextAlignmentCenter;
    _fengliLabel.textColor=[UIColor whiteColor];
//    [_turnView addSubview:_fengliLabel];
    [self addSubview:_warnBtn];
//    [self addSubview:_turnLabel];
//    [self addSubview:_turnView];
    [self addSubview:_windLabel];
    [self addSubview:_windView];
    [self addSubview:_temputerLabel];
    [self addSubview:_temputerView];
    [self addSubview:_weatherLabel];
    [self addSubview:_weatherView];
    [self addSubview:_dateLabel];
    [self addSubview:_timeLabel];
    [self addSubview:_timeView];
}
//时间
-(void)update{
     _todayDate = [NSDate date];
    [_newFormatter setDateFormat:@"YY-MM-dd HH:mm"];
//    [_newFormatter1 setDateFormat:@"HH:mm"];
     NSString *diff = [_newFormatter stringFromDate:_todayDate];
    // NSString *diff1 = [_newFormatter1 stringFromDate:_todayDate];
    //_timeLabel.text=diff1;
    _dateLabel.text=diff;
}
//获取数据
-(void)setContentFirstrow:(NSMutableArray *)dataArray WithFlag:(int)flag{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sayHi:) name:@"1" object:nil];
 //   NSLog(@"weaterInfo%@",weaterInfo.BeginDate);
   //self.dateLabel.text=weaterInfo.BeginDate;
    if (_arraybx.count>0||_windArray.count>0) {
      
        [_windArray removeAllObjects];
        [_windGradeArray removeAllObjects];
        [_temArray removeAllObjects];
        [_winddircnArray removeAllObjects];
        [_weathertypeArray removeAllObjects];
        [_winddirenArray removeAllObjects];
        [_datetimearray removeAllObjects];
        [_arraybx removeAllObjects];
        [_arrayhl removeAllObjects];
        [_arrayhl removeAllObjects];
        [_arrayfog removeAllObjects];
        [_arrayfire removeAllObjects];
        [_arrayforst removeAllObjects];
        [_arraygalewind removeAllObjects];
        [_arrayhail removeAllObjects];
        [_arrayhaze removeAllObjects];
        [_arraytem removeAllObjects];
        [_arrayhail removeAllObjects];
        [_arrayroad removeAllObjects];
        [_arraysandstorm removeAllObjects];
        [_arraytthunderbolt removeAllObjects];
        [_arraythunderstormgale removeAllObjects];
        [_arraytorrentialrain removeAllObjects];
        [_arraythunderstormgale removeAllObjects];
        [_arraytyphoon removeAllObjects];
        
    }

    if (flag == 0) {
        for (DayArrayinfo*dainfo in dataArray) {
            if ([dainfo.wea_types isEqual:[NSNull null]])
            {
                dainfo.wea_types=@"无数据";
            }
            if ([dainfo.wdir_en isEqual:[NSNull null]])
            {
                dainfo.wdir_en=@"无数据";
            }
            if ([dainfo.wdir_cn isEqual:[NSNull null]])
            {
                dainfo.wdir_cn=@"无数据";
            }
            
            [_windArray addObject:dainfo.wspd];
            [_windGradeArray addObject:dainfo.wspd_gread];
            
            [_temArray addObject:dainfo.Td2m];
            [_winddircnArray addObject:dainfo.wdir_cn];
            [_weathertypeArray addObject:dainfo.wea_types];
            [_winddirenArray addObject:dainfo.wdir_en];
            
#pragma mark --修改数据时间显示格式
            NSString *timeDateStr = dainfo.times;
            timeDateStr = [timeDateStr substringWithRange:NSMakeRange(4, 8)];
            NSMutableString *timeStr = [NSMutableString stringWithFormat:@"%@",timeDateStr];
            [timeStr insertString:@":" atIndex:6];
            [timeStr insertString:@" " atIndex:4];
            [timeStr insertString:@"-" atIndex:2];
            [_datetimearray addObject:timeStr];
            
        }

    }else if (flag != 0){
        for (WindPlantModel *windPlantModel in dataArray) {
            if ([windPlantModel.wea_types isEqual:[NSNull null]])
            {
                windPlantModel.wea_types=@"无数据";
            }
            if ([windPlantModel.wdir_en isEqual:[NSNull null]])
            {
                windPlantModel.wdir_en=@"无数据";
            }
            if ([windPlantModel.wdir_cn isEqual:[NSNull null]])
            {
                windPlantModel.wdir_cn=@"无数据";
            }
            
            [_windArray addObject:windPlantModel.WindSpeed];
            [_windGradeArray addObject:windPlantModel.wspd_gread];
            
            [_temArray addObject:windPlantModel.Td2m];
            [_winddircnArray addObject:windPlantModel.wdir_cn];
            [_weathertypeArray addObject:windPlantModel.wea_types];
            [_winddirenArray addObject:windPlantModel.wdir_en];
            
            NSString *timeDateStr = windPlantModel.DataDateTime;
            timeDateStr = [timeDateStr substringWithRange:NSMakeRange(5, 11)];
            [_datetimearray addObject:timeDateStr];
            
        }
    }


    _warnArray=[NSMutableArray array];
    _headArray=[NSMutableArray array];
    for (int i=0; i<_arraybx.count; i++) {
         NSString *str1=_arraybx[i];
         NSString*str2=_arrayhl[i];
         NSString*str3=_arrayfog[i];
         NSString*str4=_arrayfire[i];
         NSString*str5=_arrayforst[i];
         NSString*str6=_arraygalewind[i];
         NSString*str7=_arrayhail[i];
         NSString*str8=_arrayhaze[i];
         NSString*str9=_arraytem[i];
         NSString*str10=_arraysandstorm[i];
         NSString*str11=_arrayroad[i];
         NSString*str12=_arraytthunderbolt[i];
         NSString*str13= _arraythunderstormgale[i];
         NSString*str14= _arraytorrentialrain[i];
         NSString*str15= _arraytyphoon[i];
        
        if(_headArray.count>0||_warnArray.count>0){
            [_warnArray removeAllObjects];
            [_headArray removeAllObjects];
        
        }
        NSUserDefaults*accountDefaults = [NSUserDefaults standardUserDefaults];
         NSString* _curtime1 = [accountDefaults objectForKey:@"citynameloc"];
   
        if ([str1 isEqual:@"1"]){
            NSString *strc1=[NSString stringWithFormat:@"时间:%@\n信息:雷暴大风或冰雹预警\n地区:%@",_datetimearray[i],_curtime1];
            NSString *strh1=[NSString stringWithFormat:@"%@  暴雪蓝色预警  亦庄(地区)镇",_curtime ];
            [_headArray addObject:strh1];
            [_warnArray addObject:strc1];
           
        }
        if ([str2 isEqual:@"1"]){
            NSString *strc1=[NSString stringWithFormat:@"时间:%@\n信息:寒流预警\n地区:%@",_datetimearray[i],_curtime1];
            NSString *strh1=[NSString stringWithFormat:@"%@  寒流预警  亦庄(地区)镇",_curtime ];
            
            [_headArray addObject:strh1];
            [_warnArray addObject:strc1];
            
        }
        if ([str3 isEqual:@"1"]){
            NSString *strc1=[NSString stringWithFormat:@"时间:%@\n信息:大雾预警\n地区:%@",_datetimearray[i],_curtime1];
            NSString *strh1=[NSString stringWithFormat:@"%@  大雾预警  亦庄(地区)镇",_curtime ];
            
            [_headArray addObject:strh1];
            [_warnArray addObject:strc1];
            
        }
        if ([str4 isEqual:@"1"]){
            NSString *strc1=[NSString stringWithFormat:@"时间:%@\n信息:森林火灾预警\n地区:%@",_datetimearray[i],_curtime1];
            NSString *strh1=[NSString stringWithFormat:@"%@  森林火灾预警  亦庄(地区)镇",_curtime ];
            
            [_headArray addObject:strh1];
            [_warnArray addObject:strc1];
            
        }
        if ([str5 isEqual:@"1"]){
            NSString *strc1=[NSString stringWithFormat:@"时间:%@\n信息:霜预警\n地区:%@",_datetimearray[i],_curtime1];
            NSString *strh1=[NSString stringWithFormat:@"%@  霜预警  亦庄(地区)镇",_curtime ];
            
            [_headArray addObject:strh1];
            [_warnArray addObject:strc1];
            
        }
        if ([str6 isEqual:@"1"]){
            NSString *strc1=[NSString stringWithFormat:@"时间:%@\n信息:盖尔风预警\n地区:%@",_datetimearray[i],_curtime1];
            NSString *strh1=[NSString stringWithFormat:@"%@  盖尔风预警  亦庄(地区)镇",_curtime ];
            
            [_headArray addObject:strh1];
            [_warnArray addObject:strc1];
            
        }
        if ([str7 isEqual:@"0"]){
            NSString *strc1=[NSString stringWithFormat:@"时间:%@\n信息:数据刷新成功预警\n地区:%@",_datetimearray[i],_curtime1];
            NSString *strh1=[NSString stringWithFormat:@"%@  冰雹预警  亦庄(地区)镇",_curtime ];
            
            [_headArray addObject:strh1];
            [_warnArray addObject:strc1];
            
        }
        if ([str8 isEqual:@"1"]){
            NSString *strc1=[NSString stringWithFormat:@"时间:%@\n信息:阴霾预警\n地区:%@",_datetimearray[i],_curtime1];
            NSString *strh1=[NSString stringWithFormat:@"%@  阴霾预警  亦庄(地区)镇",_curtime ];
            
            [_headArray addObject:strh1];
            [_warnArray addObject:strc1];
            
        }
        if ([str9 isEqual:@"1"]){
            NSString *strc1=[NSString stringWithFormat:@"时间:%@\n信息:高温预警\n地区:%@",_datetimearray[i],_curtime1];
            NSString *strh1=[NSString stringWithFormat:@"%@  高温预警  亦庄(地区)镇",_curtime ];
            
            [_headArray addObject:strh1];
            [_warnArray addObject:strc1];
            
        }
        if ([str10 isEqual:@"1"]){
            NSString *strc1=[NSString stringWithFormat:@"时间:%@\n信息:沙尘暴预警\n地区:%@",_datetimearray[i],_curtime1];
            NSString *strh1=[NSString stringWithFormat:@"%@  沙尘暴预警  亦庄(地区)镇",_curtime ];
            
            [_headArray addObject:strh1];
            [_warnArray addObject:strc1];
            
        }
        if ([str11 isEqual:@"1"]){
            NSString *strc1=[NSString stringWithFormat:@"时间:%@\n信息:冰路预警\n地区:%@",_datetimearray[i],_curtime1];
            NSString *strh1=[NSString stringWithFormat:@"%@  冰路预警  亦庄(地区)镇",_curtime ];
            
            [_headArray addObject:strh1];
            [_warnArray addObject:strc1];
            
        }
        if ([str12 isEqual:@"1"]){
            NSString *strc1=[NSString stringWithFormat:@"时间:%@\n信息:雷击预警\n地区:%@",_datetimearray[i],_curtime1];
            NSString *strh1=[NSString stringWithFormat:@"%@  雷击预警  亦庄(地区)镇",_curtime ];
            
            [_headArray addObject:strh1];
            [_warnArray addObject:strc1];
            
        }
        if ([str13 isEqual:@"1"]){
            NSString *strc1=[NSString stringWithFormat:@"时间:%@\n信息:暴雨大风预警\n地区:%@",_datetimearray[i],_curtime1];
            NSString *strh1=[NSString stringWithFormat:@"%@  暴雨大风预警  亦庄(地区)镇",_curtime ];
            
            [_headArray addObject:strh1];
            [_warnArray addObject:strc1];
            
        }
        if ([str14 isEqual:@"1"]){
            NSString *strc1=[NSString stringWithFormat:@"时间:%@\n信息:暴雨预警\n地区:%@",_datetimearray[i],_curtime1];
            NSString *strh1=[NSString stringWithFormat:@"%@  暴雨预警  亦庄(地区)镇",_curtime ];
            
            [_headArray addObject:strh1];
            [_warnArray addObject:strc1];
            
        }
        if ([str15 isEqual:@"1"]){
            NSString *strc1=[NSString stringWithFormat:@"时间:%@\n信息:台风预警\n地区:%@",_datetimearray[i],_curtime1];
            NSString *strh1=[NSString stringWithFormat:@"%@  台风预警  亦庄(地区)镇",_curtime ];
            
            [_headArray addObject:strh1];
            [_warnArray addObject:strc1];
            
        }
 
    }

    //登录成功记录登录状态本地
    NSUserDefaults *defaultswarn = [NSUserDefaults standardUserDefaults];
    
    [defaultswarn setObject:_warnArray forKey:@"warn"];
    [defaultswarn setObject:_headArray forKey:@"warnhead"];
    [defaultswarn synchronize];
    [self addfirstView];
}

-(void)addfirstView{
    if (_winddirenArray.count>0) {
        NSString *str=_winddirenArray[0];
        [self getwindDirec:str];
        //风力
        self.fengliLabel.text=_windArray[0];
        self.windSpeedLabel.text = [NSString stringWithFormat:@"%@m/s",_windArray[0]];
        
        self.windGradeLabel.text = [NSString stringWithFormat:@"风级:%@",_windGradeArray[0]];
        
        self.i=[_windArray[0] intValue];
        if ((self.i>=0)||self.i<=40){
            if ( self.i>30) {
                self.i=30;
            }
            self.windliView.layer.transform=CATransform3DMakeRotation(M_PI/4+M_PI/20* self.i,0,0,1);
        }
        float a = [_windArray[0] floatValue];
#pragma mark --修改
        [self.windChartView getWindSpeedFromNum:a];
        NSString *temstr=[NSString stringWithFormat:@"%@℃",_temArray[0]];
        self.temputerLabel.text=temstr;
        
        NSString *timeDateStr = _datetimearray[0];

        _timeLabel.text = timeDateStr;
        
        //汉字
        NSString *winddirenstr=[NSString stringWithFormat:@"%@风",_winddircnArray[0]];
        self.windLabel.text=winddirenstr;
        
        self.weatherLabel.text = _weathertypeArray[0];
 
    }else{
        _windLabel.text=@"暂无数据";
        _weatherLabel.text=@"暂无数据";
        _temputerLabel.text=@"暂无数据";
        _fengliLabel.text=@"";
    
    }
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)sayHi:(NSNotification *)noti{
    
    int index=[noti.object intValue];
    
    self.temputerLabel.text=[NSString stringWithFormat:@"%@℃",_temArray[index]];
    //NSLog(@"%@",self.temputerLabel.text);
    self.fengliLabel.text=_windArray[index];//为圆心的风力数值显示
    NSString *timeDateStr = _datetimearray[index];

    _timeLabel.text = timeDateStr;
    
    NSString *direc=_winddirenArray[index];
    _windLabel.text=_winddircnArray[index];
    self.weatherLabel.text=_weathertypeArray[index];
    //NSLog(@"%@~~~~%@",direc,_windLabel.text);
    self.windSpeedLabel.text = [NSString stringWithFormat:@"%@m/s",_windArray[index]];
    self.windGradeLabel.text = [NSString stringWithFormat:@"风级:%@",_windGradeArray[index]];//圆心风级数值显示
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"str" object:_winddirenArray];
    [self getwindDirec:direc];
    float a=[self.fengliLabel.text floatValue];
#pragma mark--修改
    [self.windChartView getWindSpeedFromNum:a];
    if ( (a>=0)||a<=40) {
        if (a>30) {
            a=30;
        }
        self.windliView.layer.transform=CATransform3DMakeRotation(M_PI/4+M_PI/20*a, 0, 0, 1);
    }
}

-(void)getwindDirec:(NSString*)str{
    if ([str isEqualToString:@"N"]) {
        self.j = 0;
    } else if ([str isEqualToString:@"NNE"]) {
        self.j = 1;
    } else if ([str isEqualToString:@"NE"]) {
        self.j = 2;
    } else if ([str isEqualToString:@"ENE"]) {
        self.j = 3;
    } else if ([str isEqualToString:@"E"]) {
        self.j = 4;
    } else if ([str isEqualToString:@"ESE"]) {
        self.j= 5;
    } else if ([str isEqualToString:@"SE"]) {
        self.j = 6;
    } else if ([str isEqualToString:@"SSE"]) {
        self.j = 7;
    } else if ([str isEqualToString:@"S"]) {
        self.j = 8;
    } else if ([str isEqualToString:@"SSW"]) {
        self.j = 9;
    } else if ([str isEqualToString:@"SW"]) {
        self.j = 10;
    } else if ([str isEqualToString:@"WSW"]) {
        self.j = 11;
    } else if ([str isEqualToString:@"W"]) {
        self.j = 12;
    } else if ([str isEqualToString:@"WNW"]) {
        self.j = 13;
    } else if ([str isEqualToString:@"NW"]) {
        self.j = 14;
    } else if ([str isEqualToString:@"NNW"]) {
        self.j = 15;
    }
    
    //风向
    if ( (self.j>=0)||self.j<=16) {
        
        self.windxiangView.layer.transform=CATransform3DMakeRotation(M_PI/8*self.j, 0, 0, 1);
    }
    
    
}
-(void)warning{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(warninfoViewdelegate)]) {
        [self.delegate warninfoViewdelegate];
    }
}
//设置风向
-(void)setValueFX{
    
    //添加风向 目前16个
    _windxiangView=[[UIView alloc]initWithFrame:AdaptCGRectMake(55,88, 30,30)];
    _windxiangView.backgroundColor=[UIColor clearColor];
    _iamge2=[[UIImageView  alloc]initWithFrame:AdaptCGRectMake(11, 8,8,14)];
    [_iamge2 setImage:[UIImage imageNamed:@"small_pointer@2x"]];
    _windxiangView.layer.anchorPoint=CGPointMake(0.5, 0.5);
    if ( (_j>=0)||_j<=16) {
        _windxiangView.layer.transform=CATransform3DMakeRotation(M_PI/8*_j, 0, 0, 1);
    }
    [_windxiangView addSubview:_iamge2];
}




-(void)dealloc
{
    
}


@end
