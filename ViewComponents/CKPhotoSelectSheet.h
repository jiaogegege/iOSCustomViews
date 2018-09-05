//
//  CKPhotoSelectSheet.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/11.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "CKActionSheet.h"

@interface CKPhotoSelectSheet : CKActionSheet

///工厂方法，创建照片选择器
+(CKPhotoSelectSheet *_Nullable)photoSelectWithCameraAction:(void (^ __nullable)(UIAlertAction * _Nullable action))handle1 withPhotoAction:(void (^ __nullable)(UIAlertAction * _Nullable action))handle2 inViewController:(UIViewController *_Nullable)vc;

@end
