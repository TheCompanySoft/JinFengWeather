
//
//  MainOneChart.m
//  JinFengWeather
//
//  Created by huake on 15/11/4.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//15分钟的双折线

#import "MainFifteenminutesChart.h"
#import "Header.h"
#import "UIUtils.h"
#import "DayArrayinfo.h"
#import "HFHChartDomain.h"
@interface MainFifteenminutesChart ()<UIScrollViewDelegate>
{
    UIView *_lineView;
    UILabel * labely ;
}
@property(nonatomic ,strong)UILabel*windSu;
@property(nonatomic ,strong)UILabel*datelabel;
@property(nonatomic ,strong)UILabel*temperlabel;
@property(nonatomic,assign) double max;
@property(nonatomic,assign)double a;
@end
#define  CELL_INDENTIFIER @"ChartCell"
#define  HEAD_INDENTIFIER @"ChartHeader"
@implementation MainFifteenminutesChart
-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        //初始化数组
        _windArray=[NSMutableArray array];
        _temArray=[NSMutableArray array];
        _dateArray=[NSMutableArray array];
        _hourArray = [NSMutableArray array];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
       [self initial];
    }
    return self;
}
-(void)initWith:(NSMutableArray*)windArray and:(NSMutableArray*)temArray and:(NSMutableArray*)dateArray andHourArray:(NSMutableArray *)hourArray{
    self.windArray=windArray;
    self.temArray=temArray;
    self.dateArray=dateArray;
   
    self.hourArray = hourArray;
    
    [self initial];

}
//初始化加载内容视图
-(void)initial
{
    
    for(UIView *view in [_collectionView subviews])
    {
        [view removeFromSuperview];
    }
    if (_collectionView) {
        [_collectionView removeFromSuperview];
    }
    
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,[UIUtils getWindowHeight]/2-50) collectionViewLayout:[[BFHCollectionViewLayout alloc] init] ];
        _collectionView.delegate=self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[BFHChartCell class] forCellWithReuseIdentifier:CELL_INDENTIFIER];
        _collectionView.bounces=NO;
        _collectionView.showsHorizontalScrollIndicator =NO;
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self addSubview:_collectionView];
         [self sendSubviewToBack:_collectionView];
    
   
    [self setYLabels];
   
    for(UIView *view in [_lineView subviews])
    {
        [view removeFromSuperview];
    }
    if (_lineView) {
        [_lineView removeFromSuperview];
    }
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[UIUtils getWindowWidth]/5,[UIUtils getWindowHeight]/2-50-10*[UIUtils getWindowHeight]/568)] ;
    _lineView.backgroundColor=[UIColor clearColor];
    [self addSubview:_lineView];
    _windSu=[[UILabel alloc]init];
    if (_windArray.count>0) {
        NSString *str=[NSString stringWithFormat:@"%@m/s",[self.windArray objectAtIndex:0]];
         _windSu.text=str;
    }
   
   
     _windSu.font=[UIFont systemFontOfSize:10];
    _windSu.layer.cornerRadius=4;
    _windSu.layer.masksToBounds=YES;
    _windSu.textAlignment=NSTextAlignmentCenter;
    CGSize sizeThatFit=[_windSu sizeThatFits:CGSizeZero];
    //重新指定frame
    _windSu.frame=AdaptCGRectMake(35, 13, sizeThatFit.width, 10);
    _windSu.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.2];
    _windSu.textColor=[UIColor yellowColor];
    [_lineView addSubview:_windSu];

    _temperlabel=[[UILabel alloc]init];
    _temperlabel.textAlignment=NSTextAlignmentCenter;
    _temperlabel.backgroundColor=[UIColor clearColor];
     _temperlabel.font=[UIFont systemFontOfSize:10];
    if (_temArray.count>0) {
        NSString *strr=[self.temArray objectAtIndex:0];
        NSString *str1=[NSString stringWithFormat:@"%@℃",strr];
        _temperlabel.text=str1;
    }
   
    CGSize sizeThatFit1=[_temperlabel sizeThatFits:CGSizeZero];
    _temperlabel.frame=AdaptCGRectMake(35, 2,sizeThatFit1.width, 10);
    _temperlabel.layer.cornerRadius=4;
    _temperlabel.layer.masksToBounds=YES;
    _temperlabel.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.2];
    _temperlabel.adjustsFontSizeToFitWidth=YES;
    _temperlabel.textColor=[UIColor colorWithRed:5/255.0 green:251/255.0 blue:250/255.0 alpha:1];
    [_lineView addSubview:_temperlabel];
    
    _datelabel=[[UILabel alloc]init];
    _datelabel.textAlignment=NSTextAlignmentCenter;
    _datelabel.backgroundColor=[UIColor clearColor];
    _datelabel.font=[UIFont systemFontOfSize:10];
