//
//  UIButton+XLBlock.m
//  XLTest
//
//  Created by admin on 2018/4/16.
//  Copyright © 2018年 xinle. All rights reserved.
//

#import "UIButton+XLBlock.h"
#import <objc/runtime.h>

@implementation UIButton (XLBlock)

#pragma Mark -- frame的处理
-(XLBtnBlock)xl_frame{
    XLBtnBlock block = ^(CGRect frame){
        self.frame = frame;
        return self;
    };
    return block;
}

-(void)setXl_frame:(XLBtnBlock)xl_frame{
 //空实现
}

#pragma Mark -- title的处理
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

-(void)addActionBlock:(ActionBlock)actionBlock forControlEvents:(UIControlEvents)event{
    
    if (actionBlock){
        objc_setAssociatedObject(self, "XLBtnBlock", actionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);//KVC增加示例变量
    }
    [self addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction:(UIButton *)btn
{
    ActionBlock block = objc_getAssociatedObject(self, "XLBtnBlock");//取出实例变量
    if (block) {
        block(btn);
    }
}



@end
