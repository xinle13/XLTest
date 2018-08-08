//
//  UIButton+XLBlock.m
//  ZJNews
//
//  Created by admin on 2018/4/17.
//  Copyright © 2018年 FXEYE. All rights reserved.
//

#import "UIButton+XLBlock.h"
#import <objc/runtime.h>

@implementation UIButton (XLBlock)

#pragma mark -- 点语法实现链式调用(测试学习代码原理)
#pragma mark -- frame的处理
-(XLBtnFrameBlock)xl_frame{
    XLBtnFrameBlock block = ^(CGRect frame){
        self.frame = frame;
        return self;
    };
    return block;
}

-(void)setXl_frame:(XLBtnFrameBlock)xl_frame{
    //空实现
}

#pragma mark -- title的处理
-(XLBtnTitleBlock)xl_title{
    XLBtnTitleBlock block = ^(NSString *title){
        [self setTitle:title forState:UIControlStateNormal];
        return self;
    };
    return block;
}

-(void)setXl_title:(XLBtnTitleBlock)xl_title{
    //空实现
}

-(void)addActionBlock:(BtnActionBlock)actionBlock forControlEvents:(UIControlEvents)event{
    
    __weak typeof(self) weakSelf = self;
    if (actionBlock){
        objc_setAssociatedObject(self, "BtnActionBlock", actionBlock, OBJC_ASSOCIATION_COPY);//KVC增加示例变量
    }
    [self addTarget:weakSelf action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction:(UIButton *)btn
{
    BtnActionBlock block = objc_getAssociatedObject(self, "BtnActionBlock");//取出实例变量
    if (block) {
        block(btn);
    }
}


@end
