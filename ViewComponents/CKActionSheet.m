//
//  CKActionSheet.m
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/9.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "CKActionSheet.h"
#import "CKConst.h"


@interface CKActionSheet ()

@end

///静态变量，记录已经创建的CKAlertView对象
static NSMapTable *identifierKeyMap;

@implementation CKActionSheet

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///工厂方法，创建弹窗
+(instancetype)actionSheetWithTitle:(nullable NSString *)title actionArray:(NSArray<UIAlertAction *> *)actionArray identifierKey:(NSString *)key inViewController:(UIViewController *)vc
{
    if (!identifierKeyMap)      //如果没有那么创建
    {
        identifierKeyMap = [NSMapTable  mapTableWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSMapTableWeakMemory];
    }
    if ([identifierKeyMap objectForKey:key])      //如果有值那么不创建
    {
        return nil;
    }
    CKActionSheet *actionSheet = [CKActionSheet alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (UIAlertAction *action in actionArray)  //修改颜色样式
    {
        [action setValue:MAIN_RED_COLOR forKey:@"titleTextColor"];
        [actionSheet addAction:action];
    }
    //添加取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:MAIN_RED_COLOR forKey:@"titleTextColor"];
    [actionSheet addAction:cancelAction];
    //设置自身到字典中
    [identifierKeyMap setObject:[CKCommonTools getWeakTypeOfObject:actionSheet] forKey:key];
    if (vc)
    {
        [vc presentViewController:actionSheet animated:YES completion:nil];
    }
    return actionSheet;
}

-(void)dealloc
{
    NSLog(@"CKActionSheet dealloc");
}

@end
