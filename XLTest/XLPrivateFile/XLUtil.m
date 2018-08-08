//
//  XLUtil.m
//  ZJNews
//
//  Created by Ben on 2017/5/25.
//  Copyright © 2017年 Bella. All rights reserved.
//

#import "XLUtil.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <CommonCrypto/CommonDigest.h>
#import "JDStatusBarNotification.h"
#import "Reachability.h"

@implementation XLUtil

//xinle 测试上传

#pragma mark --返回横线
+(UIView *)setUpLineWithFrame:(CGRect)frame{
    
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = HEX_COLOR(0xe5e5e5);
    return line;
}

#pragma mark -- 分割线置顶
+(void)setZeroLineOfTableView:(UITableView *)tableView {
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark -- nav标题设置
+(void)setUpNavTitle:(NSString *) title WithTarget:(UIViewController *) target{
    
    //标题
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 80, 30);
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    target.navigationItem.titleView = label;
}

+(void)setUpNavTitle:(NSString *) title TitleColor:(UIColor *)textColor WithTarget:(UIViewController *) target{
    
    //标题
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 80, 30);
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = textColor;
    target.navigationItem.titleView = label;
}


#pragma mark -- 带有标题,信息的alertView
+(void)alertViewWithTitle:(NSString *)title Message:(NSString *)message Target:(UIViewController *)target{
    
    [self alertViewWithTitle:title Message:message CancelActionStr:@"我知道了" Target:target];
}

+(void)alertViewWithTitle:(NSString *)title Message:(NSString *)message CancelActionStr:(NSString *)cancelActionStr Target:(UIViewController *)target{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelActionStr style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [target presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- 字体的alertView
+(void)alertViewWithMessage:(NSString *)message Target:(UIViewController *)target handler:(void (^ __nullable)(UIAlertAction *action))handler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *alertMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
    [alertMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, message.length)];
    [alertController setValue:alertMessageStr forKey:@"attributedMessage"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:handler];
    [alertController addAction:cancelAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [target presentViewController:alertController animated:YES completion:nil];
    });
}

+(void)alertViewWithTitle:(NSString *)title Message:(NSString *)message Target:(UIViewController *)target CancelActionStr:(NSString *)cancelActionStr CancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler OkActionStr:(NSString *)okActionStr OkHandler:(void (^ __nullable)(UIAlertAction *action))okHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *alertMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
    
    if ([message containsString:@"\n"]) {
        NSInteger location = [message rangeOfString:@"\n"].location;
        //标题和消息的字体什么的其实也可以修改 以后再说 2018.02.02 xinle
        NSMutableAttributedString *alertTitle = [[NSMutableAttributedString alloc] initWithString:title];
        [alertTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, title.length)];
        NSMutableParagraphStyle  *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1  setLineSpacing:8];
        // 设置文字居中
        paragraphStyle1.alignment = NSTextAlignmentCenter;
        [alertTitle  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [title length])];
        [alertController setValue:alertTitle forKey:@"attributedTitle"];
        
        NSString *value = [message substringToIndex:location];
        [alertMessageStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, value.length)];
        [alertMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(location, message.length - location)];
        
         // 行间距设置修改 2018.03.07 xinle
        NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle  setLineSpacing:6];
        // 设置文字居中
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [alertMessageStr  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [message length])];
        
        [alertController setValue:alertMessageStr forKey:@"attributedMessage"];
    }
    
    if (cancelActionStr && cancelHandler) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelActionStr style:UIAlertActionStyleDefault handler:cancelHandler];
        [alertController addAction:cancelAction];
    }
    
    if(okActionStr && okHandler){
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okActionStr style:UIAlertActionStyleDefault handler:okHandler];
        [alertController addAction:okAction];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [target presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark -一个字符串多种颜色,字体
+ (NSAttributedString *) setStringsArr:(NSArray<NSString *> *) stringsArr ColorsArr:(NSArray<UIColor *> *) colorsArr FontsArr:(NSArray <UIFont *> *) fontsArr{
    
    NSString *string = @"";//目标字段
    for (NSString *str in stringsArr) {
        string = [NSString stringWithFormat:@"%@%@",string,str];
    }
    
    
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:string];
    for (int i = 0; i < stringsArr.count; i++) {
        
        CGFloat location = 0;
        for (int j = 0; j < i; j++) {
            NSString *str = stringsArr[j];
            location = location + str.length;
        }
        
        [mutaString addAttributes:@{NSForegroundColorAttributeName:colorsArr[i],
                                    NSFontAttributeName:fontsArr[i]}
                            range:NSMakeRange(location,stringsArr[i].length)];
    }
    
    return mutaString;
}

