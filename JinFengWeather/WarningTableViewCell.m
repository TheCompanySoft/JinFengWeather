//
//  WarningTableViewCell.m
//  JinFengWeather
//
//  Created by Goldwind on 16/3/1.
//  Copyright © 2016年 HKSoft. All rights reserved.
//

#import "WarningTableViewCell.h"

#define k_UIScreen_FRAME ( [[UIScreen mainScreen] applicationFrame].size)

@implementation WarningTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCellUI];
    }
    return self;
}

-(void)createCellUI{
    UIView *backGroundView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, k_UIScreen_FRAME.width-20, 70)];
    backGroundView.layer.borderWidth = 1;
    backGroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    backGroundView.layer.cornerRadius = 10;
    [self.contentView addSubview:backGroundView];
    
    _warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 2, backGroundView.frame.size.width - 55, backGroundView.frame.size.height)];
    _warnLabel.textColor = [UIColor whiteColor];
    _warnLabel.numberOfLines = 0;
    [backGroundView addSubview:_warnLabel];
    
    _warnView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 35, 31)];
    [backGroundView addSubview:_warnView];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
