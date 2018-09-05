//
//  CKDatePickerView.m
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/10.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "CKDatePickerView.h"
#import "ColorConst.h"
#import "AppDelegate.h"


@interface CKDatePickerView()
{
    UIDatePicker *_datePicker;      //日期选择器
    UIButton *_bgView;      //背景视图
    UIView *_toolBar;       //顶部工具条，包含取消和确定按钮
    UIButton *_cancelBtn;
    UIButton *_confirmBtn;
    UILabel *_titleLabel;
    
    
}
@end

@implementation CKDatePickerView

    ///工厂方法
+(CKDatePickerView *)datePickerWithConfirmBlock:(DatePickerConfirmBlock)confirm withCancelBlock:(DatePickerCancelBlock)cancel
{
    CKDatePickerView *picker = [[CKDatePickerView alloc] initWithFrame:[AppDelegate shareDelegate].window.bounds];
    picker.confirm = confirm;
    picker.cancel = cancel;
    [[AppDelegate shareDelegate].window addSubview:picker];
    return picker;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createUI:frame];
    }
    return self;
}

///初始化视图
-(void)createUI:(CGRect)frame
{
    //背景视图
    _bgView = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgView.frame = self.bounds;
    _bgView.backgroundColor = BG_MASK_GRAY_COLOR;
    [_bgView addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bgView];
    //日历视图，固定高度217
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 217, self.bounds.size.width, 217)];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    _datePicker.locale = locale;
    _datePicker.maximumDate = [NSDate date];
    _datePicker.minimumDate = [CKCommonTools formatStringToDate:MinDate];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_datePicker];
    //工具条，固定高度44
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, _datePicker.frame.origin.y - 44, self.bounds.size.width, 44)];
    _toolBar.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    [_bgView addSubview:_toolBar];
    //取消按钮
    CGFloat btnWidth = 66;
    CGFloat btnHeight = 44;
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelBtn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:MAIN_RED_COLOR forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:_cancelBtn];
    //完成按钮
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _confirmBtn.frame = CGRectMake(self.bounds.size.width - 66, 0, btnWidth, btnHeight);
    [_confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:MAIN_RED_COLOR forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:_confirmBtn];
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cancelBtn.x + _cancelBtn.width, 0, _confirmBtn.x - (_cancelBtn.x + _cancelBtn.width), 44)];
    _titleLabel.text = @"选择日期";
    _titleLabel.textColor = MAIN_TEXT_BLACK_COLOR;
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_toolBar addSubview:_titleLabel];
    [self viewAppear];
}

///设置标题
-(void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

///设置最大日期
-(void)setMaxDate:(NSDate *)maxDate
{
    _maxDate = maxDate;
    _datePicker.maximumDate = maxDate;
}

///设置日期模式
-(void)setDateMode:(UIDatePickerMode)dateMode
{
    _dateMode = dateMode;
    _datePicker.datePickerMode = dateMode;
}

    ///设置当前显示的时间
-(void)setCurrentDate:(NSDate *)date
{
    if (date)
    {
        _datePicker.date = date;
    }
}

///取消按钮事件
-(void)cancelAction:(UIButton *)sender
{
    if (self.cancel)
    {
        self.cancel();
    }
    [self viewDisappear];
}

///完成按钮事件
-(void)confirmAction:(UIButton *)sender
{
    NSDate *date = _datePicker.date;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy/MM/dd";
    NSString *dateStr = [format stringFromDate:date];
    if (self.confirm)
    {
        self.confirm(date, dateStr);
    }
    [self viewDisappear];
}

///视图出现
-(void)viewAppear
{
    _bgView.alpha = 0.0;
    _datePicker.frame = CGRectMake(0, _datePicker.frame.origin.y + _datePicker.frame.size.height + _toolBar.frame.size.height, _datePicker.frame.size.width,_datePicker.frame.size.height);
    _toolBar.frame = CGRectMake(0, _toolBar.frame.origin.y + _datePicker.frame.size.height + _toolBar.frame.size.height, _toolBar.frame.size.width, _toolBar.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self -> _bgView.alpha = 1;
        self -> _datePicker.frame = CGRectMake(0, self -> _datePicker.frame.origin.y - (self -> _datePicker.frame.size.height + self -> _toolBar.frame.size.height), self -> _datePicker.frame.size.width,self ->  _datePicker.frame.size.height);
        self -> _toolBar.frame = CGRectMake(0, self -> _toolBar.frame.origin.y - (self -> _datePicker.frame.size.height + self -> _toolBar.frame.size.height), self -> _toolBar.frame.size.width, self -> _toolBar.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

///视图消失
-(void)viewDisappear
{
    __weak typeof(self) weak = self;
    [UIView animateWithDuration:0.3 animations:^{
        self -> _bgView.alpha = 0.0;
       self -> _datePicker.frame = CGRectMake(0, self -> _datePicker.frame.origin.y + self -> _datePicker.frame.size.height + self -> _toolBar.frame.size.height, self -> _datePicker.frame.size.width,self ->  _datePicker.frame.size.height);
        self -> _toolBar.frame = CGRectMake(0, self -> _toolBar.frame.origin.y + self -> _datePicker.frame.size.height + self -> _toolBar.frame.size.height, self -> _toolBar.frame.size.width, self -> _toolBar.frame.size.height);
    } completion:^(BOOL finished) {
        [weak removeFromSuperview];
    }];
}

@end
