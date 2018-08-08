//
//  UIAlertView+XLBlock.h
//  ZJNews
//
//  Created by admin on 2018/4/17.
//  Copyright © 2018年 FXEYE. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AlertViewBtnClickBlock)(NSInteger index);
@interface UIAlertView (XLBlock)

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message actionBlock:(AlertViewBtnClickBlock) block cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ...;

@end
