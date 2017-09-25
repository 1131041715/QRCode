//
//  EGHeader.h
//  EntranceGuard
//
//  Created by 大碗豆 on 16/11/15.
//  Copyright © 2016年 大碗豆. All rights reserved.
//


#import "Masonry.h"
#import "UIViewController+Message.h"



//权限区分

#define ANYColorWithRGB(redValue, greenValue, blueValue) ([UIColor colorWithRed:((redValue)/255.0) green:((greenValue)/255.0) blue:((blueValue)/255.0) alpha:1])

/**随机颜色设置*/
#define ANYColorRandom ANYColorWithRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

/**屏幕尺寸设置*/
#define ANYScreenSize [[UIScreen mainScreen] bounds].size
#define ANYScreenWidth ANYScreenSize.width
#define ANYScreenHeight ANYScreenSize.height
#define CellHeight 50
#define btnMargin 6

//网络请求旋转小图标
#define ActivityIndicator(boo) [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:boo];
