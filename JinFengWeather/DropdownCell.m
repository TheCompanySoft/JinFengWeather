//
//  MidViewCell.m
//  JinFengWeather
//
//  Created by huake on 15/10/26.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//点击section上的按钮，下拉出一个cell

#import "DropdownCell.h"
#import "Header.h"
#import "UIUtils.h"
#import "DayArrayinfo.h"
#import "WindPlantModel.h"

@interface DropdownCell ()
{
    //温度
    NSMutableArray *_temArray;
    //风力
    NSMutableArray *_windArray;
    //风向
    NSMutableArray *_fengxiangArray;
    //湿度
    NSMutableArray *_shiduArray;
    //降雪
    NSMutableArray *_snowArray;
    //降雨
    NSMutableArray *_rainArray;
    
   // NSMutableArray *_snowarr;
  //  NSMutableArray *_rainarr;
    NSDictionary *dicDC;
    //温度label
    UILabel *_labeltem;
    //降雨label
    UILabel *_labelrain;
    //风
    UILabel *_labelwind;
    //湿度label
    UILabel *_labelshidu;
    //降雪label
    UILabel *_labelsnow;
    //风向label
    UILabel *_labelfengxiang;
    //
    UILabel *_labeltems;
    UILabel *_labelsnows;
    UILabel *_labeltem8;
}
@property(nonatomic,strong)UIView *midTableView;
@end

@implementation DropdownCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        //_midTableView= [[UIView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 0)];
        //温度
        _temArray=[NSMutableArray array];
        //风
        _windArray=[NSMutableArray array];
        //湿度
        _shiduArray=[NSMutableArray array];
        //风向
        _fengxiangArray=[NSMutableArray array];
        //雪
        _snowArray=[NSMutableArray array];
        //雨
        _rainArray=[NSMutableArray array];
//        _snowarr=[NSMutableArray array];
//        _rainarr=[NSMutableArray array];
        
    }
    return self;
}
//中间
-(void)addContentVew{
    if (_midTableView==nil) {
        _midTableView= [[UIView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 0)];
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sayHi:) name:@"1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sayHi1:) name:@"str12" object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sayHi2:) name:@"hour" object:nil];
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sayHi12:) name:@"hour12" object:nil];
    
    //画图表
    for (int i=0; i<=3; i++) {
        UIView *linView =[[UIView alloc]initWithFrame:CGRectMake(0.1, i*[UIUtils getWindowHeight]/3.33/3, [UIUtils getWindowWidth]-1, 1)];
        linView.backgroundColor=[UIColor whiteColor];
        [_midTableView addSubview:linView];
        UIView *linView1 =[[UIView alloc]initWithFrame:CGRectMake([UIUtils getWindowWidth]/3*i-0.5, 0, 1, [UIUtils getWindowHeight]/3.33)];
        linView1.backgroundColor=[UIColor whiteColor];
        [_midTableView addSubview:linView1];
    }
    NSArray *lableArray=[NSArray arrayWithObjects:@"温度(℃)",@"湿度(%)",@"降水量(mm/h)",@"降水量(mm/12h)",@"降雪量(mm/h)",@"降雪量(mm/12h)",@"风速(m/s)",@"风向",@"",nil];
    int count =0;
    for (int j=0; j<3; j++) {
        for (int i=0; i<3; i++) {
            UILabel *label =[[UILabel alloc]initWithFrame:AdaptCGRectMake(i*320/3+5, j*568/3.33/3, 100,25)];
            label.text=[lableArray objectAtIndex:count];
            label.textAlignment=NSTextAlignmentCenter;
            label.textColor=[UIColor whiteColor];
            label.font=[UIFont systemFontOfSize:14];
            label.adjustsFontSizeToFitWidth=YES;
            count++;
            [_midTableView addSubview:label];
        }
    }
    _labeltem =[[UILabel alloc]initWithFrame:AdaptCGRectMake(0*320/3+5, 0*170/3+25,100,25)];
    if (_labeltem.text!=nil) {
        _labeltem.text=nil;
    }
    //温度
    _labeltem.text=@"0.0";
    _labeltem.font =[UIFont systemFontOfSize:15];
    _labeltem.textAlignment=NSTextAlignmentCenter;
    _labeltem.textColor=[UIColor whiteColor];
    [_midTableView addSubview:_labeltem];
    //雨
    _labelrain =[[UILabel alloc]initWithFrame:AdaptCGRectMake(0*320/3+5, 1*170/3+25,100,25)];
    _labelrain.text=@"0.0";
    _labelrain.font =[UIFont systemFontOfSize:15];
    _labelrain.textAlignment=NSTextAlignmentCenter;
    _labelrain.textColor=[UIColor whiteColor];
    [_midTableView addSubview:_labelrain];
    //风
    _labelwind =[[UILabel alloc]initWithFrame:AdaptCGRectMake(0*320/3+5, 2*170/3+25,100,25)];
    _labelwind.text=@"0.0";
    _labelwind.font =[UIFont systemFontOfSize:15];
    _labelwind.textAlignment=NSTextAlignmentCenter;
    _labelwind.textColor=[UIColor whiteColor];
    [_midTableView addSubview:_labelwind];
    _labelshidu =[[UILabel alloc]initWithFrame:AdaptCGRectMake(1*320/3+5, 0*170/3+25,100,25)];
    //湿度
    _labelshidu.text=@"0.0";
    _labelshidu.font =[UIFont systemFontOfSize:15];
    _labelshidu.textAlignment=NSTextAlignmentCenter;
    _labelshidu.textColor=[UIColor whiteColor];
    [_midTableView addSubview:_labelshidu];
    //雪
    _labelsnow =[[UILabel alloc]initWithFrame:AdaptCGRectMake(1*320/3+5, 1*170/3+25,100,25)];
    _labelsnow.text=@"0.0";
    _labelsnow.font =[UIFont systemFontOfSize:15];
    _labelsnow.textAlignment=NSTextAlignmentCenter;
    _labelsnow.textColor=[UIColor whiteColor];
    [_midTableView addSubview:_labelsnow];
    
    //风向暂无
    _labelfengxiang =[[UILabel alloc]initWithFrame:AdaptCGRectMake(1*320/3+5, 2*170/3+25,100,25)];
    _labelfengxiang.text=@"0.0";
    _labelfengxiang.font =[UIFont systemFontOfSize:15];
    _labelfengxiang.textAlignment=NSTextAlignmentCenter;
    _labelfengxiang.textColor=[UIColor whiteColor];
    [_midTableView addSubview:_labelfengxiang];
    _labeltems =[[UILabel alloc]initWithFrame:AdaptCGRectMake(2*320/3+5, 0*170/3+25,100,25)];
    
    _labeltems.text=@"0.0";
    _labeltems.font =[UIFont systemFontOfSize:15];
    _labeltems.textAlignment=NSTextAlignmentCenter;
    _labeltems.textColor=[UIColor whiteColor];
    [_midTableView addSubview:_labeltems];
    _labelsnows =[[UILabel alloc]initWithFrame:AdaptCGRectMake(2*320/3+5,1*170/3+25,100,25)];
    
    _labelsnows.text=@"0.0";
    _labelsnows.font =[UIFont systemFontOfSize:15];
    _labelsnows.textAlignment=NSTextAlignmentCenter;
    _labelsnows.textColor=[UIColor whiteColor];
    [_midTableView addSubview:_labelsnows];
    if (_temArray.count>0) {
        _labeltem.text=_temArray[0];
        _labelrain.text=_rainArray[0];
        _labelwind.text=_windArray[0];
        
        _labelshidu.text=_shiduArray[0];
        _labelsnow.text=_snowArray[0];
        
        _labelfengxiang.text=_fengxiangArray[0];
        _labeltems.text=_rainArray[12];
        _labelsnows.text=_snowArray[12];
    }
    [self addSubview:_midTableView];
}
//利用通知将数组的索引传给数组获取对应的参数
-(void)sayHi:(NSNotification *)noti
{
   
    int index=[noti.object intValue];

    if (_labeltem.text!=nil) {
        _labeltem.text=nil;
        _labeltem.text=_temArray[index];
    }
    if (_labelwind.text!=nil) {
        _labelwind.text=nil;
        _labelwind.text=_windArray[index];
    }
    if (_labelshidu.text!=nil) {
        _labelshidu.text=nil;
        _labelshidu.text=_shiduArray[index];
        
    }
    if (_labelfengxiang.text!=nil) {
        _labelfengxiang.text=nil;
        _labelfengxiang.text=_fengxiangArray[index];
    }
    
}

