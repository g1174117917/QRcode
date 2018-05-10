//
//  takePhoto.h
//  TakePicture
//  选择图片
//  Created by yitonghou on 15/8/5.
//  Copyright (c) 2015年 移动事业部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//使用block 返回值
typedef void (^sendPictureBlock)(UIImage *image,UIViewController * controller);

@interface gkhPickerImage : NSObject<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic,copy)sendPictureBlock sPictureBlock;
@property (nonatomic,strong) UIViewController  *controller;

+ (gkhPickerImage *)sharedModel;

//+(void)sharePicture:(sendPictureBlock)block;
/**
 *  从相册或相机获得图片
 *
 *  @param controller 显示的controller
 *
 *  @return sendPictureBlock image 图片
 */
+(void)sharePictureByController:(UIViewController *)controller susscond:(sendPictureBlock)block;

@end


