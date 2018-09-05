//
//  TopSelectionBar.m
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/14.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "TopSelectionBar.h"
#import "ColorConst.h"
#import "UIButton+ButtonBlock.h"
#import "CKCommonTools.h"
#import "UIView+FrameSet.h"
#import "MacroConst.h"

@interface TopSelectionBar()
{
    UIView *_bottomBar;     //底部滑动条
    NSMutableArray *_buttonArray;       //按钮数组
    UIColor *_highlightColor;      //高亮文字颜色
    UIColor *_normalColor;      //默认文字颜色
    UIFont *_font;      //字体
    CGFloat _spaceWidth;        //空白宽度
    
}

@end

@implementation TopSelectionBar

///初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initData];
    }
    return self;
}

///初始化数据结构，配置基本属性
-(void)initData
{
    _needAnimated = YES;
    _isAverage = YES;
    _buttonArray = [NSMutableArray array];
    _highlightColor = MAIN_TEXT_BLACK_COLOR;
    _normalColor = GRAY_TEXT_COLOR;
    _currentIndex = -1;
    self.bounces = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    _font = [UIFont systemFontOfSize:14];
    
}

///初始化界面
-(void)configUI
{
    CGFloat offsetX = 0;
    _spaceWidth = 20;
    //创建按钮，前后20px空白
    for (int i = 0; i < _titleArray.count; ++i)
    {
        CGFloat width = [CKCommonTools getTextWidth:_titleArray[i] withFont:_font withSize:CGSizeMake(0, self.height)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(offsetX, 0, width + 2 * _spaceWidth, self.frame.size.height);
        offsetX += btn.width;
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_normalColor forState:UIControlStateNormal];
        btn.titleLabel.font = _font;
        btn.tag = BASE_TAG + i;
        __weak typeof(self) weak = self;
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
            [weak titleButtonAction:sender.tag - BASE_TAG];
        }];
        [self addSubview:btn];
        [_buttonArray addObject:btn];
    }
    self.contentSize = CGSizeMake(offsetX, self.height);
    //创建底部滑动条
    UIButton *btn = _buttonArray[0];
    _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(btn.x, btn.frame.size.height - 2, btn.frame.size.width - 2 * _spaceWidth, 2)];
    _bottomBar.center = CGPointMake(btn.center.x, _bottomBar.center.y);
    _bottomBar.backgroundColor = MAIN_RED_COLOR;
    [self addSubview:_bottomBar];
    [self setSelectIndex:0 animated:NO];        //默认选中第一个
}

///创建滑动条，不可滑动，平均分布
-(void)configUIAverage
{
    CGFloat spaceCount = _titleArray.count * 2.0;       //空白的个数
    CGFloat btnTotalWidth = 0.0;
    for (NSString *str in _titleArray)
    {
        btnTotalWidth += [CKCommonTools getTextWidth:str withFont:_font withSize:CGSizeMake(0, self.height)];
    }
    CGFloat spaceWidth = (self.frame.size.width - btnTotalWidth) / spaceCount;      //得到空白宽度
    _spaceWidth = spaceWidth;
    CGFloat offsetX = 0;
//    offsetX += spaceWidth;
    for (int i = 0; i < _titleArray.count; ++i)
    {
        CGFloat width = [CKCommonTools getTextWidth:_titleArray[i] withFont:_font withSize:CGSizeMake(0, self.height)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(offsetX, 0, width + 2 * spaceWidth, self.frame.size.height);
//        offsetX += width + 2 * spaceWidth;
        offsetX += btn.width;
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_normalColor forState:UIControlStateNormal];
        btn.titleLabel.font = _font;
        btn.tag = BASE_TAG + i;
        __weak typeof(self) weak = self;
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
            [weak titleButtonAction:sender.tag - BASE_TAG];
        }];
        [self addSubview:btn];
        [_buttonArray addObject:btn];
    }
        //创建底部滑动条
    UIButton *btn = _buttonArray[0];
    _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(btn.x + spaceWidth, btn.frame.size.height - 2, btn.frame.size.width - 2 * spaceWidth, 2)];
    _bottomBar.backgroundColor = MAIN_RED_COLOR;
    [self addSubview:_bottomBar];
    [self setSelectIndex:0 animated:NO];        //默认选中第一个
}

