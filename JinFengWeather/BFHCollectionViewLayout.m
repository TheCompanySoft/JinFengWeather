//
//  DayArrayinfo.h
//  网络请求—AFNetworking
//
//  Created by huake on 15/9/28.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//collectionView的布局

#import "BFHCollectionViewLayout.h"
#define STATUS_BAR_OFFSET 0
#import "UIUtils.h"
NSString *const GLCollectionViewLayoutTop = @"GLCollectionViewLayoutTop";
@interface BFHCollectionViewLayout ()
{
    NSMutableDictionary *_indexDictionary;
}

@end
@implementation BFHCollectionViewLayout
//cell的尺寸
-(CGSize)cellSize
{
    return CGSizeMake([UIUtils getWindowWidth]/5, self.collectionView.bounds.size.height);
}
//宽度
-(CGFloat)cellWidth
{
    return [UIUtils getWindowWidth]/5;
}
-(void)prepareLayout
{
    [super prepareLayout];
    _indexDictionary = [NSMutableDictionary dictionary];
    NSInteger index  =  0;
    for (NSInteger section = 0;section < [self.collectionView numberOfSections] ; section ++) {
        for (NSInteger item = 0 ; item < [self.collectionView numberOfItemsInSection:section]; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            [_indexDictionary setObject:indexPath forKey:[NSNumber numberWithInteger:index]];
            index++;
        }
            }
}
//collection的变化
-(CGSize)collectionViewContentSize
{
    NSInteger sectionNumber = [self.collectionView numberOfSections];
    CGFloat width = 0 ;
    for(NSInteger section =0;section < sectionNumber;section++){
        NSInteger items = [self.collectionView numberOfItemsInSection:section];
        width = width + items*[self cellWidth];
    }
    return  CGSizeMake(width, self.collectionView.bounds.size.height);
}
//collectionView 的布局属性
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath
{
    return [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:elementIndexPath];
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [self preLayoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    attribute = [self postLayoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    return attribute;
}

-(UICollectionViewLayoutAttributes *)preLayoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes *attribute  =  [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    CGFloat offsetX = 0;
    
    for (NSInteger section = 0; section < indexPath.section ; section ++) {
        NSInteger itemsNumber =[ self.collectionView numberOfItemsInSection:section];
        CGFloat sectionWith = [self cellWidth] * itemsNumber;
        offsetX = offsetX + sectionWith;
    }
    
    NSInteger thisIndexPathItems =[ self.collectionView numberOfItemsInSection:indexPath.section];
    CGFloat sectionWith = [self cellWidth] * thisIndexPathItems;
    attribute.frame = CGRectMake(offsetX, STATUS_BAR_OFFSET,sectionWith , 0);
    return attribute;
}

-(UICollectionViewLayoutAttributes *)postLayoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [self preLayoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
   
    return attribute;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attrs = [NSMutableArray array];
    //start offset
    CGFloat startXOffset = rect.origin.x;
    NSInteger startIndex = startXOffset/[self cellWidth] -1;
    if(startIndex < 0){
        startIndex = 0;
    }
    //end offset
    CGFloat endXOffset = rect.origin.x + rect.size.width;
    NSInteger endIndex= endXOffset/[self cellWidth];
    if(endXOffset < [self.collectionView contentSize].width){
         endIndex = endIndex + 1;
    }
    //for update index
    for (NSInteger index  = startIndex; index <= endIndex  ;  ++index) {
        NSIndexPath *indexPath = [_indexDictionary objectForKey:[NSNumber numberWithInteger:index]];
        if(indexPath == nil){
            continue;
        }
        if(indexPath.item == 0 || index == startIndex){
            UICollectionViewLayoutAttributes *sectionAttr = [self layoutAttributesForSupplementaryViewOfKind:GLCollectionViewLayoutTop atIndexPath:indexPath];
            [attrs addObject:sectionAttr];
        }
        UICollectionViewLayoutAttributes *itemAttr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attrs addObject:itemAttr];
    }
    return attrs;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute =  [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat offsetX = 0;
    offsetX = offsetX + indexPath.item * [UIUtils getWindowWidth]/5;
    attribute.frame = CGRectMake(offsetX, 0, [UIUtils getWindowWidth]/5, self.collectionView.bounds.size.height);
    
    return attribute;
}

@end
