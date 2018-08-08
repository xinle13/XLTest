//
//  UIAlertView+XLBlock.m
//  ZJNews
//
//  Created by admin on 2018/4/17.
//  Copyright © 2018年 FXEYE. All rights reserved.
//

#import "UIAlertView+XLBlock.h"
#import <objc/runtime.h>

@implementation UIAlertView (XLBlock)

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message actionBlock:(AlertViewBtnClickBlock) block cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ...{
    
    __weak typeof(self) weakSelf = self;
    self = [self initWithTitle:title message:message delegate:weakSelf cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    
    //处理字符串组
    if (otherButtonTitles) {
        [self addButtonWithTitle:otherButtonTitles];

        id buttonTitle = nil;
        va_list argumentList;
        va_start(argumentList, otherButtonTitles);

        while ((buttonTitle=(__bridge NSString *)va_arg(argumentList, void *))) {
            [self addButtonWithTitle:buttonTitle];
        }

        va_end(argumentList);
    }
    //动态添加block
    if (block) {
        objc_setAssociatedObject(self, "AlertViewBtnClickBlock", block, OBJC_ASSOCIATION_COPY);
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    AlertViewBtnClickBlock block = objc_getAssociatedObject(self, "AlertViewBtnClickBlock");
    block(buttonIndex);
}

@end
