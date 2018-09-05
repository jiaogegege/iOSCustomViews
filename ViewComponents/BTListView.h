//
//  BTListView.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/30.
//  Copyright © 2018年 dyimedical. All rights reserved.
//


/**
 蓝牙搜索界面设备列表
 **/

#import <UIKit/UIKit.h>
#import "BTBluetoothSDK.h"

//回调block
typedef void(^BTListViewBlock)(void);

///列表代理方法
@protocol BTListViewDelegate<NSObject>
@required
///点击了重新搜索，如果返回值为true那么开始重连；如果返回false，那么停止当前操作
-(BOOL)btListViewDidReScanning;
///选择了某个设备
-(void)btListViewDidSelectDevice:(BTPeripheralModel *)device;

@end

#define BottomViewHeight 75
#define START_SCAN_TEXT @"正在搜索……"
#define END_SCAN_TEXT @"重新搜索"

@interface BTListView : UIView

@property(nonatomic, weak)id<BTListViewDelegate> delegate;
@property(nonatomic, copy,readonly)BTListViewBlock success;      //连接成功
@property(nonatomic, copy, readonly)BTListViewBlock failure;        //连接失败

///开始搜索
-(void)startSearching;
///结束搜索
-(void)stopSearching;
///推入一个蓝牙设备信息
-(void)pushDevice:(BTPeripheralModel *)device;




@end
