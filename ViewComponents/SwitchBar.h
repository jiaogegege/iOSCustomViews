//
//  SwitchBar.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/10.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 开关按钮
 */

typedef NS_ENUM(NSInteger, SwitchBarStatus) {
    SwitchBarStatusLeftOn = 0,      //左边高亮
    SwitchBarStatusRightOn = 1      //右边高亮
};

typedef void(^ActionBlock)(SwitchBarStatus status, NSString *title);

@interface SwitchBar : UIView
///左边标题
@property(nonatomic, copy)NSString *leftTitle;
///右边标题
@property(nonatomic, copy)NSString *rightTitle;
///高亮颜色
@property(nonatomic, strong)UIColor *highlightColor;
///block
@property(nonatomic, copy)ActionBlock block;
///状态
@property(nonatomic, assign)SwitchBarStatus status;

///工厂方法
+(SwitchBar *)switchBarWithFrame:(CGRect)frame andAction:(ActionBlock)block;


@end