#pragma mark 修改x轴和滑动线时间显示
    if (_temArray.count>0) {
        NSString *str=[self.dateArray objectAtIndex:0];
        
        _datelabel.text=str;
    }
 
    CGSize sizeThatFitd=[_datelabel sizeThatFits:CGSizeZero];
    _datelabel.frame=AdaptCGRectMake(35,25,sizeThatFitd.width, 10);
    _datelabel.layer.cornerRadius=4;
    _datelabel.layer.masksToBounds=YES;
    _datelabel.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.2];
    _datelabel.adjustsFontSizeToFitWidth=YES;
    _datelabel.textColor=[UIColor yellowColor];
    [_lineView addSubview:_datelabel];
    //线所在的View
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(_lineView.frame.size.width/2, 0, 1.5*[UIUtils getWindowWidth]/320, [UIUtils getWindowHeight]/2-50-10*[UIUtils getWindowHeight]/568)];
    view.backgroundColor=[UIColor colorWithWhite:1 alpha:0.8];
    [_lineView addSubview:view];
}
//添加y轴的label
-(void)setYLabels
{
    if (labely) {
        [labely removeFromSuperview];
    }
    float level = 30/6.0;
    CGFloat chartCavanHeight = [UIUtils getWindowHeight]/2-65*[UIUtils getWindowHeight]/568;
    CGFloat levelHeight = chartCavanHeight/6.0;
    for (int i=0; i<7; i++) {
        //y轴label
       labely= [[UILabel alloc] initWithFrame:CGRectMake(5.0,chartCavanHeight-i*levelHeight, 18*[UIUtils getWindowWidth]/320, 10*[UIUtils getWindowHeight]/568)];
        labely.textColor=[UIColor whiteColor];
        labely.adjustsFontSizeToFitWidth=YES;
        labely.font=[UIFont systemFontOfSize:11];
        labely.backgroundColor=[UIColor clearColor];
        
        
            labely.text = [NSString stringWithFormat:@"%d",(int)(level * i)];
        
        [self addSubview:labely];
    }
}
//滚动线的滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point=scrollView.contentOffset;
    CGRect frame = _lineView.frame;
    NSInteger sec=0;
    _max=(double)[self numberOfitemsInSection:sec]*[UIUtils getWindowWidth]/5;
  
    _a=4*([UIUtils getWindowWidth]/5*point.x)/(_max-[UIUtils getWindowWidth]);
    
    double gv=(4*[UIUtils getWindowWidth]/5)/((_max-[UIUtils getWindowWidth]/5)/([UIUtils getWindowWidth]/5));
    //索引
   int index=_a/gv;
    if (index==287&&_windArray.count
        ==288) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"log" object:nil];
    }
    NSString *indexstr=[NSString stringWithFormat:@"%d",index];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"1" object:indexstr];
    
    NSString *str=[NSString stringWithFormat:@"%@m/s",[self.windArray objectAtIndex:index]];
    _windSu.text=str;
    NSString *str1=[NSString stringWithFormat:@"%@℃",[self.temArray objectAtIndex:index]];
    _temperlabel.text=str1;
