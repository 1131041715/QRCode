//
//  creatViewController.m
//  QRCode
//
//  Created by 大碗豆 on 17/2/9.
//  Copyright © 2017年 大碗豆. All rights reserved.
//

#import "creatViewController.h"



#define qrImageSize CGSizeMake(300,300)

@interface creatViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation creatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    
    UITextField *text = [UITextField new];
    [self.view addSubview:text];
    self.textField = text;
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(74);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(40));
    }];
//    text.backgroundColor = [UIColor redColor];
    text.textColor = [UIColor blackColor];
    text.font = [UIFont systemFontOfSize:15];
    text.layer.borderColor = [UIColor blueColor].CGColor;
    text.layer.borderWidth = 1.0f;
    text.borderStyle = UITextBorderStyleRoundedRect;
    text.delegate = self;
    text.clearsOnBeginEditing = YES;
    
    CGFloat H = ANYScreenHeight/13;
    NSArray *arr = @[@"换颜色",@"在中间添加图片",@"生成二维码"];
    for (NSInteger index = 0; index < arr.count; index++) {
        UIButton *btn = [UIButton new];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.view);
            make.top.equalTo(self.view).offset(130 + (index * (H + 10)));
            make.height.equalTo(@(H));
        }];
        btn.tag = index;
        btn.backgroundColor = ANYColorRandom;
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [btn setTitle:arr[index] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    UIImageView *imagViwe = [UIImageView new];
    [self.view addSubview:imagViwe];
    self.imageView = imagViwe;
    [imagViwe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@150);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    imagViwe.image = [UIImage imageNamed:@"me"];
    
    
}

- (void)btnAction:(UIButton *)btn{
    //    NSLog(@"%zd",btn.tag);
    switch (btn.tag) {
        case 0:
        {
            NSLog(@"%zd",btn.tag);
            UIImage *image = [self createQRImageWithString:self.textField.text size:qrImageSize];
            
            self.imageView.image = [self changeColorForQRImage:image backColor:ANYColorRandom frontColor:ANYColorRandom];
        }
            
            break;
        case 1:
        {
            NSLog(@"%zd",btn.tag);
            self.imageView.image = [self addImageForQRImage:self.imageView.image];
        }
            break;
        case 2:
        {
            NSLog(@"%zd",btn.tag);
            
            [self.textField resignFirstResponder];
            
            if (self.textField.text.length > 0) {
                self.imageView.image = [self createQRImageWithString:self.textField.text size:qrImageSize];
            }else{
                [self showAlertWithTitle:@"提示" message:@"请输入文字" handler:nil];
            }
        }
            break;
            
        default:
            break;
    }
}


//生成制定大小的黑白二维码
- (UIImage *)createQRImageWithString:(NSString *)string size:(CGSize)size
{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    //放大并绘制二维码（上面生成的二维码很小，需要放大）
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    //翻转一下图片 不然生成的QRCode就是上下颠倒的
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

//为二维码改变颜色
- (UIImage *)changeColorForQRImage:(UIImage *)image backColor:(UIColor *)backColor frontColor:(UIColor *)frontColor
{
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage", [CIImage imageWithCGImage:image.CGImage],
                             @"inputColor0",[CIColor colorWithCGColor:frontColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:backColor.CGColor],
                             nil];
    
    return [UIImage imageWithCIImage:colorFilter.outputImage];
}

//在二维码中心加一个小图
- (UIImage *)addImageForQRImage:(UIImage *)qrImage
{
    UIGraphicsBeginImageContext(qrImage.size);
    
    [qrImage drawInRect:CGRectMake(0, 0, qrImage.size.width, qrImage.size.height)];
    
    UIImage *image = [UIImage imageNamed:@"lucky"];
    
    CGFloat imageW = 50;
    CGFloat imaegX = (qrImage.size.width - imageW) * 0.5;
    CGFloat imageY = (qrImage.size.height - imageW) * 0.5;
    
    [image drawInRect:CGRectMake(imaegX, imageY, imageW, imageW)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
