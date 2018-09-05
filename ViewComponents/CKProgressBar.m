//
//  CKProgressBar.m
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/9.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "CKProgressBar.h"
#import "CKConst.h"

///背景圆圈灰色
#define CIRCLE_GRAY_COLOR [UIColor colorWithHexString:@"e5e5e5"]
///渐变的3种颜色，从浅到深
#define CIRCLE_FIRST_COLOR [UIColor colorWithHexString:@"ff7499"]
#define CIRCLE_SECOND_COLOR [UIColor colorWithHexString:@"ec4c72"]
#define CIRCLE_THIRD_COLOR [UIColor colorWithHexString:@"da274d"]

@implementation CKProgressBar
{
    CALayer *_containergLayer;      //渐变图层容器
    CAGradientLayer *_leftgLayer;       //左边渐变图层
    CAGradientLayer *_rightgLayer;      //右边渐变图层
    CAShapeLayer *_sLayer;      //轨道图层
    UILabel *_countLabel;       //中间文字
    CGFloat _lineWidth;         //线宽
    UIBezierPath *_fullPath;       //全部填充时候的path
    UIBezierPath *_emptyPath;      //未全部填充的path
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self configUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self configUI];
    }
    return self;
}

///初始化界面Layer
-(void)configUI
{
    self.maxValue = 100;
    CGFloat lineWidth = 10;
    _lineWidth = 10;
    CGFloat radius = self.bounds.size.width / 2.0 - lineWidth / 2.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2) radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    //轨道图层
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.path = path.CGPath;
    trackLayer.frame = self.bounds;
    trackLayer.lineWidth = lineWidth;
    trackLayer.strokeColor = [CIRCLE_GRAY_COLOR CGColor];
    trackLayer.fillColor = [[UIColor whiteColor] CGColor];
    trackLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:trackLayer];
    
    //渐变图层
    _containergLayer = [CALayer layer];
    _containergLayer.frame = self.bounds;
    _containergLayer.backgroundColor = [MAIN_RED_COLOR CGColor];
    //左边渐变
    _leftgLayer = [CAGradientLayer layer];
    _leftgLayer.colors = @[(__bridge id) [CIRCLE_THIRD_COLOR CGColor], (__bridge id)[CIRCLE_SECOND_COLOR CGColor]];
    _leftgLayer.startPoint = CGPointMake(0, 0);
    _leftgLayer.endPoint = CGPointMake(0, 1);
    _leftgLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width / 2.0, self.bounds.size.height);
    [_containergLayer addSublayer:_leftgLayer];
    //右边渐变
    _rightgLayer = [CAGradientLayer layer];
    _rightgLayer.colors = @[(__bridge id) [CIRCLE_FIRST_COLOR CGColor], (__bridge id)[CIRCLE_SECOND_COLOR CGColor]];
    _rightgLayer.startPoint = CGPointMake(0, 0);
    _rightgLayer.endPoint = CGPointMake(0, 1);
    _rightgLayer.frame = CGRectMake(self.bounds.size.width / 2.0, self.bounds.origin.y, self.bounds.size.width / 2.0, self.bounds.size.height);
    [_containergLayer addSublayer:_rightgLayer];
    [self.layer addSublayer:_containergLayer];
    
    //计算偏移量
    CGFloat offset = lineWidth / 2.0 / radius;
    UIBezierPath *stepPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2) radius:radius startAngle:-M_PI_2 + offset endAngle:M_PI*2-M_PI_2 clockwise:YES];
    _emptyPath = stepPath;
    _sLayer = [CAShapeLayer layer];
    //遮罩图层
    _sLayer.path = stepPath.CGPath;
    _sLayer.frame = self.bounds;
    _sLayer.lineWidth = lineWidth;
    _sLayer.strokeColor = [UIColor whiteColor].CGColor;
    _sLayer.fillColor = [UIColor clearColor].CGColor;
    _sLayer.lineCap = kCALineCapRound;
    _containergLayer.mask = _sLayer;
    _sLayer.strokeEnd = 0;
    
    //添加圆圈中间的白色圆
    CAShapeLayer *middleLayer = [CAShapeLayer layer];
    UIBezierPath *middlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2) radius:radius - lineWidth / 2.0 startAngle:-M_PI_2 endAngle:M_PI*2-M_PI_2 clockwise:YES];
    middleLayer.path = middlePath.CGPath;
    middleLayer.frame = self.bounds;
    middleLayer.lineWidth = 0;
    middleLayer.strokeColor = [UIColor clearColor].CGColor;
    middleLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:middleLayer];
    
    //添加圆圈中间的文字UILabel
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (radius + lineWidth) * 2.0, (radius + lineWidth) * 2.0)];
    _countLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2);
    _countLabel.text = @"0";
    _countLabel.textColor = MAIN_TEXT_BLACK_COLOR;
    _countLabel.font = [UIFont systemFontOfSize:radius];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.numberOfLines = 1;
    [self addSubview:_countLabel];
    
    //创建全部填充的path
    CGFloat radius2 = self.bounds.size.width / 2.0 - _lineWidth / 2.0;
    UIBezierPath *stepPath2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2) radius:radius2 startAngle:-M_PI_2 endAngle:M_PI*2-M_PI_2 clockwise:YES];
    _fullPath = stepPath2;
    
}

///设置数值
-(void)setValue:(CGFloat)value withAnimate:(BOOL)animated
{
    if (value >= self.maxValue)
    {
        value = self.maxValue;
        _currentValue = value;
        _leftgLayer.hidden = YES;
        _rightgLayer.hidden = YES;
        _sLayer.path = _fullPath.CGPath;
    }
    else
    {
        if (value <= 0)
        {
            value = 0;
        }
        _currentValue = value;
        _sLayer.path = _emptyPath.CGPath;
        _leftgLayer.hidden = NO;
        _rightgLayer.hidden = NO;
    }
    _countLabel.text = [NSString stringWithFormat:@"%d", (int)_currentValue];
    if (animated)
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self -> _sLayer.strokeEnd = value / self.maxValue;
        } completion:^(BOOL finished) {
            
        }];
        
    }
    else
    {
        _sLayer.strokeEnd = value / self.maxValue;
    }
}





@end
