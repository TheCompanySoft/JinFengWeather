//
//  FengCheView.m
//  zsj
//
//  Created by huake on 15/10/10.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//

#import "WindmillView.h"
@interface WindmillView ()
{
    UIImageView *_turnimageView;
    UIImageView *_turnimageblowView;
    CADisplayLink *_link;
    UIImageView *_smallView;
    UIImageView *_smallmoveView;
    
}
@end
@implementation WindmillView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor blueColor];
        [self addContView];
    }
    return self;
}
-(void)addContView{
    //大上
    UIImage *image=[UIImage imageNamed:@"bigfengche"];
    
    _turnimageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,5, image.size.width/1.7, image.size.height/1.7)];
    [_turnimageView setImage:image];
    _turnimageView.backgroundColor=[UIColor clearColor];
    [self addSubview:_turnimageView];
    UIImage *image1=[UIImage imageNamed:@"bigwindfengche"];
    _turnimageblowView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image1.size.width/1.7, image1.size.height/1.7)];
    _turnimageblowView.backgroundColor=[UIColor clearColor];
    [_turnimageblowView setImage:image1];
    
    [self addSubview:_turnimageblowView];
    UIImage *image3=[UIImage imageNamed:@"small"];
    _smallView=[[UIImageView alloc]initWithFrame:CGRectMake(40, 35, image3.size.width/1.7, image3.size.height/1.8)];
    [_smallView setImage:image3];
    _smallView.backgroundColor=[UIColor clearColor];
    [self addSubview:_smallView];
    //小上
    UIImage *image4=[UIImage imageNamed:@"fengche123"];
    _smallmoveView=[[UIImageView alloc]initWithFrame:CGRectMake(39.5,25, image4.size.width/1.7, image4.size.height/1.7)];
    _smallmoveView.backgroundColor=[UIColor clearColor];
    [_smallmoveView setImage:image1];
    [self addSubview:_smallmoveView];
    _link=[CADisplayLink displayLinkWithTarget:self
                                      selector:@selector(move)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)move{
//大风车的旋转
    _turnimageblowView.transform = CGAffineTransformRotate(_turnimageblowView.transform, M_PI/180*4);
    //小风车的旋转
    _smallmoveView.transform=CGAffineTransformRotate(_turnimageblowView.transform, M_PI/180*4);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