#pragma mark 时间
    NSString *time = [self.dateArray objectAtIndex:index];

    _datelabel.text= time;
    
  if ((int)_a>150) {
      CGSize sizeThatFit=[_windSu sizeThatFits:CGSizeZero];
      //重新指定frame
      _windSu.frame=AdaptCGRectMake(sizeThatFit.width*-1+30, 13, sizeThatFit.width, 10);
      CGSize sizeThatFit1=[_temperlabel sizeThatFits:CGSizeZero];
      _temperlabel.frame=AdaptCGRectMake(sizeThatFit1.width*-1+30, 2,sizeThatFit1.width, 10);
      
      CGSize sizeThatFitd=[_datelabel sizeThatFits:CGSizeZero];
      //重新指定frame
      _datelabel.frame=AdaptCGRectMake(sizeThatFitd.width*-1+30, 25, sizeThatFitd.width, 10);
  }else {
      CGSize sizeThatFit=[_windSu sizeThatFits:CGSizeZero];
      //重新指定frame
      _windSu.frame=AdaptCGRectMake(35, 13, sizeThatFit.width, 10);
      CGSize sizeThatFit1=[_temperlabel sizeThatFits:CGSizeZero];
      _temperlabel.frame=AdaptCGRectMake(35, 2,sizeThatFit1.width, 10);
      CGSize sizeThatFitd=[_datelabel sizeThatFits:CGSizeZero];
      //重新指定frame
      _datelabel.frame=AdaptCGRectMake(35, 25, sizeThatFitd.width, 10);
  }

    frame.origin.x=_a;
   _lineView.frame=frame;
    _lineView.backgroundColor=[UIColor clearColor];
    [self addSubview:_lineView];
    if (point.x<0) {
        [self addSubview:_lineView];
    }
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"log" object:nil];
    
}

#pragma mark public method
//刷新
-(void)reloadData
{
    [_collectionView reloadData];
}
-(void)updateVisible
{
    NSArray *visibleIndexPaths = [_collectionView indexPathsForVisibleItems];
    for(NSIndexPath *indexPath  in visibleIndexPaths){
        BFHChartCell *chartCell = (BFHChartCell*)[_collectionView cellForItemAtIndexPath:indexPath];
        [self setCell:chartCell indexPath:indexPath];
    }
}

#pragma mark collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self numberOfitemsInSection:section];
   
}
-(NSInteger)numberOfitemsInSection:(NSInteger)section
{
    return [_dataSource  numberOfItemsInSection:section];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BFHChartCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:CELL_INDENTIFIER forIndexPath:indexPath];
    
    NSMutableArray *xTitles = [NSMutableArray array];
    
#pragma mark 修改为直接展示
    for (NSString *timeStr in self.hourArray) {
        [xTitles addObject:timeStr];
    }
    
    NSString *str1=self.windArray[indexPath.row];
   
    float value=[str1 floatValue];
    if (value <8&&value>3) {
        cell.yellowview.backgroundColor=[UIColor yellowColor];
    }else{
        cell.yellowview.backgroundColor=[UIColor clearColor];
    }
    
    
    cell.xlabel.text=[xTitles objectAtIndex:indexPath.row];
   [self setCell:cell  indexPath:indexPath];
   
    return cell;
}

