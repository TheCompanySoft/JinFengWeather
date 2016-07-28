//
//  RightTableViewCell.m
//  tableview
//
//  Created by Goldwind on 16/2/19.
//  Copyright © 2016年 Goldwind. All rights reserved.
//



#import "RightTableViewCell.h"
#import "SeaTravelModel.h"
#import "WindowTimeModel.h"
#import "TimeRangeModel.h"


@implementation RightTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


#pragma mark --懒加载
-(NSMutableArray *)seaTravelArrray{
    if (_seaTravelArrray == nil) {
        _seaTravelArrray = [[NSMutableArray alloc]init];
    }
    return _seaTravelArrray;
}

-(void)createTravelTimeCellWithDataArray:(NSMutableArray *)travelArray WithNumber:(NSInteger)row{
    if (self.seaTravelArrray.count > 0) {
        [self.seaTravelArrray removeAllObjects];
    }
    self.seaTravelArrray = travelArray;
    int i = 0;
    SeaTravelModel *seaModel = travelArray[row];
    for (WindowTimeModel *windowModel in seaModel.WindowTime) {
        if (windowModel.WindowTimeRange.count > 1) {
            UILabel *seaLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(120*i, 0, 120, 25)];
            seaLabel1.textAlignment = NSTextAlignmentCenter;
            seaLabel1.textColor = [UIColor whiteColor];
            TimeRangeModel *model1 = windowModel.WindowTimeRange[0];
            NSMutableString *timeStr1 = [NSMutableString stringWithFormat:@"%@:00~%@:00",model1.BeginTime,model1.EndTime];
            seaLabel1.text = timeStr1;
            
            UILabel *seaLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(120*i, 25, 120, 25)];
            seaLabel2.textAlignment = NSTextAlignmentCenter;
            seaLabel2.textColor = [UIColor whiteColor];
            TimeRangeModel *model2 = windowModel.WindowTimeRange[1];
            NSMutableString *timeStr2 = [NSMutableString stringWithFormat:@"%@:00~%@:00",model2.BeginTime,model2.EndTime];
            seaLabel2.text = timeStr2;
            
            [self.contentView addSubview:seaLabel1];
            [self.contentView addSubview:seaLabel2];
            
        }else{
            UILabel *seaLabel = [[UILabel alloc]initWithFrame:CGRectMake(120*i, 0, 120, 50)];
            seaLabel.textAlignment = NSTextAlignmentCenter;
            seaLabel.textColor = [UIColor whiteColor];
            for (TimeRangeModel *model in windowModel.WindowTimeRange) {
                NSMutableString *timeStr = [NSMutableString stringWithFormat:@"%@:00~%@:00",model.BeginTime,model.EndTime];
                seaLabel.text = timeStr;
                [self.contentView addSubview:seaLabel];
            }
        }
        i++;
    }
}

-(void)createCellTitleWithDataArray:(NSMutableArray *)travelArray{
    if (self.seaTravelArrray.count > 0) {
        [self.seaTravelArrray removeAllObjects];
    }
    SeaTravelModel *seaModel = travelArray[0];
    int i = 0;
    for (WindowTimeModel *windowModel in seaModel.WindowTime) {
        UILabel *seaLabel = [[UILabel alloc]initWithFrame:CGRectMake(120*i, 0, 120, 50)];
        seaLabel.textAlignment = NSTextAlignmentCenter;
        seaLabel.textColor = [UIColor whiteColor];
        seaLabel.text = windowModel.Date;
        [self.contentView addSubview:seaLabel];
        i++;
    }
}



@end
