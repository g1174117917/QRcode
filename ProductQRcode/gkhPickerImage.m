//
//  takePhoto.m
//  TakePicture
//
//  Created by yitonghou on 15/8/5.
//  Copyright (c) 2015年 移动事业部. All rights reserved.
//
/*
 作者：景泰蓝   bug联系QQ：840737320  微信：housenkui
 
  从民国的青帮，到文革的红卫兵，
  再到城市化建设的城管，以及现在软件行业的产品经理，无一不是社会深刻变革的产物。
 
 */
#define AppRootView  ([[[[[UIApplication sharedApplication] delegate] window] rootViewController] view])

#define AppRootViewController  ([[[[UIApplication sharedApplication] delegate] window] rootViewController])

#import "gkhPickerImage.h"

@implementation gkhPickerImage
{
    NSUInteger sourceType;
}

+ (gkhPickerImage *)sharedModel{
    static gkhPickerImage *sharedModel = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
}

+(void)sharePicture:(sendPictureBlock)block{
    
    gkhPickerImage *tP = [gkhPickerImage sharedModel];
    tP.sPictureBlock =block;
    [tP choseImage];
    
}
+(void)sharePictureByController:(UIViewController *)controller susscond:(sendPictureBlock)block;{
    gkhPickerImage *tP = [gkhPickerImage sharedModel];
    
    tP.sPictureBlock =block;
    tP.controller=controller;
    [tP choseImage];
}
-(void)choseImage{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"设置图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册中获取", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"设置图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册中获取", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.controller.view];
}

#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==actionSheet.cancelButtonIndex) {
        return;
    }
    if (actionSheet.tag == 255) {
         sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        
        // 跳转到相机或相册页面
       UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self.controller presentViewController:imagePickerController animated:YES completion:NULL];

    }
}

#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    gkhPickerImage *TPhoto = [gkhPickerImage sharedModel];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    [TPhoto sPictureBlock](image,self.controller);
    
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    //    [self saveImage:image withName:@"currentImage.png"];
    //    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    //    UIImage * savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
}

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

@end
