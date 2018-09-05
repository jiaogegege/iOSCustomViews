//
//  WaveView.m
//  CGDemo
//
//  Created by 蒋雪姣 on 18/5/4.
//  Copyright © 2018年 movit-tech. All rights reserved.
//

#import "WaveView.h"
#import <objc/runtime.h>
#import "CKConst.h"


@interface WaveView ()<CAAnimationDelegate>
{
    NSArray *alphaArray;
    UIColor *_mainColor;
    UIImageView *_imageView;            //中心图片
    int _circleCount;     //最大圆环个数
    CGFloat _circleWidth;       //圆环宽度
    BOOL _stopFlag;
    
}
@property(nonatomic, strong) NSMutableArray *colorArray;        //颜色数组
@property(nonatomic, strong) NSMutableArray *viewArray;         //视图数组
@property(nonatomic, strong) NSMutableArray *gradientLayerArray;            //渐变图层数组
@property(nonatomic, strong) NSMutableArray *maskLayerArray;           //蒙板图层数组
@property(nonatomic, strong) NSMutableArray *frameArray;            //临界位置大小

@end

@implementation WaveView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initData];
        [self configColor:nil];
        [self configUI];
        [self addCenterImage];
    }
    return self;
}

///初始化数据结构
-(void)initData
{
    _colorArray = [NSMutableArray array];
    _viewArray = [NSMutableArray array];
    _gradientLayerArray = [NSMutableArray array];
    _maskLayerArray = [NSMutableArray array];
    _frameArray  = [NSMutableArray array];
    alphaArray = @[@0.0,@0.03, @0.06, @0.12, @0.18, @0.24];
    _mainColor = [UIColor colorWithRed:218/255.0 green:39/255.0 blue:77/255.0 alpha:1];
    _circleCount = 5;
    _stopFlag = YES;
    _circleWidth = (self.bounds.size.width > self.bounds.size.height ? self.bounds.size.width : self.bounds.size.height) / _circleCount / 2.0;
    //创建临界位置，6个位置，第0个为1个宽度，第6个为7个宽度
    for (int i = 1; i <= _circleCount + 1; i++)
    {
        CGRect rect = CGRectMake(self.bounds.size.width / 2.0 - i * _circleWidth, self.bounds.size.height / 2.0 - i * _circleWidth, i * _circleWidth * 2, i * _circleWidth * 2);
        [_frameArray addObject:[NSValue valueWithCGRect:rect]];
    }
}

///设置颜色数组
-(void)configColor:(UIColor *)mainColor
{
    UIColor *color = nil;
    color = mainColor ? mainColor : _mainColor;
    
    for (int i = _circleCount; i >= 0; --i)     //6个颜色，最后一个是透明颜色
    {
        [_colorArray addObject:[color colorWithAlphaComponent:[alphaArray[i] floatValue]]];
    }
}

///添加中间图片
-(void)addCenterImage
{
    _imageView = [[UIImageView alloc] initWithFrame:[[_frameArray firstObject] CGRectValue]];
    _imageView.image = [UIImage imageNamed:@"Bluetooth icon"];
    [self addSubview:_imageView];
}

-(void)configUI
{
    CGRect rect = [[_frameArray firstObject] CGRectValue];
    //容器视图
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor clearColor];
    view.layer.cornerRadius = view.frame.size.width / 2.0;
    [self addSubview:view];
    [_viewArray addObject:view];
    
    //渐变图层
    CAGradientLayer *gLayer = [CAGradientLayer layer];
    gLayer.colors = @[(__bridge id) [[_colorArray firstObject] CGColor], (__bridge id)[[_colorArray lastObject] CGColor]];
    gLayer.startPoint = CGPointMake(0, 0);
    gLayer.endPoint = CGPointMake(1, 1);
    gLayer.frame = view.bounds;
    [view.layer addSublayer:gLayer];
    [_gradientLayerArray addObject:gLayer];
    
    //半径
    float radius = _circleWidth / 2.0;
    UIBezierPath *stepPath = [UIBezierPath bezierPathWithArcCenter:gLayer.position radius:radius startAngle:0.0 endAngle:M_PI * 2 clockwise:YES];
    
    CAShapeLayer *sLayer = [CAShapeLayer layer];
    //遮罩图层
    sLayer.path = stepPath.CGPath;
    sLayer.lineWidth = _circleWidth;
    sLayer.strokeColor = [UIColor redColor].CGColor;
    sLayer.fillColor = [UIColor clearColor].CGColor;
    sLayer.lineCap = kCALineCapRound;
    sLayer.strokeEnd = 1;
    gLayer.mask = sLayer;
    [_maskLayerArray addObject:sLayer];
    
}

