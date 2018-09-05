//
//  SwitchBar.m
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/10.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "SwitchBar.h"
#import "ColorConst.h"


@interface SwitchBar()
{
    UIView *_highLightView;          //高亮按钮块
    NSMutableArray *_btnArray;      //按钮数组
    SwitchBarStatus _currentStatus;     //当前状态
}
@end

@implementation SwitchBar

///工厂方法
+(SwitchBar *)switchBarWithFrame:(CGRect)frame andAction:(ActionBlock)block
{
    SwitchBar *bar = [[SwitchBar alloc] initWithFrame:frame];
    bar.block = block;
    return bar;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initData];
        [self configUI];
        self.status = SwitchBarStatusLeftOn;    //默认第一个选中
    }
    return self;
}

///初始化数据结构
-(void)initData
{
    _btnArray = [NSMutableArray array];
    
}

///初始化界面
-(void)configUI
{
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    self.layer.cornerRadius = self.bounds.size.height / 2.0;
    self.layer.borderColor = [GRAY_TEXT_COLOR CGColor];
    self.layer.borderWidth = 1;
    //创建底层滑动块
    _highLightView = [[UIView alloc] initWithFrame:CGRectMake(1.5, 1.5, (self.bounds.size.width - 3) / 2.0, self.bounds.size.height - 3)];
    _highLightView.backgroundColor = MAIN_RED_COLOR;
    _highLightView.layer.cornerRadius = _highLightView.frame.size.height / 2.0;
    [self addSubview:_highLightView];
    [self createSwitchBtn];
}

///创建按钮
-(void)createSwitchBtn
{
    //左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.backgroundColor = [UIColor clearColor];
    leftBtn.frame = CGRectMake(1.5, 1.5, (self.frame.size.width - 3) / 2.0, self.frame.size.height - 3);
    leftBtn.tag = SwitchBarStatusLeftOn;
    [leftBtn setTitleColor:GRAY_TEXT_COLOR forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [leftBtn addTarget:self action:@selector(switchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    [_btnArray addObject:leftBtn];
    //右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.backgroundColor = [UIColor clearColor];
    rightBtn.frame = CGRectMake(self.frame.size.width / 2.0, 1.5, self.frame.size.width / 2.0 - 1.5, self.frame.size.height - 3);
    rightBtn.tag = SwitchBarStatusRightOn;
    [rightBtn setTitleColor:GRAY_TEXT_COLOR forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [rightBtn addTarget:self action:@selector(switchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    [_btnArray addObject:rightBtn];
}



///设置标题
-(void)setLeftTitle:(NSString *)leftTitle
{
    _leftTitle = leftTitle;
    [_btnArray[0] setTitle:leftTitle forState:UIControlStateNormal];
}

-(void)setRightTitle:(NSString *)rightTitle
{
    _rightTitle = rightTitle;
    [_btnArray[1] setTitle:rightTitle forState:UIControlStateNormal];
}

    ///按钮设置高亮
-(void)setBtnHighLight:(SwitchBarStatus)status animated:(BOOL)animated
{
    UIButton *btn = (status == SwitchBarStatusLeftOn) ? _btnArray[0] : _btnArray[1];
    _highLightView.hidden = NO;
    if (animated)
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [btn setTitleColor:HIGHLIGHT_TEXT_COLOR forState:UIControlStateNormal];
            self -> _highLightView.frame = btn.frame;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [btn setTitleColor:HIGHLIGHT_TEXT_COLOR forState:UIControlStateNormal];
        self -> _highLightView.frame = btn.frame;
    }
}

    ///按钮设置默认
-(void)setBtnDefault:(SwitchBarStatus)status
{
    UIButton *btn = (status == SwitchBarStatusLeftOn) ? _btnArray[0] : _btnArray[1];
    [btn setTitleColor:GRAY_TEXT_COLOR forState:UIControlStateNormal];
}

///设置哪一个按钮选中
-(void)setStatus:(SwitchBarStatus)status
{
    _status = status;
    _currentStatus = status;
    switch (status) {
        case SwitchBarStatusLeftOn:
        {
            [self setBtnHighLight:status animated:NO];
            [self setBtnDefault:SwitchBarStatusRightOn];
            break;
        }
        case SwitchBarStatusRightOn:
        {
            [self setBtnHighLight:status animated:NO];
            [self setBtnDefault:SwitchBarStatusLeftOn];
            break;
        }
        default:
            break;
    }
}

///按钮绑定事件
-(void)switchBtnAction:(UIButton *)sender
{
    SwitchBarStatus status = sender.tag;
    if (!(status == _currentStatus))
    {
        NSString *str = nil;
        switch (status) {
            case SwitchBarStatusLeftOn:
            {
                str = self.leftTitle;
                [self setBtnHighLight:status animated:YES];
                [self setBtnDefault:SwitchBarStatusRightOn];
                break;
            }
            case SwitchBarStatusRightOn:
            {
                str = self.rightTitle;
                [self setBtnHighLight:status animated:YES];
                [self setBtnDefault:SwitchBarStatusLeftOn];
                break;
            }
            default:
                break;
        }
        if (_block)
        {
            _block(status, str);
        }
        _currentStatus = status;
    }

}


@end
