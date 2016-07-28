//
//  MainTwoChart.h
//  JinFengWeather
//
//  Created by huake on 15/11/4.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFHCollectionViewLayout.h"
#import "BFHChartCell.h"

@protocol GLLineChartViewDataSource1 <NSObject>

-(NSInteger)numberOfItemsInSection:(NSInteger)section;

-(HFHChartDomain*)chartDomainOfIndex:(NSIndexPath*)indexPath;
@end

@interface MainOnehoursChart : UIView
<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
}

@property(nonatomic,strong)NSMutableArray*windArray;
@property(nonatomic,strong)NSMutableArray*temArray;
@property(nonatomic,strong)NSMutableArray*dateArray;

-(void)initWith:(NSMutableArray*)windArray and:(NSMutableArray*)temArray and:(NSMutableArray*)dateArray;
@property (nonatomic,assign) id<GLLineChartViewDataSource1> dataSource;

-(void)reloadData;

-(void)updateVisible;

@end
