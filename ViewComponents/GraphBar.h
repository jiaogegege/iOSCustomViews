//
//  GraphBar.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/14.
//  Copyright © 2018年 dyimedical. All rights reserved.
//


/**
 历史记录柱状图
 */

#import <UIKit/UIKit.h>

@interface GraphBar : UIView
///渐变色，CGColor，(__bridge id)
@property(nonatomic, strong)NSArray *colors;
///最大值
@property(nonatomic, assign)CGFloat maxValue;
///设置值
@property(nonatomic, assign)CGFloat currentValue;

@end
