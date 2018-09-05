//
//  HistogramView.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/28.
//  Copyright © 2018年 dyimedical. All rights reserved.
//


/**
 数据统计柱状图
 **/

#import <UIKit/UIKit.h>

@interface HistogramView : UIView

@property(nonatomic, assign)CGFloat maxValue;
@property(nonatomic, assign)CGFloat currentValue;

@property(nonatomic, strong)CAGradientLayer *gLayer;

@end
