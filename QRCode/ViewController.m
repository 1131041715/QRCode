//
//  ViewController.m
//  QRCode
//
//  Created by 大碗豆 on 17/2/9.
//  Copyright © 2017年 大碗豆. All rights reserved.
//

#import "ViewController.h"
#import "scanViewController.h"
#import "readViewController.h"
#import "creatViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat H = ANYScreenHeight/10;
    NSArray *arr = @[@"扫描二维码",@"识别图中二维码",@"生成二维码"];
    for (NSInteger index = 0; index < arr.count; index++) {
        UIButton *btn = [UIButton new];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.view);
            make.top.equalTo(self.view).offset(100 + (index * (H + 20)));
            make.height.equalTo(@(H));
        }];
        btn.tag = index;
        btn.backgroundColor = ANYColorRandom;
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [btn setTitle:arr[index] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

- (void)btnAction:(UIButton *)btn{
//    NSLog(@"%zd",btn.tag);
    switch (btn.tag) {
        case 0:
        {
            NSLog(@"%zd",btn.tag);
            scanViewController *scanVC = [scanViewController new];
            [self.navigationController pushViewController:scanVC animated:YES];
        }
            
            break;
        case 1:
        {
            NSLog(@"%zd",btn.tag);
            readViewController *readVC = [readViewController new];
            [self.navigationController pushViewController:readVC animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"%zd",btn.tag);
            creatViewController *creatVC = [creatViewController new];
            [self.navigationController pushViewController:creatVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
