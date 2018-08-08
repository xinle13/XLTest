//
//  XLUtil.h
//  ZJNews
//
//  Created by Ben on 2017/5/25.
//  Copyright © 2017年 Bella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIButton+XLBlock.h"
#import "UITextField+XLBlock.h"
#import "UIAlertView+XLBlock.h"

@interface XLUtil : NSObject<UIAlertViewDelegate>

/**返回横线*/
+(UIView *)setUpLineWithFrame:(CGRect)frame;
/**分割线置顶*/
+(void)setZeroLineOfTableView:(UITableView *)tableView;
/**nav标题设置*/
+(void)setUpNavTitle:(NSString *) title WithTarget:(UIViewController *) target;
+(void)setUpNavTitle:(NSString *) title TitleColor:(UIColor *)textColor WithTarget:(UIViewController *) target;

/**一个字符串多种颜色,字体*/
+ (NSAttributedString *) setStringsArr:(NSArray<NSString *> *) stringsArr ColorsArr:(NSArray<UIColor *> *) colorsArr FontsArr:(NSArray <UIFont *> *) fontsArr;
/**lbl首行缩进*/
+(NSAttributedString *)getAttributedTextWithLbl:(UILabel *)lbl HeadInStr:(NSString *)str;
/**获取当前时间差的MM-DD字符串*/
+(NSString *)getMonthDayFromNowDays:(NSInteger)days;
/**获取当前月份差的月份*/
+(NSString *)getBeforeMonthFromNowMons:(NSInteger)mons;
/**网络提示*/
+(BOOL)isNetWork;
+(void)isHaveNetWork;
+(void)isWeakNetWork;
/**获取Window当前显示的ViewController*/
+ (UIViewController*)currentViewController;
/**获取响应者*/
+(UIViewController *)getResponderWithObj:(UIView *) view;
/**获取单位*/
+(NSString *)getUnitByKey:(NSString *)key;
/**获取价格的显示字符串*/
+(NSString *)getMoneyStrByStr:(NSString *)str;
/**验证密码是否简单*/
+(BOOL)checkPWDiSSmipleWithStr:(NSString *)str;
/**字典key排序后的字符串*/
+(NSString*)stringWithDict:(NSDictionary*)dict;
/**是否是提交审核的版本*/
+(BOOL)isSHAppVersionCompareNetVersion:(NSString *)netVersion;
/**长截图功能*/
+(UIImage *)screenLongShotWithScrollView:(UIScrollView *) scrolledView;
+(UIImage *)screenLongShotWithView:(UIView *) view;
+(UIImage *)screenLongShotWithView:(UIView *) view Size:(CGSize) size;
/**图片拼接*/
+(UIImage *)addSlaveImage:(UIImage *)slaveImage toMasterImage:(UIImage *)masterImage ;
/**处理nil*/
+(NSString *)dealWithNilObj:(id)obj;
/**判断和字符串是否为空*/
+(BOOL)isNilStr:(NSString *)str;
/**切割图片*/
+(UIImage *)getNewImageWithImg:(UIImage *)image Width:(CGFloat)width Height:(CGFloat)height;
/**截取图片的某一部分*/
+(UIImage *)clipImage:(UIImage *)image InRect:(CGRect)rect;
/**获得汉字的年月日时间*/
+(NSString *)getChnDateTimeWithDateStr:(NSString *) time;
/**处理label,button等显示字体模糊的情况*/
+(void)solveUIWidgetFuzzy:(UIView *)view;
/**调整图片文字的位置*/
+(void)setLeftTitleRightImageWith:(UIButton *)button;
/**十六进制字符串转颜色*/
+(UIColor *)getColorByStr:(NSString *)str;
/**带有标题,信息的alertView*/
+(void)alertViewWithTitle:(NSString *)title Message:(NSString *)message Target:(UIViewController *)target;
+(void)alertViewWithTitle:(NSString *)title Message:(NSString *)message CancelActionStr:(NSString *)cancelActionStr Target:(UIViewController *)target;
/**处理带有逗号的字符串*/
+(NSString *)dealWithMoreStrsStr:(NSString *)str;
/** 闪烁的动画 ======*/
+(CABasicAnimation *)opacityForever_Animation:(float)time;
/** 图片翻转*/
+(void)rotateImageView:(UIImageView *)imgView FinishBlock:(void(^)(void))finishBlock;
/**获取对外的IP地址*/
+(void)getDeviceWANIPAddressSuccess:(void (^)(NSString *ipStr)) success Failure:(void (^)(void)) failure;
/**根据URL字符串获取参数字典*/
+(NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr;
/**修改全局的UserAgent xinle 2018.02.25*/
+(void)setNewUserAgent;
/**字典转成model字符串*/
+(NSString *)getModelStrByDic:(NSDictionary *)dic;
/** 永久闪烁的动画 ====== MAXFLOAT//无限循环*/
+(CABasicAnimation *)opacityForever_Animation:(float)time RepeatCount:(float)repeatCount CompleteBlock:(void(^)(void)) completeBlock;
/**启用.禁用右滑返回手势*/
+(void)setNavPopGestureRecognizerEnabled:(BOOL)enable TargetVC:(UIViewController *)vc;
/**字体的alertView*/
+(void)alertViewWithMessage:(NSString *)message Target:(UIViewController *)target handler:(void (^ __nullable)(UIAlertAction *action))handler;
+(void)alertViewWithTitle:(NSString *)title Message:(NSString *)message Target:(UIViewController *)target CancelActionStr:(NSString *)cancelActionStr CancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler OkActionStr:(NSString *)okActionStr OkHandler:(void (^ __nullable)(UIAlertAction *action))okHandler;
/**Email验证*/
+ (BOOL)validateEmail:(NSString *)string;
/**http验证*/
+ (BOOL)validateHttp:(NSString *)string;
/**全数字验证*/
+ (BOOL)allIsNumber:(NSString *)string;
/**身份证验证*/
+ (BOOL)isIdentificationCard:(NSString *)idCardString;
/**不同类型的字符串转换*/
+ (NSString *)UTF8_To_GB2312:(NSString*)utf8string;


@end
