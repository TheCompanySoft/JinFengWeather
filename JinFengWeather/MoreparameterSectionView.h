//
//  SecondSectionView.h
//  JinFengWeather
//
//  Created by huake on 15/11/7.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SecondSectionViewdelegate <NSObject>
-(void)secondSection:(UIButton*)sender;

@end

@interface MoreparameterSectionView : UIView
@property(nonatomic ,strong)NSMutableArray *buttons;
@property(nonatomic ,strong)NSArray *iconArray;
@property(nonatomic ,strong)UILabel *marklabel;
@property(nonatomic ,strong)UIButton *temp;
@property(nonatomic ,strong) UIImage * images;
@property(nonatomic ,strong)UIImageView *imageView;;
@property(nonatomic ,strong)UILabel *percentLabel;
@property(nonatomic ,strong)NSString *strValue;
@property(nonatomic,assign)id delegate;


-(void)addContentViewWithFlag:(int)flag;

@end
