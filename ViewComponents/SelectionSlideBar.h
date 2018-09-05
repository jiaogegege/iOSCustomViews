//
//  SelectionSlideBar.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/10.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 顶部tab选择条
 */

#define BASE_TAG 1000
#define HIGHLIGHT_TEXT_COLOR [UIColor colorWithWhite:1 alpha:1]
#define DEFAULT_TEXT_COLOR [UIColor colorWithWhite:1 alpha:0.3]

/**
 代理方法
 */
@protocol SelectionSlideBarDelegate<NSObject>
@required
///点击按钮后的代理方法回调
-(void)selectionSlideBarDidSelectIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, SelectionSlideBarStyle)
{
    SelectionSlideBarStyleDark = 0,     //深色模式，灰底，无边框；默认
    SelectionSlideBarStyleLight = 1         //浅色模式，白底，有灰色边框
};

@interface SelectionSlideBar : UIView
///显示风格
@property(nonatomic, assign)SelectionSlideBarStyle style;
///按钮数组，传入标题
@property(nonatomic, strong)NSArray *titleArray;
///高亮颜色，默认主色调
@property(nonatomic, strong)UIColor *highLightColor;
///代理对象
@property(nonatomic, weak) id <SelectionSlideBarDelegate> delegate;
///是否可操作
@property(nonatomic, assign)BOOL isEnabled;

///设置选择某一个按钮，index从0开始
-(void)setSelectItemIndex:(NSInteger)index;



@end
