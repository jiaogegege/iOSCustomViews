//
//  BTListItemView.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/30.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTListItemViewDelegate<NSObject>
@required
///选择了这个设备
-(void)btListItemViewDidSelectDevice:(NSInteger)index;

@end

@interface BTListItemView : UIView

@property(nonatomic, strong)UILabel *label;         //显示标题
@property(nonatomic, strong)UIButton *imageView;        //显示勾
@property(nonatomic, strong)UIButton *actionBtn;            //动作按钮
@property(nonatomic, strong)UIView *bottomLine;         //底部横线

@property(nonatomic, assign)NSInteger index;                //在父容器中的位置
@property(nonatomic, copy)NSString *title;          //显示的标题

@property(nonatomic, weak)id<BTListItemViewDelegate> delegate;

///工厂方法
+(BTListItemView *)btListView:(CGRect)frame title:(NSString *)title index:(NSInteger)index;
///是否显示横线
-(void)setBottomLIneHidden:(BOOL)hidden;
///选中自身
-(void)setSelected:(BOOL)selected;

@end