#pragma mark - 获取当前时间差的MM-DD字符串
+(NSString *)getMonthDayFromNowDays:(NSInteger)days{
    
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    
    if(days!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow:(oneDay * days)];
    }
    else
    {
        theDate = nowDate;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formatter stringFromDate:theDate];
    return strDate;
}

#pragma mark - 获取当前月份差的月份
+(NSString *)getBeforeMonthFromNowMons:(NSInteger)mons{
    
    NSDate*nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM"];
    NSString *strDate = [formatter stringFromDate:nowDate];
    
    NSString *yearStr = [strDate substringWithRange:NSMakeRange(0,4)];
    NSString *monthStr = [strDate substringWithRange:NSMakeRange(5,2)];
    if ([monthStr integerValue] <= mons) {
        yearStr = [NSString stringWithFormat:@"%ld",([yearStr integerValue] - 1)];
        monthStr =[NSString stringWithFormat:@"%ld",([monthStr integerValue] + 12 - mons)];
    }else{
        monthStr = [NSString stringWithFormat:@"%ld",([monthStr integerValue] - mons)];
    }
    if ([monthStr integerValue] < 10) {
        monthStr = [NSString stringWithFormat:@"0%@",monthStr];
    }
    strDate = [NSString stringWithFormat:@"%@-%@",yearStr,monthStr];
    return strDate;
}

#pragma mark -- 网络提示
+(BOOL)isNetWork{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    return isExistenceNetwork;
}

+(void)isHaveNetWork{
    
    if (!JDStatusBarNotification.isVisible) {
        [JDStatusBarNotification addStyleNamed:@"netWork" prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            
            style.barColor = HEX_COLOR(0X122338);
            style.textColor = [UIColor whiteColor];
            style.font = [UIFont boldSystemFontOfSize:14];
            return style;
        }];
        [JDStatusBarNotification showWithStatus:@"网络连接失败,请检查网络" dismissAfter:3.0 styleName:@"netWork"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JDStatusBarNotification dismiss];
        });
    }
}

+(void)isWeakNetWork{
    
    if (!JDStatusBarNotification.isVisible) {
        [JDStatusBarNotification addStyleNamed:@"netWork" prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            
            style.barColor = HEX_COLOR(0X122338);
            style.textColor = [UIColor whiteColor];
            style.font = [UIFont boldSystemFontOfSize:14];
            return style;
        }];
        [JDStatusBarNotification showWithStatus:@"网络不给力,请重试" dismissAfter:3.0 styleName:@"netWork"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JDStatusBarNotification dismiss];
        });
    }
}


#pragma mark -- 获取Window当前显示的ViewController
+ (UIViewController*)currentViewController{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
        
    }
    
    return vc;
}

//获取响应者
+(UIViewController *)getResponderWithObj:(UIView *) view{
    
    UIResponder *responder = view.nextResponder;
    while (1) {
        if (![responder isKindOfClass:[UIViewController class]]) {
            responder = responder.nextResponder;
        }else{
            break;
        }
    }
    UIViewController *vc = (UIViewController *)responder;
    return vc;
}

//获取单位
+(NSString *)getUnitByKey:(NSString *)key{
    
    NSDictionary *params = @{@"Fuc_Forever_Price":@"永久",
                             @"Fuc_Year_Price":@"年",
                             @"Fuc_Ban_Price":@"半年",
                             @"Fuc_Three_Price":@"季",
                             @"Fuc_Month_Price":@"月"};
    return params[key];
}

