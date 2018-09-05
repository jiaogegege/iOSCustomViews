//
//  SelectionSlideBar.m
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/10.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "SelectionSlideBar.h"
#import "ColorConst.h"
#import "UIView+FrameSet.h"


@interface SelectionSlideBar()
{
    NSInteger _currentIndex;        //当前选择的index
    UIView *_highLightView;          //高亮按钮块
    NSMutableArray *_btnArray;      //按钮数组
    
}
@end

@implementation SelectionSlideBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initData];
        [self configUI];
    }
    return self;
}

///初始化数据结构
-(void)initData
{
    _btnArray = [NSMutableArray array];
    _currentIndex = -1;
    _style = SelectionSlideBarStyleDark;
    _isEnabled = YES;
}

-(void)setIsEnabled:(BOOL)isEnabled
{
    _isEnabled = isEnabled;
    self.userInteractionEnabled = isEnabled;
    if (isEnabled)
    {
        _highLightView.backgroundColor = MAIN_RED_COLOR;
    }
    else
    {
        _highLightView.backgroundColor = GRAY3_COLOR;
    }
}

///初始化界面
-(void)configUI
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
    self.layer.cornerRadius = self.bounds.size.height / 2.0;
    //创建底层滑动块
    _highLightView = [[UIView alloc] initWithFrame:self.bounds];
    _highLightView.backgroundColor = MAIN_RED_COLOR;
    _highLightView.layer.cornerRadius = _highLightView.frame.size.height / 2.0;
    _highLightView.hidden = YES;
    [self addSubview:_highLightView];
}

///设置标题数组
-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    CGFloat btnLength = self.frame.size.width / titleArray.count;
    CGFloat btnHeight = self.frame.size.height;
    _highLightView.width = btnLength;
    for (int i = 0; i < titleArray.count; ++i)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * btnLength, 0, btnLength, btnHeight);
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:((_style == SelectionSlideBarStyleDark) ? DEFAULT_TEXT_COLOR : GRAY_TEXT_COLOR) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:((_style == SelectionSlideBarStyleDark) ? 18 : 14)];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = BASE_TAG + i;
        [self addSubview:btn];
        [_btnArray addObject:btn];
    }
    //默认选择第一个按钮
//    [self setSelectItemIndex:0];
}

-(void)setStyle:(SelectionSlideBarStyle)style
{
    _style = style;
    switch (style) {
        case SelectionSlideBarStyleLight:       //浅色模式
        {
            self.backgroundColor = [UIColor whiteColor];
            self.layer.borderColor = [GRAY_TEXT_COLOR CGColor];
            self.layer.borderWidth = 1;
            for (UIButton *btn in _btnArray)
            {
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                [btn setTitleColor:GRAY_TEXT_COLOR forState:UIControlStateNormal];
            }
            break;
        }
        case SelectionSlideBarStyleDark:        //深色模式，默认
        {
            self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
            self.layer.borderWidth = 0;
            self.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.15].CGColor;
            for (UIButton *btn in _btnArray)
            {
                btn.titleLabel.font = [UIFont systemFontOfSize:18];
                [btn setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
            }
            break;
        }
        default:
        {
            break;
        }
    }
}

///设置选择某一个按钮，index从0开始
-(void)setSelectItemIndex:(NSInteger)index
{
    if (!(index == _currentIndex) && index >= 0 && index < _btnArray.count)     //如果两个值相等说明是同一个按钮，不做任何操作
    {
        self.userInteractionEnabled = NO;
        [self setBtnDefault:_currentIndex];
        [self setBtnHighLight:index];
    }
    else if (index < 0)     //如果index小于0，那么隐藏
    {
        _currentIndex = index;
        _highLightView.hidden = YES;
    }
    
}

///按钮设置高亮
-(void)setBtnHighLight:(NSInteger)index
{
    UIButton *btn = _btnArray[index];
    if (_highLightView.hidden)  //如果按钮隐藏了，那么不需要动画
    {
        _highLightView.hidden = NO;
        [btn setTitleColor:HIGHLIGHT_TEXT_COLOR forState:UIControlStateNormal];
        self -> _highLightView.frame = btn.frame;
        self -> _currentIndex = index;
        self.userInteractionEnabled = _isEnabled;
    }
    else
    {
        __weak typeof(self) weak = self;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [btn setTitleColor:HIGHLIGHT_TEXT_COLOR forState:UIControlStateNormal];
            self -> _highLightView.frame = btn.frame;
        } completion:^(BOOL finished) {
            self -> _currentIndex = index;
            weak.userInteractionEnabled = self -> _isEnabled;
        }];
    }

}

///按钮设置默认
-(void)setBtnDefault:(NSInteger)index
{
    if (index >= 0 && index < _btnArray.count)
    {
        UIButton *btn = _btnArray[index];
        [btn setTitleColor:((_style == SelectionSlideBarStyleDark) ? DEFAULT_TEXT_COLOR : GRAY_TEXT_COLOR) forState:UIControlStateNormal];
    }
    
}

///绑定按钮事件
-(void)btnAction:(UIButton *)sender
{
    NSInteger index = sender.tag - BASE_TAG;
    [self setSelectItemIndex:index];
    //执行代理方法，响应外部处理事件
    if ([_delegate respondsToSelector:@selector(selectionSlideBarDidSelectIndex:)])
    {
        [_delegate selectionSlideBarDidSelectIndex:index];
    }
}


@end
