//
//  HKalertView.h
//  自学BMK
//
//  Created by huake on 15/10/20.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKalertViewdelegate <NSObject>
- (void)cancelviewdelegate;
- (void)saveActiondelegate;
@end

@interface HKalertView : UIView
@property(nonatomic,assign)id delegate;
@property(nonatomic,strong)UITextField*startAdressTF;
@property(nonatomic,strong)UITextField*leftCityTF;
@property(nonatomic,strong)UITextField*rightCityTF;

@end