//获取价格的显示字符串
+(NSString *)getMoneyStrByStr:(NSString *)str{
    
    NSString *price;
    double money = [[NSString stringWithFormat:@"%.2f",[str doubleValue]] doubleValue] - [[NSString stringWithFormat:@"%.0f",[str doubleValue]] doubleValue];
    money = fabs(money);
    if ([str doubleValue] < 1 ||(money > 0 && money < 1)) {
        price = [NSString stringWithFormat:@"%.2f",[str doubleValue]];
    }else{
        price = [NSString stringWithFormat:@"%.0f",[str doubleValue]];
    }
    return price;
}

//验证密码是否简单
+(BOOL)checkPWDiSSmipleWithStr:(NSString *)str{
    
    if (str == nil || str.length == 0) {
        return NO;
    }
    NSMutableArray *charArr = [NSMutableArray arrayWithCapacity:1];
    NSString *temp =nil;
    for(int i =0; i < [str length]; i++)
    {
        temp = [str substringWithRange:NSMakeRange(i,1)];
        [charArr addObject:temp];
    }
    BOOL isSmiple = NO;
    
    //是否全部相等
    for (int i = 0; i < charArr.count - 1; i ++) {
        if ([charArr[i] integerValue] - [charArr[i + 1] integerValue] != 0) {
            isSmiple = NO;
            break;
        }else{
            isSmiple = YES;
        }
    }
    
    //是否升序
    if (isSmiple == NO) {
        for (int i = 0; i < charArr.count - 1; i ++) {
            if ([charArr[i] integerValue] - [charArr[i + 1] integerValue] != 1 ) {
                isSmiple = NO;
                break;
            }else{
                isSmiple = YES;
            }
        }
        //是否降序
        if (isSmiple == NO) {
            for (int i = 0; i < charArr.count - 1; i ++) {
                if ([charArr[i] integerValue] - [charArr[i + 1] integerValue] != -1 ) {
                    isSmiple = NO;
                    break;
                }else{
                    isSmiple = YES;
                }
            }
        }
    }
    return isSmiple;
}

#pragma mark -- 字典key排序后的字符串
+(NSString*)stringWithDict:(NSDictionary*)dict{
    
    NSArray*keys = [dict allKeys];
    NSArray*sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        return[obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSString*str =@"";
    for(NSString*categoryId in sortedArray) {
        
        id value = [dict objectForKey:categoryId];
        if([value isKindOfClass:[NSDictionary class]]) {
            value = [self stringWithDict:value];
        }
        if([str length] !=0) {
            str = [str stringByAppendingString:@"&"];
        }
        
        if ([value isKindOfClass:[NSString class]]) {
            str = [str stringByAppendingFormat:@"%@=%@",[self utf8StrWithStr:categoryId],[self utf8StrWithStr:value]];
        }else{
            
            //暂时数值型
            str = [str stringByAppendingFormat:@"%@=%@",[self utf8StrWithStr:categoryId],value];
        }
        
        
    }
    return str;
}

#pragma mark -- 得到utf8字符串
+(NSString*)utf8StrWithStr:(NSString *)str{
    str = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)str,NULL,(CFStringRef)@"!*'():;@&=+$,/?%#[]",kCFStringEncodingUTF8 ));
    return str;
}

