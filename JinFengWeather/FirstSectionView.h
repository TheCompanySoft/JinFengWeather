//
//  FirstSectionView.h
//  JinFengWeather
//
//  Created by huake on 15/11/7.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol First1SectionViewdelegate <NSObject>
-(void)firseSectiondelegate;

@end

@interface FirstSectionView : UIView
@property(nonatomic,assign)id delegate;
@end
