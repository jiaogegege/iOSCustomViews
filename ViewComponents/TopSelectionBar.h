//
//  TopSelectionBar.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/14.
//  Copyright © 2018年 dyimedical. All rights reserved.
//


/**
 顶部滑动tabbar
 */

#define BASE_TAG 1000

#import <UIKit/UIKit.h>

///协议
@protocol TopSelectionBarDelegate<NSObject>
@required
///控件点击了一个标题
-(void)topSelectionBarDidSelectIndex:(NSInteger)index;

@end

@interface TopSelectionBar : UIScrollView

///按钮标题数组，外部赋值
@property(nonatomic, strong)NSArray *titleArray;
///当前被选中的index
@property(nonatomic, assign, readonly)NSInteger currentIndex;
///代理对象
@property(nonatomic, weak)id<TopSelectionBarDelegate> barDelegate;
///是否需要动画效果
@property(nonatomic, assign)BOOL needAnimated;
///是否是平均分布，默认NO
@property(nonatomic, assign)BOOL isAverage;

///设置选中某一个index，从0开始计数
-(void)setSelectIndex:(NSInteger)index animated:(BOOL)animated;




@end
