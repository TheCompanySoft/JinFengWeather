//
//  CollectionViewCell.m
//  CollectView
//
//  Created by 陈晨 on 15/7/17.
//  Copyright (c) 2015年 ice. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lable = [[UILabel alloc]init];
        self.imageView = [[UIImageView alloc]init];

        [self addSubview:self.lable];
        [self addSubview:self.imageView];

    }
    return self;
}

@end
