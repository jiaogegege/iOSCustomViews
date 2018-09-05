//
//  BTListItemView.m
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/30.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "BTListItemView.h"
#import "CKConst.h"

@implementation BTListItemView

    ///工厂方法
+(BTListItemView *)btListView:(CGRect)frame title:(NSString *)title index:(NSInteger)index
{
    BTListItemView *listItem = [[BTListItemView alloc] initWithFrame:frame];
    listItem.index = index;
    listItem.title = title;
    return listItem;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createUI];
    }
    return self;
}

///创建界面
-(void)createUI
{
    //文本
    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    self.label.textColor = MAIN_TEXT_BLACK_COLOR;
    self.label.font = [UIFont systemFontOfSize:16];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    //打勾图标
    self.imageView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageView.frame = CGRectMake(self.width - self.height - 20, 0, self.height, self.height);
    [self.imageView setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    self.imageView.enabled = NO;
    self.imageView.hidden = YES;
    [self addSubview:self.imageView];
    //按钮
    self.actionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionBtn.frame = self.bounds;
    self.actionBtn.backgroundColor = [UIColor clearColor];
    [self.actionBtn addTarget:self action:@selector(actionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.actionBtn];
    //横线
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
    self.bottomLine.backgroundColor = GRAY_TEXT_COLOR;
    self.bottomLine.hidden = YES;
    [self addSubview:self.bottomLine];
    
}

///显示的标题
-(void)setTitle:(NSString *)title
{
    _title = title;
    self.label.text = title;
}

//按钮回调方法
-(void)actionBtnAction:(UIButton *)sender
{
    if (self.delegate)
    {
        if ([self.delegate conformsToProtocol:@protocol(BTListItemViewDelegate)])
        {
            if ([self.delegate respondsToSelector:@selector(btListItemViewDidSelectDevice:)])
            {
                [self.delegate btListItemViewDidSelectDevice:self.index];
            }
        }
    }
}

    ///是否显示横线
-(void)setBottomLIneHidden:(BOOL)hidden
{
    self.bottomLine.hidden = hidden;
}

    ///选中自身
-(void)setSelected:(BOOL)selected
{
    self.imageView.hidden = !selected;
}





@end
