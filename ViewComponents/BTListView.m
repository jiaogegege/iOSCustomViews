//
//  BTListView.m
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/30.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "BTListView.h"
#import "CKConst.h"
#import "BTListItemView.h"


@interface BTListView()<BTListItemViewDelegate>
{
    UIButton *_resacanBtn;      //重新搜索按钮
    BOOL _isSearching;      //是否在扫描中
    CGRect _originFrame;
    
}
@property(nonatomic, strong)UIView *topAreaView;        //上部设备信息区域
@property(nonatomic, strong)UIView *bottomAreaView;     //下部重新搜索按钮区域
@property(nonatomic, strong)NSMutableArray *modelArray;         //设备数组
@property(nonatomic, strong)NSMutableArray *itemArray;          //列表元素数组

@end

@implementation BTListView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _modelArray = [NSMutableArray array];
        _itemArray = [NSMutableArray array];
        _isSearching = NO;
        self.backgroundColor = [UIColor clearColor];
        frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height - BottomViewHeight, frame.size.width, BottomViewHeight);      //重新定位
        self.frame = frame;
        _originFrame = frame;
        //创建底部视图
        [self createBottomView:self.bounds];
    }
    return self;
}

///创建底部视图
-(void)createBottomView:(CGRect)frame
{
    _bottomAreaView = [[UIView alloc] initWithFrame:frame];
    _bottomAreaView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bottomAreaView];
    //按钮
    _resacanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _resacanBtn.frame = CGRectMake(10, 8, frame.size.width - 10 * 2, 57);
    [_resacanBtn setTitle:@"重新搜索" forState:UIControlStateNormal];
    _resacanBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _resacanBtn.backgroundColor = [UIColor clearColor];
    _resacanBtn.layer.cornerRadius = 13;
    _resacanBtn.clipsToBounds = YES;
    [_resacanBtn setTitleColor:MAIN_TEXT_BLACK_COLOR forState:UIControlStateNormal];
    [_resacanBtn addTarget:self action:@selector(rescanAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomAreaView addSubview:_resacanBtn];
    
}

///创建顶部视图
-(UIView *)createTopView
{
    if (!_topAreaView)
    {
        _topAreaView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.width - 10 * 2, 0)];
        _topAreaView.backgroundColor = [UIColor clearColor];
        _topAreaView.clipsToBounds = YES;
        _topAreaView.layer.cornerRadius = 13;
    }
    [self addSubview:_topAreaView];
    return _topAreaView;
}

///重新搜索按钮事件
-(void)rescanAction:(UIButton *)sender
{
    if (self.delegate)
    {
        if ([self.delegate conformsToProtocol:@protocol(BTListViewDelegate)])
        {
            if ([self.delegate respondsToSelector:@selector(btListViewDidReScanning)])
            {
                if ([self.delegate btListViewDidReScanning])    //如果返回true，那么开始重连动画
                {
                    [self startSearching];
                }
            }
        }
    }
}

///重置
-(void)reset
{
    [self.topAreaView removeFromSuperview];
    self.topAreaView = nil;
    [self.bottomAreaView removeFromSuperview];
    self.bottomAreaView = nil;
    [_modelArray removeAllObjects];
    [_itemArray removeAllObjects];
    _isSearching = NO;
    self.frame = _originFrame;
    [self createBottomView:self.bounds];
}

///推入一个蓝牙设备信息
-(void)pushDevice:(BTPeripheralModel *)device
{
    if (_isSearching && (self.height + 60 < SCREEN_HEIGHT - SafeAreaTopHeight - SafeAreaBottomHeight))
    {
        [_modelArray addObject:device];
        [self createTopView];
        BTListItemView *v = [BTListItemView btListView:CGRectMake(0, _topAreaView.height, _topAreaView.width, 60) title:device.name index:_modelArray.count - 1];
        v.delegate = self;
        [_topAreaView addSubview:v];
        for (BTListItemView *v in _itemArray)
        {
            [v setBottomLIneHidden:NO];
        }
        [_itemArray addObject:v];
            //做一个显示动画
        _resacanBtn.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
        __weak typeof(self) weak = self;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect topFrame = CGRectMake(weak.topAreaView.x, weak.topAreaView.y, weak.topAreaView.width, weak.topAreaView.height + v.height);
            CGRect selfFrame = CGRectMake(weak.x, weak.y - v.height, weak.width, topFrame.size.height + weak.bottomAreaView.height);
            CGRect bottomFrame = CGRectMake(weak.bottomAreaView.x, selfFrame.size.height - weak.bottomAreaView.height, weak.bottomAreaView.width, weak.bottomAreaView.height);
            weak.frame = selfFrame;
            weak.topAreaView.frame = topFrame;
            weak.bottomAreaView.frame = bottomFrame;
        } completion:^(BOOL finished) {
            
        }];
    }

}

///item代理方法
-(void)btListItemViewDidSelectDevice:(NSInteger)index
{
    __weak typeof(self) weak = self;
    self.userInteractionEnabled = NO;
    //停止扫描
    [self stopSearching];
    if (self.delegate)
    {
        if ([self.delegate conformsToProtocol:@protocol(BTListViewDelegate)])
        {
            if ([self.delegate respondsToSelector:@selector(btListViewDidSelectDevice:)])
            {
                _success = ^{
                    weak.userInteractionEnabled = YES;
                    BTListItemView *itemView = weak.itemArray[index];
                    [itemView setSelected:YES];
                };
                _failure = ^{
                    weak.userInteractionEnabled = YES;
                    BTListItemView *itemView = weak.itemArray[index];
                    [itemView setSelected:NO];
                };
                [self.delegate btListViewDidSelectDevice:_modelArray[index]];
            }
        }
    }
}

    ///开始搜索
-(void)startSearching
{
    [self reset];
    _resacanBtn.backgroundColor = [UIColor clearColor];
    [_resacanBtn setTitle:START_SCAN_TEXT forState:UIControlStateNormal];
    _resacanBtn.enabled = NO;
    _isSearching = YES;
}

    ///结束搜索
-(void)stopSearching
{
    _resacanBtn.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [_resacanBtn setTitle:END_SCAN_TEXT forState:UIControlStateNormal];
    _resacanBtn.enabled = YES;
    _isSearching = NO;
}



@end
