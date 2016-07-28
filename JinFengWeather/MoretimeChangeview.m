//
//  Moretimeview.m
//  JinFengWeather
//
//  Created by huake on 15/10/30.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//时间切换界面

#import "MoretimeChangeview.h"
#import "Header.h"
#import "UIUtils.h"
@implementation MoretimeChangeview
-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        /**
         *  添加内容视图
         */
        [self addContentview];
    }
    return self;
}
/**
 *  添加内容视图
 */
-(void)addContentview{
    NSArray *arr=@[@"1小时",@"3小时",@"6小时",@"12小时"];
    int count=0;
    self.buttons =[NSMutableArray array];
    for (int i=0; i<2; i++) {
        for ( int j=0; j<2; j++) {
            _temp =[UIButton buttonWithType:UIButtonTypeCustom];
            _temp.frame=AdaptCGRectMake(j*120+15, i*50+10,100, 40);
            _temp.tag=count;
            //默认选中一小时的按钮
            if (i==0&&j==0) {
                _temp.selected=YES;
                _temp.backgroundColor=[UIColor colorWithWhite:0.2 alpha:0.7];
            }
            NSString *index=[NSString stringWithFormat:@"间隔%@",[arr objectAtIndex:count++]];
            [_temp setTitle:index forState:UIControlStateNormal];
            _temp.titleLabel.font=[UIFont systemFontOfSize:15];
            _temp.layer.cornerRadius=5;
            [_temp addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_buttons addObject:_temp];
            [self addSubview:_temp];
        }
    }
}
/**
 *
 *
 *  @param sender 按钮点击方法
 */
-(void)clickBtn:(UIButton*)sender{
        sender.backgroundColor=[UIColor colorWithWhite:0.15 alpha:0.8];
       for (UIButton *temp in _buttons) {
       if (temp.selected && temp !=sender) {
            temp.selected =NO;
            temp.backgroundColor=[UIColor clearColor];
       }
    }
    sender.selected =YES;
 
    if (self.delegate &&[self.delegate respondsToSelector:@selector(moretime:)]) {
        [self.delegate moretime:sender];
    }
    }

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
