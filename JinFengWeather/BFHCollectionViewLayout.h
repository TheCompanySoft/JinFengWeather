//
//  DayArrayinfo.h
//  网络请求—AFNetworking
//
//  Created by huake on 15/9/28.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GLCollectionViewLayoutTop;

@protocol UICollectionViewDelegateDelegate <UICollectionViewDelegate>
@optional
-(CGSize)cellWith:(UICollectionView*)collectionView;

@end

@interface BFHCollectionViewLayout : UICollectionViewFlowLayout

@end
