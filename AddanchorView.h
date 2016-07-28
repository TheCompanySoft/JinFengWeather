//
//  AddanchorView.h
//  自学BMK
//
//  Created by huake on 15/10/29.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddanchorViewdelegate <NSObject>
- (void)cancelanchorviewdelegate;
- (void)saveanchorActiondelegate;
@end
@interface AddanchorView : UIView
@property(nonatomic,assign)id delegate;

@property(nonatomic,strong)UITextField*leftCityTF1;
@property(nonatomic,strong)UITextField*rightCityTF1;
@property(nonatomic,strong)UITextField*startAdressTF1;
@property(nonatomic,strong)UITextField*leftCityTF;
@property(nonatomic,strong)UITextField*rightCityTF;

@end
