//
//  CountDownButton.m
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/11.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "CountDownButton.h"
#import "ColorConst.h"

    ///静态变量，记录已经创建的UIButton对象，强引用
static NSMutableDictionary *identifierKeyMap;

@interface CountDownButton()
{
    NSTimer *_timer;        //倒计时
    
}
@end

@implementation CountDownButton

    ///工厂方法
+(instancetype)buttonWithType:(UIButtonType)buttonType withNormalTitle:(NSString *)normalTitle withCountingTitle:(NSString *)countingTitle withIdentifier:(NSString *)identifier
{
    if (!identifierKeyMap)      //如果没有那么创建
    {
        identifierKeyMap = [NSMutableDictionary dictionary];
    }
    if ([identifierKeyMap objectForKey:identifier])      //如果有值那么不创建，返回已有的按钮
    {
        return [identifierKeyMap objectForKey:identifier];
    }
    //创建一个新的按钮
    CountDownButton *btn = [CountDownButton buttonWithType:buttonType];
    btn.identifierKey = identifier;
    btn.totalTime = 60;     //倒计时总时间默认60
    btn.countNormalTitle = normalTitle;
    btn.countingDownTitle = countingTitle;
    btn.countingStyle = CountDownButtonStyleLight;
    [btn setTitle:normalTitle forState:UIControlStateNormal];
    btn.backgroundColor = MAIN_RED_COLOR;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.layer.cornerRadius = btn.frame.size.height / 2.0;
    return btn;
}

///设置倒计时时间
-(void)setTotalTime:(int)totalTime
{
    _totalTime = totalTime;
    self.restTime = totalTime;
}

    ///开始倒计时，就把自己加入唯一识别map中
-(void)startCountDown
{
    if (!_timer)        //如果没有值，那么创建并开始倒计时
    {
        //设定初始状态
        [self setDisabled];
        [self setTitle:[NSString stringWithFormat:@"%@(%d)", _countingDownTitle, _restTime] forState:UIControlStateNormal];
        
        [identifierKeyMap setObject:self forKey:self.identifierKey];        //加入唯一map中，防止重复创建
        
        __weak typeof(self) weak = self;
        _timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self -> _restTime = --self -> _restTime;
            [weak setTitle:[NSString stringWithFormat:@"%@(%d)", self -> _countingDownTitle, self -> _restTime] forState:UIControlStateNormal];
                //倒计时回调
            if (self -> _countingBlock)
            {
                self -> _countingBlock(self -> _restTime);
            }
            if (self -> _restTime < 0)
            {
                [self -> _timer invalidate];
                self -> _timer = nil;
                [identifierKeyMap removeObjectForKey:self -> _identifierKey];       //从唯一列表中移除
                [weak setNormalState];
            }
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

    ///是否在倒计时
-(BOOL)isCountingDown
{
    return _timer ? YES : NO;
}

    ///设置为不可点击
-(void)setDisabled
{
    switch (self.countingStyle) {
        case CountDownButtonStyleLight:
        {
            self.layer.borderColor = [GRAY_TEXT_COLOR CGColor];
            self.layer.borderWidth = 1;
            self.backgroundColor = [UIColor whiteColor];
            [self setTitleColor:GRAY_TEXT_COLOR forState:UIControlStateNormal];
            self.enabled = NO;
            break;
        }
        case CountDownButtonStyleDark:
        {
            self.layer.borderColor = [GRAY3_COLOR CGColor];
            self.layer.borderWidth = 0;
            self.backgroundColor = GRAY3_COLOR;
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.enabled = NO;
            break;
        }
        default:
            break;
    }

}
    ///设置为可点击
-(void)setEnabled
{
    if (!_timer)    //只有剩余时间为60的时候可以设置为可点击
    {
        [self setNormalState];
    }
    
}

///设置为原始状态
-(void)setNormalState
{
    self.layer.borderWidth = 0;
    self.layer.borderColor = [MAIN_RED_COLOR CGColor];
    self.restTime =self.totalTime;       //剩余时间创建的时候60，倒计时开始后递减
    [self setTitle:self.countNormalTitle forState:UIControlStateNormal];
    self.backgroundColor = MAIN_RED_COLOR;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.enabled = YES;
}

@end
