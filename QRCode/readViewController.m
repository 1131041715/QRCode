//
//  readViewController.m
//  QRCode
//
//  Created by 大碗豆 on 17/2/9.
//  Copyright © 2017年 大碗豆. All rights reserved.
//

#import "readViewController.h"
#import "UIViewController+Message.h"
#import "QRImageView.h"

#define SIZE [[UIScreen mainScreen] bounds].size
@interface readViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong)QRImageView *imageView;

@end

@implementation readViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"从相册中选择" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
    
    CGFloat imageViewWidth = SIZE.width/1.5;
    
    QRImageView *imagView = [[QRImageView alloc] initWithFrame:CGRectMake((SIZE.width - imageViewWidth)/2, (SIZE.height - imageViewWidth)/3, imageViewWidth, imageViewWidth)];
    imagView.image = [UIImage imageNamed:@"me"];
    imagView.userInteractionEnabled = YES;
    [self.view addSubview:imagView];
    self.imageView = imagView;

    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [imagView addGestureRecognizer:longPressGr];
    
    UILabel *lab = [UILabel new];
    lab.frame = CGRectMake((SIZE.width - imageViewWidth)/2, (SIZE.height - imageViewWidth)/3 + imageViewWidth + 10, imageViewWidth, imageViewWidth/5);
    lab.text = @"长按识别图中的二维码";
    lab.font = [UIFont systemFontOfSize:20];
    lab.textColor = [UIColor blackColor];
    lab.backgroundColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];
}

#pragma mark - Action
- (void)rightBarButtonAction:(UIBarButtonItem *)item
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        
        [self presentViewController:controller animated:YES completion:NULL];
    }else{
        [self showAlertWithTitle:@"提示" message:@"设备不支持访问相册" handler:nil];
    }
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    NSLog(@"%ld",(long)gesture.state);
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self findQRCodeFromImage:self.imageView.image];
    }
}


#pragma mark - UIImagePickerControllrDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        self.imageView.image = image;
        [self findQRCodeFromImage:image];
    }];
}

- (void)findQRCodeFromImage:(UIImage *)image
{
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1) {
        CIQRCodeFeature *feature = [features firstObject];
        
        [self showAlertWithTitle:@"扫描结果" message:feature.messageString handler:nil];
    }else{
        [self showAlertWithTitle:@"提示" message:@"图片里没有二维码" handler:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
