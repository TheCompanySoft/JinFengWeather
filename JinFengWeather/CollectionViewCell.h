//
//  CollectionViewCell.h
//  CollectView
//
//  Created by 陈晨 on 15/7/17.
//  Copyright (c) 2015年 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
//cell中添加文字
@property (nonatomic,strong)UILabel *lable;
//添加选中图片imageview
@property (nonatomic,strong)UIImageView *imageView;

@end