#pragma mark -- 是否是提交审核的版本
+(BOOL)isSHAppVersionCompareNetVersion:(NSString *)netVersion{
    
    if ([netVersion isEqualToString:@""]) {
        return YES;
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSArray *appVersionArr = [app_Version componentsSeparatedByString:@"."];
    if ([netVersion isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSArray *netVersionArr = [netVersion componentsSeparatedByString:@"."];
    BOOL isSHAPPVersion = NO;
    if ([appVersionArr[0] integerValue] > [netVersionArr[0] integerValue]) {
        isSHAPPVersion = YES;
    }else if([appVersionArr[0] integerValue] == [netVersionArr[0] integerValue]){
        
        if ([appVersionArr[1] integerValue] > [netVersionArr[1] integerValue]){
            isSHAPPVersion = YES;
        }else if ([appVersionArr[1] integerValue] == [netVersionArr[1] integerValue]){
            
            if ([appVersionArr[2] integerValue] > [netVersionArr[2] integerValue]){
                isSHAPPVersion = YES;
            }
        }
    }
    return isSHAPPVersion;//本地版本号小于等于后台版本号
}





#pragma mark -- 长截图功能
+(UIImage *)screenLongShotWithScrollView:(UIScrollView *) scrolledView{
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(scrolledView.contentSize, YES, 0.0);
    
    //保存collectionView当前的偏移量
    CGPoint savedContentOffset = scrolledView.contentOffset;
    CGRect saveFrame = scrolledView.frame;
    
    //将collectionView的偏移量设置为(0,0)
    scrolledView.contentOffset = CGPointZero;
    scrolledView.frame = CGRectMake(0, 0, scrolledView.contentSize.width, scrolledView.contentSize.height);
    
    //在当前上下文中渲染出collectionView
    [scrolledView.layer renderInContext: UIGraphicsGetCurrentContext()];
    //截取当前上下文生成Image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    //恢复collectionView的偏移量
    scrolledView.contentOffset = savedContentOffset;
    scrolledView.frame = saveFrame;
    
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }else {
        return nil;
    }
}

+(UIImage *)screenLongShotWithView:(UIView *) view{
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    //在当前上下文中渲染出collectionView
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    //截取当前上下文生成Image
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }else {
        return nil;
    }
}

+(UIImage *)screenLongShotWithView:(UIView *) view Size:(CGSize) size{
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    //在当前上下文中渲染出collectionView
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    //截取当前上下文生成Image
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }else {
        return nil;
    }
}

