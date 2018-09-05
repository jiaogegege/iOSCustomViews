//
//  CKProgressBar.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/9.
//  Copyright © 2018年 dyimedical. All rights reserved.
//


/**
 圆形进度条
 */

#import <UIKit/UIKit.h>

@interface CKProgressBar : UIView

@property(nonatomic, assign)CGFloat maxValue;
@property(nonatomic, readonly, assign)CGFloat currentValue;

///设置数值
-(void)setValue:(CGFloat)value withAnimate:(BOOL)animated;

@end