-(void)setCell:(BFHChartCell*)cell indexPath:(NSIndexPath*)indexPath
{
    NSIndexPath *preIndex  = [self preIndex:indexPath];
    NSIndexPath *nextIndex = [self nextIndexPath:indexPath];
    
    HFHChartDomain *preDomain = nil;
    if(preIndex != nil){
        preDomain =[self chartDomainOfIndex:preIndex];
    }
    
    HFHChartDomain *currentDomain = [self chartDomainOfIndex:indexPath];
    HFHChartDomain *nextDomain = nil;
    if(nextIndex != nil){
        nextDomain   = [self chartDomainOfIndex:nextIndex];
    }
    
    CGFloat startPoint = 0;
    CGFloat oldStartPoint = 0;
    if (preDomain!=nil) {
        startPoint = preDomain.nowPercent;
        oldStartPoint = preDomain.oldPercent;
    }else{
        startPoint = currentDomain.nowPercent;
        oldStartPoint = currentDomain.oldPercent;
    }
    startPoint = [self convertPercentToPosition:startPoint]; // 转换成位置
    oldStartPoint = [self convertPercentToPosition1:oldStartPoint];
    
    CGFloat mainPoint = [self convertPercentToPosition:currentDomain.nowPercent];
    CGFloat oldMainPoint = [self convertPercentToPosition1:currentDomain.oldPercent];
    
    CGFloat endPoint = 0;
    CGFloat oldEndPoint = 0;
    if(nextDomain  != nil){
        endPoint = nextDomain.nowPercent;
        oldEndPoint = nextDomain.oldPercent;
        
    }else {
        endPoint = currentDomain.nowPercent;
        oldEndPoint = currentDomain.oldPercent;
    }
    endPoint = [self convertPercentToPosition:endPoint];
    oldEndPoint = [self convertPercentToPosition1:oldEndPoint];
    
    GLChartLine chartLine = GLChartLineMake((startPoint+mainPoint)/2, mainPoint, (mainPoint +endPoint)/2);
    GLChartLine oldChartLine = GLChartLineMake((oldStartPoint + oldMainPoint)/2,oldMainPoint, (oldMainPoint + oldEndPoint)/2);
    
    
    [cell setChartLine:chartLine  oldChartLine:oldChartLine showStart:[self needShowStart:indexPath]  showEnd:[self needShowEnd:indexPath]];
    
}


#pragma mark for data source private
-(HFHChartDomain*)chartDomainOfIndex:(NSIndexPath*)indexPath
{
    if(indexPath == nil){
        return nil;
    }
    return [_dataSource chartDomainOfIndex:indexPath];
}

-(NSIndexPath*)preIndex:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0 && indexPath.item == 0) {
        return nil;
    }
    if(indexPath.item == 0){
        NSInteger preSection = indexPath.section -1;
        NSInteger preItems = [self numberOfitemsInSection:preSection] - 1;
        return [NSIndexPath indexPathForItem:preItems inSection:preSection];
    }
    NSInteger preItem = indexPath.item - 1;
    return [NSIndexPath indexPathForItem:preItem inSection:indexPath.section];
}

-(NSIndexPath*)nextIndexPath:(NSIndexPath*)indexPath
{
    NSInteger section = 1;
    NSInteger itemCount = [self numberOfitemsInSection:indexPath.section];
    //is last index
    if(itemCount == indexPath.item+1 && section == indexPath.section+1 ){
        return nil;
    }
    if (indexPath.item+1 == itemCount) {
        NSInteger nextSection = indexPath.section + 1;
        return [NSIndexPath indexPathForItem:0 inSection:nextSection];
    }
    return [NSIndexPath indexPathForItem:(indexPath.item+1) inSection:indexPath.section];
}
-(CGFloat)convertPercentToPosition:(CGFloat)percent
{
   
    return  _collectionView.bounds.size.height-15 - percent/30*(_collectionView.bounds.size.height-15 );
}
-(CGFloat)convertPercentToPosition1:(CGFloat)percent
{
   
    return  _collectionView.bounds.size.height -  percent/30*_collectionView.bounds.size.height-15 ;
}
-(BOOL)needShowStart:(NSIndexPath*)indexPath
{
    return indexPath.item != 0 || indexPath.section != 0;
}
-(BOOL)needShowEnd:(NSIndexPath*)indexPath
{
    NSInteger lastSection  = 0;
    NSInteger lastItem = [self numberOfitemsInSection:lastSection] -1;
    
    return  indexPath.item !=lastItem  || indexPath.section != lastSection ;
}


@end

