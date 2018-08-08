//
//  XLConst.h
//  ZJNews
//
//  Created by Ben on 2017/5/25.
//  Copyright © 2017年 Bella. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "IQKeyboardManager.h"
#import "AFNetworking.h"
#import "FMDB.h"
#import "UIView+Extension.h"

//枚举类型示例
typedef NS_ENUM(NSInteger, HeatDateType) {
    TypeDay = 0,
    TypeMonth = 1,
    TypeSpread = 2,//点差
};


#ifdef  DEBUG
#define LOG(...)  NSLog(__VA_ARGS__)
#define LOG_FUNC  NSLog(@"%s", __func__);
#define LOG_ERROR NSLog(@"%s\n%@", __func__, error);
#else
#define LOG(...)
#define LOG_FUNC
#define LOG_ERROR
#endif

//屏幕相关
#define WIDTH             [UIScreen mainScreen].bounds.size.width
#define HEIGHT            [UIScreen mainScreen].bounds.size.height 
#define KEY_WINDOW        [UIApplication sharedApplication].keyWindow
#define IOS_VERSION       [[UIDevice currentDevice]systemVersion].floatValue
#define kInterval1970     [[NSDate date] timeIntervalSince1970]

//iPhoneX适配 2017.11.12 xinle
#define IPHONEXHEIGHT 812.0
#define SafeAreaTopHeight    (HEIGHT == IPHONEXHEIGHT ? 88 : 64)
#define SafeAreaBottomHeight (HEIGHT == IPHONEXHEIGHT ? 34 : 0)

// 字体
#define FONT(s) (([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) ? [UIFont fontWithName:@"ArialMT" size:TOPFONT(s)] : [UIFont fontWithName:@"PingFangSC-Regular" size:TOPFONT(s)])
#define BOLDFONT(s) (([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) ? [UIFont fontWithName:@"ArialMT" size:TOPFONT(s)] : [UIFont fontWithName:@"PingFangSC-Medium" size:TOPFONT(s)])
#define BOLD_FONT(s)         [UIFont boldSystemFontOfSize:s]

// 颜色
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGBColor(r, g, b)     RGBAColor((r), (g), (b), 1.0)
#define RandomColor           RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
#define HEX_COLOR(rgb)  RGBAColor(((float)((rgb & 0xFF0000) >> 16)), ((float)((rgb & 0xFF00) >> 8)), ((float)(rgb & 0xFF)), 1.0)

#define WEAK_SELF       __weak typeof(self) weakSelf = self;


//自定义常量示例
extern NSInteger const kHeatBlueColor;
extern NSString const *kAppID;

@interface XLConst : NSObject

@end
