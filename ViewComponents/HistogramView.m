//
//  HistogramView.m
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/28.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "HistogramView.h"

@implementation HistogramView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = rect.size.width / 2.0;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    [_gLayer removeFromSuperlayer];
    _gLayer = [CAGradientLayer layer];
    _gLayer.colors = @[(__bridge id)[UIColor colorWithWhite:1 alpha:0.6].CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    CGFloat height =(float) _currentValue / (float)_maxValue * rect.size.height;
    height = height < 5 ? 5 : height;
    _gLayer.frame = CGRectMake(0, rect.size.height - height, rect.size.width, height);
    _gLayer.cornerRadius = rect.size.width / 2.0;
    _gLayer.masksToBounds = YES;
    [self.layer addSublayer:_gLayer];
}

@end
