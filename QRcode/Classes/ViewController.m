//
//  ViewController.m
//  QRcode
//
//  Created by xynet on 15/12/25.
//  Copyright © 2015年 GKH. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeGenerator.h"
#import "GKHScanQCodeViewController.h"
#import "gkhPickerImage.h"
@interface ViewController ()<QRScanViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *QRString;//输入二维码字符串
@property (weak, nonatomic) IBOutlet UIImageView *QRimageView;//二维码图片
@property (weak, nonatomic) IBOutlet UILabel *lableQRstring;//转换出来的字符串

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//来自于图库
- (IBAction)comePhoto:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [gkhPickerImage sharePictureByController:self susscond:^(UIImage *image, UIViewController *controller) {
        weakSelf.lableQRstring.text=[GKHScanQCodeViewController QRStringByimage:image];
        _QRimageView.image=image;
    }];
}

//二维码保存到相册
- (IBAction)savePhoto:(UIButton *)sender {
    [self saveImageToAlbum];
}

//二维码扫描
- (IBAction)QRscan:(UIButton *)sender {
    GKHScanQCodeViewController * sqVC = [[GKHScanQCodeViewController alloc]init];
    sqVC.delegate=self;
    UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:sqVC];
    [self presentViewController:nVC animated:YES completion:nil];

}

//生成二维码
- (IBAction)productQR:(UIButton *)sender {
    if (self.QRString.text.length==0) {
        UIAlertController *alter=[UIAlertController alertControllerWithTitle:@"请输入需要生成二维码的字符" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alter showViewController:self sender:nil];
    }
    //把QRCodeGenerator生成的二维码放到定义的imageView上（注意：QRCodeGenerator的返回值是一个image）
    _QRimageView.image = [QRCodeGenerator qrImageForString:self.QRString.text imageSize:_QRimageView.bounds.size.width];
    
    [self.view addSubview:_QRimageView];
    self.lableQRstring.text=self.QRString.text;
}

#pragma mark--scan delgate
//扫描后得到的字符串
-(void)GKHScanQCodeViewController:(GKHScanQCodeViewController *)lhScanQCodeViewController readerScanResult:(NSString *)result{
    self.lableQRstring.text=result;
}

//保存图片到本地
- (void)saveImageToAlbum{
    UIImageWriteToSavedPhotosAlbum(_QRimageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

//实现imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:方法

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if (!error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存失败" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.QRString resignFirstResponder];
}
@end
