//
//  SeaTarvelView.h
//  tableview
//
//  Created by Goldwind on 16/2/18.
//  Copyright © 2016年 Goldwind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeaTarvelView : UIView

@property (nonatomic,strong)UITableView *leftBoatView;

@property (nonatomic,strong)UITableView *rightTimeView;

@property (nonatomic,strong)UIScrollView *timeScrollView;

/**
 *  存储所有船只信息
 */
@property (nonatomic,strong)NSMutableArray *seaDataArray;



@end
