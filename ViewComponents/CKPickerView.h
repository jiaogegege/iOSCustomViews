//
//  CKPickerView.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/10.
//  Copyright © 2018年 dyimedical. All rights reserved.
//


/**
 单项选择器，默认加入UIWindow
 */

#import <UIKit/UIKit.h>


@protocol CKPickerViewDelegate<NSObject>
@required
///点击完成按钮
-(void)pickerViewDidPickerData:(NSString *)strData;
@optional
///点击取消按钮
-(void)pickerViewDidCancel;
@end

typedef void(^PickerConfirmBlock)(NSString *string);
typedef void(^PickerCancelBlock)(void);

@interface CKPickerView : UIView
///标题
@property(nonatomic, copy)NSString *title;
///数据源
@property(nonatomic, strong)NSArray<NSString *> *dataArray;
    ///回调
@property(nonatomic, copy)PickerConfirmBlock confirm;
@property(nonatomic, copy)PickerCancelBlock cancel;

///工厂方法
+(CKPickerView *)pickerViewwithDataSource:(NSArray *)array withConfirmBlock:(PickerConfirmBlock)confirm withCancelBlock:(PickerCancelBlock)cancel;

///手动选择一行，从0开始计数
- (void)pickerViewSelectRow:(NSInteger)row animated:(BOOL)animated;

///手动选择一行
-(void)pickerViewSelectRowWithTitle:(NSString *)title animated:(BOOL)animated;

///选择的行数，从0开始计数
- (NSInteger)selectedRowCount;

///选择的行，返回字符串
-(NSString *)selectedRowTitle;


@end
