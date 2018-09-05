//
//  GraphBar.m
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/14.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "GraphBar.h"
#import "ColorConst.h"
#import "UIView+FrameSet.h"

@interface GraphBar()
{
    CAGradientLayer *_gLayer;       //渐变图层
    
}

@end

@implementation GraphBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initData];
    }
    return self;
}

///初始化数据
-(void)initData
{
    self.colors = @[(__bridge id)[RED_GRAPHBAR_COLOR CGColor], (__bridge id)[UIColor whiteColor].CGColor];
    _currentValue = 0;
    _maxValue = 0.01;
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = self.frame.size.width / 2.0;
    self.layer.masksToBounds = YES;
}

-(void)drawRect:(CGRect)rect
{
    //创建渐变图层
    _gLayer = [CAGradientLayer layer];
    _gLayer.colors = self.colors;
    _gLayer.startPoint = CGPointMake(0, 0);
    _gLayer.endPoint = CGPointMake(0, 1);
    _gLayer.frame = CGRectMake(0, (1 - _currentValue / _maxValue) * self.height, self.width, _currentValue / _maxValue * self.height);
    _gLayer.cornerRadius = self.width / 2.0;
    [self.layer addSublayer:_gLayer];

}


@end
