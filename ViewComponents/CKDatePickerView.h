//
//  CKDatePickerView.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/10.
//  Copyright © 2018年 dyimedical. All rights reserved.
//


/**
 日期选择器，默认加入UIWindow
 */

#import <UIKit/UIKit.h>

#define MinDate @"1960/01/01"

typedef void(^DatePickerConfirmBlock)(NSDate *date, NSString *stringDate);
typedef void(^DatePickerCancelBlock)(void);

@interface CKDatePickerView : UIView

///限制日期最大值，默认今天
@property(nonatomic, strong)NSDate *maxDate;
///日期显示模式，默认日期
@property(nonatomic)UIDatePickerMode dateMode;
///标题
@property(nonatomic, copy)NSString *title;
///回调
@property(nonatomic, copy)DatePickerConfirmBlock confirm;
@property(nonatomic, copy)DatePickerCancelBlock cancel;

///工厂方法
+(CKDatePickerView *)datePickerWithConfirmBlock:(DatePickerConfirmBlock)confirm withCancelBlock:(DatePickerCancelBlock)cancel;
///设置当前显示的时间
-(void)setCurrentDate:(NSDate *)date;


@end