///开启动画
-(void)startAnimation
{
    if (_stopFlag)
    {
        _stopFlag = NO;
        for (UIView *v in _viewArray)
        {
            [v removeFromSuperview];
        }
        [_viewArray removeAllObjects];
        [_gradientLayerArray removeAllObjects];
        [_maskLayerArray removeAllObjects];
        [self animationAction];
    }
}

///动画
-(void)animationAction
{
    //颜色渐变动画
    if (!_stopFlag)
    {
        //颜色渐变动画
        for (int i = 0; i < _viewArray.count; i++)
        {
            CAGradientLayer *gLayer = _gradientLayerArray[i];
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
            animation.duration = 0.8;
            animation.beginTime = CACurrentMediaTime();
            animation.fromValue = gLayer.colors;
            animation.delegate = self;
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            UIColor *originColor = [UIColor colorWithCGColor:(CGColorRef)[gLayer.colors firstObject]];
            CGFloat originAlpha = CGColorGetAlpha(originColor.CGColor);
            CGFloat newAlpha = [self getAlpha:originAlpha];
            UIColor *newColor = [_mainColor colorWithAlphaComponent:newAlpha];
            animation.toValue = @[(__bridge id) [newColor CGColor], (__bridge id)[[_colorArray lastObject] CGColor]];
//            animation.toValue = @[(__bridge id) [newColor CGColor], (__bridge id)[newColor CGColor]];
            [gLayer addAnimation:animation forKey:@"colors"];
            objc_setAssociatedObject(gLayer, &key, animation.toValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        //变形动画
        __weak typeof(self) weak = self;
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            for (int i = 0; i < self -> _viewArray.count; i++)
            {
                UIView *view = self -> _viewArray [i];
                view.transform = CGAffineTransformScale(view.transform, (view.frame.size.width + self -> _circleWidth * 2) / view.frame.size.width, (view.frame.size.width + self -> _circleWidth * 2) / view.frame.size.width);
            }
        } completion:^(BOOL finished) {
            for (int i = 0; i < self -> _viewArray.count; i++)
            {
                UIView *v = self -> _viewArray[i];
                if (v.frame.size.width / 2.0 >= self -> _circleCount * self -> _circleWidth)
                {
                    [v removeFromSuperview];
                    [self -> _viewArray removeObjectAtIndex:i];
                    [self -> _gradientLayerArray removeObjectAtIndex:i];
                    [self -> _maskLayerArray removeObjectAtIndex:i];
                }
            }
            [weak addNewCircle];
            [weak animationAction];
        }];
        
    }
}

///得到透明度
-(CGFloat)getAlpha:(CGFloat)originAlpha
{
    CGFloat newAlpha = 0.0;
    for (int i = 0; i < alphaArray.count; i++)
    {
        if (originAlpha == [alphaArray[i] floatValue])
        {
            newAlpha = [alphaArray[i - 1] floatValue];
            break;
        }
    }
    return newAlpha;
}


///停止动画
-(void)stopAnimation
{
    if (!_stopFlag)
    {
        _stopFlag = YES;
//        for (UIView *v in _viewArray)
//        {
//            [v removeFromSuperview];
//        }
//        [_viewArray removeAllObjects];
//        [_gradientLayerArray removeAllObjects];
//        [_maskLayerArray removeAllObjects];
    }

}

///增加一个圆环
-(void)addNewCircle
{
    [self configUI];
    [self bringSubviewToFront:_imageView];
}

/**动画代理**/
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    for (CAGradientLayer *gLayer in _gradientLayerArray)
    {
        gLayer.colors = objc_getAssociatedObject(gLayer, &key);
    }
}


@end
