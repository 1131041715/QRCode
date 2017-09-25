//
//  scanViewController.m
//  QRCode
//
//  Created by 大碗豆 on 17/2/9.
//  Copyright © 2017年 大碗豆. All rights reserved.
//

#import "scanViewController.h"
#import "MaskView.h"
// 二维码需要的框架
#import <AVFoundation/AVFoundation.h>

@interface scanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

// 创建AVCaptureSession
@property (nonatomic, strong) AVCaptureSession *session;
// 闪光灯是否打开
@property (nonatomic, assign) BOOL flashOpen;

@end

@implementation scanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"打开闪光灯" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
    
    
    MaskView *View = [MaskView new];
    //改变扫描页面颜色
    View.backgroundColor = [UIColor clearColor];
    View.frame = CGRectMake(0, 0, ANYScreenWidth, 600);
    [self.view addSubview:View];
    
    //调用 -(void)drawRect:(CGRect)rect
//    [View setNeedsDisplay];
    
    
    
    //利用session生成一个AVCaptureVideoPreviewLayer加到view的layer上，就可以实时显示摄像头捕捉的内容了
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开始捕获
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //停止捕获
    [super viewWillDisappear:animated];
    [self.session stopRunning];
}

#pragma makr - AVCaptureMetadataOutputObjectsDelegate
//扫描出结果后调用该代理方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        NSString *strResult = metadataObject.stringValue;
        
        if ([strResult hasPrefix:@"http"]) {
            NSURL *url = [NSURL URLWithString:metadataObject.stringValue];
            [[UIApplication sharedApplication] openURL:url];
            [self.session startRunning];
        }else{
            [self showAlertWithTitle:@"扫描结果" message:metadataObject.stringValue handler:^(UIAlertAction *action) {
                [self.session startRunning];
            }];
        }
    }
}

#pragma mark - Getter
- (AVCaptureSession *)session
{
    if (!_session) {
        _session = ({
            //获取摄像设备
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            //创建输入流
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            if (!input)
            {
                return nil;
            }
            
            //创建输出流
            AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
            //设置代理 在主线程里刷新
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            //设置扫描区域的比例
            CGFloat width = 300 / CGRectGetHeight(self.view.frame);
            CGFloat height = 300 / CGRectGetWidth(self.view.frame);
            output.rectOfInterest = CGRectMake((1 - width) / 2, (1- height) / 2, width, height);
            
            AVCaptureSession *session = [[AVCaptureSession alloc] init];
            //高质量采集率
            [session setSessionPreset:AVCaptureSessionPresetHigh];
            [session addInput:input];
            [session addOutput:output];
            
            //设置扫码支持的编码格式(这里设置条形码和二维码兼容)
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                           AVMetadataObjectTypeEAN13Code,
                                           AVMetadataObjectTypeEAN8Code,
                                           AVMetadataObjectTypeCode128Code];
            
            session;
        });
    }
    return  _session;
}

#pragma mark - Action
- (void)rightBarButtonAction:(UIBarButtonItem *)item
{
    self.flashOpen = !self.flashOpen;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        
        if (self.flashOpen){
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭闪光灯" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
            
            device.torchMode = AVCaptureTorchModeOn;
            device.flashMode = AVCaptureFlashModeOn;
            
            
        }else{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"打开闪光灯" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
            
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeOff;
        }
        
        [device unlockForConfiguration];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
