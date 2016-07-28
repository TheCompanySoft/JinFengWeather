//
//  RightTableViewCell.h
//  tableview
//
//  Created by Goldwind on 16/2/19.
//  Copyright © 2016年 Goldwind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightTableViewCell : UITableViewCell

/**
 *  根据传输的数据来创建cell内容
 *
 *  @param travelArray 安全出行数据
 */
-(void)createTravelTimeCellWithDataArray:(NSMutableArray *)travelArray WithNumber:(NSInteger)row;


-(void)createCellTitleWithDataArray:(NSMutableArray *)travelArray;


@property (nonatomic,strong)NSMutableArray *seaTravelArrray;

@end