///设置标题
-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    if (titleArray.count)
    {
        if (_isAverage)
        {
            [self configUIAverage];
        }
        else
        {
            [self configUI];
        }
    }
    
}

    ///设置选中某一个index，从0开始计数
-(void)setSelectIndex:(NSInteger)index animated:(BOOL)animated
{
    if (!(_currentIndex == index))      //index不同的时候才做操作
    {
        if (_currentIndex >= 0)
        {
            UIButton *previousBtn = _buttonArray[_currentIndex];
            [self setButtonNormal:previousBtn];
        }
        UIButton *newBtn = _buttonArray[index];
        [self setButtonHighlight:newBtn];
        _currentIndex = index;
        //移动底部滑动条
        CGFloat width = [CKCommonTools getTextWidth:[newBtn titleForState:UIControlStateNormal] withFont:_font withSize:CGSizeMake(0, self.height)];
        CGRect frame = CGRectMake(newBtn.x + _spaceWidth, _bottomBar.y, width, _bottomBar.height);
//        CGRect frame = CGRectMake(newBtn.center.x - width / 2.0, _bottomBar.y, width, _bottomBar.height);
        [self moveBottomBar:frame animated:animated];
    }
}

///设置按钮默认
-(void)setButtonNormal:(UIButton *)btn
{
    [btn setTitleColor:_normalColor forState:UIControlStateNormal];
}

///设置按钮高亮
-(void)setButtonHighlight:(UIButton *)btn
{
    [btn setTitleColor:_highlightColor forState:UIControlStateNormal];
}

///移动底部滑动条
-(void)moveBottomBar:(CGRect)frame animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self -> _bottomBar.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        _bottomBar.frame = frame;
    }
    //不是平均分布要移动tabbar
    if (!_isAverage)
    {
        __weak typeof(self) weak = self;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                //移动scrollView
            if (frame.size.width + frame.origin.x - weak.width + self->_spaceWidth * 2 + self->_spaceWidth > weak.contentOffset.x)
            {
                if (frame.size.width + frame.origin.x - weak.width + self->_spaceWidth * 2 + self->_spaceWidth > weak.contentSize.width - weak.width)  //如果超过了scrollview的宽度，移动scrollview的最大宽度
                {
                    weak.contentOffset = CGPointMake(weak.contentSize.width - weak.width, 0);
                }
                else
                {
                    weak.contentOffset = CGPointMake(frame.size.width + frame.origin.x - weak.width + self->_spaceWidth * 2 + self->_spaceWidth, 0);
                }
            }
            else if (frame.origin.x - self->_spaceWidth * 2 - self->_spaceWidth <= weak.contentOffset.x)
            {
                if (frame.origin.x - self->_spaceWidth * 2 - self->_spaceWidth <= 0)
                {
                    weak.contentOffset = CGPointMake(0, 0);
                }
                else
                {
                    weak.contentOffset = CGPointMake(frame.origin.x - self->_spaceWidth * 2 - self->_spaceWidth, 0);
                }
            }
        } completion:^(BOOL finished) {
            
        }];
    }
}

///移动scrollView，让选中的按钮始终出现在屏幕上
-(void)moveScrollView:(CGFloat)x
{
    
}

///标题按钮点击事件
-(void)titleButtonAction:(NSInteger)index
{
    if (index != _currentIndex)
    {
        [self setSelectIndex:index animated:_needAnimated];
        if (self.barDelegate)
        {
            if ([self.barDelegate conformsToProtocol:@protocol(TopSelectionBarDelegate)])
            {
                if ([self.barDelegate respondsToSelector:@selector(topSelectionBarDidSelectIndex:)])
                {
                    [self.barDelegate topSelectionBarDidSelectIndex:index];     //执行代理方法
                }
            }
        }
    }

}



@end
