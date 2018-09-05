//
//  CountDownButton.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/11.
//  Copyright © 2018年 dyimedical. All rights reserved.
//


/**
 倒计时按钮，倒计时的时候，这个按钮一直存在，即使退出界面也可以存在，直到倒计时结束，恢复可点击
 */

#import <UIKit/UIKit.h>

///倒计时按钮显示风格，控制倒计时的时候显示的外表
typedef NS_ENUM(NSInteger, CountDownButtonStyle) {
    CountDownButtonStyleLight,
    CountDownButtonStyleDark
};

typedef void(^CountDownBlock)(int restTime);

@interface CountDownButton : UIButton

///倒计时剩余时间
@property(nonatomic, assign)int restTime;
///唯一识别码
@property(nonatomic, copy)NSString *identifierKey;
///倒计时时长，默认60，可自定义
@property(nonatomic, assign)int totalTime;
///倒计时的时候显示的文字
@property(nonatomic, copy)NSString *countingDownTitle;
///非倒计时的时候显示的文字
@property(nonatomic, copy)NSString *countNormalTitle;
///倒计时显示风格
@property(nonatomic, assign)CountDownButtonStyle countingStyle;
///倒计时回调
@property(nonatomic, copy)CountDownBlock countingBlock;

///工厂方法
+(CountDownButton *)buttonWithType:(UIButtonType)buttonType withNormalTitle:(NSString *)normalTitle withCountingTitle:(NSString *)countingTitle withIdentifier:(NSString *)identifier;
///开始倒计时
-(void)startCountDown;
///设置为不可点击
-(void)setDisabled;
///设置为可点击
-(void)setEnabled;
///是否在倒计时
-(BOOL)isCountingDown;

@end
