//
//  CKPickerView.m
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/10.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "CKPickerView.h"
#import "AppDelegate.h"
#import "ColorConst.h"
#import "UIView+FrameSet.h"

@interface CKPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView *_pickerView;
    UIButton *_bgView;      //背景视图
    UIView *_toolBar;       //顶部工具条，包含取消和确定按钮
    UIButton *_cancelBtn;
    UIButton *_confirmBtn;
    UILabel *_titleLabel;
}

@end

@implementation CKPickerView

    ///工厂方法
+(CKPickerView *)pickerViewwithDataSource:(NSArray *)array withConfirmBlock:(PickerConfirmBlock)confirm withCancelBlock:(PickerCancelBlock)cancel
{
    CKPickerView *picker = [[CKPickerView alloc] initWithFrame:[AppDelegate shareDelegate].window.bounds];
    picker.dataArray = array;
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
        //选择器视图，固定高度217
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 217, self.bounds.size.width, 217)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
//    _pickerView.showsSelectionIndicator = YES;
    [_bgView addSubview:_pickerView];
        //工具条，固定高度44
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, _pickerView.frame.origin.y - 44, self.bounds.size.width, 44)];
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
    _titleLabel.text = @"请选择";
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
    NSString *str = self.dataArray[[_pickerView selectedRowInComponent:0]];
    if (self.confirm)
    {
        self.confirm(str);
    }
    [self viewDisappear];
}

    ///视图出现
-(void)viewAppear
{
    _bgView.alpha = 0.0;
    _pickerView.frame = CGRectMake(0, _pickerView.frame.origin.y + _pickerView.frame.size.height + _toolBar.frame.size.height, _pickerView.frame.size.width,_pickerView.frame.size.height);
    _toolBar.frame = CGRectMake(0, _toolBar.frame.origin.y + _pickerView.frame.size.height + _toolBar.frame.size.height, _toolBar.frame.size.width, _toolBar.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self -> _bgView.alpha = 1;
        self -> _pickerView.frame = CGRectMake(0, self -> _pickerView.frame.origin.y - (self -> _pickerView.frame.size.height + self -> _toolBar.frame.size.height), self -> _pickerView.frame.size.width,self ->  _pickerView.frame.size.height);
        self -> _toolBar.frame = CGRectMake(0, self -> _toolBar.frame.origin.y - (self -> _pickerView.frame.size.height + self -> _toolBar.frame.size.height), self -> _toolBar.frame.size.width, self -> _toolBar.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

    ///视图消失
-(void)viewDisappear
{
    __weak typeof(self) weak = self;
    [UIView animateWithDuration:0.3 animations:^{
        self -> _bgView.alpha = 0.0;
        self -> _pickerView.frame = CGRectMake(0, self -> _pickerView.frame.origin.y + self -> _pickerView.frame.size.height + self -> _toolBar.frame.size.height, self -> _pickerView.frame.size.width,self ->  _pickerView.frame.size.height);
        self -> _toolBar.frame = CGRectMake(0, self -> _toolBar.frame.origin.y + self -> _pickerView.frame.size.height + self -> _toolBar.frame.size.height, self -> _toolBar.frame.size.width, self -> _toolBar.frame.size.height);
    } completion:^(BOOL finished) {
        [weak removeFromSuperview];
    }];
}

    ///手动选择一行，从0开始计数
- (void)pickerViewSelectRow:(NSInteger)row animated:(BOOL)animated
{
    [_pickerView selectRow:row inComponent:0 animated:animated];
}

    ///手动选择一行
-(void)pickerViewSelectRowWithTitle:(NSString *)title animated:(BOOL)animated
{
    for (int i = 0; i < self.dataArray.count; ++i)
    {
        if ([self.dataArray[i] isEqualToString:title])
        {
            [_pickerView selectRow:i inComponent:0 animated:animated];
            break;
        }
    }
}

    ///选择的行数，从0开始计数
- (NSInteger)selectedRowCount
{
    return [_pickerView selectedRowInComponent:0];
}

    ///选择的行，返回字符串
-(NSString *)selectedRowTitle
{
    NSInteger row = [_pickerView selectedRowInComponent:0];
    return self.dataArray[row];
}

#pragma mark - UIPickerView代理方法
//列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

//行高
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

//每一行数据
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    for (UIView *subView in pickerView.subviews)
    {
        if (subView.frame.size.height <= 1)
        {//获取分割线view
            subView.hidden = NO;
            subView.frame = CGRectMake(0, subView.frame.origin.y, subView.frame.size.width, 0.5);
            subView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];//设置分割线颜色
        }
    }
    return self.dataArray[row];
}

//每一行数据
//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    if (!view)
//    {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 35)];
//        label.backgroundColor = [UIColor whiteColor];
//        label.text = self.dataArray[row];
////        label.textColor = ANOTHER_TEXT_BLACK_COLOR;
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont systemFontOfSize:23];
//        view = label;
//        //创建两条横线
//
//    }
//    else
//    {
//        UILabel *label = (UILabel *)view;
//        label.text = self.dataArray[row];
//    }
//    return view;
//}




@end
