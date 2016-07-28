//
//  SeaTarvelView.m
//  tableview
//
//  Created by Goldwind on 16/2/18.
//  Copyright © 2016年 Goldwind. All rights reserved.
//

#import "SeaTarvelView.h"
#import "SeaTravelModel.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "RightTableViewCell.h"


@interface SeaTarvelView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SeaTarvelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
    }
    return self;
}

#pragma mark --懒加载
-(NSMutableArray *)seaDataArray{
    if (_seaDataArray == nil) {
        _seaDataArray = [[NSMutableArray alloc]init];
    }
    return _seaDataArray;
}



#pragma mark --数据请求
-(void)loadData{
    [self loadLeftBoatView];
    
    //解决tableView分割线左边不到边的情况
    if ([self.leftBoatView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.leftBoatView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.leftBoatView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.leftBoatView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    if (self.seaDataArray.count>0) {
        [self.seaDataArray removeAllObjects];
    }
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *nextDate = [NSDate dateWithTimeInterval:72*60*60 sinceDate:currentDate];
    NSString *nextDateStr = [dateFormatter stringFromDate:nextDate];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
    NSString *loadStr = [NSString stringWithFormat:@"http://54.223.190.36:8092/api/PublicWeather/SafeWindow/5EE567DF-337D-4D68-97B0-8764A42B4428/%@/%@/1",currentDateStr,nextDateStr];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:loadStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rootDict = responseObject;
        NSArray *rootArray = [rootDict objectForKey:@"Transportations"];
        for (NSDictionary *dict in rootArray) {
            SeaTravelModel *seaModel = [SeaTravelModel objectWithKeyValues:dict];
            [self.seaDataArray addObject:seaModel];
        }
        [self.leftBoatView reloadData];
        [self loadRightTimeView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"无法获取海上出行数据");
    }];
    
    
}

#pragma mark --tableview
-(void)loadRightTimeView{
    SeaTravelModel *seaModel = self.seaDataArray[0];
    int a = (int)seaModel.WindowTime.count;
    self.rightTimeView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, a*120, 200) style:UITableViewStylePlain];
    self.rightTimeView.delegate = self;
    self.rightTimeView.dataSource = self;
    self.rightTimeView.showsVerticalScrollIndicator = NO;
    self.rightTimeView.scrollEnabled = NO;
    self.rightTimeView.backgroundColor = [UIColor clearColor];
    
    if ([self.rightTimeView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.rightTimeView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.rightTimeView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.rightTimeView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    self.timeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.leftBoatView.frame.size.width, 0, self.frame.size.width - self.leftBoatView.frame.size.width, self.rightTimeView.frame.size.height)];
    self.timeScrollView.contentSize = CGSizeMake(self.rightTimeView.frame.size.width, 0);
    self.timeScrollView.bounces = NO;
    self.timeScrollView.showsHorizontalScrollIndicator = NO;
    [self.timeScrollView addSubview:self.rightTimeView];
    
    [self addSubview:self.timeScrollView];
}




-(void)loadLeftBoatView{
    self.leftBoatView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 120, 200) style:UITableViewStylePlain];
    self.leftBoatView.delegate = self;
    self.leftBoatView.dataSource = self;
    self.leftBoatView.scrollEnabled = NO;
    self.leftBoatView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.leftBoatView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.seaDataArray.count+1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorColor = [UIColor whiteColor];
    if (tableView == self.leftBoatView) {
        static NSString *boat = @"boat";
        tableView.backgroundColor = [UIColor clearColor];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:boat];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:boat];
        }
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        if (indexPath.row == 0) {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.text = @"安全出行";
        }else{
            SeaTravelModel *seaModel = self.seaDataArray[indexPath.row - 1];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.text = seaModel.TransportationName;
        }
        return cell;
    }else{
        static NSString *seaTravelTime = @"seaTravelTime";
        RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:seaTravelTime];
        if (cell == nil) {
            cell = [[RightTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:seaTravelTime];
        }
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        if (indexPath.row == 0) {
            [cell createCellTitleWithDataArray:self.seaDataArray];
        }else{
            [cell createTravelTimeCellWithDataArray:self.seaDataArray WithNumber:indexPath.row-1];
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
