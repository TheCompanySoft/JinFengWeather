//
//  MainOneChart.h
//  JinFengWeather
//
//  Created by huake on 15/11/4.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFHCollectionViewLayout.h"
#import "BFHChartCell.h"

@protocol GLLineChartViewDataSource <NSObject>

//cell数量
-(NSInteger)numberOfItemsInSection:(NSInteger)section;
//获取数据对象
-(HFHChartDomain*)chartDomainOfIndex:(NSIndexPath*)indexPath;
@end

@interface MainFifteenminutesChart : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
}

@property(nonatomic,strong)NSMutableArray*windArray;
@property(nonatomic,strong)NSMutableArray*temArray;
/**
 *  存储Y轴移动的日期时间
 */
@property(nonatomic,strong)NSMutableArray*dateArray;
/**
 *  存储X轴横坐标 小时时间
 */
@property (nonatomic,strong)NSMutableArray *hourArray;

-(void)initWith:(NSMutableArray*)windArray and:(NSMutableArray*)temArray and:(NSMutableArray*)dateArray andHourArray:(NSMutableArray *)hourArray;
@property (nonatomic,assign) id<GLLineChartViewDataSource> dataSource;
//刷新
-(void)reloadData;

-(void)updateVisible;


@end