-(void)sayHi1:(NSNotification *)noti{
    
    _labelshidu.text=noti.object;
    
}
//-(void)sayHi2:(NSNotification *)noti{
//    int a =[noti.object intValue];
//    
//    _labelsnow.text=_snowArray[a];
//    _labeltems.text=_rainArray[a];
//    
//  
//}
//-(void)sayHi12:(NSNotification *)noti{
//    int a =[noti.object intValue];
//    
//    int c=a;
//        _labelsnows.text=_snowArray[c];
//        _labelwind.text=_rainArray[c];
//}
/**
 *  将数据存放在数组中
 *
 *  @param weaterInfo 获取数据
 */
-(void)getcontent:(NSMutableArray *)dataArray WithFlag:(int)flag{
    
    if (flag == 0) {
        for (DayArrayinfo*dainfo in dataArray) {
            
            
            if ([dainfo.wdir_cn isEqual:[NSNull null]])
            {
                dainfo.wdir_cn=@"无数据";
            }
            [_windArray addObject:dainfo.wspd];
            [_temArray addObject:dainfo.Td2m];
            [_fengxiangArray addObject:dainfo.wdir_cn];
            [_shiduArray addObject:dainfo.RH2m];
            [_snowArray addObject:dainfo.snow];
            [_rainArray addObject:dainfo.rain];
            
        }
    }else if (flag != 0){
        for (WindPlantModel *windPlantModel in dataArray) {
            if ([windPlantModel.wdir_cn isEqual:[NSNull null]]) {
                windPlantModel.wdir_cn = @"无数据";
            }
            [_windArray addObject:windPlantModel.WindSpeed];
            [_temArray addObject:windPlantModel.Td2m];
            [_fengxiangArray addObject:windPlantModel.wdir_cn];
            [_shiduArray addObject:windPlantModel.RH2m];
            [_snowArray addObject:windPlantModel.snow];
            [_rainArray addObject:windPlantModel.rain];
        }
    }

    [self addContentVew];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"1" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"str12" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addindex" object:nil];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
