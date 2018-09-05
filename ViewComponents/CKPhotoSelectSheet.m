//
//  CKPhotoSelectSheet.m
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/11.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "CKPhotoSelectSheet.h"

@interface CKPhotoSelectSheet ()

@end

@implementation CKPhotoSelectSheet

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    ///工厂方法，创建照片选择器
+(CKPhotoSelectSheet *)photoSelectWithCameraAction:(void (^ __nullable)(UIAlertAction *action))handle1 withPhotoAction:(void (^ __nullable)(UIAlertAction *action))handle2 inViewController:(UIViewController *)vc;
{
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:handle1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:handle2];
    CKPhotoSelectSheet *sheet = [CKPhotoSelectSheet actionSheetWithTitle:nil actionArray:@[action1, action2] identifierKey:@"photoSelect" inViewController:vc];
    
    return sheet;
}

@end