//图片拼接
+(UIImage *)addSlaveImage:(UIImage *)slaveImage toMasterImage:(UIImage *)masterImage {
    
    /**
     masterImage  主图片，生成的图片的宽度为masterImage的宽度
     *slaveImage   从图片，拼接在masterImage的下面
     */
    CGSize size;
    size.width = masterImage.size.width;
    size.height = masterImage.size.height + slaveImage.size.height;
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    //Draw masterImage
    [masterImage drawInRect:CGRectMake(0, 0, masterImage.size.width, masterImage.size.height)];
    //Draw slaveImage
    [slaveImage drawInRect:CGRectMake(0, masterImage.size.height, masterImage.size.width, slaveImage.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+(NSString *)dealWithNilObj:(id)obj{

    NSString *str = @"";
    NSString *objStr = [NSString stringWithFormat:@"%@",obj];
    if (obj == nil || [obj isKindOfClass:[NSNull class]] || [objStr containsString:@"null"]) {
        str = @"--";
    }else{
        str = [NSString stringWithFormat:@"%@",obj];
    }
    return str;
}


//十六进制字符串转颜色
+(UIColor *)getColorByStr:(NSString *)str{
    
    if (str == nil) {
        return HEX_COLOR(0x9ea1a2);
    }
    str = [str stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    //strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
    unsigned long lColor = strtoul([str UTF8String],0,0);
    UIColor *color = HEX_COLOR(lColor);
    return color;
}

//判断和字符串是否为空
+(BOOL)isNilStr:(NSString *)str{
    
    if (str == nil || [[str stringByReplacingOccurrencesOfString:@" " withString:@""]isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
}

//切割图片
+(UIImage *)getNewImageWithImg:(UIImage *)image Width:(CGFloat)width Height:(CGFloat)height{
    
    if (width != 0) {
        height = width * image.size.height / image.size.width;
    }else{
        width = height * image.size.width / image.size.height;
    }
    
    CGSize imageSize =CGSizeMake(width,height);//自定义图片的大小
    UIGraphicsBeginImageContextWithOptions(imageSize,NO,0.0);//获得用来处理图片的图形上下文。利用该上下文，你就可以在其上进行绘图，并生成图片 ,三个参数含义是设置大小、透明度（NO为不透明）、缩放（0代表不缩放）
    CGRect imageRect =CGRectMake(0.0,0.0, imageSize.width, imageSize.height);
    [image drawInRect:imageRect];
    image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//截取图片的某一部分
+(UIImage *)clipImage:(UIImage *)image InRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}


//获得汉字的年月日时间
+(NSString *)getChnDateTimeWithDateStr:(NSString *) time{
    
    if (![time isKindOfClass:[NSNull class]] && time.length >= 11) {
        time = [time substringToIndex:11];
        time = [time stringByReplacingOccurrencesOfString:@"T" withString:@"日 "];
        time = [time stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
        time = [time stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
    }
    return time;
}

//处理label,button等显示字体模糊的情况
+(void)solveUIWidgetFuzzy:(UIView *)view
{
    CGRect frame = view.frame;
    int x = floor(frame.origin.x);
    int y = floor(frame.origin.y);
    int w = floor(frame.size.width)+1;
    int h = floor(frame.size.height)+1;
    
    view.frame = CGRectMake(x, y, w, h);
}

 //调整图片文字的位置
+(void)setLeftTitleRightImageWith:(UIButton *)button{
   
    button.titleLabel.backgroundColor = button.backgroundColor;
    button.imageView.backgroundColor = button.backgroundColor;
    //在使用一次titleLabel和imageView后才能正确获取titleSize
    CGSize titleSize = button.titleLabel.bounds.size;
    CGSize imageSize = button.imageView.bounds.size;
    CGFloat interval = 1.0;
    button.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval));
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval);
}

//处理带有逗号的字符串
+(NSString *)dealWithMoreStrsStr:(NSString *)str{
    
    NSString *newStr = str;
    newStr = [newStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newStr;
}


//获取对外的IP地址
+(void)getDeviceWANIPAddressSuccess:(void (^)(NSString *ipStr)) success Failure:(void (^)(void)) failure{
    //deviceWANIPAddress
    //常用方式异步并发+与主线程交互
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //耗时长的操作
        NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
        NSData *data = [NSData dataWithContentsOfURL:ipURL];
        NSDictionary *ipDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]; 
        NSString *ipStr = nil;
        if (ipDic && [ipDic[@"code"] integerValue] == 0) { //获取成功
            NSDictionary *dataDic = ipDic[@"data"];
            if ([dataDic isKindOfClass:[NSDictionary class]] && dataDic != nil) {
                ipStr = dataDic[@"ip"];
            }
        }
        //子线程与主线程通信
        dispatch_async(dispatch_get_main_queue(), ^{
            //主线程界面刷新
            if (ipStr) {
                if (success) {
                    success(ipStr);
                }
            }else{
                if (failure) {
                    failure();
                }
            }
        });
    });
}

// 闪烁的动画 ======
+(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.3f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = 1;//重复次数
    animation.removedOnCompletion = YES;//在动画执行完成之后，最好还是将动画移除掉。也就是尽量不要设置removedOnCompletion属性为NO
    //    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

//根据URL字符串获取参数字典
+(NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr
{
    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if (array && array.count == 2) {
            NSString *paramsStr = array[1];
            if (paramsStr.length) {
                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                for (NSString *param in paramArray) {
                    if (param && param.length) {
                        NSArray *parArr = [param componentsSeparatedByString:@"="];
                        if (parArr.count == 2) {
                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
                        }
                    }
                }
                return paramsDict;
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

//修改全局的UserAgent xinle 2018.02.25 
+(void)setNewUserAgent{
    // FXEYE-BIB-<平台名称>-<用户身份加密KEY> 此处还缺少接口返回的<用户身份加密KEY>
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    NSString * oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newUserAgent = [NSString stringWithFormat:@"FXEYE-BIB-IOS %@",oldAgent];//自定义需要拼接的字符串
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

// 启用.禁用右滑返回手势
+(void)setNavPopGestureRecognizerEnabled:(BOOL)enable TargetVC:(UIViewController *)vc{
    if ([vc.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        vc.navigationController.interactivePopGestureRecognizer.enabled = enable;
    }
}

/**lbl首行缩进*/
+(NSAttributedString *)getAttributedTextWithLbl:(UILabel *)lbl HeadInStr:(NSString *)str{
    
    NSString *_test  = lbl.text;
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
    paraStyle01.headIndent = 0.0f;//行首缩进
    //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
    CGFloat emptylen = lbl.font.pointSize * str.length + 10;
    paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
    paraStyle01.tailIndent = 0.0f;//行尾缩进
    paraStyle01.lineSpacing = WIDTH / 750 * 7;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_test attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    
    return attrText;
}

/** 图片翻转*/
+(void)rotateImageView:(UIImageView *)imgView FinishBlock:(void(^)(void))finishBlock{
    
    //2.0图片翻转
    [UIView transitionWithView:imgView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        
        
    }completion:^(BOOL finished) {
        
        if (finishBlock) {
            finishBlock();
        }
    }];
}

#pragma mark -- xinle
//字典转成model字符串
+(NSString *)getModelStrByDic:(NSDictionary *)dic{
    NSString *modelStr = @"";
    NSArray *keysArr = dic.allKeys;
    for (NSString *key in keysArr) {
        
        id value = dic[key];
        NSString *str = @"";
        if ([value isKindOfClass:[NSArray class]]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong)NSArray *%@;",key];
        }else if ([value isKindOfClass:[NSDictionary class]]){
            str = [NSString stringWithFormat:@"@property (nonatomic, strong)NSDictionary *%@;",key];
        }else{
            str = [NSString stringWithFormat:@"@property (nonatomic, strong)NSString *%@;",key];
        }
        modelStr = [NSString stringWithFormat:@"%@%@",modelStr,str];
    }
    return modelStr;
}

/** 永久闪烁的动画 ====== MAXFLOAT//无限循环*/
+(CABasicAnimation *)opacityForever_Animation:(float)time RepeatCount:(float)repeatCount CompleteBlock:(void(^)(void)) completeBlock
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = repeatCount;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time - 0.2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completeBlock) {
            completeBlock();
        }
    });
    return animation;
}

//几个常用的正则表达式,参考示例备用
+ (BOOL)validateEmail:(NSString *)string{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}
+ (BOOL)validateHttp:(NSString *)string{
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    if (arrayOfAllMatches.count > 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)allIsNumber:(NSString *)string{
    NSString *numberRegex = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:string];
}
//身份证
+ (BOOL)isIdentificationCard:(NSString *)idCardString
{
    NSString * idCard = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    NSPredicate *regextestIDCard = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idCard];
    return [regextestIDCard evaluateWithObject:idCardString];
}

//不同类型的字符串转换
+ (NSString *)UTF8_To_GB2312:(NSString*)utf8string{
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *cityEnc = [utf8string dataUsingEncoding:encode];
    NSString *gb2312 = [[NSString alloc] initWithData:cityEnc encoding:encode];
    return [gb2312 stringByAddingPercentEscapesUsingEncoding:encode];
}

#pragma mark -- private 私有方法

+(nullable NSString *)getMd5_32Bit_String:(nullable NSString *)str {
        if (!str) return nil;
        
        const char *cStr = str.UTF8String;
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
        
        NSMutableString *md5Str = [NSMutableString string];
        for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
            [md5Str appendFormat:@"%02x", result[i]];
        }
        return md5Str;
    }


//获取当前时间字符串
+(NSString *)getToDayDateStr{
    
    NSDate *localeDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *localeDateString =  [formatter stringFromDate:localeDate];
    
    return localeDateString;
    
}

+(NSString *)getYestodayDateStr{
    
    NSDate *localeDate = [NSDate dateWithTimeIntervalSinceNow:(- 24 * 60 * 60)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *localeDateString =  [formatter stringFromDate:localeDate];
    
    return localeDateString;
    
}


@end
